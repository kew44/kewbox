/****
*@description Tests Site Login Controller
*
*includes assert
*hard-coded sample name/password
*
*@group Test Script 
*@group-content /ApexDocContent/Test/SiteLoginController.htm
****/
@IsTest global with sharing class TestClass_SiteLoginController {
    /****
    *@description Instantiate a new controller with all parameters in the page
    ****/
    @IsTest(SeeAllData=true) global static void testSiteLoginController () {
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
                
        System.assertEquals(controller.login(),null);                           
    }    
}