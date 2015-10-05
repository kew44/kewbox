@istest(SeeAllData=false)
public class TestClass_DS_CLINEVAL{
    
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_CLINEVAL', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        obj.STATUS_CLINEVAL__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_CLINEVAL_Controller controller = new DS_CLINEVAL_Controller(sc);        
        
        List<SelectOption> nsvu = controller.getPrimaryProbIems();
        
        controller.save();
        controller.cancel();
        
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_CLINEVAL', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_F__c obj = new DS_Functioning_Forms_F__c();    
        obj.STATUS_CLINEVAL__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_CLINEVAL_Controller controller = new DS_CLINEVAL_Controller(sc);        
        
        List<SelectOption> nsvu = controller.getPrimaryProbIems();
        
        controller.save();
        controller.cancel();
        
    }
        
    static TestMethod void Test_samlpeAsserts(){    
    
       // Utility ut = new Utility();
       // TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        //create test client 
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
        obj.client__c = client.id;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        
        //    controllers
     //   DS_CLINEVAL_Controller clinevalController = new DS_CLINEVAL_Controller(sc);
        
        String BCEPRIM='2';
        String BCEOTHY = '1';
        String BCEOTHER= 'null'; 
        
        insert obj;
        
        //asserts
        System.assertNotEquals(obj.BCEPRIM__c, BCEPRIM, 'The primary problem is NOT Bipolar Disorder.');
        System.assertNotEquals(obj.BCEOTHY__c, BCEOTHY, 'No additional problems.');
        System.assertNotEquals(obj.BCEOTHER__c, BCEOTHER , 'Other problem identified as '+obj.BCEOTHER__c+'.');
        
        //save/cancels
       // clinevalController.save();
       // clinevalController.cancel();
        
    }
}