@isTest
global class TestClass_Mock_HttpResponse_Oauth implements HttpCalloutMock {
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://cs15.salesforce.com/services/oauth2/token', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
         
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"00De0000005UKMn!ARIAQLdFf0Fz90cXxvQNDXAzNyTKvj69ehaB.aCA5qMK4XzCjlkah25mc0eZFN21hZduU2oVnFcokP.3JZbKS9My4rYynmKD","instance_url":"https://cs15.salesforce.com","id":"https://test.salesforce.com/id/00De0000005UKMnEAO/005i0000001QIixAAG","token_type":"Bearer","issued_at":"1441138053989","signature":"MK3mtjYVr8799Dqu0TePIyF9TXTHjZnWRGlRxv1fwWU="}');
        res.setStatusCode(200);
        return res;
        
    }

}