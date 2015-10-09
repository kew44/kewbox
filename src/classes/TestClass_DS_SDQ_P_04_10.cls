@istest(SeeAllData=false)
public class TestClass_DS_SDQ_P_04_10 {
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    // Test baseline controller 
    static TestMethod void Test_Baseline_Controller() {
                
        Client__c client = test_ut.createClientSDQY();
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_P_04_10', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c();    
        obj.STATUS_SDQ_P_04_10__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_SDQ_P_04_10_Controller controller = new DS_SDQ_P_04_10_Controller(sc);        
        
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();
        
        controller.save();
        controller.cancel();
        controller.saveview();
     
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 6));
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_P_04_10', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c();    
        obj.STATUS_SDQ_P_04_10__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_SDQ_P_04_10_Controller controller = new DS_SDQ_P_04_10_Controller(sc);        
        
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();
        
        controller.save();
        controller.cancel();
        controller.saveview();
        
    }
    
    static TestMethod Client__c testWvals(){ 
    
        Client__c client = test_ut.createClient();
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c();
        
        obj.Client__c = client.id;
        obj.BMETSDOP__c = '1';
        obj.BDOASDOP__c=date.today(); 
        obj.client__c = client.id;
        obj.BForm__c = 'DS_SDQ_P_04_10';
        
        obj.BSDPSOMA__c= '1';
        obj.BSDPWORR__c= '1';
        obj.BSDPUNHA__c= '1';
        obj.BSDPCLIN__c= '1';
        obj.BSDPAFRA__c= '1';
        obj.BSDPEMO__c= 1;
        obj.BSDPTANT__c= '1';
        obj.BSDPOBEY__c= '1';
        obj.BSDPFIGH__c= '1';
        obj.BSDPLIES__c= '1';
        obj.BSDPSTEA__c= '1';
        obj.BSDPBEH__c= 1;
        obj.BSDPREST__c= '1';
        obj.BSDPFIDG__c= '1';
        obj.BSDPDIST__c= '1';
        obj.BSDPREFL__c= '1';
        obj.BSDPATTE__c= '1';
        obj.BSDPHYP__c= 1;
        obj.BSDPLONE__c= '1';
        obj.BSDPFRIE__c= '1';
        obj.BSDPPOPU__c= '1';
        obj.BSDPBULL__c= '1';
        obj.BSDPOLDB__c= '1';
        obj.BSDPOTC__c= 1;
        obj.BSDPCONS__c= '1';
        obj.BSDPSHAR__c= '1';
        obj.BSDPCARI__c= '1';
        obj.BSDPKIND__c= '1';
        obj.BSDPHELP__c= '1';
        obj.BSDPKHB__c= 1;
        obj.BSDPIMPF__c= '1';
        obj.BSDPIMPH__c= '1';
        obj.BSDPIMPC__c= '1';
        obj.BSDPUPSET__c= '1';
        obj.BSDPIMPL__c= '1';
        obj.BSDPDCL__c= 1;
        obj.BSDPTOT__c= 1; 
        insert obj;
        return null;
        return client;
    }   
}