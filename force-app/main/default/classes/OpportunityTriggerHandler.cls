
public with sharing class OpportunityTriggerHandler {
    public static void updateOpportunityPhone(List<Opportunity> newOpportunities) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : newOpportunities) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Phone FROM Account WHERE Id IN :accountIds]);

        for (Opportunity opp : newOpportunities) {
            if (opp.AccountId != null && accountMap.containsKey(opp.AccountId)) {
                opp.Phone__c = accountMap.get(opp.AccountId).Phone;
            }
        }
    }
//Whenever a create or update or delete opportunity object record updated total opportunities and total amount in account object
    public static void updateAccountTotal(List<Opportunity> newOpportunities, List<Opportunity> oldOpportunities) {
        try {
            Set<Id> accountIdsToUpdate = new Set<Id>();
    
            if (newOpportunities != null) {
                for (Opportunity opp : newOpportunities) {
                    if (opp.AccountId != null) {
                        accountIdsToUpdate.add(opp.AccountId);
                    }
                }
            }
    
            if (oldOpportunities != null) {
                for (Opportunity opp : oldOpportunities) {
                    if (opp.AccountId != null) {
                        accountIdsToUpdate.add(opp.AccountId);
                    }
                }
            }
            // Update account records
            List<Account> accountsToUpdate = new List<Account>();
    
            for (Id accId : accountIdsToUpdate) {
                Account acc = new Account(Id = accId);
    
                // Use aggregate query to get count of opportunities and total amount
                AggregateResult[] results = [SELECT COUNT(Id), SUM(Amount) 
                                             FROM Opportunity 
                                             WHERE AccountId = :accId];
    
                acc.Total_Opportunities__c = (results != null && !results.isEmpty() && results[0].get('expr0') != null) ? (Integer)results[0].get('expr0') : 0;
                acc.Total_Amount__c = (results != null && !results.isEmpty() && results[0].get('expr1') != null) ? (Decimal)results[0].get('expr1') : 0.0;
    
                accountsToUpdate.add(acc);
            }
    
            // Update the account records
            update accountsToUpdate;
        } catch (System.NullPointerException e) {
            System.debug('Caught a NullPointerException: ' + e.getMessage());
        }
    }  
} 
