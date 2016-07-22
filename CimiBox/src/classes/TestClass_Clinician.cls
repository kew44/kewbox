/****
*@description This test provides code coverage for Clinician 
*
*@group Test Script 
*@group-content /ApexDocContent/Test/Clinician.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
private class TestClass_Clinician {
    
    /****
    *@description Initialize reference to TestClass_A_Utility
    ****/
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    /****
    *@description Initialize reference to Utility
    ****/
    public static Utility ut = new Utility();
    
    /****
    *@description method to test creation of clinician record
    ****/
  static TestMethod void Test_ClinicianController_CreateClinician() {

    test_ut.addAdminToCounter();

    // Create new clinician

    Clinician__c clinician = new Clinician__c();

    PageReference pageRef = ApexPages.currentPage();
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(clinician);

    ClinicianController controller = new ClinicianController(sc);
    
  }

    /****
    *@description method to test editing a record
    ****/
  static TestMethod void Test_ClinicianController_EditClinician() {

    Clinician__c clinician = Test0_TestClinicianInsert();

    PageReference pageRef = ApexPages.currentPage();
    pageRef.getParameters().put('id', clinician.id);
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(clinician);

    ClinicianController controller = new ClinicianController(sc);

  }

    /****
    *@description method to test inserting a record
    ****/
  static TestMethod Clinician__c Test0_TestClinicianInsert() {

    Clinician__c clinician = test_ut.createClinician();

    return clinician;

  }

    /****
    *@description method to test updating a record
    ****/
  static TestMethod void Test1_TestClinicianUpdate() {

    Clinician__c clinician = Test0_TestClinicianInsert();
    update clinician;

  }

    /****
    *@description method to test deletion of a record
    ****/
  static TestMethod void Test2_TestClinicianDelete() {

    Clinician__c clinician = Test0_TestClinicianInsert();

    delete clinician;

  }

}