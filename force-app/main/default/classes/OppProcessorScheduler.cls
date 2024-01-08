public with sharing class OppProcessorScheduler implements Schedulable{
    public void execute(SchedulableContext sc)  {
        OppProcessor oppProcess = new OppProcessor();
        Database.executeBatch(oppProcess);
    }
}