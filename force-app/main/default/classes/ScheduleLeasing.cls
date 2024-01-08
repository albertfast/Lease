public  class ScheduleLeasing implements Database.Batchable<sObject>, Schedulable {
    
    //Schedule Functionality
    public void execute(SchedulableContext sc){
        Database.executeBatch(new ScheduleLeasing());

        }
    
    //Batch records query
    public Database.QueryLocator start(Database.BatchableContext bc){
       
        Database.QueryLocator q1 = Database.getQueryLocator([select id from Leasing__c where End_Date_Time__c<=:Datetime.now().addMonths(-2) and Status__c = 'Completed' ]);
        return q1;
   
   }
   
   //the real what to do
   public void execute(Database.BatchableContext bc, List<Leasing__c> leasings){
    delete leasings;

    }

    //send email
    public void finish(Database.BatchableContext bc){
    //find members
    set<Id> userIds=new set<Id>();
    for(groupMember gm:[select UserOrGroupId from groupMember where Group.name= 'Daily Job']){
        userIds.add(gm.UserOrGroupId);

    }
    set<String> emailAddresses=new set<String>();
    for(user us:[select email from user where IsActive =true and Id in: userIds]){
        emailAddresses.add(us.email);

    }

    //send email to daily job public group members
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   mail.setSubject('Daily Job Leasing Completed.');
   mail.setSenderDisplayName('SI Salesforce Robot');
   mail.setPlainTextBody('Daily Job Leasing is Completed.You can check Setup ->Apex Jobs.');
   mail.setHtmlBody('<p>Daily Job Leasing is Completed.You can check Setup ->Apex Jobs.</p>');


   String[] toAddresses = new String[] {'wekone8076@mailvxin.net'};
   mail.setToAddresses(new List<String>(emailAddresses));
   Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});    
    
    


}
}