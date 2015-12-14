@istest
public class TestClass_DS_FOLLOWUPINFO {
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_FOLLOWUPINFO', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Background_Family_Info_F__c obj = new DS_Background_Family_Info_F__c();    
        obj.STATUS_FOLLOWUPINFO__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_FOLLOWUPINFO_Controller controller = new DS_FOLLOWUPINFO_Controller(sc);        
        
        List<SelectOption> nsvu = new List<SelectOption>();
        
        nsvu = controller.getTypeOption();
        nsvu = controller.getTimeOption();
        nsvu = controller.getStatusOption();
        nsvu = controller.getGuardianOption();
        nsvu = controller.getHealthOption();
        
        controller.save();
        controller.cancel();
        
    }
    
}