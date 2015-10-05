@istest(SeeAllData=false)
public class TestClass_DS_REFIMM {
    
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
        obj.BUSBORN__c = '0';        
        obj.BPUSBORN__c  = '0';
        obj.RWHITE__c = true;
        obj.SECTION__c = '0';
                   
        insert obj;    
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_REFIMM', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        obj = new DS_Background_Family_Info_B__c();    
        obj.STATUS_REFIMM__c = 'Complete';
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_REFIMM_Controller controller = new DS_REFIMM_Controller(sc);        
        
        List<SelectOption> EngWell= controller.getEngWellItems();
        List<SelectOption> CTDECT= controller.getCTDECT();
        
        controller.save();
        controller.cancel();
     
    }
    
    static TestMethod void Test_samlpeAsserts(){    
        
        //create test client 
        Client__c client = test_ut.createClient();
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
        obj.RWHITE__c=true;
        obj.client__c = client.id;
        
        //Refimm 
        String BREFCAMP= '1';
        Boolean BPSTNONE  = true;
        String BCAMPMO= 'null'; 
        
        insert obj;
        
        //asserts 
        //Refimm   
        System.assertNotEquals(obj.BREFCAMP__c,BREFCAMP,'Child has NOT lived in refugee/detention camp.');
        System.assertNotEquals(obj.BPSTNONE__c,BPSTNONE,'Child has had Refugee, Asylee, or Immigrant status, or status is unknown.');
        System.assertNotEquals(obj.BCAMPMO__c,BCAMPMO,'Child lived '+obj.BCAMPMO__c+' months in a detention/refugee camp.');
        
    }
}