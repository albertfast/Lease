@isTest
private class InvSmartyStreetCallerTest {
    @isTest
    static void tester() {
        Location__c location = new Location__c(Name = 'Test Address Name',
                                                City__c = 'TestCity',
                                                Postal_Code__c ='94255',
                                                State__c = 'TestState',
                                                Street__c = 'TestStreet',
                                                Country__c = 'USA');

        Test.startTest();
        insert location;
        Test.stopTest();

        location = [SELECT Verified__c FROM Location__c WHERE Id=: location.Id ];
        System.assertEquals(true, location.Verified__c);
    }

    @isTest
    static void testPositive() {
        Location__c location = new Location__c(Name = 'Test Address Name',
                                                City__c = 'TestCity',
                                                Postal_Code__c ='94255',
                                                State__c = 'TestState',
                                                Street__c = 'TestStreet',
                                                Country__c = 'USA');
         //Set mock callout classs
         Test.setMock(HttpCalloutMock.class, new MockSmartyStreetApi());                                       

        Test.startTest();
        insert location;
        Test.stopTest();

        location = [SELECT Verified__c FROM Location__c WHERE Id=: location.Id ];
        System.assert(location.Verified__c);
    }

    public class MockSmartyStreetApi implements HttpCalloutMock {
        // Implement this interface method
      public HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
          //  System.assertEquals('http://example.com/example/test', req.getEndpoint());
         //   System.assertEquals('GET', req.getMethod());
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }
}