//Write a batch apex to populate Account Billing address on related Contact's Mailing address.
public with sharing class UpdateContactMailingAddress implements Database.Batchable<SObject>,Database.Stateful{
   public Integer recordCount = 0;
   public Database.QueryLocator start(Database.BatchableContext bc){
    return Database.getQueryLocator(
        'SELECT Id,  BillingStreet, BillingCity, BillingState, BillingPostalCode,' +
        '(SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode FROM Contacts)' +
        'FROM Account WHERE BillingCountry = \'USA\''
    );  
   }
   public void execute(Database.BatchableContext bc, List<Account> accList){
    List<Contact> conList = new List<Contact>();
    for (Account acc : accList) {
        for (Contact con : acc.Contacts) {
            con.MailingStreet = acc.BillingStreet;
            con.MailingCity = acc.BillingCity;
            con.MailingState = acc.BillingState;
            con.MailingPostalCode = acc.BillingPostalCode;
            conList.add(con);
            recordCount++;
        }
    }
    update conlist;
   }
   public void finish(Database.BatchableContext bc){
    System.debug('Record Count = ' + recordCount);
   }
}