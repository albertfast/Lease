
@isTest
public with sharing class InsertContactOnAccountInsertTest {
    @isTest
    public static void testInsertContactOnAccountInsert() {
        Account testAcc = new Account();
        testAcc.Name = 'Test Account';
        testAcc.Rating = 'Hot';
        testAcc.Industry = 'Education';

        insert testAcc;

        Account insertedAccount = [SELECT Name, Rating, Industry From Account WHERE Id = : testAcc.Id ];
        system.assertEquals('Test Account', testAcc.Name);
        system.assertEquals('Hot', testAcc.Rating);
        system.assertEquals('Education', testAcc.Industry);
        
    }
}