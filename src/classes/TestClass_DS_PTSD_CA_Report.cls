@isTest (SeeAllData=false)
private class TestClass_DS_PTSD_CA_Report {

  static TestMethod void controllerTest() {

    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility();

    Client__c client = test_ut.createClientPTSD_CA_B();

    Client_Summary__c summary = [SELECT id 
                                   FROM Client_Summary__c
                                  WHERE Page__r.Form__c = 'DS_PTSD_CA'
                                    AND SECTION__c = '0'
                                    AND Client__c = : client.id]; 

    String cimi = ut.urlEncode('c='+client.id+'&summary='+summary.id);

    ApexPages.currentPage().getParameters().put('cimi', cimi);

    DS_PTSD_CA_B__c obj = new DS_PTSD_CA_B__c();
    

    obj.client__c = client.id;
    obj.BMETPTSD__c = '1';
    system.debug(obj);
    ApexPages.StandardController sc = new ApexPages.StandardController(obj);
    DS_PTSD_CA_Report_Controller controller = new DS_PTSD_CA_Report_Controller(sc);

    String clientInfo = controller.getClientInfo();
        
    controller.save();
    controller.cancel();
  
    // Update record
    obj = [SELECT id FROM DS_PTSD_CA_B__c WHERE client__c =: client.id];
    sc = new ApexPages.StandardController(obj);    
    controller = new DS_PTSD_CA_Report_Controller(sc);
    ApexPages.currentPage().getParameters().put('cimi', cimi);
    
    controller.save();
    
  }

}