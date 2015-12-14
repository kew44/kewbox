/****
*@description Provides coverage for skipLogic class
*
*@group Test Script 
*@group-content /ApexDocContent/Test/SkipLogic.htm
*
****/
@isTest (SeeAllData=false)
private class TestClass_SkipLogic {

  /****
  *@description method to test a controller utilizing skip logic
  ****/
  
  static TestMethod void controllerTest() {

    //Initialize reference to TestClass_A_Utility
    TestClass_A_Utility ut = new TestClass_A_Utility();

    // Initialize test client
    Client__c client = ut.createClient();
    
    // Initialize an object, DS_Background_Family_Info__c chosen 
    DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();

    SkipLogic skip = new SkipLogic();

    skip.skipLibrary('CUREPI', 'show', '0', new Map<String, String>{'CUREPVS'=>'text'});  
    skip.skipLibrary('BTRT', 'show', '1', new Map<String, String>{'BTRTOMED'=>'checkbox'});  

    skip.runSkipLogic('CUREPI', '0', obj);
    skip.runSkipLogic('CUREPI', '1', obj);

    skip.runSkipLogic('BTRT', '0', obj);
    skip.runSkipLogic('BTRT', '1', obj);

    skip.skipList.get('CUREPI').get('CUREPVS').addTargetValue('1');
    
    //forceRedirect scenarios
    skip.formRedirct(client.id, '0', '0');//Baseline, no redirect
    skip.formRedirct(client.id, '0', '1');//Baseline, redirecting
    skip.formRedirct(client.id, '-1', '0');//Trauma, no redirect
    skip.formRedirct(client.id, '1', '0');//FollowUp, no redirect
    skip.formRedirct(client.id, '1', '1');//FollowUp redirecting
    
    skip.removeHiddenElementValue(obj, '');

  }
  
}