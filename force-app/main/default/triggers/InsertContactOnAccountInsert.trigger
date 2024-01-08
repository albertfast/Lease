trigger InsertContactOnAccountInsert on Account (before insert, after insert,
                                                 before update, before delete) {
    if (trigger.isBefore && trigger.isInsert) {
        BeforeInsertAccountHandler.beforeAccountHandler(trigger.new);
    }
    if (trigger.isBefore && trigger.isUpdate) {
        BeforeInsertAccountHandler.beforeUpdateAccountTrigger(trigger.new, trigger.oldMap);
    }
    if (trigger.isBefore && trigger.isDelete) {
        BeforeInsertAccountHandler.beforeDeleteAccountTrigger(trigger.old);
    }
}



 /* List<Contact> newContact = new List<Contact>();
    for (Account acc : trigger.new) {
        Contact con = new Contact();
        con.FirstName = acc.Name;
        con.LastName = 'My trigger';
        con.Email = 'testem@email.com';
        con.AccountId = acc.Id;

        newContact.add(con);
    }

    if (!newContact.isEmpty()) {
        insert newContact;
    } */