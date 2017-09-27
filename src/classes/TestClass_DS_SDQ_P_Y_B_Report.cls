@isTest (SeeAllData=false)
private class TestClass_DS_SDQ_P_Y_B_Report{
static TestMethod void controllerTest() {

    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility(); 
     
    TestClassData_DS_SDQ_PSI_CDI_Form_Info formInfo = new TestClassData_DS_SDQ_PSI_CDI_Form_Info();///////////////////////////
      
     Client__c client = test_ut.createClientSDQY();     
    
    
    List<Client_Summary__c> su = [Select id, section__c FROM Client_Summary__c WHERE client__c =: client.id];

system.debug(su);
    system.debug(su);
    
        Client_Summary__c summary = [SELECT id 
                                   FROM Client_Summary__c
                                  WHERE Page__r.Form__c = 'DS_SDQ_P_04_10'
                                    AND SECTION__c = '0'
                                    AND Client__c = : client.id]; 
                                   system.debug(summary);
    String cimi = ut.urlEncode('c='+client.id+'&summary='+summary.id);
      system.debug(cimi);
  ApexPages.currentPage().getParameters().put('cimi', cimi);
  
    DS_SDQ_PSI_CDI_B__c obj =  [SELECT id FROM DS_SDQ_PSI_CDI_B__c
                         WHERE Client__c = : client.id 
                           AND SECTION__c = '0'];
                           system.debug(obj);

obj.Form__c = 'DS_SDQ_P_04_10';

    ApexPages.StandardController sc = new ApexPages.StandardController(obj);
    DS_SDQ_P_Y_B_Report_Controller YoungReportController= new DS_SDQ_P_Y_B_Report_Controller(sc);  
  
    String clientInfo = YoungReportController.getClientInfo();
    
    YoungReportController.saveYoung();
    YoungReportController.cancel();
    }
    }