public with sharing class BeforeInsertAccountHandler {
//Write a trigger if account type = customer direct populate Learn Salesforce to Yes
    public static void beforeAccountHandler(List<Account> accListUpdate) {
        for (Account acc : accListUpdate) {
            if (acc.Type == 'Customer - Direct') {
                acc.Learn_Salesforce__c = 'Yes';
            } else {
                acc.Learn_Salesforce__c = 'No';
            }
        }
    }
//Write a trigger if account phone is updated, update the description in Account
    public static void beforeUpdateAccountTrigger(List<Account> newAccList, Map<Id, Account> oldAccMap) {
        for (Account acc : newAccList) {
            if (oldAccMap != null && acc.Phone != oldAccMap.get(acc.Id).Phone) {
                acc.Description = 'The account Phone field is updated, new Phone is : ' + acc.Phone;
            }
            if (oldAccMap != null && acc.Industry != oldAccMap.get(acc.Id).Industry) {
                acc.CustomerPriority__c = 'High';
                acc.Description = ' ==> Account Industry is ' + acc.Industry;
            }
        }
    }
//Write a trigger Prevent account deletion if account is Active
    public static void beforeDeleteAccountTrigger(List<Account> accListDelete) {
        for (Account acc : accListDelete) {
            if (acc.Active__c == 'Yes') {
                acc.Active__c.addError('This account is active mod, so it cant be delete!');
            }
        }
    }
}


