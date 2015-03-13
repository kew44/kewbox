@istest(SeeAllData=false)
public class TestClass_DS_CLINEVAL{

static TestMethod void Test_DS_CLINEVAL_Controller() {
    
        Utility ut = new Utility();
        TestClass_Utility test_ut = new TestClass_Utility();    
        Client__c client = test_ut.createClientSummary();
    String cimi = ut.urlEncode('c='+client.id+'&s=0');
ApexPages.currentPage().getParameters().put('cimi',cimi);

        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
        //obj.STATUS__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_CLINEVAL_Controller controller = new DS_CLINEVAL_Controller(sc);     
        
        List<SelectOption> YN = controller.getYNIems();
        List<SelectOption> Primary = controller.getPrimaryProbIems();
  
        controller.save();
        controller.cancel();
        
        // Update record
        obj = [SELECT id FROM DS_Functioning_Forms_B__c WHERE client__c =: client.id];    
        sc = new ApexPages.StandardController(obj);        
        controller = new DS_CLINEVAL_Controller(sc);    
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
 DS_CLINEVAL_Controller clinevalController = new DS_CLINEVAL_Controller(sc);
 
String BCEPRIM='2';
String BCEOTHY = '1';
String BCEOTHER= 'null'; 
 
 insert obj;
 
 //asserts
  System.assertNotEquals(obj.BCEPRIM__c, BCEPRIM, 'The primary problem is NOT Bipolar Disorder.');
  System.assertNotEquals(obj.BCEOTHY__c, BCEOTHY, 'No additional problems.');
  System.assertNotEquals(obj.BCEOTHER__c, BCEOTHER , 'Other problem identified as '+obj.BCEOTHER__c+'.');

 //save/cancels
   clinevalController.save();
   clinevalController.cancel();
    }
}