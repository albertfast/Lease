@isTest
public with sharing class CalculateCaseOriginTest {
    @isTest
    public static void testCountCases() {
        List<Account> accList = new List<Account>();
        for (Integer i=0; i<5;i++) {
            Account acc = new Account(Name='Test'+i);
            accList.add(acc);
        }
        insert accList;

        List<Case> caseList = new List<Case>();
        List<Id> accIds = new List<Id>();

        for (Account acc : accList) {
            accIds.add(acc.Id);
            for (Integer i=0; i<3;i++) {
                Case c = new Case();
                c.Status='New';
                c.Origin='Phone';
                c.AccountId= acc.Id;
                caseList.add(c);
            }  
            for (Integer i=0; i<3;i++) {
                Case c = new Case();
                c.Status='New';
                c.Origin='Web';
                c.AccountId= acc.Id;
                caseList.add(c);
            }  
            for (Integer i=0; i<3;i++) {
                Case c = new Case();
                c.Status='New';
                c.Origin='Email';
                c.AccountId= acc.Id;
                caseList.add(c);
            }  
        }
        insert caseList;
        Test.startTest();
            CalculateCaseOrigin.countCaseBasedOnOrigin(accIds);
        Test.stopTest();

        List<Account> updatedAcc = [SELECT Id, Cases_through_Email__c, Cases_through_Phone__c,
                                 Cases_through_Web__c FROM Account WHERE Id IN: accIds];
        System.assertEquals(3, updatedAcc[0].Cases_through_Email__c);
        System.assertEquals(3, updatedAcc[0].Cases_through_Phone__c);
        System.assertEquals(3, updatedAcc[0].Cases_through_Web__c);                         
    }
}