trigger UpdateAccountTotals on Opportunity (after insert, after update, after delete, before insert) {
    if (trigger.isBefore && trigger.isInsert) {
        OpportunityTriggerHandler.updateOpportunityPhone(trigger.new);
    }
    if (Trigger.isDelete) {
        OpportunityTriggerHandler.updateAccountTotal(null, trigger.old);
    } else {
        OpportunityTriggerHandler.updateAccountTotal(Trigger.new, Trigger.old);
    }
}


