@istest(SeeAllData=false)
public class TestClass_DS_HEALTH{
    
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
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();          
        
        obj.Client__c = client.id;
        obj.BHOVERALL__c = '4';        
        obj.BHTHSTAT__c  = '3';
        obj.RWHITE__c = true;
        obj.SECTION__c = '0';
                   
        insert obj;    
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_HEALTH', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        obj.STATUS_HEALTH__c = 'Complete';
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_HEALTH_Controller controller = new DS_HEALTH_Controller(sc);        
                
        controller.save();
        controller.cancel();
        
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        DS_Background_Family_Info_B__c baselineObj = new DS_Background_Family_Info_B__c();          
        
        baselineObj.Client__c = client.id;
        baselineObj.BHOVERALL__c = '4';        
        baselineObj.BHTHSTAT__c  = '3';
        baselineObj.RWHITE__c = true;
        baselineObj.SECTION__c = '0';
                   
        insert baselineObj;
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        DS_Background_Family_Info_F__c followObj = new DS_Background_Family_Info_F__c();          
        
        followObj.Client__c = client.id;
        followObj.FHOVERALL__c = '4';        
        followObj.SECTION__c = section;
                   
        insert followObj;
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_HEALTH', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        followObj.STATUS_HEALTH__c = 'Complete';
        ApexPages.StandardController sc = new ApexPages.StandardController(followObj);    
        DS_HEALTH_Controller controller = new DS_HEALTH_Controller(sc);        
                
        controller.save();
        controller.cancel();
        
    }
        
    static TestMethod void Test_samlpeAsserts(){ 
        
     //   Utility ut = new Utility();
       // TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        //create test client 
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
        obj.RWHITE__c=true;
        obj.client__c = client.id;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        
        //    controllers   
       // DS_HEALTH_Controller healthController = new DS_HEALTH_Controller(sc); //healthController
        
        //Health
        //String BTRT= '1';
        //Boolean BTRTOTHR= true;
        String BTRTOTSP= 'null'; 
        
        insert obj;
        
        //asserts
        //Health
        // System.assertNotEquals(obj.BTRT__c,BTRT,'Child does NOT have current course of treatment.');
       // System.assertNotEquals(obj.BTRTOTHR__c,BTRTOTHR,'Other condition NOT selected.');
        System.assertNotEquals(obj.BTRTOTSP__c,BTRTOTSP,'Condition is specified as '+obj.BTRTOTSP__c+'.');
        
        //save/cancels
      //  healthController.save();
        //healthController.cancel();
    }
}