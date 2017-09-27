@isTest (SeeAllData=false)
private class TestClass_ClientSummary {

  static TestMethod void Test_ClientSummaryController() {

    Utility ut = new Utility();

    TestClass_Utility test_ut = new TestClass_Utility();

    //test_ut.createFormInfo();
    TestClassData_DS_Form_Info formInfo = new TestClassData_DS_Form_Info();

    Client__c client = test_ut.createClient();

    ApexPages.currentPage().getParameters().put('id', client.id);

    ApexPages.StandardController sc = new ApexPages.StandardController(client);
  
    ClientSummaryController summary = new ClientSummaryController(sc);

    summary.SummaryInit();
    summary.traumaHistoryRowList();

    //String clientInfo = summary.getClientInfo();


    // need client who has TD record
    
  }

  


}