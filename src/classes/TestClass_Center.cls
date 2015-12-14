@isTest (SeeAllData=false)
public class TestClass_Center {

  static TestMethod void Test_CenterController_CreateCenter() {

    TestClass_A_Utility ut = new TestClass_A_Utility();

    ut.addAdminToCounter();


    // Create new center

    Center__c center = new Center__c();

    PageReference pageRef = ApexPages.currentPage();
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(center);

    CenterController controller = new CenterController(sc);

    List<SelectOption> radio = controller.getItems();

    
  }

  static TestMethod void Test_CenterController_EditCenter() {

    TestClass_A_Utility ut = new TestClass_A_Utility();

    Center__c center = Test0_TestInsertMainCenter();

    PageReference pageRef = ApexPages.currentPage();
    pageRef.getParameters().put('id', center.id);
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(center);

    CenterController controller = new CenterController(sc);

    List<SelectOption> radio = controller.getItems();

  }

  static TestMethod Center__c Test0_TestInsertMainCenter() {

    TestClass_A_Utility ut = new TestClass_A_Utility();

    Center__c center = ut.createMainCenter();

    return center;

  }

  static TestMethod Center__c Test1_TestInsertSubCenter() {

    TestClass_A_Utility ut = new TestClass_A_Utility();

    Center__c subCenter = ut.createSubCenter();

    return subCenter;
  }

  static TestMethod void Test2_TestUpdateCenter() {

    Center__c mainCenter = Test0_TestInsertMainCenter();

    Center__c main = [SELECT id FROM Center__c WHERE Type__c = 'Main' LIMIT 1];

    update main;

    //Center__c sub = [SELECT id FROM Center__c WHERE Type__c = 'Sub' LIMIT 1];
    //update sub;

  }

  static TestMethod void Test3_TestDeleteCenterWithAssociate() {

    Center__c mainCenter = Test0_TestInsertMainCenter();

    Center__c main = [SELECT id FROM Center__c WHERE Type__c = 'Main' LIMIT 1];

    PageReference pageRef = ApexPages.currentPage();
    pageRef.getParameters().put('id', main.id);
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(main);

    CenterDeletion controller = new CenterDeletion(sc);

    controller.total = 1;

    controller.checkDeletion();

  }

  static TestMethod void Test4_TestDeleteCenterWithoutAssociate() {

    Center__c mainCenter = Test0_TestInsertMainCenter();

    Center__c main = [SELECT id FROM Center__c WHERE Type__c = 'Main' LIMIT 1];

    PageReference pageRef = ApexPages.currentPage();
    pageRef.getParameters().put('id', main.id);
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(main);

    CenterDeletion controller = new CenterDeletion(sc);

    controller.checkDeletion();

  }

}