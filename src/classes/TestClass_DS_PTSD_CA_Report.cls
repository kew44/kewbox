@isTest (SeeAllData=false)
private class TestClass_DS_PTSD_CA_Report {
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    static TestMethod void Test_Controller() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        // Add Baseline record
        DS_PTSD_CA_B__c ptsdB = new DS_PTSD_CA_B__c();
        
        ptsdB.client__c = client.id;
        ptsdB.BMETPTSD__c = '1';
        ptsdB.BDOAPTSD__c = System.today();//Date.today();
        
        insert ptsdB;
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_PTSD_CA', section);
        
        // Add Follow-up record
        DS_PTSD_CA_F__c ptsdF = new DS_PTSD_CA_F__c();
        
        ptsdF.client__c = client.id;
        ptsdF.FMETPTSD__c = '1';
        ptsdF.FDOAPTSD__c = System.today();//Date.today();
        ptsdF.SECTION__c = '1';
        
        insert ptsdF;       
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ptsdF);  
        DS_PTSD_CA_Report_Controller controller = new DS_PTSD_CA_Report_Controller(sc); 
        
        controller.init();
        controller.editRecord();
        
        
    }
    
    /*static TestMethod void controllerTest() {
        
        Utility ut = new Utility();
        TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        Client__c client = test_ut.createClientPTSD_CA_B();
        
        Client_Summary__c summary = [SELECT id 
                                     FROM Client_Summary__c
                                     WHERE Page__r.Form__c = 'DS_PTSD_CA'
                                     AND SECTION__c = '0'
                                     AND Client__c = : client.id]; 
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summary.id);
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        DS_PTSD_CA_B__c obj = new DS_PTSD_CA_B__c();
        
        
        obj.client__c = client.id;
        obj.BMETPTSD__c = '1';
        system.debug(obj);
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        DS_PTSD_CA_Report_Controller controller = new DS_PTSD_CA_Report_Controller(sc);
        
        String clientInfo = controller.getClientInfo();
        
        controller.save();
        controller.cancel();
        
        // Update record
        obj = [SELECT id FROM DS_PTSD_CA_B__c WHERE client__c =: client.id];
        sc = new ApexPages.StandardController(obj);    
        controller = new DS_PTSD_CA_Report_Controller(sc);
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        controller.save();
        
    }*/
    
}