@istest(SeeAllData=false)
public class TestClass_DS_SERVREC {
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    // Test baseline controller 
    static TestMethod void Test_Baseline_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SERVREC', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        obj.STATUS_SERVREC__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_SERVREC_Controller controller = new DS_SERVREC_Controller(sc);        
                
        controller.save();
        controller.cancel();
     
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SERVREC', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_F__c obj = new DS_Functioning_Forms_F__c();    
        obj.STATUS_SERVREC__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_SERVREC_Controller controller = new DS_SERVREC_Controller(sc);        
                
        controller.save();
        controller.cancel();
        
    }
    
    static TestMethod void Test_samlpeAsserts(){         
        
      //  Utility ut = new Utility();
      //  TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        //create test client 
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
        obj.client__c = client.id;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        
        //    controllers
       // DS_SERVREC_Controller servrecController = new DS_SERVREC_Controller(sc);
        
        String BOSMEN='99';
        Boolean BLTCOGB = true;
        String BOSOSP= 'null';  
        
        insert obj;
        
        //asserts
        System.assertNotEquals(obj.BOSMEN__c,BOSMEN , 'It is known if the child has recieved mentor services or not within the last 30 days.'); 
        System.assertNotEquals(obj.BLTCOGB__c,BLTCOGB , 'Child has NOT recieved cognitive behavioral therapy in lifetime.');
        System.assertNotEquals(obj.BOSOSP__c,BOSOSP , 'Other service is specified as'+obj.BOSOSP__c+'.');
        
        //save/cancels
     //   servrecController.save();
       // servrecController.cancel();
    }
}