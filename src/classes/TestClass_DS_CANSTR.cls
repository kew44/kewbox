@istest(SeeAllData=false)
public class TestClass_DS_CANSTR{
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
        
    // Test baseline controller 
    static TestMethod void Test_Baseline_Controller() {
    
        //create test client 
        //Client__c client = test_ut.createClient(test_ut.getClient('Female', 6));
        Client__c client = test_ut.createClient();
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_CANSTR', '0');                 
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c(); 
        obj.STATUS_FAPGAR__c = 'Complete';
        obj.client__c = client.id;                    
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        DS_CANSTR_Controller controller = new DS_CANSTR_Controller(sc);     
        
        List<SelectOption> nsvu = new List<SelectOption>();
        
        nsvu = controller.getStrongFamItems();
        nsvu = controller.getStrongIntItems();
        nsvu = controller.getStrongEduItems();
        nsvu = controller.getStrongVocItems();
        nsvu = controller.getStrongCopeItems();
        nsvu = controller.getStrongOptItems();
        nsvu = controller.getStrongTalentItems();
        nsvu = controller.getStrongSpiritItems();
        nsvu = controller.getStrongComItems();
        nsvu = controller.getStrongRelateItems();
        nsvu = controller.getStrongResItems();
        
        controller.save();
        controller.cancel();
        
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        //Client__c client = test_ut.createClient(getClient());
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_CANSTR', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Functioning_Forms_F__c obj = new DS_Functioning_Forms_F__c();    
        obj.STATUS_FAPGAR__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_CANSTR_Controller controller = new DS_CANSTR_Controller(sc);        
        
        List<SelectOption> nsvu = new List<SelectOption>();
        
        nsvu = controller.getStrongFamItems();
        nsvu = controller.getStrongIntItems();
        nsvu = controller.getStrongEduItems();
        nsvu = controller.getStrongVocItems();
        nsvu = controller.getStrongCopeItems();
        nsvu = controller.getStrongOptItems();
        nsvu = controller.getStrongTalentItems();
        nsvu = controller.getStrongSpiritItems();
        nsvu = controller.getStrongComItems();
        nsvu = controller.getStrongRelateItems();
        nsvu = controller.getStrongResItems();
        
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
        
      //  DS_CANSTR_Controller canstrController = new DS_CANSTR_Controller(sc); 
        
        String BSTFAM='1';
        String BSTINTP='0';
        String BSTEDU='2';
        String BSTVOC='97';
        String BSTCOPE='3';
        String BSTOPT='3';
        String BSTSPIR='3';
        String BSTCOM='3';
        String BSTRELT='2';
        String BSTRESC='3';
        
        insert obj;
        
        System.assertNotEquals(obj.BSTFAM__c, BSTFAM, 'Child is NOT considered to have moderate level of family strengths.');
        System.assertNotEquals(obj.BSTINTP__c,BSTINTP , 'Child does NOT have significant interpersonal strengths.');
        System.assertNotEquals(obj.BSTEDU__c, BSTEDU, 'School plan (if any) seems to be effective.');
        System.assertNotEquals(obj.BSTVOC__c, BSTVOC, 'The child is at least 14 and this item is applicable.');
        System.assertNotEquals(obj.BSTCOPE__c,BSTCOPE , 'Child has known or identifiable psychological strengths.');
        System.assertNotEquals(obj.BSTOPT__c, BSTOPT, 'Child has known talents, interests, or hobbies.');
        System.assertNotEquals(obj.BSTSPIR__c,BSTSPIR , 'Child is involded in spiritual or religious involvement.');
        System.assertNotEquals(obj.BSTCOM__c, BSTCOM, 'Child has community ties and/or support.');
        System.assertNotEquals(obj.BSTRELT__c,BSTRELT , 'Child has had more than one stable relationship in lifetime.');
        System.assertNotEquals(obj.BSTRESC__c,BSTRESC , 'Child recognizes strengths.');
        
     //   canstrController.save();
       // canstrController.cancel();
    }
}