import { LightningElement, wire } from 'lwc';
import getAcc from '@salesforce/apex/ListOfAccountsController.getAccountList';

const columns = [
    {label: 'Account Name', fieldName: 'Name'},
    {label:'Phone', fieldName: 'Phone'}
];


export default class ListOfAccounts extends LightningElement {
    data = [];
    columns = columns;

    @wire(getAcc)
    wiredAccounts(result){
        if (result.data) {
            this.data = result.data;
        }else if(result.error){
            console.error('Error', result.error);
        }
    }
}


