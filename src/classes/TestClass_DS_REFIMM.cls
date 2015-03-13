@istest(SeeAllData=false)
public class TestClass_DS_REFIMM{

static TestMethod void Test_DS_REFIMM_Controller() {  
 
        Utility ut = new Utility();
        TestClass_Utility test_ut = new TestClass_Utility();
        Client__c client = test_ut.createClientSummary();
String cimi= ut.urlEncode('c='+client.id);
ApexPages.currentPage().getParameters().put('cimi',cimi);


    DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
        obj.RWHITE__c=true;
      //  obj.STATUS__c = 'Complete'; 
        obj.client__c = client.id;
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        DS_REFIMM_Controller controller = new DS_REFIMM_Controller(sc);
        
        List<SelectOption> CTYNUN = controller.getCTYNUNItems();
        List<SelectOption> EngWell= controller.getEngWellItems();
        List<SelectOption> CTDECT= controller.getCTDECT();
       // String clientInfo = controller.getClientInfo();

        controller.save();
        controller.cancel();
        
        // Update record
  /*      obj = [SELECT id FROM DS_Background_Family_Info_B__c WHERE client__c =: client.id];
        sc = new ApexPages.StandardController(obj);
        controller = new DS_REFIMM_Controller(sc);
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        controller.save();*/
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
 DS_REFIMM_Controller refimmController = new DS_REFIMM_Controller(sc); //refimmController
    
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
   
 //save/cancels
    refimmController.save();
   refimmController.cancel();

    }
}