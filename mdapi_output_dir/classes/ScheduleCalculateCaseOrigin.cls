global class ScheduleCalculateCaseOrigin implements Schedulable {
    global void execute(SchedulableContext sc) {
        List<Account> accList = [SELECT Id FROM Account];
        List<Id> accIds = new List<Id>();
        for (Account acc : accList) {
            accIds.add(acc.Id);
        }
        CalculateCaseOrigin.countCaseBasedOnOrigin(accIds);
    }
}

