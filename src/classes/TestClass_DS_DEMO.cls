@istest(SeeAllData=false)
public class TestClass_DS_DEMO {
    
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_DEMO', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();    
        obj.STATUS_DEMO__c = 'Complete';
        obj.client__c = client.id;  
        obj.RREF__c= true;
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_DEMO_Controller controller = new DS_DEMO_Controller(sc);        
        
        List<SelectOption> q4 = controller.getQ4Items();
        List<SelectOption> hisplat = controller.getHispLatItems();
        List<SelectOption> q14 = controller.getQ14Items();
        List<SelectOption> milself = controller.getMilSelfItems();
        List<SelectOption> milfam = controller.getMilFamItems();
        List<SelectOption> overall = controller.getOverAllItems();
        List<SelectOption> geniden = controller.getGenIdenItems();
        List<SelectOption> orient = controller.getOrientItems();
        
        controller.save();
        controller.cancel();
     
    }
    
}