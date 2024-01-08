public class WeatherDetailsClass {
    @AuraEnabled
    public static WeatherDetailsWrapper getWeatherDetails(String cityName) {
        // Frame the Endpoint URL
        String apiKey = '469d8eb56ad0031a1cfc8ea9f28c0b37';
        String endpoint = 'http://api.openweathermap.org/data/2.5/weather';
        endpoint += '?q=' + EncodingUtil.urlEncode(cityName, 'UTF-8'); // Ensure city name is URL encoded
        endpoint += '&units=metric';
        endpoint += '&APPID=' + apiKey;
        system.debug('Endpoint URL=> ' + endpoint);

        // Callout to Weather API with retry mechanism
        HttpResponse res = performWeatherApiCallout(endpoint);

        // Return the weather details in wrapper form
        WeatherDetailsWrapper weatherDet = new WeatherDetailsWrapper();
        if (res != null && res.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            weatherDet.city = String.valueOf(result.get('name'));
            Map<String, Object> mainResult = (Map<String, Object>) (result.get('main'));
            weatherDet.temperature = String.valueOf(mainResult.get('temp'));
            weatherDet.pressure = String.valueOf(mainResult.get('pressure'));
            weatherDet.humidity = String.valueOf(mainResult.get('humidity'));
            weatherDet.feelsLike = String.valueOf(mainResult.get('feels_like'));
            weatherDet.tempMin = String.valueOf(mainResult.get('temp_min'));
            weatherDet.tempMax = String.valueOf(mainResult.get('temp_max'));
        }
        system.debug('Weather details to return=> ' + weatherDet);
        return weatherDet;
    }

    // Wrapper class to store weather details in a serial manner
    public class WeatherDetailsWrapper {
        @AuraEnabled public String city { get; set; }
        @AuraEnabled public String temperature { get; set; }
        @AuraEnabled public String pressure { get; set; }
        @AuraEnabled public String humidity { get; set; }
        @AuraEnabled public String feelsLike { get; set; }
        @AuraEnabled public String tempMin { get; set; }
        @AuraEnabled public String tempMax { get; set; }
    }

    // Helper method to perform the Weather API callout with retry mechanism
    private static HttpResponse performWeatherApiCallout(String endpoint) {
        Integer maxAttempts = 3; // Maximum number of attempts
        Integer attempt = 0;
        HttpResponse res;

        while (attempt < maxAttempts) {
            attempt++;
            try {
                Http http = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(endpoint);
                req.setMethod('GET');
                req.setTimeout(30000); // Set a longer timeout (in milliseconds), e.g., 30 seconds
                res = http.send(req);

                if (res.getStatusCode() == 200) {
                    return res; // Successful response, exit the loop
                } else {
                    system.debug('Attempt ' + attempt + ' failed with status ' + res.getStatusCode() + '. Retrying...');
                }
            } catch (Exception e) {
                system.debug('Attempt ' + attempt + ' failed with exception: ' + e.getMessage() + '. Retrying...');
            }

            // Exponential backoff: Wait for 2^attempt seconds before retrying
            Long waitTimeMillis = (Long) Math.pow(2, attempt) * 1000;
            // Use System.schedule to introduce delay
            System.schedule('WeatherApiRetry_' + DateTime.now().getTime(), '0 ' + waitTimeMillis / 1000 + ' * * * ?', new ScheduledRetryJob(endpoint));

            // Break the loop for now
            break;
        }

        system.debug('Maximum retry attempts reached. Returning null.');
        return null;
    }

    // Scheduled job class for retry
    public class ScheduledRetryJob implements Schedulable {
        private String endpoint;

        public ScheduledRetryJob(String endpoint) {
            this.endpoint = endpoint;
        }

        public void execute(SchedulableContext sc) {
            // Retry the API callout
            performWeatherApiCallout(endpoint);
        }
    }
}


/*public class WeatherDetailsClass {
    @AuraEnabled
    public static WeatherDetailsWrapper getWeatherDetails(String cityName){
        //Frame the Enpoint URL
        String apiKey = '469d8eb56ad0031a1cfc8ea9f28c0b37';
        String endpoint = 'http://api.openweathermap.org/data/2.5/weather';
        endpoint += '?q='+cityName;
        endpoint += '&units=metric';
        endpoint += '&APPID='+apiKey;
        system.debug('endPoint URL=> '+endpoint);
        
        //Callout to Weather API
        Http http =new http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        // Set a longer timeout (in milliseconds), e.g., 30 seconds
        req.setTimeout(30000);
        HttpResponse res = http.send(req);
        system.debug('response status=> '+res);
        system.debug('response body=> '+JSON.deserializeUntyped(res.getBody()));
        
        //return the weather details in wrapper form
        WeatherDetailsWrapper weatherDet = new WeatherDetailsWrapper();
        if(res.getStatusCode() == 200){
            Map<String,object> result = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
            weatherDet.city = String.valueOf(result.get('name'));
            Map<String,object> mainResult = (Map<String,object>)(result.get('main'));
            weatherDet.temperature = String.valueOf(mainResult.get('temp'));
            weatherDet.pressure = String.valueOf(mainResult.get('pressure'));
            weatherDet.humidity = String.valueOf(mainResult.get('humidity'));
            weatherDet.feelsLike = String.valueOf(mainResult.get('feels_like'));
            weatherDet.tempMin = String.valueOf(mainResult.get('temp_min'));
            weatherDet.tempMax = String.valueOf(mainResult.get('temp_max'));
        }
        system.debug('weather details to return=> '+weatherDet);
        return weatherDet;
        
    }
    
    //Wrapper class to store weather details in serial manner
    public class WeatherDetailsWrapper {
        @AuraEnabled public String city {get;set;}
        @AuraEnabled public String temperature {get;set;}
        @AuraEnabled public String pressure {get;set;}
        @AuraEnabled public String humidity {get;set;}
        @AuraEnabled public String feelsLike {get;set;}
        @AuraEnabled public String tempMin {get;set;}
        @AuraEnabled public String tempMax {get;set;}
    }
    
}*/