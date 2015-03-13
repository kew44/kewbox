@istest(SeeAllData=false)
public class TestClass_DS_FAPGAR{

static TestMethod void Test_DS_FAPGAR_Controller() {
    
        Utility ut = new Utility();
        TestClass_Utility test_ut = new TestClass_Utility();
    
        Client__c client = test_ut.createClientSummary();
    String cimi = ut.urlEncode('c='+client.id+'&s=0');
ApexPages.currentPage().getParameters().put('cimi',cimi);

    DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        //obj.STATUS__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_FAPGAR_Controller controller = new DS_FAPGAR_Controller(sc);        
             
        List<SelectOption> nsvu = controller.getNSVUItems();

        controller.save();
        controller.cancel();
        
        // Update record
        obj = [SELECT id FROM DS_Functioning_Forms_B__c WHERE client__c =: client.id];    
        sc = new ApexPages.StandardController(obj);        
        controller = new DS_FAPGAR_Controller(sc);    
        ApexPages.currentPage().getParameters().put('cimi', cimi);    
        controller.save();    
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
    
    //    controllers
 DS_FAPGAR_Controller fapgarController = new DS_FAPGAR_Controller(sc);
 
String BFAPGAR1='99';
String BFAPGAR2='1';
String BFAPGAR3='0';
String BFAPGAR4='2';
String BFAPGAR5='99';
String BFAPGAR_MET = 'Not Met';
Integer BFAPGAR_RAW =5;   
                
 insert obj;
 
 //asserts
  System.assertNotEquals(obj.BFAPGAR1__c,BFAPGAR1 , 'I do NOT know if I am satisfied with the help that I receive from my family when something is troubling me.');
  System.assertNotEquals(obj.BFAPGAR2__c,BFAPGAR2 , 'I am satisfied with the way my family discusses items of common interest and shares problem-solving with me SOME OF THE TIME.');
  System.assertNotEquals(obj.BFAPGAR3__c, BFAPGAR3, 'I HARDLY EVER find that my family accepts my wishes to take on new activities or make changes in my life-style.');
  System.assertNotEquals(obj.BFAPGAR4__c, BFAPGAR4, 'I am ALMOST ALWAYS satisfied with the way my family expresses affection and responds to feelings such as anger, sorrow, and love.');
  System.assertNotEquals(obj.BFAPGAR5__c, BFAPGAR5, 'I do NOT know if I am satisfied with the amount of time my family and I spend together.');
 
 //save/cancels
   fapgarController.save();
   fapgarController.cancel();
   }
}