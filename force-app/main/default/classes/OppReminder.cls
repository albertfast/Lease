public with sharing class OppReminder implements Schedulable {
    public void execute(SchedulableContext ctx){
        List<Opportunity> oppList = [SELECT Id, StageName, CloseDate FROM Opportunity
                                    WHERE IsClosed=FALSE AND CloseDate < TODAY];
    List<Task> taskList = new List<Task>();
    if (!oppList.isEmpty()) {
        for (Opportunity opp : oppList) {
           Task tsk = new Task();
            tsk.Subject = 'Reminder Task';
            tsk.Status = 'Open';
            tsk.Priority = 'Normal';
            tsk.WhatId = opp.Id;
            tsk.OwnerId = opp.OwnerId;
            taskList.add(tsk);
        }
    }  
    
    if (!taskList.isEmpty()) {
        insert taskList;
    }
    }
}