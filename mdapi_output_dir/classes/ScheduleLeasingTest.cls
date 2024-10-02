@isTest
private  class ScheduleLeasingTest {

    @isTest 
    static void tester(){
        Lease_Office_Manager__c lstest=new Lease_Office_Manager__c(name='Test',Email__c='test@gmail.com',Phone__c='346532');
        insert lstest;
        
        List<Leasing__c>  ls=new List<Leasing__c>();
        for(integer i=0;i<200;i++){
            ls.add(new Leasing__c(Lease_Office_Manager__c=lstest.Id,Name__c='Test Leasing '+ String.valueof(i),Start_Date_Time__c=datetime.now().addMonths(-3),End_Date_Time__c=datetime.now().addMonths(-3).addDays(1)));
            
            }
            insert ls;

            Test.startTest();
            ScheduleLeasing obj= new ScheduleLeasing();
            obj.execute(null);
            test.StopTest();

            Integer eventCount=[select count() from Leasing__c];
            system.assertEquals(0,eventCount);

    }
    
}