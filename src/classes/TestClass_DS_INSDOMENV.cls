@istest(SeeAllData=false)
public class TestClass_DS_INSDOMENV{

static TestMethod void Test_DS_INSDOMENV_Controller(){ 
           
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
        DS_INSDOMENV_Controller controller = new DS_INSDOMENV_Controller(sc);  
        
     //  String clientInfo = controller.getClientInfo();        
        List<SelectOption> CTYNUN = controller.getCTYNUNItems();
        List<SelectOption> PrimeRest = controller.getPrimeRestIems();
        List<SelectOption> HowLong = controller.getHowLongIems();
        List<SelectOption> OutPlace = controller.getOutPlaceIems();
        List<SelectOption> LiveMost = controller.getLiveMostItems(); 

        controller.save();
        controller.cancel();  
        
    // Update record
     /*   obj = [SELECT id FROM DS_Background_Family_Info_B__c WHERE client__c =: client.id];
        sc = new ApexPages.StandardController(obj);        
        controller = new DS_INSDOMENV_Controller(sc);    
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

    DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
        obj.RWHITE__c=true;
    obj.client__c = client.id;
    
    ApexPages.StandardController sc = new ApexPages.StandardController(obj);
    
    //    controllers
 DS_INSDOMENV_Controller indsevController = new DS_INSDOMENV_Controller(sc); //indsevController
 
 //Insdomenv
 String BCINANY = '1';
Boolean BCINOPUB = true;
String BCINOPSP= 'null'; 

 insert obj;
 
 //asserts
 //Insdomenv
 System.assertNotEquals(obj.BCINANY__c, BCINANY, 'Child NOT currently covered by any type of public or private health insurance .'); 
System.assertNotEquals(obj.BCINOPUB__c, BCINOPUB, 'Child NOT currently covered by other type of public health insurance.'); 
System.assertNotEquals(obj.BCINOPSP__c, BCINOPSP, 'Child covered by '+obj.BCINOPSP__c +'public health insurance.');

 //save/cancels
    indsevController.save();
   indsevController.cancel();
}
}