@isTest
private class TestClass_Aduit_Trail {

  /*static TestMethod void Test_Insert_Update() {
  
    Utility ut = new Utility();

    TestClass_Utility test_ut = new TestClass_Utility();

    Client__c client = new Client__c();

    Date dob = date.valueOf('2007-10-5 00:00:00');

    client.INIT__c = 'BBB';
    client.DOB1__c = dob;
    client.DOB2__c = dob;
    client.AGE__c = Integer.valueOf(dob.daysBetween(date.today())/365);
    client.GENDER__c = 'Male';
    
    client = test_ut.createCustomClientSummary(client);
    
    List<Client_Summary__c> su = [Select id, section__c, page__r.Form__c FROM Client_Summary__c WHERE client__c =: client.id];

    Client_Summary__c summary = [SELECT id 
                                   FROM Client_Summary__c
                                  WHERE Page__r.Form__c = 'DS_DEMO'
                                    AND SECTION__c = '0'
                                    AND Client__c = : client.id]; 
    
    String cimi = ut.urlEncode('c='+client.id+'&summary='+summary.id);
    
    ApexPages.currentPage().getParameters().put('cimi', cimi);


    DS_CBCL_B__c cbclOld = new DS_CBCL_B__c();
    
    cbclOld.Client__c = client.id;
    cbclOld.BCBOMETH__c = '1';
    cbclOld.FORM__c = 'DS_CBCL_6_18';
    cbclOld.BDOACO__c = dob;
    cbclOld.BCBO56B__c = '0';
    cbclOld.STATUS_CBCL_6_18__c = 'complete';
    
    ApexPages.StandardController sc = new ApexPages.StandardController(cbclOld);  
    DS_CBCL_6_18_Controller controller = new DS_CBCL_6_18_Controller(sc); 

    controller.save();

    insert cbclOld;

    Audit_Trail__c auditInitial = [SELECT ACTION__c, CLIENT__c, FORM__c, PRIOR_VALUE__c, UPDATED_VALUE__c 
                                    FROM Audit_Trail__c
                                   WHERE Client__c = :client.id];

    System.assertEquals(auditInitial.ACTION__c, 'Initial Entry', 'There is no initial entry.');


    cbclOld.BCBO56B__c = '1';

    update cbclOld;

    Audit_Trail__c auditUpdate = [SELECT ACTION__c, CLIENT__c, FORM__c, PRIOR_VALUE__c, UPDATED_VALUE__c 
                                   FROM Audit_Trail__c
                                  WHERE Client__c = :client.id
                                    AND ACTION__c = 'Update'];

    System.assertNotEquals(auditUpdate.PRIOR_VALUE__c, '0', 'Prior value is wrong.');
    System.assertNotEquals(auditUpdate.UPDATED_VALUE__c, '1', 'Update value is wrong.');
    

  }*/

}