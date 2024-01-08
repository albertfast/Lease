public with sharing class AfterTriggerHandler {
    // Write a trigger to create child Contact record Whenever new Account record get created
    public static void afterInsertMethod(List<Account> newAccList) {
        List<Contact> conList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();

        for (Account acc : newAccList) {
            // Create Contact
            Contact con = new Contact();
            con.FirstName = 'Test Trigger';
            con.LastName = acc.Name;
            con.AccountId = acc.Id;

            conList.add(con);

            // Create Opportunity
            Opportunity opp = new Opportunity();
            opp.Name = 'New Opportunity';
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today().addDays(7);
            opp.AccountId = acc.Id;
            opp.Phone__c = acc.Phone; // Add phone number from account to opportunity

            oppList.add(opp);
        }

        if (!conList.isEmpty()) {
            insert conList;
        }
        if (!oppList.isEmpty()) {
            insert oppList;
        }
    }

    //Write a trigger to update child opportunity phone whenever parent account phone get updated
    public static void afterUpdateMethod(List<Account> newAccList, Map<Id, Account> oldAccMap) {
        // Convert newAccList to a Map
        Map<Id, Account> newAccMap = new Map<Id, Account>(newAccList);
    
        // Get the IDs of the accounts whose phone numbers have changed
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : newAccList) {
            if (oldAccMap != null && acc.Phone != oldAccMap.get(acc.Id).Phone) {
                accountIds.add(acc.Id);
            }
        }
        // Query for all opportunities related to these accounts
        List<Opportunity> opps = [SELECT Id, Phone__c, AccountId FROM Opportunity WHERE AccountId IN :accountIds];
    
        // Update the phone numbers of the opportunities
        for (Opportunity opp : opps) {
            opp.Phone__c = newAccMap.get(opp.AccountId).Phone;
        }
        // Update the opportunities
        update opps;
    }
    //Write a trigger to update child Contact phone whenever parent account phone get updated   
    public static void updateConPhone(List<Account> newAccList, Map<Id,Account> oldAccMap) {     
        Map<Id,Account> newAccIdsMap = new Map<Id,Account>();    
        for (Account acc : newAccList) {
            if (oldAccMap != null && acc.Phone != oldAccMap.get(acc.Id).Phone) {
                newAccIdsMap.put(acc.Id, acc);
            }
        }
        // Query for all Contact related to these accounts
        List<Contact> listOfConToBeUpdated = new List<Contact>();

        // Update the phone numbers of the opportunities
        for (Contact con : [SELECT Id, Phone, AccountId FROM Contact 
                            WHERE AccountId IN :newAccIdsMap.keySet()]) {
            if (newAccIdsMap.containsKey(con.AccountId)) {
                con.Phone = newAccIdsMap.get(con.AccountId).Phone;
                listOfConToBeUpdated.add(con);
            }    
        }
       // Update the Contact
       if (!listOfConToBeUpdated.isEmpty()) {
        update listOfConToBeUpdated;
       }     
    }
    //Write a trigger to delete opportunity when account get deleted
    public static void afterDeleteMethod(Map<Id,Account> mapIdAccount) {
        List<Opportunity> oppListToBeDeleted = new List<Opportunity>();
        for (Opportunity opp : [SELECT Id FROM Opportunity WHERE AccountId IN : mapIdAccount.keySet()]) {
            oppListToBeDeleted.add(opp);
        }
        if (!oppListToBeDeleted.isEmpty()) {
            delete oppListToBeDeleted;
        }
    }
    //Write a trigger to delete Contact when account get deleted
    public static void afterDeleteConMethod(Map<Id,Account> mapIdAccount) {
        List<Contact> conListToBeDeleted = new List<Contact>();
        for (Contact con : [SELECT Id FROM Contact WHERE AccountId IN : mapIdAccount.keySet()]) {
            conListToBeDeleted.add(con);
        }
        if (!conListToBeDeleted.isEmpty()) {
            delete conListToBeDeleted;
        }
    }
    //Write a trigger to undelete recycle bin and store it in org
    public static void afterUndeleteMethod(List<Account> accList) {
        List<Account> accListToBeUpdated = new List<Account>();
        for (Account acc : accList) {
            Account accnt = new Account();
            accnt.Id = acc.Id;
            accnt.Active__c = 'Yes';
            accListToBeUpdated.add(accnt);
        }
        if (!accListToBeUpdated.isEmpty()) {
            update accListToBeUpdated;
        }
    }
}