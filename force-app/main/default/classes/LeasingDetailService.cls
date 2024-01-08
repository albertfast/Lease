public with sharing class LeasingDetailService {

    @AuraEnabled
    public static List<Leasing__c> searchByKeyword(string name){
        String nameLike = '%' + name + '%';

        return [SELECT Id,Name,Name__c,Leasing_Detail__c,Location__c, Location__r.Name,Lease_Office_Manager__c,
                Lease_Office_Manager__r.Name,Start_Date_Time__c
                FROM Leasing__c
                WHERE Start_Date_Time__c >= TODAY
                AND Name__c LIKE :nameLike
                WITH SECURITY_ENFORCED];
    }

  
}