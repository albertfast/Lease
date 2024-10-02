public with sharing class LocationVerificationHandler {
    public static void handleLocationVerification(List<Location__c> newLocations) {
        List<Id> locationIds = new List<Id>();
        
        for(Location__c loc : newLocations){
            locationIds.add(loc.Id);
        }
        
        InvSmartyStreetCaller.getAccountNames(locationIds);
    }
}
