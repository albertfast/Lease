public with sharing class RealEstateAgentDetailsController {
   
    @AuraEnabled
    public static List<Leasing_Real_Estate_Agent__c> getRealEstate(String realEstateId){
       return [ SELECT Id, Name, Real_Estate_Agent__c, Real_Estate_Agent__r.Name, Real_Estate_Agent__r.Phone__c, Real_Estate_Agent__r.Email__c,
       Real_Estate_Agent__r.Picture__c, Real_Estate_Agent__r.AboutMe__c
        FROM Leasing_Real_Estate_Agent__c 
        WHERE Leasing__c = :realEstateId WITH SECURITY_ENFORCED];
    }

    @AuraEnabled
    public static List<Leasing__c> getLocationDetails(String locId){
       return [ SELECT Id, Name__c, Location__c, Location__r.Name, Location__r.City__c, Location__r.Country__c,
       Location__r.Land_Mark__c, Location__r.Postal_Code__c, Location__r.State__c, Location__r.Street__c
        FROM Leasing__c
        WHERE Id = :locId 
        WITH SECURITY_ENFORCED];
    }

    @AuraEnabled
    public static List<Leasing_Potential_Client__c> getPotClient(String potClientId){
       return [ SELECT Id, Name, Potential_Client__c, Potential_Client__r.Name, Potential_Client__r.Email__c, Potential_Client__r.Location__c,
       Potential_Client__r.Location__r.Name
        FROM Leasing_Potential_Client__c
        WHERE Leasing__c = :potClientId 
        WITH SECURITY_ENFORCED];
    }

}


