/****
*@description This test provides code coverage for Center
*
*@group Test Script 
*@group-content /ApexDocContent/Test/Center.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
public class TestClass_Center {
    
    /****
    *@description Initialize reference to TestClass_A_Utility
    ****/
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    /****
    *@description Initialize reference to Utility
    ****/
    public static Utility ut = new Utility();
    
    /****
    *@description method to test creation of center record
    ****/
  static TestMethod void Test_CenterController_CreateCenter() {

    test_ut.addAdminToCounter();

    // Create new center
    Center__c center = new Center__c();

    PageReference pageRef = ApexPages.currentPage();
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(center);

    CenterController controller = new CenterController(sc);

    List<SelectOption> radio = controller.getItems();
    
  }

    /****
    *@description method to test editing a record
    ****/
  static TestMethod void Test_CenterController_EditCenter() {

    Center__c center = Test0_TestInsertMainCenter();

    PageReference pageRef = ApexPages.currentPage();
    pageRef.getParameters().put('id', center.id);
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(center);

    CenterController controller = new CenterController(sc);

    List<SelectOption> radio = controller.getItems();

  }

    /****
    *@description method to test inserting a main center record
    ****/
  static TestMethod Center__c Test0_TestInsertMainCenter() {

    Center__c center = test_ut.createMainCenter();

    return center;

  }

    /****
    *@description method to test inserting a sub center record
    ****/
  static TestMethod Center__c Test1_TestInsertSubCenter() {

    Center__c subCenter = test_ut.createSubCenter();

    return subCenter;
  }

    /****
    *@description method to test updating a record
    ****/
  static TestMethod void Test2_TestUpdateCenter() {

    Center__c mainCenter = Test0_TestInsertMainCenter();

    Center__c main = [SELECT id FROM Center__c WHERE Type__c = 'Main' LIMIT 1];

    update main;

  }

    /****
    *@description method to test deletion of a record
    ****/
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

    /****
    *@description method to test deletion of a record
    ****/
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

    /****
    *@description method to test deletion of a record
    ****/
 static TestMethod void deleteTest() { 
 
    Center__c center = test_ut.createMainCenter();
    
    ApexPages.currentPage().getParameters().put('id', center.id);

    ApexPages.StandardController sc = new ApexPages.StandardController(center);

    CenterDeletion controller = new CenterDeletion(sc);

    controller.checkDeletion();
    
    controller.total = 1;
    
    System.assert(controller.total == 1);

    controller.checkDeletion();

  }

}