@istest(SeeAllData=false)
public class TestClass_DS_SDQ_P_O_B {
static TestMethod void controllerTest() {
    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility();
    
        TestClassData_DS_SDQ_PSI_CDI_Form_Info formInfo = new TestClassData_DS_SDQ_PSI_CDI_Form_Info();

    Client__c client = new Client__c();
    
     Date dob = date.valueOf('2000-10-5 12:20:20');
    client.INIT__c = 'WFW';
    client.DOB1__c = dob;
    client.DOB2__c = dob;
    client.AGE__c = Integer.valueOf(dob.daysBetween(date.today())/365);
    client.GENDER__c = 'Male';
    
    client = test_ut.createCustomClientSummary(client);    
    
    List<Client_Summary__c> su = [Select id, section__c FROM Client_Summary__c WHERE client__c =: client.id];

    system.debug(su);
    
        Client_Summary__c summary = [SELECT id 
                                   FROM Client_Summary__c
                                  WHERE Page__r.Form__c = 'DS_SDQ_P_11_17'
                                    AND SECTION__c = '0'
                                    AND Client__c = : client.id]; 
                                   system.debug(summary);
String cimi= ut.urlEncode('c='+client.id+'&summary='+summary.id);
ApexPages.currentPage().getParameters().put('cimi',cimi);

DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c();
obj.client__c = client.id;
    
    ApexPages.StandardController sc = new ApexPages.StandardController(obj); 
    DS_SDQ_P_O_B_Controller controller = new DS_SDQ_P_O_B_Controller(sc);  
      
    List<SelectOption> Overall= controller.getOverallItems();
    List<SelectOption> HowLong= controller.getHowLongItems();
    List<SelectOption> Upset= controller.getUpsetItems();
    List<SelectOption> Difficult= controller.getDifficultItems();
    List<SelectOption> BMET= controller.getBMETItems();
    
    String clientInfo = controller.getClientInfo();
    
 controller.saveviewOld();
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
    obj.Form__c = 'DS_SDQ_P_11_17';

    obj.BSDPSOMA__c= '1';
    obj.BSDPWORR__c= '1';
    obj.BSDPUNHA__c= '1';
    obj.BSDPCLIN__c= '1';
    obj.BSDPAFRA__c= '1';
    obj.BSDPEMO__c= 1;
    obj.BSDPTANT__c= '1';
    obj.BSDPOBEY__c= '1';
    obj.BSDPFIGH__c= '1';
    obj.BSDPLIES__c= '1';
    obj.BSDPSTEA__c= '1';
    obj.BSDPBEH__c= 1;
    obj.BSDPREST__c= '1';
    obj.BSDPFIDG__c= '1';
    obj.BSDPDIST__c= '1';
    obj.BSDPREFL__c= '1';
    obj.BSDPATTE__c= '1';
    obj.BSDPHYP__c= 1;
    obj.BSDPLONE__c= '1';
    obj.BSDPFRIE__c= '1';
    obj.BSDPPOPU__c= '1';
    obj.BSDPBULL__c= '1';
    obj.BSDPOLDB__c= '1';
    obj.BSDPOTC__c= 1;
    obj.BSDPCONS__c= '1';
    obj.BSDPSHAR__c= '1';
    obj.BSDPCARI__c= '1';
    obj.BSDPKIND__c= '1';
    obj.BSDPHELP__c= '1';
    obj.BSDPKHB__c= 1;
    obj.BSDPIMPF__c= '1';
    obj.BSDPIMPH__c= '1';
    obj.BSDPIMPC__c= '1';
    obj.BSDPUPSET__c= '1';
    obj.BSDPIMPL__c= '1';
    obj.BSDPDCL__c= 1;
    obj.BSDPTOT__c= 1; 
    insert obj;
    return client;
  } 
}