/****
*@description An apex page controller that exposes the site forgot password functionality
*
*includes assert
*hard-coded sample username
*
*@group Test Script 
*@group-content /ApexDocContent/Test/ForgotPasswordController.htm
****/
@IsTest public with sharing class TestClass_ForgotPasswordController {
    /****
    *@description Instantiate a new controller with all parameters in the page
    ****/
     @IsTest(SeeAllData=true) public static void testForgotPasswordController() {
        ForgotPasswordController controller = new ForgotPasswordController();
        controller.username = 'test@salesforce.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
    }
}