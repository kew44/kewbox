@isTest (SeeAllData=false)
private class TestClass_DS_PTSD_CA {

  static TestMethod void controllerBaselineTest() {
  
    Utility ut = new Utility();

    TestClass_Utility test_ut = new TestClass_Utility();
    
    TestClassData_DS_PTSD_Form_Info formInfo = new TestClassData_DS_PTSD_Form_Info();
    
    Client__c client = test_ut.createClientSummary();

    List<Client_Summary__c> su = [Select id, section__c FROM Client_Summary__c];

    Client_Summary__c summary = [SELECT id 
                                   FROM Client_Summary__c
                                  WHERE Page__r.Form__c = 'DS_PTSD_CA'
                                    AND SECTION__c = '0'
                                    AND Client__c = : client.id]; 
    
    String cimi = ut.urlEncode('c='+client.id+'&summary='+summary.id);
    
    ApexPages.currentPage().getParameters().put('cimi', cimi);
    
    DS_PTSD_CA_B__c ptsd = new DS_PTSD_CA_B__c();
    
    ptsd.client__c = client.id;
    ptsd.BMETPTSD__c = '1';
   // ptsd.BPTSDATE__c = System.today();//Date.today();
    
    ApexPages.StandardController sc = new ApexPages.StandardController(ptsd);  
    DS_PTSD_CA_Controller controller = new DS_PTSD_CA_Controller(sc); 

    List<SelectOption> radio = controller.getRadioItems();
    List<SelectOption> radioNYU = controller.getNYUItems();
    List<SelectOption> radioYesNo = controller.getRadioYesNo();
    List<SelectOption> met = controller.getBMETItems();

    String clientInfo = controller.getClientInfo();

    controller.save();
    controller.saveViewReport();
    controller.cancel();
  
    // Update record

    /*ptsd = [SELECT id FROM DS_PTSD_CA_B__c WHERE client__c =: client.id];
    sc = new ApexPages.StandardController(ptsd);
    controller = new DS_PTSD_CA_Controller(sc);
    ApexPages.currentPage().getParameters().put('cimi', cimi);
    //controller.save();
    
    ptsd.STATUS_PTSD_CA__c = 'Complete'; 
   
    controller.save();*/

    
  }

  static TestMethod Client__c Test0_BaselineTestInsertWithMoreeThan3Blank() {

    TestClass_Utility test_ut = new TestClass_Utility();

    TestClassData_DS_PTSD_Form_Info formInfo = new TestClassData_DS_PTSD_Form_Info();

    Client__c client = test_ut.createClientSummary();

    DS_PTSD_CA_B__c obj = new DS_PTSD_CA_B__c();

    obj.client__c = client.id;

    obj.BMETPTSD__c = '1';
    obj.FORM__c = 'DS_PTSD_CA';

    obj.BPTSV1__c  = obj.BPTSV2__c  = obj.BPTSV3__c  = obj.BPTSV4__c  = '1';
    obj.BPTSV6__c  = obj.BPTSV7__c  = obj.BPTSV8__c  = obj.BPTSV9__c  = obj.BPTSV10__c = '4';
    obj.BPTSV11__c = obj.BPTSV12__c = obj.BPTSV13__c = obj.BPTSV14__c = obj.BPTSV15__c = '4';
    obj.BPTSV16__c = obj.BPTSV17__c = obj.BPTSV18__c = obj.BPTSV19__c = obj.BPTSV20__c = '2';
    obj.BPTSV21__c = obj.BPTSV22__c = obj.BPTSV23__c = obj.BPTSV24__c = obj.BPTSV25__c = '3';
    obj.BPTSV26__c = obj.BPTSV27__c = obj.BPTSV28__c = obj.BPTSV29__c = obj.BPTSV30__c = '1';

    insert obj;

    return client;

  }

  static TestMethod Client__c Test1_BaselineTestInsertWith2Blank() {

    TestClass_Utility test_ut = new TestClass_Utility();

    TestClassData_DS_PTSD_Form_Info formInfo = new TestClassData_DS_PTSD_Form_Info();

    Client__c client = test_ut.createClientSummary();

    DS_PTSD_CA_B__c obj = new DS_PTSD_CA_B__c();

    obj.client__c = client.id;

    obj.BMETPTSD__c = '1';
    obj.FORM__c = 'DS_PTSD_CA';

    obj.BPTSV1__c  = obj.BPTSV2__c  = obj.BPTSV3__c  = obj.BPTSV4__c  = obj.BPTSV5__c  = '2';
    obj.BPTSV6__c  = obj.BPTSV7__c  = obj.BPTSV8__c  = obj.BPTSV9__c  = obj.BPTSV10__c = '4';
    obj.BPTSV11__c = obj.BPTSV12__c = obj.BPTSV13__c = obj.BPTSV14__c = obj.BPTSV15__c = '4';
    obj.BPTSV16__c = obj.BPTSV17__c = obj.BPTSV18__c = obj.BPTSV19__c = obj.BPTSV20__c = '2';
    obj.BPTSV21__c = obj.BPTSV22__c = obj.BPTSV23__c = obj.BPTSV24__c = obj.BPTSV25__c = '3';
    obj.BPTSV26__c = obj.BPTSV27__c = obj.BPTSV28__c = obj.BPTSV29__c = obj.BPTSV30__c = '2';

    insert obj;

    return client;

  }

}