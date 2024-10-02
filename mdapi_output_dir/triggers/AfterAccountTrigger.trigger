trigger AfterAccountTrigger on Account (after insert, after update, after delete, after undelete) {
    if (trigger.isAfter && trigger.isInsert) {
        AfterTriggerHandler.afterInsertMethod(trigger.new);
    }

    if (trigger.isAfter && trigger.isUpdate) {
        AfterTriggerHandler.afterUpdateMethod(trigger.new, trigger.oldMap);
        AfterTriggerHandler.updateConPhone(trigger.new, trigger.oldMap);
    }

    if (trigger.isAfter && trigger.isDelete) {
        AfterTriggerHandler.afterDeleteMethod(trigger.oldMap);
        AfterTriggerHandler.afterDeleteConMethod(trigger.oldMap);
    }

    if (trigger.isAfter && trigger.isUndelete) {
        AfterTriggerHandler.afterUndeleteMethod(trigger.new);
    }
}