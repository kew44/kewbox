@IsTest global with sharing class TestClass_CommunitiesLandingController {
    @IsTest(SeeAllData=true) global static void Test_CommunitiesLandingController(){

CommunitiesLandingController controller = new CommunitiesLandingController();
   UserInfo.getUserType();
   controller.forwardToStartPage();
     
}
}