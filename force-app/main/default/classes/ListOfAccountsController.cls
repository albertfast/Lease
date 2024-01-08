public with sharing class ListOfAccountsController {
    @AuraEnabled(cacheable=true)
     
    public static List<Account> getAccountList() {
        return [SELECT Id, Name, Phone FROM Account LIMIT 30];
    }
    
    }


