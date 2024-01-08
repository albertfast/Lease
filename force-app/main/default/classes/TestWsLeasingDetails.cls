@isTest
public with sharing class TestWsLeasingDetails {
   
    @isTest
    public static void tester() {
        Lease_Office_Manager__c  manager = new Lease_Office_Manager__c (Name='Manager Test',Email__c ='testemail1@test.com', Phone__c ='12122356789');
        insert manager;
        Leasing__c  leasing1= new Leasing__c (Name__c='Test Leasing', Lease_Office_Manager__c= manager.Id, Start_Date_Time__c = Datetime.now().addDays(14), End_Date_Time__c = Datetime.now().addDays(45));
        insert leasing1;

        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        RestContext.request.requestURI = '/services/apexrest/LeasingDetails/' ;
        RestContext.request.httpMethod = 'GET';
        test.startTest();
       List<WsLeasingDetails.LeasingWrapper> leasing = WsLeasingDetails.getLeasingDetails();
        test.stopTest();

        system.assertEquals(1, leasing.size());
        WsLeasingDetails.LeasingWrapper result = leasing[0];
        system.assertEquals('Test Leasing', result.name);
    }
}