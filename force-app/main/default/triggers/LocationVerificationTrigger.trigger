trigger LocationVerificationTrigger on Location__c (after insert) {
    LocationVerificationHandler.handleLocationVerification(Trigger.new);
}
