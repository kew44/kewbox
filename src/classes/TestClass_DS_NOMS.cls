@istest(SeeAllData=false)
public class TestClass_DS_NOMS{
    
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_NOMS', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        obj.STATUS_NOMS__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_NOMS_Controller controller = new DS_NOMS_Controller(sc);        
        
        List<SelectOption> nsvu = controller.getAdminItems();
        
        controller.save();
        controller.cancel();
     
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_NOMS', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_F__c obj = new DS_Functioning_Forms_F__c();    
        obj.STATUS_NOMS__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_NOMS_Controller controller = new DS_NOMS_Controller(sc);        
        
        List<SelectOption> nsvu = controller.getAdminItems();
        
        controller.save();
        controller.cancel();
        
    }
    
    static TestMethod void Test_samlpeAsserts(){  
        
      //  Utility ut = new Utility();
        //TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        //create test client 
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
        obj.client__c = client.id;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        
        //    controllers
       // DS_NOMS_Controller nomsController = new DS_NOMS_Controller(sc);
        
        String BNDAILYL='1';
        String BNADMINOSP= 'null'; 
        
        insert obj;
        
        //asserts
        System.assertNotEquals(obj.BNDAILYL__c, BNDAILYL, 'I [my child] do[es] NOT strongly disagree that the child is handling dsily life.');
        System.assertNotEquals(obj.BNADMINOSP__c,BNADMINOSP , 'Form was administered by '+obj.BNADMINOSP__c+'.');
        
        //save/cancels
     //   nomsController.save();
      //  nomsController.cancel();
    }
}