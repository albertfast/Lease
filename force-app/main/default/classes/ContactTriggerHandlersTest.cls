@isTest
public with sharing class ContactTriggerHandlersTest {
    @isTest
    static void testInsertToAccount() {
        //Create Test Data - Contacts
        List<Contact> contacts = new List<Contact>();
        Contact con = new Contact();
        con.LastName = 'WeWillBeCreateAccount';
        con.Phone = '555-555-8585';
        con.Good_Quantity__c = 5;
        con.Best_Price__c = 10000;
        contacts.add(con);
        Test.startTest();
        insert contacts;
        Test.stopTest();
        List<Account> accounts = [SELECT Name, Phone, Quantity__c, Price__c From Account 
                                  WHERE Name LIKE 'WeWillBeCreateAccount%'];
        System.assertEquals(1, accounts.size(), 'Unexpected number of accounts Created.');
    }
}