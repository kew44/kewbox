@istest(SeeAllData=false)
public class TestClass_DS_NOMS{

static TestMethod void Test_DS_NOMS_Controller() {

        Utility ut = new Utility();
        TestClass_Utility test_ut = new TestClass_Utility();
        
        Client__c client = test_ut.createClientSummary();
    String cimi = ut.urlEncode('c='+client.id+'&s=0');
ApexPages.currentPage().getParameters().put('cimi',cimi);

    DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        //obj.STATUS__c = 'Complete';
        obj.client__c = client.id;      
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        DS_NOMS_Controller controller = new DS_NOMS_Controller(sc);
        
        List<SelectOption> admin = controller.getAdminItems();

        controller.save();
        controller.cancel();
        
        // Update record
        obj = [SELECT id FROM DS_Functioning_Forms_B__c WHERE client__c =: client.id];
        sc = new ApexPages.StandardController(obj);
        controller = new DS_NOMS_Controller(sc);
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
 DS_NOMS_Controller nomsController = new DS_NOMS_Controller(sc);
 
String BNDAILYL='1';
String BNADMINOSP= 'null'; 

 insert obj;
 
 //asserts
  System.assertNotEquals(obj.BNDAILYL__c, BNDAILYL, 'I [my child] do[es] NOT strongly disagree that the child is handling dsily life.');
  System.assertNotEquals(obj.BNADMINOSP__c,BNADMINOSP , 'Form was administered by '+obj.BNADMINOSP__c+'.');
  
 //save/cancels
   nomsController.save();
   nomsController.cancel();
  }
}