@istest(SeeAllData=false)
private class TestClass_DS_YCINDSEV {
    
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_YCINDSEV', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        obj.STATUS_YCINDSEV__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_YCINDSEV_Controller controller = new DS_YCINDSEV_Controller(sc);        
        
        List<SelectOption> NSVUItems        =   controller.getNSVUItems();
        List<SelectOption> NYUItems         =   controller.getNYUItems();
        List<SelectOption> FeedItems        =   controller.getFeedItems();
        List<SelectOption> SleepItems       =   controller.getSleepItems();
        List<SelectOption> PlayItems        =   controller.getPlayItems();
        List<SelectOption> PreCareItems     =   controller.getPreCareItems();
        List<SelectOption> SocialItems      =   controller.getSocialItems();
        List<SelectOption> AggressiveItems  =   controller.getAggressiveItems();
        List<SelectOption> SexualizedItems  =   controller.getSexualizedItems();
        List<SelectOption> AttachmentItems  =   controller.getAttachmentItems();
        List<SelectOption> AtypicalItems    =   controller.getAtypicalItems();
        List<SelectOption> DevItems         =   controller.getDevItems();
        
        controller.save();
        controller.cancel();
     
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_YCINDSEV', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_F__c obj = new DS_Functioning_Forms_F__c();    
        obj.STATUS_YCINDSEV__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_YCINDSEV_Controller controller = new DS_YCINDSEV_Controller(sc);        
        
        List<SelectOption> NSVUItems        =   controller.getNSVUItems();
        List<SelectOption> NYUItems         =   controller.getNYUItems();
        List<SelectOption> FeedItems        =   controller.getFeedItems();
        List<SelectOption> SleepItems       =   controller.getSleepItems();
        List<SelectOption> PlayItems        =   controller.getPlayItems();
        List<SelectOption> PreCareItems     =   controller.getPreCareItems();
        List<SelectOption> SocialItems      =   controller.getSocialItems();
        List<SelectOption> AggressiveItems  =   controller.getAggressiveItems();
        List<SelectOption> SexualizedItems  =   controller.getSexualizedItems();
        List<SelectOption> AttachmentItems  =   controller.getAttachmentItems();
        List<SelectOption> AtypicalItems    =   controller.getAtypicalItems();
        List<SelectOption> DevItems         =   controller.getDevItems();
        
        controller.save();
        controller.cancel();
        
    }
    
    /*static TestMethod void controllerTest(){
        
        Utility ut = new Utility();
        TestClass_A_Utility test_ut=new TestClass_A_Utility();
        
        Client__c client=test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c yc=new DS_Functioning_Forms_B__c();
        // yc.STATUS__c='Complete';
        yc.client__c=client.id;
        ApexPages.StandardController sc = new ApexPages.StandardController(yc);
        DS_YCINDSEV_Controller controller=new DS_YCINDSEV_Controller(sc);
        
        List<SelectOption>NSVUItems=controller.getNSVUItems();
        List<SelectOption>NYUItems=controller.getNYUItems();
        List<SelectOption>FeedItems=controller.getFeedItems();
        List<SelectOption>SleepItems=controller.getSleepItems();
        List<SelectOption>PlayItems=controller.getPlayItems();
        List<SelectOption>PreCareItems=controller.getPreCareItems();
        List<SelectOption>SocialItems=controller.getSocialItems();
        List<SelectOption>AggressiveItems=controller.getAggressiveItems();
        List<SelectOption>SexualizedItems=controller.getSexualizedItems();
        List<SelectOption>AttachmentItems=controller.getAttachmentItems();
        List<SelectOption>AtypicalItems=controller.getAtypicalItems();
        List<SelectOption>DevItems=controller.getDevItems();
        
        controller.save();
        controller.cancel();
        
        // Update record
        yc = [SELECT id FROM DS_Functioning_Forms_B__c WHERE client__c =: client.id];   
        sc=new ApexPages.StandardController(yc);
        controller = new DS_YCINDSEV_Controller(sc);
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        controller.save();
    }
    static TestMethod void Test_samlpeAsserts(){         
        
        Utility ut = new Utility();
        TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        //create test client 
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
        obj.client__c = client.id;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        
        //    controllers
        DS_YCINDSEV_Controller ycindsevController = new DS_YCINDSEV_Controller(sc);
        
        String BIMRISK='0';
        Boolean BDMICOG = true;
        insert obj;
        
        //asserts
        System.assertNotEquals(obj.BIMRISK__c,BIMRISK , 'Child has self-injurous behaviors.');
        System.assertNotEquals(obj.BDMICOG__c, BDMICOG, 'Cognitive development does NOT need further consideration.');
        
        //save/cancels
        ycindsevController.save();
        ycindsevController.cancel();
        
    }*/
}