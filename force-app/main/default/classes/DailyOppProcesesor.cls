public with sharing class DailyOppProcesesor implements Schedulable{
    public void execute(SchedulableContext ctx) {
        List<Opportunity> oppList = [SELECT Id, LeadSource FROM Opportunity
                                     WHERE LeadSource= 'Web' LIMIT 200];
      for (Opportunity opp : oppList) {
        opp.LeadSource = 'Phone';
      }                        
      if (!oppList.isEmpty()) {
        update oppList;
      }     
    }
}