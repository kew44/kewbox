@IsTest global with sharing class TestClass_CommunityLogin{
@IsTest(SeeAllData=true) global static void Test_CommunitiesLoginController(){
CommunitiesLoginController controller = new CommunitiesLoginController();
String Username;
String Password;
controller.Username = 'test@salesforce.com';
controller.Password = '123456'; 
//PageReference forwardToAuthPage = new PageReference( '/CommunitiesLogin');
        System.assertEquals(controller.login(),null); 
           UserInfo.getUserType();
   controller.forwardToAuthPage();

        
}
}