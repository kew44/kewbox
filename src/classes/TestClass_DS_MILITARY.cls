@istest(SeeAllData=false)
public class TestClass_DS_MILITARY{

static TestMethod void Test_DS_MILITARY_Controller(){

        Utility ut = new Utility();
        TestClass_Utility test_ut = new TestClass_Utility();
        
        Client__c client = test_ut.createClientSummary();
String cimi= ut.urlEncode('c='+client.id);
ApexPages.currentPage().getParameters().put('cimi',cimi);

    DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
        obj.RWHITE__c=true;
       // obj.STATUS__c = 'Complete'; 
        obj.client__c = client.id;
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        DS_MILITARY_Controller controller = new DS_MILITARY_Controller(sc);
        
        
        List<SelectOption> move = controller.getMoveItems();
        List<SelectOption> serve = controller.getServeItems();
        List<SelectOption> diff = controller.getIsDiffItems();
        List<SelectOption> relation = controller.getRelationItems();
        List<SelectOption> branch1 = controller.getBranch1Items();
        List<SelectOption> branch2 = controller.getBranch2Items();
        List<SelectOption> status = controller.getStatusItems();
        List<SelectOption> wartime = controller.getWartimeItems();
        List<SelectOption> deploy = controller.getDeployItems();
        List<SelectOption> deployall = controller.getDeployAllItems();
      //  String clientInfo = controller.getClientInfo(); 

        
        controller.save();
        controller.cancel();
        
        // Update record
    /*    obj = [SELECT id FROM DS_Background_Family_Info_B__c WHERE client__c =: client.id];
        sc = new ApexPages.StandardController(obj);
        controller = new DS_MILITARY_Controller(sc);
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
 DS_MILITARY_Controller militaryController = new DS_MILITARY_Controller(sc); //militaryController
 
   //Military
String BMFMR2= '98';
Boolean BSELFMIL= true;
String BMFMR2SP='null';

 insert obj;
 
 //asserts
   //Military
 System.assertNotEquals(obj.BMFMR2__c,BMFMR2,'NOT other family member.');
 System.assertNotEquals(obj.BSELFMIL__c,BSELFMIL,'Child is NOT in the military.');
 System.assertNotEquals(obj.BMFMR2SP__c,BMFMR2SP,'Other family member is specified as '+obj.BMFMR2SP__c+'.');
 
 //save/cancels
    militaryController.save();
   militaryController.cancel();
    }
    }