/****
*@description Tests Site Register Controller
*
*includes asserts
*hard-coded sample name/password
*
*@group Test Script 
*@group-content /ApexDocContent/Test/SiteRegisterController.htm
****/
@IsTest public with sharing class TestClass_SiteRegisterController {
    /****
    *@description Instantiate a new controller with all parameters in the page
    ****/
    @IsTest(SeeAllData=true) static void testRegistration() {
        SiteRegisterController controller = new SiteRegisterController();
        controller.username = 'test@force.com';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
    }
}