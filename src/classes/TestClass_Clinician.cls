@isTest (SeeAllData=false)
private class TestClass_Clinician {

  static TestMethod void Test_ClinicianController_CreateClinician() {

    TestClass_Utility ut = new TestClass_Utility();

    ut.addAdminToCounter();

    // Create new clinician

    Clinician__c clinician = new Clinician__c();

    PageReference pageRef = ApexPages.currentPage();
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(clinician);

    ClinicianController controller = new ClinicianController(sc);
    
  }

  static TestMethod void Test_ClinicianController_EditClinician() {

    TestClass_Utility ut = new TestClass_Utility();

    Clinician__c clinician = Test0_TestClinicianInsert();

    PageReference pageRef = ApexPages.currentPage();
    pageRef.getParameters().put('id', clinician.id);
    Test.setCurrentPage(pageRef);

    ApexPages.StandardController sc = new ApexPages.StandardController(clinician);

    ClinicianController controller = new ClinicianController(sc);

  }

  static TestMethod Clinician__c Test0_TestClinicianInsert() {

    TestClass_Utility ut = new TestClass_Utility();

    Clinician__c clinician = ut.createClinician();

    return clinician;

  }

  static TestMethod void Test1_TestClinicianUpdate() {

    Clinician__c clinician = Test0_TestClinicianInsert();
    update clinician;

  }

  static TestMethod void Test2_TestClinicianDelete() {

    Clinician__c clinician = Test0_TestClinicianInsert();

    delete clinician;

  }

}