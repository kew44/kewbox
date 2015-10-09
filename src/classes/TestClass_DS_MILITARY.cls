@istest(SeeAllData=false)
public class TestClass_DS_MILITARY{
    
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
        
        // Trigger military form display logic
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();          
        
        obj.Client__c = client.id;
        obj.BMILSELF__c = '1';        
        obj.RWHITE__c = true;
        obj.SECTION__c = '0';
                   
        insert obj;    
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_MILITARY', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        obj.STATUS_MILITARY__c = 'Complete';
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_MILITARY_Controller controller = new DS_MILITARY_Controller(sc);     
        
        List<SelectOption> move = controller.getMoveItems();
        List<SelectOption> serve = controller.getServeItems();
        List<SelectOption> diff = controller.getIsDiffItems();
        List<SelectOption> relation = controller.getRelationItems();
        List<SelectOption> branch1 = controller.getBranch1Items();
        List<SelectOption> branch2 = controller.getBranch2Items();
        List<SelectOption> status = controller.getStatusItems();
        List<SelectOption> wartime = controller.getWartimeItems();
        List<SelectOption> deploy = controller.getDeployItems();
        List<SelectOption> deployall = controller.getDeployAllItems();
                
        controller.save();
        controller.cancel();
        
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        // Trigger military form display logic
        DS_Background_Family_Info_F__c followObj = new DS_Background_Family_Info_F__c();          
        
        followObj.Client__c = client.id;
        followObj.FMSTAT__c = '1';        
        followObj.SECTION__c = section;
                   
        insert followObj;
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_MILITARY', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        followObj.STATUS_MILITARY__c = 'Complete';
        ApexPages.StandardController sc = new ApexPages.StandardController(followObj);    
        DS_MILITARY_Controller controller = new DS_MILITARY_Controller(sc);  
        
        List<SelectOption> move = controller.getMoveItems();
        List<SelectOption> serve = controller.getServeItems();
        List<SelectOption> diff = controller.getIsDiffItems();
        List<SelectOption> relation = controller.getRelationItems();
        List<SelectOption> branch1 = controller.getBranch1Items();
        List<SelectOption> branch2 = controller.getBranch2Items();
        List<SelectOption> status = controller.getStatusItems();
        List<SelectOption> wartime = controller.getWartimeItems();
        List<SelectOption> deploy = controller.getDeployItems();
        List<SelectOption> deployall = controller.getDeployAllItems();
                
        controller.save();
        controller.cancel();
        
    }
    
    /*static TestMethod void Test_DS_MILITARY_Controller(){
        
        Utility ut = new Utility();
        TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
        obj.RWHITE__c=true;
        // obj.STATUS__c = 'Complete'; 
        obj.client__c = client.id;
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        DS_MILITARY_Controller controller = new DS_MILITARY_Controller(sc);
        
        
        List<SelectOption> move = controller.getMoveItems();
        List<SelectOption> serve = controller.getServeItems();
        List<SelectOption> diff = controller.getIsDiffItems();
        List<SelectOption> relation = controller.getRelationItems();
        List<SelectOption> branch1 = controller.getBranch1Items();
        List<SelectOption> branch2 = controller.getBranch2Items();
        List<SelectOption> status = controller.getStatusItems();
        List<SelectOption> wartime = controller.getWartimeItems();
        List<SelectOption> deploy = controller.getDeployItems();
        List<SelectOption> deployall = controller.getDeployAllItems();
        //  String clientInfo = controller.getClientInfo(); 
        
        
        controller.save();
        controller.cancel();
        

    } 
    static TestMethod void Test_samlpeAsserts(){    
        
        Utility ut = new Utility();
        TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        //create test client 
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
        obj.RWHITE__c=true;
        obj.client__c = client.id;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        
        //    controllers
        DS_MILITARY_Controller militaryController = new DS_MILITARY_Controller(sc); //militaryController
        
        //Military
        String BMFMR2= '98';
        Boolean BSELFMIL= true;
        String BMFMR2SP='null';
        
        insert obj;
        
        //asserts
        //Military
        System.assertNotEquals(obj.BMFMR2__c,BMFMR2,'NOT other family member.');
        System.assertNotEquals(obj.BSELFMIL__c,BSELFMIL,'Child is NOT in the military.');
        System.assertNotEquals(obj.BMFMR2SP__c,BMFMR2SP,'Other family member is specified as '+obj.BMFMR2SP__c+'.');
        
        //save/cancels
        militaryController.save();
        militaryController.cancel();
    }*/
}