@isTest (SeeAllData=false)
private class TestClass_DS_GTRAUMA {

  static TestMethod void controllerTest() {

    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility();

    Client__c client = test_ut.createClientSummary();
    String cimi = ut.urlEncode('c='+client.id);//+'&summary='+summary.id);
    ApexPages.currentPage().getParameters().put('cimi', cimi);
    
    DS_GTRAUMA__c obj = new DS_GTRAUMA__c();    
    obj.client__c = client.id;
    obj.GT1R__c = '1';
    obj.GT2R__c = '1';
    obj.GT3R__c = '1';
    obj.GT4R__c = '1';
    obj.GT5R__c = '1';
    obj.GT6R__c = '1';
    obj.GT7R__c = '1';
    obj.GT8R__c = '1';
    obj.GT9R__c = '1';
    obj.GT10R__c = '1';
    obj.GT11R__c = '1';
    obj.GT12R__c = '1';
    obj.GT13R__c = '1';
    obj.GT14R__c = '1';
    obj.GT15R__c = '1';
    obj.GT16R__c = '1';
    obj.GT17R__c = '1';
    obj.GT18R__c = '1';
    obj.GT19R__c = '1';
    obj.GT20R__c = '1';
    obj.GT21R__c = '1';
    obj.GT22R__c = '1';
    obj.GT23R__c = '1';
    obj.GT8RA0__c = true;
    obj.GT20RA0__c = false;
    ApexPages.StandardController sc = new ApexPages.StandardController(obj);
    DS_GTRAUMA_Controller controller = new DS_GTRAUMA_Controller(sc);
    
    List<SelectOption> radio = controller.getTraumaType();
    List<SelectOption> radioYesNo = controller.getPrimaryType();
    //String clientInfo = controller.getClientInfo();
    
    
    System.assertEquals(obj.client__c, client.id, 'There is a problem with the clieni id.');
    System.assertEquals(obj.GT8R__c, '1', 'There is a problem with the variable GT8R.');
    System.assertEquals(obj.GT20R__c, '1', 'There is a problem with the variable GT20R.');
    System.assertEquals(obj.GT8RA0__c, true, 'There is a problem with the variable GT8RA0.');
    System.assertEquals(obj.GT20RA0__c, false, 'There is a problem with the variable GT20RA0.');
    
    controller.rowList();



    controller.save();
    controller.cancel();

    insert obj;
    // Update general trauma
        obj = [SELECT id FROM DS_GTRAUMA__c WHERE client__c =: client.id Limit 1];
   /* obj.client__c = client.id;//?
    obj.GT8R__c = '1';
    obj.GT20R__c = '1';
    obj.GT8RA0__c = true;*/
    obj.GT20RA0__c = true;
    sc = new ApexPages.StandardController(obj);
    controller = new DS_GTRAUMA_Controller(sc);    
    ApexPages.currentPage().getParameters().put('cimi', cimi);


    controller.save();
    //String nextPage = controller.save().getUrl();
    
  }

  static TestMethod DS_GTRAUMA__c Test0_insertUpdateGeneralTrauma() {

    TestClass_Utility test_ut = new TestClass_Utility();

    Client__c client = test_ut.createClientSummary();

    DS_GTRAUMA__c obj = new DS_GTRAUMA__c();

    obj.client__c = client.id;
    
    obj.GT1R__c = '1';
    obj.GT2R__c = '1';
    obj.GT3R__c = '1';
    obj.GT4R__c = '1';
    obj.GT5R__c = '1';
    obj.GT6R__c = '1';
    obj.GT7R__c = '1';
    obj.GT8R__c = '1';
    obj.GT9R__c = '1';
    obj.GT10R__c = '1';
    obj.GT11R__c = '1';
    obj.GT12R__c = '1';
    obj.GT13R__c = '1';
    obj.GT14R__c = '1';
    obj.GT15R__c = '1';
    obj.GT16R__c = '1';
    obj.GT17R__c = '1';
    obj.GT18R__c = '1';
    obj.GT19R__c = '1';
    obj.GT20R__c = '0';
    obj.GT21R__c = '1';
    obj.GT22R__c = '1';
    obj.GT23R__c = '1';

    obj.GT8RA0__c = true;
    obj.GT20RA0__c = true;

    obj.GT8RA1__c = false;

    obj.GT8RAU__c = false;

    insert obj;

    return obj;
  }

