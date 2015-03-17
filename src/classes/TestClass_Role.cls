@isTest (SeeAllData=false)
private class TestClass_Role {

  static TestMethod void controllerTest() {

    // add for jenkin deployment

    Utility ut = new Utility();

    TestClass_Utility test_ut = new TestClass_Utility();

    Center__c center = test_ut.createMainCenter();

    ID id = UserInfo.getUserRoleId();

    Profile p = [SELECT Id FROM Profile WHERE Name='Force.com - App Subscription User']; 

    Integer numCode = ut.getRandomInt(1, 100);

    //String redundentCode = EncodingUtil.convertToHex(crypto.generateAesKey(128)).substring(0,numCode);

    User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='testUser@nctsn.org');
    
    System.runAs(u) {

      test.startTest();

      RoleController roleManager = new RoleController();

      roleManager.CleanUserRole(id);
      
      roleManager.RoleType(id);
      roleManager.fillZero(3, 2);
      
      UserRole role = roleManager.roleInfo(id);

      roleManager.getRoleInfo(role.name);
        
      RoleControllerStatic.insertRoleList(role.name, center.id, 1);

      RoleControllerStatic.CreateCenter('test role', role.id);

      RoleControllerStatic.DeleteRole(role.id);

      RoleControllerStatic.UpdateCenter('test role', role.id);
        
      test.stopTest();

    }

  }

}