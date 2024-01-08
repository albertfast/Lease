@isTest
public with sharing class DailyOppProcesesorTest {
    
    @isTest
    private static void testScheduledApex() {
        List<Opportunity> oppList = new List<Opportunity>();
        String sch = '0 0 0 ? * * *';
        for (Integer i=0; i<25; i++) {
            if(i<13){
                oppList.add(new Opportunity(Name='Test' +i, StageName='Prospecting', CloseDate = System.today()));
            }else {
                oppList.add(new Opportunity(Name='Test' +i, StageName='Prospecting', CloseDate = System.today(), LeadSource='Partner Referral'));
            }
        }
        insert oppList;

        Test.startTest();
        String jobId = System.schedule('Process Opportunities', sch, new DailyOppProcesesor());
        Test.stopTest();

        List<Opportunity> updatesOppList = [SELECT Id, LeadSource FROM Opportunity
                                     WHERE LeadSource= 'Partner Referral' LIMIT 200];
        System.assertEquals(12, updatesOppList.size());                             
    }
}