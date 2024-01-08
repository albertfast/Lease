import { LightningElement, wire } from 'lwc';
import getCon from '@salesforce/apex/ListOfContactController.getContactList';

columns = [
    {label: 'Contact Name', field: 'LastName'},
    {label:'Email', field:'Email'}
];

export default class ContactListLWC extends LightningElement {
    data = [];
    columns = columns;

    @wire(getCon)
    wiredMethod(result){
        if (result.data) {
            this.data = result.data;
        }else if(result.error){
            console.error('Error', result.error);
        }
    }
}