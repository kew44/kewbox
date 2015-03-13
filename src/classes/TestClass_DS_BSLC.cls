@istest(SeeAllData=false)
public class TestClass_DS_BSLC{

static TestMethod void Test_DS_BSLC_Controller() {
    
        Utility ut = new Utility();
        TestClass_Utility test_ut = new TestClass_Utility();
    
        Client__c client = test_ut.createClientSummary();
    String cimi = ut.urlEncode('c='+client.id+'&s=0');
ApexPages.currentPage().getParameters().put('cimi',cimi);

    DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();    
        //obj.STATUS__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_BSLC_Controller controller = new DS_BSLC_Controller(sc);
        
        List<SelectOption> YN = controller.getYNIems();
        List<SelectOption> YNUnknown = controller.getYNUIems();
        List<SelectOption> treatment = controller.getTreatIems();
        List<SelectOption> YNComplete = controller.getYNCompletedIems();
                
        controller.save();
        controller.cancel();
        
        // Update record
     /*  obj = [SELECT id FROM DS_Functioning_Forms_B__c WHERE client__c =: client.id];    
        sc = new ApexPages.StandardController(obj);        
        controller = new DS_BSLC_Controller(sc);    
        ApexPages.currentPage().getParameters().put('cimi', cimi);    
        controller.save(); */   
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
 DS_BSLC_Controller bslcController = new DS_BSLC_Controller(sc);
 
String BNCCTSBSLC='1';//
Date BTXSTDT=system.today();
String BTXCOMP = '1';//
String BTXTYPSP= 'null'; 

 insert obj;
 
 //asserts
  System.assertNotEquals(obj.BNCCTSBSLC__c,BNCCTSBSLC , 'Breakthrough series or learning collaborative NOT led by the UCLA-Duke University National Center for Child Traumatic Stress');
  System.assertNotEquals(obj.BTXCOMP__c, BTXCOMP, 'Treatment was NOT completed.');
  System.assertNotEquals(obj.BTXTYPSP__c, BTXTYPSP, 'Other treatment specified as '+obj.BTXTYPSP__c+'.');
  
 //save/cancels
   bslcController.save();
   bslcController.cancel();
    }
}