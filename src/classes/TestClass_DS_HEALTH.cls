@istest(SeeAllData=false)
public class TestClass_DS_HEALTH{

 static TestMethod void Test_DS_HEALTH_Controller(){
 
    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility();
    
    Client__c client = test_ut.createClientSummary();
String cimi= ut.urlEncode('c='+client.id);
ApexPages.currentPage().getParameters().put('cimi',cimi);

    DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
  //  obj.STATUS__c = 'Complete'; 
        obj.RWHITE__c=true;
    obj.client__c = client.id;
    ApexPages.StandardController sc = new ApexPages.StandardController(obj);
    DS_HEALTH_Controller controller = new DS_HEALTH_Controller(sc);
    
        List<SelectOption> nyu = controller.getNYUItems();
     
    controller.save();
    controller.cancel();
    
    // Update record
  /*  obj = [SELECT id FROM DS_Background_Family_Info_B__c WHERE client__c =: client.id];
    sc = new ApexPages.StandardController(obj);
    controller = new DS_HEALTH_Controller(sc);
 //   ApexPages.currentPage().getParameters().put('cimi', cimi);
    controller.save();   */
  }
  
      static TestMethod void Test_samlpeAsserts(){ 
  
    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility();
    
//create test client 
    Client__c client = test_ut.createClientSummary();
String cimi= ut.urlEncode('c='+client.id);
ApexPages.currentPage().getParameters().put('cimi',cimi);

    DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
        obj.RWHITE__c=true;
    obj.client__c = client.id;
    
    ApexPages.StandardController sc = new ApexPages.StandardController(obj);
    
    //    controllers   
 DS_HEALTH_Controller healthController = new DS_HEALTH_Controller(sc); //healthController
 
   //Health
//String BTRT= '1';
//Boolean BTRTOTHR= true;
String BTRTOTSP= 'null'; 

 insert obj;
 
 //asserts
   //Health
// System.assertNotEquals(obj.BTRT__c,BTRT,'Child does NOT have current course of treatment.');
 //System.assertNotEquals(obj.BTRTOTHR__c,BTRTOTHR,'Other condition NOT selected.');
 System.assertNotEquals(obj.BTRTOTSP__c,BTRTOTSP,'Condition is specified as '+obj.BTRTOTSP__c+'.');
 
 //save/cancels
    healthController.save();
   healthController.cancel();
      }
  }