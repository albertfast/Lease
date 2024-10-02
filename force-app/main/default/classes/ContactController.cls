public without sharing class ContactController {

    // Retrieves contacts owned by the logged-in user with non-null email and account, ordered by email
    @AuraEnabled(cacheable=true)
    public static List<Contact> getUserContacts() {
        Id userId = UserInfo.getUserId();
        List<Contact> contacts = [SELECT Id, OwnerId, Owner.Name, FirstName, LastName, Email, Phone, Account.Name, CreatedDate 
                                  FROM Contact 
                                  WHERE OwnerId = :userId
                                  AND Email != null
                                  AND AccountId != null
                                  ORDER BY Email ASC];
        System.debug(contacts);
        return contacts;
    }

    // Merges two contacts by updating the first one and deleting the second
    @AuraEnabled
    public static void mergeContacts(String contactId1, String contactId2, String firstName, String lastName, String email, String phone) {
        try {
            // Query the contacts to be merged
            List<Contact> contactsToUpdate = [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Id IN :new List<String>{contactId1, contactId2}];
            
            System.debug('Contacts to update: ' + contactsToUpdate);
            
            if (contactsToUpdate.size() == 2) {
                // Update first contact with merged data
                Contact contact1 = contactsToUpdate[0];
                contact1.FirstName = firstName;
                contact1.LastName = lastName;
                contact1.Email = email;
                contact1.Phone = phone;

                // Delete second contact
                Contact contact2 = contactsToUpdate[1];
                delete contact2;

                // Save updated first contact
                update contact1;

                System.debug('Merge Successful');
            } else {
                throw new AuraHandledException('Could not find both contacts.');
            }
        } catch (Exception e) {
            // Handle any errors during the merge
            throw new AuraHandledException('Error merging contacts: ' + e.getMessage());
        }
    }
}
