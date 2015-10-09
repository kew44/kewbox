@isTest (SeeAllData=false)
private class TestClass_DS_SDQ_P_04_10_Report {
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    static TestMethod void Test_Controller() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 6));
        
        // Add Baseline record
        DS_SDQ_PSI_CDI_B__c objBaseline = new DS_SDQ_PSI_CDI_B__c();
        
        objBaseline.client__c = client.id;
        objBaseline.BDOASDYP__c = System.today();
        objBaseline.BMETSDYP__c = '1';
        
        insert objBaseline;
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_P_04_10', section);
        
        // Add Follow-up record
        DS_SDQ_PSI_CDI_F__c objFollow = new DS_SDQ_PSI_CDI_F__c();
        
        objFollow.client__c = client.id;
        objFollow.FMETSDYP__c = '1';
        objFollow.FDOASDYP__c = System.today();
        objFollow.SECTION__c = section;
        
        insert objFollow;       
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objFollow);  
        DS_SDQ_P_04_10_Report_Controller controller = new DS_SDQ_P_04_10_Report_Controller(sc); 
        
        controller.init();
        controller.editRecord();
        
    }    
    
}