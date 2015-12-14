@isTest (SeeAllData=false)
private class TestClass_Client {

  static TestMethod void Test_ClientController_CreateClient() {

    TestClass_A_Utility ut = new TestClass_A_Utility();

    ut.addAdminToCounter();

    Client__c client = new Client__c();

    PageReference pageRef = ApexPages.currentPage();
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(client);

    ClientController controller = new ClientController(sc);
    
    System.debug(client);
    
  }

  static TestMethod void Test_ClientController_EditClient() {

    TestClass_A_Utility ut = new TestClass_A_Utility();

    Client__c client = Test0_TestClientInsert();

    PageReference pageRef = ApexPages.currentPage();
    pageRef.getParameters().put('id', client.id);
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(client);

    ClientController controller = new ClientController(sc);    
    
    System.debug(client);

  }

  static TestMethod Client__c Test0_TestClientInsert() {

    TestClass_A_Utility ut = new TestClass_A_Utility();

    Client__c client = ut.createClient();
    
    System.debug(client);

    return client;

  }

  static TestMethod void Test1_TestClientUpdate() {

    Client__c client = Test0_TestClientInsert();
    
    System.debug(client);

    update client;

  }


}