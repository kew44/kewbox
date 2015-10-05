@isTest (SeeAllData=false)
public class TestClass_DS_DATA_SYNC {
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    /*@testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }*/
    
    @isTest static void Test_CalloutOauth() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new TestClass_Mock_HttpResponse_Oauth());
        
        DS_DATA_SYNC_Controller sync = new DS_DATA_SYNC_Controller();
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        sync.testConnection();
        sync.step1();
        
        //Test.setMock(HttpCalloutMock.class, new TestClass_Mock_HttpResponse_DS_DATA());
        
        //sync.step2();
        
        //sync.sync();
        
        // Verify response received contains fake values
        //String contentType = res.getHeader('Content-Type');
        //System.assert(contentType == 'application/json');
        //String actualValue = res.getBody();
        //String expectedValue = '{"foo":"bar"}';
        //System.assertEquals(actualValue, expectedValue);
        //System.assertEquals(200, res.getStatusCode());
    }
    
    @isTest static void Test_CalloutSync() {
        
        
        DS_DATA_SYNC_Controller sync = new DS_DATA_SYNC_Controller();
        
        
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new TestClass_Mock_HttpResponse_DS_DATA());
        
        sync.syncRecord('DS_PTSD_Form_Info', new List<String>{'field', 'number'}, '');

        Test.setMock(HttpCalloutMock.class, new TestClass_Mock_HttpResponse_Oauth());
        sync.step1();
        
        sync.step2();
        
        sync.getItems();
        
        sync.sync();
        
        // Verify response received contains fake values
        //String contentType = res.getHeader('Content-Type');
        //System.assert(contentType == 'application/json');
        //String actualValue = res.getBody();
        //String expectedValue = '{"foo":"bar"}';
        //System.assertEquals(actualValue, expectedValue);
        //System.assertEquals(200, res.getStatusCode());
    }
    
}