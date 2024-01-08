@RestResource(urlMapping='/LeasingDetails/*')
global with sharing class WsLeasingDetails {
   //https://leasemanagementapplication-dev-ed.develop.my.salesforce.com/services/apexrest/LeasingDetails/
    @HttpGet
    global static List<LeasingWrapper> getLeasingDetails(){
       List<LeasingWrapper> leasing = new List<LeasingWrapper>();
       for(Leasing__c le : [SELECT Id,Name,Name__c,Start_Date_Time__c,	End_Date_Time__c,Recurring__c,Lease_Office_Manager__c,Leasing_Type__c 
                            FROM Leasing__c 
                            WHERE Recurring__c = TRUE 
                            AND Start_Date_Time__c >= TODAY 
                            WITH SECURITY_ENFORCED ])
                            {
                                leasing.add(new LeasingWrapper(le));
                            }
                            return leasing;
        
    }

    global class LeasingWrapper {
        global String leasingId;
        global String stdName;
        global String name;
        global string startDate;
        global Datetime endDate;
        global Boolean leasingReccuring;
        global String leasingOfficeManager;
        global String leasingType;

        global LeasingWrapper(Leasing__c lease){
            this.leasingId=String.valueOf(lease.Id);
            this.stdName=lease.Name;
            this.name=lease.Name__c;
            this.startDate=lease.Start_Date_Time__c.format('yyyy-MM-dd HH:mm');
            this.endDate=lease.End_Date_Time__c;
            this.leasingReccuring=lease.Recurring__c;
            this.leasingOfficeManager=lease.Lease_Office_Manager__c;
            this.leasingType=lease.Leasing_Type__c;
        }
    }
}