@isTest (SeeAllData=false)
private class TestClass_CenterDeletion {

 static TestMethod void controllerTest() {

    TestClass_A_Utility ut = new TestClass_A_Utility();

    Center__c center = ut.createMainCenter();

    ApexPages.currentPage().getParameters().put('id', center.id);

    ApexPages.StandardController sc = new ApexPages.StandardController(center);

    CenterDeletion controller = new CenterDeletion(sc);

    controller.checkDeletion();
    
    controller.total = 1;
    
    System.assert(controller.total == 1);

    controller.checkDeletion();

  }
  
}