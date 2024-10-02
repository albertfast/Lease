trigger InsertContactToAccount on Contact (after insert, after update) {
   if (trigger.isInsert || trigger.isUpdate) {
    ContactTriggerHandlers.createAccounts(trigger.new);
    ContactTriggerHandlers.countContact(trigger.new, trigger.oldMap);
   }

}