@istest(SeeAllData=false)
public class TestClass_DS_BSLC {
    
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_BSLC', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        obj.STATUS_BSLC__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_BSLC_Controller controller = new DS_BSLC_Controller(sc);        
        
        List<SelectOption> treatment = controller.getTreatIems();
        List<SelectOption> YNComplete = controller.getYNCompletedIems();
        
        controller.save();
        controller.cancel();
     
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_BSLC', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_F__c obj = new DS_Functioning_Forms_F__c();    
        obj.STATUS_BSLC__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_BSLC_Controller controller = new DS_BSLC_Controller(sc);        
        
        List<SelectOption> treatment = controller.getTreatIems();
        List<SelectOption> YNComplete = controller.getYNCompletedIems();
        
        controller.save();
        controller.cancel();
        
    }
    
    static TestMethod void Test_samlpeAsserts(){  
        
     //   Utility ut = new Utility();
       // TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        //create test client 
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
        obj.client__c = client.id;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        
        //    controllers
       // DS_BSLC_Controller bslcController = new DS_BSLC_Controller(sc);
        
        String BNCCTSBSLC='1';//
        Date BTXSTDT=system.today();
        String BTXCOMP = '1';//
        String BTXTYPSP= 'null'; 
        
        insert obj;
        
        //asserts
        System.assertNotEquals(obj.BNCCTSBSLC__c,BNCCTSBSLC , 'Breakthrough series or learning collaborative NOT led by the UCLA-Duke University National Center for Child Traumatic Stress');
     //   System.assertNotEquals(obj.BTXCOMP__c, BTXCOMP, 'Treatment was NOT completed.');
        System.assertNotEquals(obj.BTXTYPSP__c, BTXTYPSP, 'Other treatment specified as '+obj.BTXTYPSP__c+'.');
        
        //save/cancels
      //  bslcController.save();
        //bslcController.cancel();
    }
}