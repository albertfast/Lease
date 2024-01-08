import { LightningElement, api, wire } from 'lwc';
import getLeaveRequests from '@salesforce/apex/LeaveRequstController.getLeaveRequests';
import IsEditable from '@salesforce/schema/ListViewChartInstance.IsEditable';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';
import {refreshApex} from '@salesforce/apex';

const COLUMNS = [
    {label: 'Request Id', fieldName: 'Name', cellAttributes:{class:{fieldName: 'cellClass'}}},
    {label: 'User', fieldName: 'userName', cellAttributes:{class:{fieldName: 'cellClass'}}},
    {label: 'From Date', fieldName: 'From_Date__c', cellAttributes:{class:{fieldName: 'cellClass'}}},
    {label: 'To Date', fieldName: 'To_Date__c', cellAttributes:{class:{fieldName: 'cellClass'}}},
    {label: 'Reason', fieldName: 'Reason__c', cellAttributes:{class:{fieldName: 'cellClass'}}},
    {label: 'Status', fieldName: 'Status__c', cellAttributes:{class:{fieldName: 'cellClass'}}},
    {label: 'Manager Comment', fieldName: 'Manager_Comment__c', cellAttributes:{class:{fieldName: 'cellClass'}}},
    {type:"button", typeAttributes:{
        label:'Edit',
        name:'Edit',
        title:'Edit',
        value:'edit',
        disabled:{fieldName:'isEditDisabled'}
    }, cellAttributes:{class:{fieldName: 'cellClass'}}
    }
];
export default class LeaveRequests extends LightningElement {
    columns = COLUMNS;

    leaveRequests = [];
    leaveRequestsLeavesWireResult;
    showModalPopup = false;
    objectApiName='LeaveRequest__c';
    recordId='';
    currentUserId = Id;

    @wire(getLeaveRequests)
    wiredmyleaves(result){
        this.leaveRequestsLeavesWireResult = result;
        if(result.data){
            this.leaveRequests = result.data.map(a=> ({
                ...a,
                userName:a.User__r.Name,
                cellClass:a.Status__c=='Approved'?'slds-theme_success':a.Status__c=='Rejected'?'slds-theme_warning':'',
                isEditDisabled:a.Status__c!='Pending'
            }));
        }
        if(result.error){
            console.log('Error occures while fetching my leaves- ', result.error);
        }
    }

    get noRecordsFound(){
        return this.leaveRequests.length == 0;
    }
    newRequestClickHandler(){
        this.showModalPopup = true;
        this.recordId = '';
    }

    popupCloseHandler(){
        this.showModalPopup = false;
    }
    rowActionHandler(event){
        this.showModalPopup = true;
        this.recordId = event.detail.row.Id;
    }

    successHandler(){
        this.showModalPopup = false;
        this.showToast('Data saved successfully');
        this.refreshGrid();
    }
    @api 
    refreshGrid(){
        refreshApex(this.leaveRequestsLeavesWireResult);   
    }

    showToast(message,title='success', variant='success'){
        const event = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(event);
    }
}