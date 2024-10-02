public with sharing class ErrorLogHelper {
    public static void createErrorLog (String className, String processName, String details) {
        insert new Error_Log__c( 
        Process_Name__c=processName,
        Log_Details__c=details,
        Log_Date_Time__c= Datetime.now()
        );
    }
}