// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

System.debug('URL ' + Url.getOrgDomainUrl().toExternalForm());
//|USER_DEBUG|[1]|DEBUG|URL https://leasemanagementapplication-dev-ed.develop.my.salesforce.com

List<Location__c> newLocations = new List<Location__c>();

// Yeni lokasyonları oluşturun (burada örnek olarak iki lokasyon eklenmiştir)
newLocations.add(new Location__c(City__c = 'New York', Postal_Code__c = '10001', State__c = 'NY', Street__c = '123 Main St', Country__c = 'USA'));
newLocations.add(new Location__c(City__c = 'San Francisco', Postal_Code__c = '94107', State__c = 'CA', Street__c = '456 Elm St', Country__c = 'USA'));

insert newLocations;

UpdateContactMailingAddress accProcess = new UpdateContactMailingAddress();
Id batchId = Database.executeBatch(accProcess);

List<Account> accList = [SELECT Id FROM Account LIMIT 50];
List<Id> accIds = new List<Id>();
for (Account acc : accList) {
    accIds.add(acc.Id);
}
AccountCalculator.countContacts(accIds);


OppProcessor oppProcess = new OppProcessor();
Id batchId = Database.executeBatch(oppProcess, 1);

List<Account> accList = [SELECT Id FROM Account WHERE BillingCountry = 'USA'];
Id parentId = [SELECT Id FROM Account WHERE Name='Create Account'][0].Id;
UpdateParentAccount updateJob = new UpdateParentAccount(accList,parentId);
Id jobId = System.enqueueJob(updateJob);

OppReminder reminder = new OppReminder();
//Seconds Minutes Hours DayOfMonth Month DayOfWeek Year

String sch =  '0 06 2 27 12 ? 2023';
String jobId = System.schedule('Create Task', sch, reminder);

List<Account> accList = [SELECT Id FROM Account];
List<Id> accIds = new List<Id>();
for (Account acc : accList) {
    accIds.add(acc.Id);
}

CalculateCaseOrigin.countCaseBasedOnOrigin(accIds);

// This is how you schedule the class
            //Seconds Minutes Hours DayOfMonth Month DayOfWeek Year
String cronExp = '0 39 5 25 12 ? 2023'; // replace this with your desired schedule
String jobName = 'MyScheduledSecondJob';
ScheduleCalculateCaseOrigin sc = new ScheduleCalculateCaseOrigin();
System.schedule(jobName, cronExp, sc);


Contact con = new Contact(LastName='QueueableApex');
insert con;
ContactClone conClone = new ContactClone(con, 'Media');
Id jobId = System.enqueueJob(conClone);

LeaveRequestSampleData.createData();