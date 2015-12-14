@isTest
global class TestClass_Mock_HttpResponse_DS_DATA implements HttpCalloutMock {
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://cs15.salesforce.com/sobjects/DS_DATA__c', req.getEndpoint());
        //System.assertEquals('POST', req.getMethod());
         
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"totalSize":32,"done":true,"records":[{"attributes":{"type":"DS_DATA__c","url":"/services/data/v34.0/sobjects/DS_DATA__c/a08e0000004dmSfAAI"},"Name":"DS DATA - 368983","Age_Range__c":null,"Category__c":null,"CODE__c":null,"CODELIST__c":null,"Content__c":"I am on the lookout for danger or things that I am afraid of (like looking over my shoulder even when nothing is there).","Data_Type__c":"DS_PTSD_Form_Info","Describe_Field__c":null,"Field__c":"PTSV1","FILE_NAME__c":"BASELINE","Form__c":"DS_PTSD_CA","Gender__c":null,"Gender_Required__c":false,"LONG_DESCRIPTION__c":null,"LONGLABEL__c":null,"Note__c":null,"Number__c":1.0,"Object__c":"DS_PTSD_CA_B","Page__c":null,"Percentile__c":null,"Question_Field__c":null,"Raw_Score__c":null,"Scale__c":null,"Scale_Number__c":null,"Section__c":false,"Sig_Range__c":null,"SOURCE_FORM__c":null,"Symptom__c":"E3","T_Score__c":null,"Type__c":"Children / Adolescents","Variable__c":null,"VARIABLE_LABEL__c":null,"VARIABLE_NAME__c":null,"VARIABLE_NUMBER__c":null,"VARIABLE_TYPE__c":null,"VARIABLE_VALUE__c":null,"Weight__c":null}]}');
        res.setStatusCode(200);
        return res;
        
    }

}