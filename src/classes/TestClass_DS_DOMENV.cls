@istest(SeeAllData=false)
public class TestClass_DS_DOMENV{
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    // Test baseline controller 
    static TestMethod void Test_Baseline_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_DOMENV', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();    
        obj.STATUS_DOMENV__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_DOMENV_Controller controller = new DS_DOMENV_Controller(sc);        
        
        List<SelectOption> nsvu = new List<SelectOption>();
        
        nsvu = controller.getPrimeRestIems();
        nsvu = controller.getHowLongIems();
        nsvu = controller.getOutPlaceIems();
        nsvu = controller.getLiveMostItems();
        nsvu = controller.getCTYREFUSEItems();
        nsvu = controller.getLangItems();
        nsvu = controller.getIncomeItems();
        nsvu = controller.getFamResItems();
        nsvu = controller.getCareGiveItems();
        nsvu = controller.getGradeItems();
        nsvu = controller.getAbsentItems();
        
        controller.save();
        controller.cancel();
        
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_DOMENV', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Background_Family_Info_F__c obj = new DS_Background_Family_Info_F__c();    
        obj.STATUS_DOMENV__c = 'Complete';
        obj.client__c = client.id;        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_DOMENV_Controller controller = new DS_DOMENV_Controller(sc);        
        
        List<SelectOption> nsvu = new List<SelectOption>();
        
        nsvu = controller.getPrimeRestIems();
        nsvu = controller.getHowLongIems();
        nsvu = controller.getOutPlaceIems();
        nsvu = controller.getLiveMostItems();
        nsvu = controller.getCTYREFUSEItems();
        nsvu = controller.getLangItems();
        nsvu = controller.getIncomeItems();
        nsvu = controller.getFamResItems();
        nsvu = controller.getCareGiveItems();
        nsvu = controller.getGradeItems();
        nsvu = controller.getAbsentItems();
        
        controller.save();
        controller.cancel();
        
    }
    
    /*static TestMethod void Test_DS_DOMENV_Controller(){    

Utility ut = new Utility();
TestClass_A_Utility test_ut = new TestClass_A_Utility(); 

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


}   

static TestMethod void Test_samlpeAsserts(){    

Utility ut = new Utility();
TestClass_A_Utility test_ut = new TestClass_A_Utility();

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
}*/
    
}