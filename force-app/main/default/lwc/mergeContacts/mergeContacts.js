import { LightningElement, wire, track } from 'lwc';
import getUserContacts from '@salesforce/apex/ContactController.getUserContacts';
import mergeContacts from '@salesforce/apex/ContactController.mergeContacts'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MergeContacts extends LightningElement {
    @track contacts = []; // List of contacts owned by the logged-in user
    @track showDuplicates = false; // Toggle for showing/hiding possible duplicate contacts
    @track toggleButtonLabel = 'Show Possible Duplicates'; // Label for toggle button
    @track selectedContacts = []; // Contacts selected by the user for merging
    @track showModal = false; // Control for displaying the modal
    @track contact1; // First selected contact
    @track contact2; // Second selected contact

    // Merged contact field values (user's selected data)
    @track mergedFirstName;
    @track mergedLastName;
    @track mergedEmail;
    @track mergedPhone;

    // Options for user to choose between the two selected contacts' values
    @track firstNameOptions = [];
    @track lastNameOptions = [];
    @track emailOptions = [];
    @track phoneOptions = [];

    // Column definitions for the datatable
    columns = [
        { label: 'Select', fieldName: 'checkbox', type: 'checkbox' },
        { label: 'First Name', fieldName: 'FirstName', type: 'text' },
        { label: 'Last Name', fieldName: 'LastName', type: 'text' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },
        { label: 'Account Name', fieldName: 'AccountName', type: 'text' },
        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' },
        { label: 'Owner', fieldName: 'OwnerName', type: 'text' } // Added column for contact owner
    ];

    // Fetch contacts owned by the logged-in user and map the account and owner names
    @wire(getUserContacts)
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data.map(contact => {
                return {
                    ...contact,
                    AccountName: contact.Account ? contact.Account.Name : '',
                    OwnerName: contact.Owner ? contact.Owner.Name : '' // Map owner name
                };
            });
        } else if (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error fetching contacts',
                    variant: 'error',
                }),
            );
        }
    }

    // Toggle the display of possible duplicate contacts
    toggleDuplicateList() {
        this.showDuplicates = !this.showDuplicates;
        this.toggleButtonLabel = this.showDuplicates ? 'Hide Duplicates' : 'Show Possible Duplicates';
    }
    
    // Handle row selection in the datatable
    handleCheckboxChange(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedContacts = selectedRows.map(row => row.Id);
    }

    // Filter contacts to show only possible duplicates (contacts with the same Email and AccountId)
    showDuplicates() {
        this.contacts = this.contacts.filter(contact => {
            return this.contacts.some(otherContact => 
                otherContact.Email === contact.Email && 
                otherContact.AccountId === contact.AccountId && 
                otherContact.Id !== contact.Id
            );
        });
    }

    // Handle the merge process: validate selection and open the modal for field selection
    handleMerge() {
        if (this.selectedContacts.length !== 2) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please select exactly 2 contacts to merge.',
                    variant: 'error',
                }),
            );
            return;
        }

        const selectedContactsData = this.contacts.filter(contact => this.selectedContacts.includes(contact.Id));

        this.contact1 = selectedContactsData[0];
        this.contact2 = selectedContactsData[1];

        // Prepare options for the modal (user can choose between the two contacts' values)
        this.firstNameOptions = [
            { label: this.contact1.FirstName, value: this.contact1.FirstName },
            { label: this.contact2.FirstName, value: this.contact2.FirstName }
        ];
        this.lastNameOptions = [
            { label: this.contact1.LastName, value: this.contact1.LastName },
            { label: this.contact2.LastName, value: this.contact2.LastName }
        ];
        this.emailOptions = [
            { label: this.contact1.Email, value: this.contact1.Email },
            { label: this.contact2.Email, value: this.contact2.Email }
        ];
        this.phoneOptions = [
            { label: this.contact1.Phone, value: this.contact1.Phone },
            { label: this.contact2.Phone, value: this.contact2.Phone }
        ];

        // Set default values for the modal form (values from contact1)
        this.mergedFirstName = this.contact1.FirstName;
        this.mergedLastName = this.contact1.LastName;
        this.mergedEmail = this.contact1.Email;
        this.mergedPhone = this.contact1.Phone;

        // Check if the selected contacts are duplicates (same Email and AccountId)
        if (this.contact1.Email === this.contact2.Email && this.contact1.AccountId === this.contact2.AccountId) {
            this.showModal = true; // Open the modal if duplicates
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'The two selected contacts are not duplicates. You cannot merge them.',
                    variant: 'error',
                }),
            );
        }
    }

    // Handle user input in the modal (for merging contacts)
    handleFirstNameChange(event) {
        this.mergedFirstName = event.target.value;
    }

    handleLastNameChange(event) {
        this.mergedLastName = event.target.value;
    }

    handleEmailChange(event) {
        this.mergedEmail = event.target.value;
    }

    handlePhoneChange(event) {
        this.mergedPhone = event.target.value;
    }

    // Close the modal without saving changes
    handleModalClose() {
        this.showModal = false;
    }

    // Save the merged contact data
    async handleSave() {
        try {
            await mergeContacts({
                contactId1: this.contact1.Id,
                contactId2: this.contact2.Id,
                firstName: this.mergedFirstName,
                lastName: this.mergedLastName,
                email: this.mergedEmail,
                phone: this.mergedPhone
            });

            this.showModal = false; // Close the modal on success
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contacts merged successfully!',
                    variant: 'success',
                }),
            );
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Error merging contacts: ' + error.body.message,
                    variant: 'error',
                }),
            );
        }
    }
}
