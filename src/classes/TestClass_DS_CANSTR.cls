@istest(SeeAllData=false)
public class TestClass_DS_CANSTR{

  static TestMethod void Test_DS_CANSTR_Controller() {
    
        Utility ut = new Utility();
        TestClass_Utility test_ut = new TestClass_Utility();    
        Client__c client = test_ut.createClientSummary();   
    String cimi = ut.urlEncode('c='+client.id+'&s=0');
ApexPages.currentPage().getParameters().put('cimi',cimi);

        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
        //obj.STATUS__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_CANSTR_Controller controller = new DS_CANSTR_Controller(sc);        
        
        List<SelectOption> family = controller.getStrongFamItems();
        List<SelectOption> interpersonal = controller.getStrongIntItems();
        List<SelectOption> education = controller.getStrongEduItems();
        List<SelectOption> work= controller.getStrongVocItems();
        List<SelectOption> cope= controller.getStrongCopeItems();
        List<SelectOption> optimism= controller.getStrongOptItems();
        List<SelectOption> talents= controller.getStrongTalentItems();
        List<SelectOption> spirit= controller.getStrongSpiritItems();
        List<SelectOption> community= controller.getStrongComItems();
        List<SelectOption> relationships= controller.getStrongRelateItems();
        List<SelectOption> resilience= controller.getStrongResItems();
        
       
               
        controller.save();
        controller.cancel();
        
        // Update record
      /*  obj = [SELECT id FROM DS_Functioning_Forms_B__c WHERE client__c =: client.id];    
        sc = new ApexPages.StandardController(obj);        
        controller = new DS_CANSTR_Controller(sc);    
        ApexPages.currentPage().getParameters().put('cimi', cimi);    
        controller.save();    */
    }
    static TestMethod void Test_samlpeAsserts(){         

    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility();
    
//create test client 
    Client__c client = test_ut.createClientSummary();
String cimi= ut.urlEncode('c='+client.id);
ApexPages.currentPage().getParameters().put('cimi',cimi);

    DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
      obj.client__c = client.id;
      
    ApexPages.StandardController sc = new ApexPages.StandardController(obj);
    
 DS_CANSTR_Controller canstrController = new DS_CANSTR_Controller(sc); 
 
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
  
   canstrController.save();
   canstrController.cancel();
    }
    }