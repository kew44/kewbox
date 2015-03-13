@istest(SeeAllData=false)
public class TestClass_DS_DEMO {

static TestMethod void controllerTest() {

    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility();
    
    Client__c client = test_ut.createClientSummary();
String cimi= ut.urlEncode('c='+client.id+'&section=0');
ApexPages.currentPage().getParameters().put('cimi',cimi);

    DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
  //  obj.STATUS__c = 'Complete'; 
    obj.client__c = client.id;
    obj.RREF__c= true;
    obj.FORM__c = 'DS_DEMO';
    ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
    DS_DEMO_Controller controller = new DS_DEMO_Controller(sc);

    List<SelectOption> q2 = controller.getQ2Items();
    List<SelectOption> q4 = controller.getQ4Items();
   // List<SelectOption> q6 = controller.getQ6Items();
   List<SelectOption> hisplat = controller.getHispLatItems();
    List<SelectOption> q14 = controller.getQ14Items();
    List<SelectOption> nyu = controller.getNYUItems();
    List<SelectOption> nyur = controller.getNYUrItems();
    List<SelectOption> milself = controller.getMilSelfItems();
    List<SelectOption> milfam = controller.getMilFamItems();
    List<SelectOption> overall = controller.getOverAllItems();
    List<SelectOption> administered = controller.getBMETItems();
    List<SelectOption> geniden = controller.getGenIdenItems();
    List<SelectOption> orient = controller.getOrientItems();
    
    
    
    
    controller.save();
   controller.cancel();
   
    // Update record
//        obj.RREF__c= true;
  //  obj = [SELECT id FROM DS_Background_Family_Info_B__c WHERE client__c =: client.id];

    //sc = new ApexPages.StandardController(obj);    
    //controller = new DS_DEMO_Controller(sc);
    //ApexPages.currentPage().getParameters().put('cimi', cimi);
    //controller.save();   
  }
}