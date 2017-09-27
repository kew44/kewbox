@istest(SeeAllData=false)
public class TestClass_DS_SERVREC{

static TestMethod void Test_DS_SERVREC_Controller(){

            Utility ut = new Utility();
        TestClass_Utility test_ut = new TestClass_Utility();
        
        Client__c client = test_ut.createClientSummary();    
String cimi= ut.urlEncode('c='+client.id);
ApexPages.currentPage().getParameters().put('cimi',cimi);

        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();  
        //obj.STATUS__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_SERVREC_Controller controller = new DS_SERVREC_Controller(sc);   
        
        List<SelectOption> InList = controller.getInItems();


        controller.save();
        controller.cancel();        
        
        // Update record
        obj = [SELECT id FROM DS_Functioning_Forms_B__c WHERE client__c =: client.id];
        sc = new ApexPages.StandardController(obj);
                controller = new DS_SERVREC_Controller(sc);
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
 DS_SERVREC_Controller servrecController = new DS_SERVREC_Controller(sc);

String BOSMEN='99';
Boolean BLTCOGB = true;
String BOSOSP= 'null';  
 
 insert obj;
 
 //asserts
  System.assertNotEquals(obj.BOSMEN__c,BOSMEN , 'It is known if the child has recieved mentor services or not within the last 30 days.'); 
  System.assertNotEquals(obj.BLTCOGB__c,BLTCOGB , 'Child has NOT recieved cognitive behavioral therapy in lifetime.');
  System.assertNotEquals(obj.BOSOSP__c,BOSOSP , 'Other service is specified as'+obj.BOSOSP__c+'.');
  
 //save/cancels
    servrecController.save();
   servrecController.cancel();
   }
}