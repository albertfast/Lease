@isTest
public with sharing class ContactCloneTest {

    @testSetup
    static void setup(){
        List<Account> accList = new List<Account>();
        
        for(Integer i=0; i<5;i++){
          Account acc = new Account();
          acc.Name = 'Queue'+i;
          acc.Industry = 'Media';
          accList.add(acc);
        }
        insert accList;

       
    }

    @isTest
    public static void testContactClone() {
       // Contact cont = [SELECT Id, LastName FROM Contact WHERE LastName = 'QueueableApex'];
       Contact cont = new Contact(LastName='QueueableApex');
        insert cont;
        String industryValue = 'Media';

        Test.startTest();
        ContactClone conClone = new ContactClone(cont, industryValue);
        Id jobId = System.enqueueJob(conClone);
        Test.stopTest();

        System.assertEquals(10, [SELECT COUNT() FROM Contact 
                                WHERE AccountId IN (SELECT Id FROM Account WHERE Industry = 'Media')]);

    }
}