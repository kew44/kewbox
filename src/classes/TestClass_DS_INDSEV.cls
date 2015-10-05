@istest(SeeAllData=false)
public class TestClass_DS_INDSEV{
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    // Test baseline controller 
    static TestMethod void Test_Baseline_Controller() {
        
        Client__c client = new Client__c();
        
        client.INIT__c = 'BBB';
        client.DOB1__c = date.today().addYears(-8);
        client.DOB2__c = date.today().addYears(-8);
        client.AGE__c = 8;
        client.GENDER__c = 'Female';
        
        client = test_ut.createClient(client);
        
        //Client__c client = test_ut.createClient();
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_INDSEV', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        obj.STATUS_INDSEV__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_INDSEV_Controller controller = new DS_INDSEV_Controller(sc);        
        
        List<SelectOption> nsvu = new List<SelectOption>();
        
        nsvu = controller.getNSVUItems();
        nsvu = controller.getRefUnkItems();
        
        controller.save();
        controller.cancel();
     
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = new Client__c();
        
        client.INIT__c = 'BBB';
        client.DOB1__c = date.today().addYears(-8);
        client.DOB2__c = date.today().addYears(-8);
        client.AGE__c = 8;
        client.GENDER__c = 'Female';
        
        client = test_ut.createClient(client);
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_INDSEV', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_F__c obj = new DS_Functioning_Forms_F__c();    
        obj.STATUS_INDSEV__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_INDSEV_Controller controller = new DS_INDSEV_Controller(sc);        
        
        List<SelectOption> nsvu = new List<SelectOption>();
        
        nsvu = controller.getNSVUItems();
        nsvu = controller.getRefUnkItems();
        
        controller.save();
        controller.cancel();
        
    }
        
    static TestMethod void Test_samlpeAsserts(){  
        
       // Utility ut = new Utility();
        //TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        //create test client 
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
        obj.client__c = client.id;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        
        //    controllers
      //  DS_INDSEV_Controller indsevController = new DS_INDSEV_Controller(sc);
        
        String BISPACAD='0';
        String BSUITALK = '0';//
        String BISPCRSP= 'null'; 
        
        insert obj;
        
        //asserts
        System.assertNotEquals(obj.BISPACAD__c,BISPACAD , 'Child has academic problems.');
        System.assertNotEquals(obj.BSUITALK__c,BSUITALK , 'Child has NOT talked about suicide.');
        System.assertNotEquals(obj.BISPCRSP__c,BISPCRSP , 'Child has been arrested '+obj.BISPCRSP__c+' time(s) in the past 30 days');
        
        //save/cancels
     //   indsevController.save();
       // indsevController.cancel();
    }
}