  static TestMethod void Test1_updateGeneralTrauma() {

    DS_GTRAUMA__c obj = Test0_insertUpdateGeneralTrauma();

    obj.GT1R__c = '1';
    obj.GT2R__c = '1';
    obj.GT3R__c = '1';
    obj.GT4R__c = '1';
    obj.GT5R__c = '1';
    obj.GT6R__c = '1';
    obj.GT7R__c = '1';
    obj.GT8R__c = '1';
    obj.GT9R__c = '1';
    obj.GT10R__c = '1';
    obj.GT11R__c = '1';
    obj.GT12R__c = '1';
    obj.GT13R__c = '1';
    obj.GT14R__c = '1';
    obj.GT15R__c = '1';
    obj.GT16R__c = '1';
    obj.GT17R__c = '1';
    obj.GT18R__c = '1';
    obj.GT19R__c = '1';
    obj.GT20R__c = '0';
    obj.GT21R__c = '1';
    obj.GT22R__c = '1';
    obj.GT23R__c = '1';

    obj.GT8RA0__c = true;
    obj.GT20RA0__c = true;

    obj.GT8RA1__c = true;
    obj.GT20RA1__c = true;

    obj.GT8RAU__c = true;

    update obj;

  }

  static TestMethod List<DS_GTRAUMA__c> Test3_bulkInsertGeneralTrauma() {

    TestClass_Utility test_ut = new TestClass_Utility();

    Client__c client = test_ut.createClientSummary();

    ///begin bulk insert
    System.debug('Inserting 200 records... (bulk validation)');

    List<DS_GTRAUMA__c> bulkObj = new List<DS_GTRAUMA__c>();

    for (Integer i=0;i<200;i++) {

      bulkObj.add(new DS_GTRAUMA__c(client__c = client.id,
                  
    GT1R__c = '1',GT2R__c = '1',GT3R__c = '1',GT4R__c = '1',
    GT5R__c = '1',GT6R__c = '1',GT7R__c = '1',GT8R__c = '1',
    GT9R__c = '1',GT10R__c = '1',GT11R__c = '1',GT12R__c = '1',
    GT13R__c = '1',GT14R__c = '1',GT15R__c = '1',GT16R__c = '1',
    GT17R__c = '1',GT18R__c = '1',GT19R__c = '1',GT20R__c = '1',
    GT21R__c = '1',GT22R__c = '1',GT23R__c = '1'
      
      ));

    }

    insert bulkObj;

    return bulkobj;

  }

  static TestMethod void Test4_bulkUpdateGeneralTrauma() {

    List<DS_GTRAUMA__c> bulkObj = Test3_bulkInsertGeneralTrauma();

    List<DS_GTRAUMA__c> updateBulkObj = new List<DS_GTRAUMA__c>();

    for(DS_GTRAUMA__c obj : bulkobj) {

    obj.GT1R__c = '1';
    obj.GT2R__c = '1';
    obj.GT3R__c = '1';
    obj.GT4R__c = '1';
    obj.GT5R__c = '1';
    obj.GT6R__c = '1';
    obj.GT7R__c = '1';
    obj.GT8R__c = '1';
    obj.GT9R__c = '1';
    obj.GT10R__c = '1';
    obj.GT11R__c = '1';
    obj.GT12R__c = '1';
    obj.GT13R__c = '1';
    obj.GT14R__c = '1';
    obj.GT15R__c = '1';
    obj.GT16R__c = '1';
    obj.GT17R__c = '1';
    obj.GT18R__c = '1';
    obj.GT19R__c = '1';
    obj.GT20R__c = '0';
    obj.GT21R__c = '1';
    obj.GT22R__c = '1';
    obj.GT23R__c = '1';

      obj.GT8RA0__c = true;
      obj.GT20RA0__c = true;

      obj.GT8RA1__c = true;
      obj.GT20RA1__c = true;

      obj.GT8RAU__c = true;

      updateBulkObj.add(obj);

    }

    update updateBulkObj;

  }
  


}