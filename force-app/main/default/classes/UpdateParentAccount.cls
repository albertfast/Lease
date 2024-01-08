public with sharing class UpdateParentAccount implements Queueable {
    private List<Account> accList;
    private Id parentAccId;

    public UpdateParentAccount(List<Account> accRecords, Id id){
        this.accList = accRecords;
        this.parentAccId = id;
    }

    public void execute (QueueableContext context){
        List<Account> validAccounts = new List<Account>();
        for (Account acc : accList) {
            if(acc.Id != parentAccId){
                acc.ParentId = parentAccId;
                validAccounts.add(acc);
            }
        }
        update validAccounts;
    }  
}