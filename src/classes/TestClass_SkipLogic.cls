@isTest (SeeAllData=false)
private class TestClass_SkipLogic {

  static TestMethod void controllerTest() {

    TestClass_A_Utility ut = new TestClass_A_Utility();

    Client__c client = ut.createClient();
    
    DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();

    SkipLogic skip = new SkipLogic();

    skip.skipLibrary('CUREPI', 'show', '0', new Map<String, String>{'CUREPVS'=>'text'});  
    skip.skipLibrary('BTRT', 'show', '1', new Map<String, String>{'BTRTOMED'=>'checkbox'});  

    skip.runSkipLogic('CUREPI', '0', obj);
    skip.runSkipLogic('CUREPI', '1', obj);

    skip.runSkipLogic('BTRT', '0', obj);
    skip.runSkipLogic('BTRT', '1', obj);

    skip.skipList.get('CUREPI').get('CUREPVS').addTargetValue('1');

    skip.formRedirct(client.id, '0', '0');

    skip.formRedirct(client.id, '-1', '0');

    skip.formRedirct(client.id, '0', '1');

  }
  
}