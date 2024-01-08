@isTest
public with sharing class OpportunityTriggerHandlerTest {
    @isTest
    public static void testUpdateAccountTotal() {
        // Create test data - Accounts
        Account acc = new Account(Name = 'Test Account Total Amount');
        insert acc;

        // Test insert
        Opportunity opp = new Opportunity(
            Name = 'Amount Cool Opp',
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(7),
            Amount = 100,
            AccountId = acc.Id
        );
        insert opp;

        // Test update
        opp.Amount = 200;
        update opp;

        // Test delete
        delete opp;

        // Retrieve the updated Account records
        Account updatedAccount = [SELECT Id, Total_Opportunities__c, Total_Amount__c 
                                  FROM Account WHERE Id = :acc.Id];

        // Assert the account records have been updated correctly
        System.assertEquals(0, updatedAccount.Total_Opportunities__c, 'Total_Opportunities__c is incorrect');
        System.assertEquals(0, updatedAccount.Total_Amount__c, 'Total_Amount__c is incorrect');                                
    }
}
