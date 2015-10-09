@istest(SeeAllData=false)
public class TestClass_DS_SDQ_S_B {
static TestMethod void controllerTest() {
    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility();    
 
    TestClassData_DS_SDQ_PSI_CDI_Form_Info formInfo = new TestClassData_DS_SDQ_PSI_CDI_Form_Info();
/*
    Client__c client = test_ut.createClientSDQO();
    
    List<Client_Summary__c> su = [Select id, section__c FROM Client_Summary__c WHERE client__c =: client.id];

    system.debug(su);

  Client_Summary__c summary = [SELECT id 
                                   FROM Client_Summary__c
                                  WHERE Page__r.Form__c = 'DS_SDQ_S_11_17'
                                    AND SECTION__c = '0'
                                    AND Client__c = : client.id]; 
                                   system.debug(summary);
String cimi= ut.urlEncode('c='+client.id+'&summary='+summary.id);
ApexPages.currentPage().getParameters().put('cimi',cimi);

DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c();
 
obj.client__c = client.id;
    ApexPages.StandardController sc = new ApexPages.StandardController(obj); 
    DS_SDQ_S_B_Controller controller = new DS_SDQ_S_B_Controller(sc);
  
      
    List<SelectOption> Overall= controller.getOverallItems();
    List<SelectOption> HowLong= controller.getHowLongItems();
    List<SelectOption> Upset= controller.getUpsetItems();
    List<SelectOption> Difficult= controller.getDifficultItems();
    List<SelectOption> BMET= controller.getBMETItems();
  
    String clientInfo = controller.getClientInfo();
    
    controller.saveview();
     controller.save();
   controller.cancel();
   
  }
  
 static TestMethod Client__c testWvals(){ 
    TestClass_Utility test_ut = new TestClass_Utility();
    TestClassData_DS_SDQ_PSI_CDI_Form_Info formInfo = new TestClassData_DS_SDQ_PSI_CDI_Form_Info();  
    Client__c client = test_ut.createClientSummary();
DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c();
    obj.Client__c = client.id;
obj.BMETSDOP__c = '1';
obj.BDOASDOP__c=date.parse('10/30/2014');  
      obj.client__c = client.id;
      obj.Form__c = 'DS_SDQ_S_11_17';
      
obj.BSDSSOMA__c= '1';
obj.BSDSWORR__c= '1';
obj.BSDSUNHA__c= '1';
obj.BSDSCLIN__c= '1';
obj.BSDSAFRA__c= '1';
obj.BSDSEMO__c= 1;
obj.BSDSTANT__c= '1';
obj.BSDSOBEY__c= '1';
obj.BSDSFIGH__c= '1';
obj.BSDSLIES__c= '1';
obj.BSDSSTEA__c= '1';
obj.BSDSBEH__c= 1;
obj.BSDSREST__c= '1';
obj.BSDSFIDG__c= '1';
obj.BSDSDIST__c= '1';
obj.BSDSREFL__c= '1';
obj.BSDSATTE__c= '1';
obj.BSDSHYP__c= 1;
obj.BSDSLONE__c= '1';
obj.BSDSFRIE__c= '1';
obj.BSDSPOPU__c= '1';
obj.BSDSBULL__c= '1';
obj.BSDSOLDB__c= '1';
obj.BSDSOTC__c= 1;
obj.BSDSCONS__c= '1';
obj.BSDSSHAR__c= '1';
obj.BSDSCARI__c= '1';
obj.BSDSKIND__c= '1';
obj.BSDSHELP__c= '1';
obj.BSDSKHB__c= 1;
obj.BSDSIMPF__c= '1';
obj.BSDSIMPH__c= '1';
obj.BSDSIMPC__c= '1';
obj.BSDSUPSET__c= '1';
obj.BSDSIMPL__c= '1';
obj.BSDSDCL__c= 1;
obj.BSDSTOT__c= 1; 
insert obj;
return client;*/
}   
}