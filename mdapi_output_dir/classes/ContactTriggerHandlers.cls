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
   
   public static void countContact(List<Contact> newContacts, Map<Id, Contact> oldMap ){
	Set<Id> accountIds = new Set<Id>();
    for(Contact con: newContacts){
	  accountIds.add(con.AccountId);	
	}
	List<AggregateResult> results = [SELECT AccountId, COUNT(Id) cnt FROM Contact 
					                WHERE AccountId IN:accountIds GROUP BY AccountId];

	List<Account> accountsToUpdate = new List<Account>();
		for(AggregateResult result: results){
		  Id accountId = (Id)result.get('AccountId');
		  Integer count = (Integer)result.get('cnt');
		  accountsToUpdate.add(new Account(Id=accountId, Count_Of_Contact__c = count));
		}
	
		if(!accountsToUpdate.isEmpty()){
		 update accountsToUpdate;
		}
    }

}