public with sharing class CalculateCaseOrigin {
    @future
    public static void countCaseBasedOnOrigin(List<Id> accIds) {
        List<Account> accList = [SELECT Id, Cases_through_Email__c, Cases_through_Phone__c,
                                 Cases_through_Web__c,
                                (SELECT Id, Origin FROM Cases) FROM Account
                                 WHERE Id IN: accIds];
        for (Account acc : accList) {
            Integer Email=0, Web=0, Phone=0;

            for (Case ca : acc.Cases) {
                if (ca.Origin == 'Phone') {
                    Phone++;
                }else if (ca.Origin == 'Web') {
                    Web++;
                }else if (ca.Origin == 'Email') {
                    Email++;
                }
            }
            acc.Cases_through_Email__c = Email;
            acc.Cases_through_Phone__c = Phone;
            acc.Cases_through_Web__c = Web;
        }   
        if (!accList.isEmpty()) {
            update accList;
        }                      
    }
}