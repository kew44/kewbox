@isTest (SeeAllData=false)
private class TestClass_Client {

  static TestMethod void Test_ClientController_CreateClient() {

    TestClass_Utility ut = new TestClass_Utility();

    ut.addAdminToCounter();

    Client__c client = new Client__c();

    PageReference pageRef = ApexPages.currentPage();
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(client);

    ClientController controller = new ClientController(sc);
    
  }

  static TestMethod void Test_ClientController_EditClient() {

    TestClass_Utility ut = new TestClass_Utility();

    Client__c client = Test0_TestClientInsert();

    PageReference pageRef = ApexPages.currentPage();
    pageRef.getParameters().put('id', client.id);
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(client);

    ClientController controller = new ClientController(sc);
    

  }

  static TestMethod Client__c Test0_TestClientInsert() {

    TestClass_Utility ut = new TestClass_Utility();

    Client__c client = ut.createClient();

    return client;

  }

  static TestMethod void Test1_TestClientUpdate() {

    Client__c client = Test0_TestClientInsert();

    update client;

  }


}