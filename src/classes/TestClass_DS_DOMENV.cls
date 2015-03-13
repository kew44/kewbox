@istest(SeeAllData=false)
public class TestClass_DS_DOMENV{

static TestMethod void Test_DS_DOMENV_Controller(){    

        Utility ut = new Utility();
        TestClass_Utility test_ut = new TestClass_Utility(); 
        
        Client__c client = test_ut.createClientSummary();
String cimi= ut.urlEncode('c='+client.id);
ApexPages.currentPage().getParameters().put('cimi',cimi);
  
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();  
   //     obj.STATUS__c = 'Complete'; 
    	obj.RWHITE__c = true;
        obj.client__c = client.id;
                ApexPages.StandardController sc = new ApexPages.StandardController(obj);       
        DS_DOMENV_Controller controller = new DS_DOMENV_Controller(sc);   
        
        List<SelectOption> PrimeRest = controller.getPrimeRestIems();
        List<SelectOption> HowLong = controller.getHowLongIems();
        List<SelectOption> OutPlace = controller.getOutPlaceIems();
        List<SelectOption> LiveMost = controller.getLiveMostItems();
        List<SelectOption> CTYREFUSE = controller.getCTYREFUSEItems();   
        List<SelectOption> Lang = controller.getLangItems();       
        List<SelectOption> Income = controller.getIncomeItems();   
        List<SelectOption> FamRes = controller.getFamResItems();         
        List<SelectOption> CareGive = controller.getCareGiveItems();         
        List<SelectOption> Grade = controller.getGradeItems();         
        List<SelectOption> Absent = controller.getAbsentItems(); 
        
        
        controller.save();
        controller.cancel();
        
        // Update record
     /*   obj = [SELECT id FROM DS_Background_Family_Info_B__c WHERE client__c =: client.id];
        sc = new ApexPages.StandardController(obj);                
        controller = new DS_DOMENV_Controller(sc);    
        ApexPages.currentPage().getParameters().put('cimi', cimi);    
        controller.save();        */        
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
 DS_DOMENV_Controller domenvController = new DS_DOMENV_Controller(sc); //domenvController
 
//Domenv
String BLANGHOM = '1';
Boolean BCHHOMECHECK= true;
String BLOTHRSP= 'null'; 
Boolean RWHITE = true;
    
 insert obj;
 
 //asserts
//Domenv
 System.assertNotEquals(obj.BLANGHOM__c,BLANGHOM,'Language at home is NOT English.');
  System.assertNotEquals(obj.BCHHOMECHECK__c,BCHHOMECHECK,'Total number of children is known.');
   System.assertNotEquals(obj.BLOTHRSP__c,BLOTHRSP,'Other adult is specified as '+obj.BLOTHRSP__c+'.');
   
 //save/cancels
    domenvController.save();
   domenvController.cancel();
    }
 
}