global with sharing class RemindOppOwners implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<Opportunity> oppList = [SELECT Id, Name, OwnerId, CloseDate FROM Opportunity
                                     WHERE IsClosed=FALSE AND CloseDate < TODAY];
      TaskUtils.remindOwners(oppList);                               
    }
}