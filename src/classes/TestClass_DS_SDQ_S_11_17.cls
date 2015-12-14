@istest(SeeAllData=false)
public class TestClass_DS_SDQ_S_11_17 {
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    // Test baseline controller 
    static TestMethod void Test_Baseline_Controller() {
        
        Client__c client = test_ut.createClientSDQO();
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_S_11_17', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c();    
        obj.STATUS_SDQ_S_11_17__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_SDQ_S_11_17_Controller controller = new DS_SDQ_S_11_17_Controller(sc);        
        
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
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 14));
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_S_11_17', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c();    
        obj.STATUS_SDQ_S_11_17__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_SDQ_S_11_17_Controller controller = new DS_SDQ_S_11_17_Controller(sc);        
        
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
        obj.BForm__c = 'DS_SDQ_S_11_17';
        
        obj.BSDSSOMA__c= '1';
        obj.BSDSWORR__c= '1';
        obj.BSDSUNHA__c= '1';
        obj.BSDSCLIN__c= '1';
        obj.BSDSAFRA__c= '1';
        obj.BSDSEMO__c= 1;
        obj.BSDSTANT__c= '1';
        obj.BSDSOBEY__c= '1';
        obj.BSDSFIGH__c= '1';
        obj.BSDSLIES__c= '1';
        obj.BSDSSTEA__c= '1';
        obj.BSDSBEH__c= 1;
        obj.BSDSREST__c= '1';
        obj.BSDSFIDG__c= '1';
        obj.BSDSDIST__c= '1';
        obj.BSDSREFL__c= '1';
        obj.BSDSATTE__c= '1';
        obj.BSDSHYP__c= 1;
        obj.BSDSLONE__c= '1';
        obj.BSDSFRIE__c= '1';
        obj.BSDSPOPU__c= '1';
        obj.BSDSBULL__c= '1';
        obj.BSDSOLDB__c= '1';
        obj.BSDSOTC__c= 1;
        obj.BSDSCONS__c= '1';
        obj.BSDSSHAR__c= '1';
        obj.BSDSCARI__c= '1';
        obj.BSDSKIND__c= '1';
        obj.BSDSHELP__c= '1';
        obj.BSDSKHB__c= 1;
        obj.BSDSIMPF__c= '1';
        obj.BSDSIMPH__c= '1';
        obj.BSDSIMPC__c= '1';
        obj.BSDSUPSET__c= '1';
        obj.BSDSIMPL__c= '1';
        obj.BSDSDCL__c= 1;
        obj.BSDSTOT__c= 1; 
        insert obj;
        return client;
    }   
}