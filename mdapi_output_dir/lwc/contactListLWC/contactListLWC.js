import { LightningElement, wire } from 'lwc';
import getCon from '@salesforce/apex/ListOfContactController.getContactList';

const columns = [
    {label: 'Contact Name', fieldName: 'LastName'},
    {label: 'Email', fieldName: 'Email'}
];

export default class ContactListLWC extends LightningElement {
    data = [];
    columns = columns;

    @wire(getCon)
    wiredMethod({ error, data }) {
        if (data) {
            this.data = data;
        } else if (error) {
            console.error('Error', error);
        }
    }
}

