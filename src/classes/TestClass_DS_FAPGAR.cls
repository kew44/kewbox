@istest(SeeAllData=false)
public class TestClass_DS_FAPGAR{
    
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_FAPGAR', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        obj.STATUS_FAPGAR__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_FAPGAR_Controller controller = new DS_FAPGAR_Controller(sc);        
        
        List<SelectOption> nsvu = controller.getNSVUItems();
        
        controller.save();
        controller.cancel();
     
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_FAPGAR', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_F__c obj = new DS_Functioning_Forms_F__c();    
        obj.STATUS_FAPGAR__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_FAPGAR_Controller controller = new DS_FAPGAR_Controller(sc);        
        
        List<SelectOption> nsvu = controller.getNSVUItems();
        
        controller.save();
        controller.cancel();
        
    }
    
    static TestMethod void Test_Baseline_SamlpeAsserts(){  
        
        String BFAPGAR1='99';
        String BFAPGAR2='1';
        String BFAPGAR3='0';
        String BFAPGAR4='2';
        String BFAPGAR5='99';
        String BFAPGAR_MET = 'Not Met';
        Integer BFAPGAR_RAW = 3;  
        
        //create test client 
        Client__c client = test_ut.createClient();
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
        obj.client__c = client.id;
        obj.STATUS_FAPGAR__c = 'Complete';
        
        insert obj;
        
        // Danny - need to add the test for raw score and met // 
        
        // Reverse testing (assertNotEquals)
        System.assertNotEquals(obj.BFAPGAR1__c, BFAPGAR1 , 'I do NOT know if I am satisfied with the help that I receive from my family when something is troubling me.');
        System.assertNotEquals(obj.BFAPGAR2__c, BFAPGAR2 , 'I am satisfied with the way my family discusses items of common interest and shares problem-solving with me SOME OF THE TIME.');
        System.assertNotEquals(obj.BFAPGAR3__c, BFAPGAR3, 'I HARDLY EVER find that my family accepts my wishes to take on new activities or make changes in my life-style.');
        System.assertNotEquals(obj.BFAPGAR4__c, BFAPGAR4, 'I am ALMOST ALWAYS satisfied with the way my family expresses affection and responds to feelings such as anger, sorrow, and love.');
        System.assertNotEquals(obj.BFAPGAR5__c, BFAPGAR5, 'I do NOT know if I am satisfied with the amount of time my family and I spend together.');
        
        
        obj.BFAPGAR1__c = BFAPGAR1;
        obj.BFAPGAR2__c = BFAPGAR2;
        obj.BFAPGAR3__c = BFAPGAR3;
        obj.BFAPGAR4__c = BFAPGAR4;
        obj.BFAPGAR5__c = BFAPGAR5;
        //obj.BFAPGAR_MET__c = BFAPGAR_MET;
        //obj.BFAPGAR_RAW__c = BFAPGAR_RAW;
    
        update obj;
        
        DS_Functioning_Forms_B__c checkObj = [SELECT BFAPGAR_MET__c, BFAPGAR_RAW__c FROM DS_Functioning_Forms_B__c WHERE id =: obj.id];
        
        // assertEquals
        System.assertEquals(BFAPGAR1, obj.BFAPGAR1__c, 'I do NOT know if I am satisfied with the help that I receive from my family when something is troubling me.');
        System.assertEquals(BFAPGAR2, obj.BFAPGAR2__c, 'I am satisfied with the way my family discusses items of common interest and shares problem-solving with me SOME OF THE TIME.');
        System.assertEquals(BFAPGAR3, obj.BFAPGAR3__c, 'I HARDLY EVER find that my family accepts my wishes to take on new activities or make changes in my life-style.');
        System.assertEquals(BFAPGAR4, obj.BFAPGAR4__c, 'I am ALMOST ALWAYS satisfied with the way my family expresses affection and responds to feelings such as anger, sorrow, and love.');
        System.assertEquals(BFAPGAR5, obj.BFAPGAR5__c, 'I do NOT know if I am satisfied with the amount of time my family and I spend together.');
        System.assertEquals(BFAPGAR_MET, checkObj.BFAPGAR_MET__c, 'Not meet error');
        System.assertEquals(BFAPGAR_RAW, checkObj.BFAPGAR_RAW__c, 'Raw score error');
        
        obj.BFAPGAR1__c = '1';
        obj.BFAPGAR2__c = '1';
        obj.BFAPGAR3__c = '1';
        obj.BFAPGAR4__c = '1';
        obj.BFAPGAR5__c = '1';
        
        update obj;
    }
    
    static TestMethod void Test_Followup_SamlpeAsserts(){  
        
        String FFAPGAR1='99';
        String FFAPGAR2='1';
        String FFAPGAR3='0';
        String FFAPGAR4='2';
        String FFAPGAR5='99';
        String FFAPGAR_MET = 'Not Met';
        Integer FFAPGAR_RAW =5;  
        
        //create test client 
        Client__c client = test_ut.createClient();
        
        DS_Functioning_Forms_F__c obj = new DS_Functioning_Forms_F__c();
        obj.client__c = client.id;
        obj.STATUS_FAPGAR__c = 'Complete';
        
        insert obj;
        
        // Danny - need to add the test for raw score and met // 
        
        // Reverse testing (assertNotEquals)
        System.assertNotEquals(obj.FFAPGAR1__c, FFAPGAR1 , 'I do NOT know if I am satisfied with the help that I receive from my family when something is troubling me.');
        System.assertNotEquals(obj.FFAPGAR2__c, FFAPGAR2 , 'I am satisfied with the way my family discusses items of common interest and shares problem-solving with me SOME OF THE TIME.');
        System.assertNotEquals(obj.FFAPGAR3__c, FFAPGAR3, 'I HARDLY EVER find that my family accepts my wishes to take on new activities or make changes in my life-style.');
        System.assertNotEquals(obj.FFAPGAR4__c, FFAPGAR4, 'I am ALMOST ALWAYS satisfied with the way my family expresses affection and responds to feelings such as anger, sorrow, and love.');
        System.assertNotEquals(obj.FFAPGAR5__c, FFAPGAR5, 'I do NOT know if I am satisfied with the amount of time my family and I spend together.');
        
        
        obj.FFAPGAR1__c = FFAPGAR1;
        obj.FFAPGAR2__c = FFAPGAR2;
        obj.FFAPGAR3__c = FFAPGAR3;
        obj.FFAPGAR4__c = FFAPGAR4;
        obj.FFAPGAR5__c = FFAPGAR5;
        obj.FFAPGAR_MET__c = FFAPGAR_MET;
        obj.FFAPGAR_RAW__c = FFAPGAR_RAW;
    
        update obj;
        
        // assertEquals
        System.assertEquals(obj.FFAPGAR1__c, FFAPGAR1 , 'I do NOT know if I am satisfied with the help that I receive from my family when something is troubling me.');
        System.assertEquals(obj.FFAPGAR2__c, FFAPGAR2 , 'I am satisfied with the way my family discusses items of common interest and shares problem-solving with me SOME OF THE TIME.');
        System.assertEquals(obj.FFAPGAR3__c, FFAPGAR3, 'I HARDLY EVER find that my family accepts my wishes to take on new activities or make changes in my life-style.');
        System.assertEquals(obj.FFAPGAR4__c, FFAPGAR4, 'I am ALMOST ALWAYS satisfied with the way my family expresses affection and responds to feelings such as anger, sorrow, and love.');
        System.assertEquals(obj.FFAPGAR5__c, FFAPGAR5, 'I do NOT know if I am satisfied with the amount of time my family and I spend together.');
        
        
        obj.FFAPGAR1__c = '1';
        obj.FFAPGAR2__c = '1';
        obj.FFAPGAR3__c = '1';
        obj.FFAPGAR4__c = '1';
        obj.FFAPGAR5__c = '1';
       
        update obj;
    }
}