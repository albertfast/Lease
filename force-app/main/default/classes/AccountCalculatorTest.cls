@isTest
public with sharing class AccountCalculatorTest {
    @isTest
    public static void countContactsTest() {
        List<Account> accList = new List<Account>();

        for (Integer i=0; i<5; i++) {
            accList.add(new Account(Name='Test Account'+i));
        }
        insert accList;
        List<Contact> conList = new List<Contact>();
        List<Id> accIds = new List<Id>();
        for (Account acc : accList) {
            conList.add(new Contact(FirstName = 'Test', LastName=acc.Name, AccountId=acc.Id));
            accIds.add(acc.Id);
        }
        insert conList;

        Test.startTest();
        AccountCalculator.countContacts(accIds);
        Test.stopTest();

        List<Account> accs = [SELECT Id, Number_Of_Contacts__c FROM Account];

        System.assertEquals(2, accs[0].Number_Of_Contacts__c, 'Contacts are not counted successfully');

    }
} 



