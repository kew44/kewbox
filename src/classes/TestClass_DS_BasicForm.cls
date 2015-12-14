@isTest
public class TestClass_DS_BasicForm {
    
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_FAPGAR', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        obj.STATUS_FAPGAR__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_FAPGAR_Controller controller = new DS_FAPGAR_Controller(sc);        
        
        List<SelectOption> option = new List<SelectOption>();
        option = controller.getNYOptionWithBlank();
        option = controller.getNYOption();
        option = controller.getNYUOptionWithBlank();
        option = controller.getNYUOption();
        option = controller.getBMETOption();
        
        controller.save();
        controller.cancel();
        
     
    }
    
}