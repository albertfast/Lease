public with sharing class InvSmartyStreetCaller {

    @InvocableMethod(label='SmartyStreetAPI' description='Makes an HTTP GET to Smarty.com' category='Location__c')
    public static void getAccountNames(List<Id> locationIds) {
        makeCallout(locationIds[0]);
    }

    @future(callout=true)
    private static void makeCallout(Id locId) {
         try {

            Location__c location = [ SELECT City__c, Postal_Code__c, State__c, Street__c FROM Location__c
                                    WHERE Id=: locId];    

            String endpoint = 'https://us-street.api.smartystreets.com/street-address'
            + '?auth-id=650c7f0f-e882-e981-d234-b314f8e0d218'
            + '&auth-token=D3qAxS3x8aoeAYKMVzGU'
            +'&street=' + location.Street__c
            +'&city=' + location.City__c
            +'&state=' + location.State__c
            +'&zipcode=' + location.Postal_Code__c
            +'&match=enhanced'
            +'&license=us-rooftop-geocoding-cloud';

            System.debug('endpoint: ' + endpoint);  

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            Integer statusCode = response.getStatusCode();
            System.debug('statusCode:' + statusCode);

            String respBody = response.getBody();
            System.debug('response Body:' + respBody);

          
         } catch (Exception exc) {
            String msg = exc.getMessage() + '(line: ' + exc.getLineNumber();
            System.debug('Exc: ' + msg);
            ErrorLogHelper.createErrorLog('InvSmartyStreetCaller', 'makeCallout', msg);
         }
    }
}