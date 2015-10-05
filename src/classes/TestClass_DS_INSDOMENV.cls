@istest(SeeAllData=false)
public class TestClass_DS_INSDOMENV{
    
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_INSDOMENV', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();    
        obj.STATUS_INSDOMENV__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_INSDOMENV_Controller controller = new DS_INSDOMENV_Controller(sc);        
                
        controller.save();
        controller.cancel();
     
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_INSDOMENV', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Background_Family_Info_F__c obj = new DS_Background_Family_Info_F__c();    
        obj.STATUS_INSDOMENV__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_INSDOMENV_Controller controller = new DS_INSDOMENV_Controller(sc);        
                
        controller.save();
        controller.cancel();
        
    }
    
    static TestMethod void Test_samlpeAsserts(){    
        
     //   Utility ut = new Utility();
     //   TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        //create test client 
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
        obj.RWHITE__c=true;
        obj.client__c = client.id;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        
        //    controllers
      //  DS_INSDOMENV_Controller indsevController = new DS_INSDOMENV_Controller(sc); //indsevController
        
        //Insdomenv
        String BCINANY = '1';
        Boolean BCINOPUB = true;
        String BCINOPSP= 'null'; 
        
        insert obj;
        
        //asserts
        //Insdomenv
        System.assertNotEquals(obj.BCINANY__c, BCINANY, 'Child NOT currently covered by any type of public or private health insurance .'); 
        System.assertNotEquals(obj.BCINOPUB__c, BCINOPUB, 'Child NOT currently covered by other type of public health insurance.'); 
        System.assertNotEquals(obj.BCINOPSP__c, BCINOPSP, 'Child covered by '+obj.BCINOPSP__c +'public health insurance.');
        
        //save/cancels
    //    indsevController.save();
      //  indsevController.cancel();
    }
}