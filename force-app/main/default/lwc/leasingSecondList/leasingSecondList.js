import { LightningElement, track } from 'lwc';
import searchByKeyword from "@salesforce/apex/LeasingDetailService.searchByKeyword";

const COLUMNS = [
    {
        label: "View",
        fieldName: "detailsPage",
        type: "url",
        wrapText: "true",
        typeAttributes: {
            label : {
                fieldName: "Name__c"
            },
            target: "_self"
        }
    },
    {
        label: "Name",
        fieldName: "Name__c",
        wrapText: "true",
        cellAttributes: {
            iconName:"standard:account",
            iconPosition: "left"
        }
    },
    {
        label: "Lease Office Manager",
        fieldName: "organizer",
        wrapText: "true",
        cellAttributes: {
            iconName:"standard:user",
            iconPosition: "left"
        }
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
export default class LeasingSecondList extends LightningElement {

    columnsList = COLUMNS;
    error;
    startDateTime;

    @track recordsToDisplay;
    @track result;


    handleSearch(event) {
        let keyword = event.detail.value;

        if(keyword && keyword.length >=2){
            searchByKeyword({
              name : keyword  
            })
            .then((data) => {
                console.log("data:" + JSON.stringify(data));

                data.forEach((record) => {
                    record.detailsPage = "https://" + window.location.host + "/" + record.Id;
                    record.organizer = record.Lease_Office_Manager__c.Name;

                    if(record.Location__c){
                        record.Location = record.Location__r.Name;
                    } else {
                        record.Location = "This is Not have location yet";
                    }
                });

                this.result = data;
                this.recordsToDisplay = data;
                this.error = undefined;
            })
            .catch((err) => {
                console.log("ERR:" + JSON.stringify(err));
                this.error = JSON.stringify(err);
                this.result = undefined;
            });
        }
    }

    handleStartDate(event) {
        let valuedatetime = event.target.value;
        console.log("selectedDate:" + valuedatetime);

        let filteredLeasings = this.result.filter((record, index, arrayobject) => {
            return record.Start_Date_Time__c >= valuedatetime;
        });

        this.recordsToDisplay = filteredLeasings;
    }

    handleLocationSearch(event){
        let keyword = event.detail.value;

        let filteredLeasings = this.result.filter((record, index, arrayobject) => {
            return record.Location.toLowerCase().inculudes(keyword.toLowerCase());
        });

        if(keyword & keyword.length >= 2) {
            this.recordsToDisplay = filteredLeasings;
        } else {
            this.recordsToDisplay = this.result;
        }
    }
}