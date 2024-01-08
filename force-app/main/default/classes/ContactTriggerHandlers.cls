public with sharing class ContactTriggerHandlers {
    //When ever a record is inserted to the contact automatically inserted to the account
   public static Boolean isRecursive = false;
   public static void createAccounts(List<Contact> newContacts) {
    if(!isRecursive){
        isRecursive = true;
        List<Account> accountsToInsert = new List<Account>();
        for (Contact con : newContacts) {
            Account acc = new Account();
            acc.Phone = con.Phone;
            acc.Name = con.LastName;
            acc.Quantity__c = con.Good_Quantity__c;
            acc.Price__c = con.Best_Price__c;
            accountsToInsert.add(acc);
        }
        insert accountsToInsert;
        isRecursive = false;
    }
   }    
}