import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { encodeDefaultFieldValues } from "lightning/pageReferenceUtils";
import { getRecord } from 'lightning/uiRecordApi';
import id from "@salesforce/user/Id";
import profile from "@salesforce/schema/User.Profile.Name";
import getRealEstate from "@salesforce/apex/RealEstateAgentDetailsController.getRealEstate";
import getLocationDetails from "@salesforce/apex/RealEstateAgentDetailsController.getLocationDetails";
import getPotClient from "@salesforce/apex/RealEstateAgentDetailsController.getPotClient";

const COLUMNS = [
    {
        label: "Name",
        fieldName: "Name",
        cellAttributes: {
            iconName: "standard:user",
            iconPosition: "left"
        }
    },
    {
        label: "Email",
        fieldName: "Email",
        type: "email" 
    },
    {
        label: "Location",
        fieldName: "Location",
        cellAttributes: {
            iconName: "utility:location",
            iconPosition: "left"
        }
    }
];

export default class LeasingDetails extends NavigationMixin (LightningElement) {

    @api recordId;
    @track realEstateAgentList;
    @track isAdmin = false;
    @track leasingRec;
    @track potClientList;
    
    errors;
    userId = id;
    columnsList = COLUMNS;

   /* @wire(getRecord, {recorId: '$userId', fields: [profile] })
    wireMethod({error, data}) {
        if(data){
            window.console.log("userRecord:", JSON.stringify(data));
            let userProfileName = data.fields.Profile.displayValue;
            console.log("userProfileName" + userProfileName);
            this.isAdmin = userProfileName === "System Administrator";
        }

        if(error){
            console.log("Error Occurred", JSON.stringify(error));
        }
    } */

    @wire(getRecord, { recordId: '$userId', fields: [profile] })
    wiredMethod({ error, data }) {
        if(data){
            let userProfileName = data.fields.Profile.displayValue;
            this.isAdmin = userProfileName === "System Administrator";
        }

        if(error){
            console.log("Error Occurred ", JSON.stringify(error));
        }
    }

    createRealEstateAgent(){
        const defaultValues = encodeDefaultFieldValues({
            Leasing__c: this.recordId
        });

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName : 'Leasing_Real_Estate_Agent__c',
                actionName: "new"
            },
            state : {
                defaultFieldValues : defaultValues
            }
        });
    }

    handleRealEstateActive(){
        getRealEstate({
            realEstateId: this.recordId
        })
        .then((result) => {
            result.forEach((realestate) => {
                realestate.Name = realestate.Real_Estate_Agent__r.Name;
                realestate.Email = "***@gmail.com"
                realestate.Phone = realestate.Real_Estate_Agent__r.Phone__c;
                realestate.Picture__c = realestate.Real_Estate_Agent__r.Picture__c;
                realestate.AboutMe__c= realestate.Real_Estate_Agent__r.AboutMe__c;
    
            });
            this.realEstateAgentList = result;

            this.errors = undefined;
        })
        .catch((err) => {
            this.errors = err;
            this.realEstateAgentList = undefined;
            window.console.log("ERR: ", this.errors);
        })
    }

    handleLocationDetails(){
        getLocationDetails ({
            locId: this.recordId
        })
        .then((result) => {
            if(result.Location__C){
                this.leasingRec = result;
            } else {
                this.leasingRec = undefined;
            }
            this.errors = undefined;
        })
        .catch((err) => {
            this.errors = err;
            this.leasingRec = undefined;
            window.console.log("ERR: ", this.errors);
        })
    }

    handleLeasingPotClient(){
        getPotClient ({
            potClientId: this.recordId
        })
        .then((result) => {
            result.forEach((poc) =>{ 
                poc.Name = poc.Potential_Client__r.Name;
                poc.Email = poc.Potential_Client__r.Email__c;

                if(poc.Potential_Client__r.Location__c){
                    poc.Location = poc.Potential_Client__r.Location__r.Name
                } else {
                    poc.Location = "Preferred Not to Say";
                }
            });

           this.potClientList = result;
           this.errors = undefined;
        })
        .catch((err) => {
            this.errors = err;
            this.potClientList = undefined;
            window.console.log("ERR: ", this.errors);
        });
    }

    createPotClient(){
        const defaultValues = encodeDefaultFieldValues({
            Leasing__c: this.recordId
        });

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName : 'Leasing_Potential_Client__c',
                actionName: "new"
            },
            state : {
                defaultFieldValues : defaultValues
            }
        });
    }
}