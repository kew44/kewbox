@istest(SeeAllData=false)
public class TestClass_DS_BIS{
    
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_BIS', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        obj.STATUS_FAPGAR__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_BIS_Controller controller = new DS_BIS_Controller(sc);        
        
        List<SelectOption> YNC = controller.getYNCompletedIems();
        
        controller.save();
        controller.cancel();
     
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_BIS', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_F__c obj = new DS_Functioning_Forms_F__c();    
        obj.STATUS_FAPGAR__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_BIS_Controller controller = new DS_BIS_Controller(sc);        
        
        List<SelectOption> YNC = controller.getYNCompletedIems();
        
        controller.save();
        controller.cancel();
        
    }
    
    /*static TestMethod void Test_DS_BIS_Controller() {
        
        Utility ut = new Utility();
        TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        Client__c client = test_ut.createClientSummary();
        String cimi = ut.urlEncode('c='+client.id+'&s=0');
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        //obj.STATUS__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_BIS_Controller controller = new DS_BIS_Controller(sc);
        
        List<SelectOption> YN = controller.getYNIems();
        List<SelectOption> YNComplete = controller.getYNCompletedIems();
        
        
        controller.save();
        controller.cancel(); 
        
        // Update record
        obj = [SELECT id FROM DS_Functioning_Forms_B__c WHERE client__c =: client.id];    
        sc = new ApexPages.StandardController(obj);        
        controller = new DS_BIS_Controller(sc);    
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
        
        DS_BIS_Controller bisController = new DS_BIS_Controller(sc);
        
        String BCBISRECV = '1';//
        Date BCBISTCDT=system.today();
        Boolean BCBISOTHE=true;
        String BCBISOTHS= 'null'; 
        insert obj;
        
        System.assertNotEquals(obj.BCBISRECV__c, BCBISRECV, 'Child/family is NOT receiving brief intervention services.');
        System.assertNotEquals(obj.BCBISOTHS__c, BCBISOTHS, 'Other treatment component specified as '+obj.BCBISOTHS__c+'.');
        
        bisController.save();
        bisController.cancel();
    }*/
}