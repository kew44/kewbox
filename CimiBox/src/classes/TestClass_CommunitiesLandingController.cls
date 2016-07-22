/****
*@description Test the Controller to display Communities Landing page
*
*@group Test Script 
*@group-content /ApexDocContent/Test/CommunitiesLandingController.htm
****/
@IsTest global with sharing class TestClass_CommunitiesLandingController {
    @IsTest(SeeAllData=true) global static void Test_CommunitiesLandingController(){

CommunitiesLandingController controller = new CommunitiesLandingController();
   UserInfo.getUserType();
   controller.forwardToStartPage();
     
}
}