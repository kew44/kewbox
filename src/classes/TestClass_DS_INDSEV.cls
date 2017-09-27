@istest(SeeAllData=false)
public class TestClass_DS_INDSEV{

static TestMethod void Test_DS_INDSEV_Controller() {

    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility();

    Client__c client = test_ut.createClientSummary();
    String cimi = ut.urlEncode('c='+client.id+'&s=0');
ApexPages.currentPage().getParameters().put('cimi',cimi);

    DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
    //obj.STATUS__c = 'Complete';
    obj.client__c = client.id;      
    ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
    DS_INDSEV_Controller controller = new DS_INDSEV_Controller(sc);
    
    List<SelectOption> nsvu = controller.getNSVUItems();
    List<SelectOption> nyu = controller.getNYUItems();
    List<SelectOption> refunk = controller.getRefUnkItems();
    List<SelectOption> bnyui = controller.getBNYUItems();
    
    controller.save();
    controller.cancel();

    // Update record
    obj = [SELECT id FROM DS_Functioning_Forms_B__c WHERE client__c =: client.id];
    sc = new ApexPages.StandardController(obj);    
    controller = new DS_INDSEV_Controller(sc);
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
 DS_INDSEV_Controller indsevController = new DS_INDSEV_Controller(sc);
 
String BISPACAD='0';
String BSUITALK = '0';//
String BISPCRSP= 'null'; 
 
 insert obj;
 
 //asserts
  System.assertNotEquals(obj.BISPACAD__c,BISPACAD , 'Child has academic problems.');
  System.assertNotEquals(obj.BSUITALK__c,BSUITALK , 'Child has NOT talked about suicide.');
  System.assertNotEquals(obj.BISPCRSP__c,BISPCRSP , 'Child has been arrested '+obj.BISPCRSP__c+' time(s) in the past 30 days');

 //save/cancels
   indsevController.save();
   indsevController.cancel();
  }
}