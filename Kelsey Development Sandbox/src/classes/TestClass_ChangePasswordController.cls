/****
*@description An apex page controller that exposes the change password functionality
*includes assert
*
*@date 7/17/2014
*@modified date
*
*@group Test Script 
*@group-content /ApexDocContent/Test/ChangePasswordController.htm
****/


@IsTest public with sharing class TestClass_ChangePasswordController {
    /****
    *@description Instantiate a new controller with all parameters in the page
    ****/
    @IsTest(SeeAllData=true) public static void testChangePasswordController() {
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';                
        
        System.assertEquals(controller.changePassword(),null);                  
    }    
}