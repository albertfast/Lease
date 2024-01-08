public with sharing class ListOfContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(){
       return [SELECT LastName,Email FROM Contact LIMIT 5];
    }
}