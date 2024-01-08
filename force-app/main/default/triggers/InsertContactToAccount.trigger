trigger InsertContactToAccount on Contact (after insert) {
    ContactTriggerHandlers.createAccounts(trigger.new);
}