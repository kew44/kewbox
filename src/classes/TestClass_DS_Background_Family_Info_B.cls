/*Page Description:
 *  Test class for DS_Background_Family_Info_B
 8/14/2014-change Baseline1 to DS_Background_Family_Info_B
 9/10-re-separated individual form methods for easier updating
 * Programmer:
 *  Kelsey
 */
@isTest
private class TestClass_DS_Background_Family_Info_B{
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////
  static TestMethod void Test_TestInsertUpdateDelete() {
    TestClass_Utility test_ut = new TestClass_Utility();
    Client__c client = test_ut.createClientSummary();
    ///begin bulk insert
    System.debug('Inserting 200 baseline records... (bulk validation)');   
    List<DS_Background_Family_Info_B__c> bulkObj = new List<DS_Background_Family_Info_B__c>();     
    for (Integer i=0;i<200;i++){
      bulkObj.add(new DS_Background_Family_Info_B__c(client__c = client.id, RREF__c= true, 
                                                     FORM__c='DS_DEMO', BMET__c = '1'));
    }
    insert bulkObj;
      ///end bulk insert   
  }
 /* static TestMethod void Test_samlpeAsserts(){

    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility();
    
//create test client 
    Client__c client = test_ut.createClientSummary();
String cimi= ut.urlEncode('c='+client.id);
ApexPages.currentPage().getParameters().put('cimi',cimi);

    DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
 
      obj.client__c = client.id;
    ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
 DS_DEMO_Controller demoController = new DS_DEMO_Controller(sc); //demoController
 DS_INSDOMENV_Controller indsevController = new DS_INSDOMENV_Controller(sc); //indsevController
 DS_DOMENV_Controller domenvController = new DS_DOMENV_Controller(sc); //domenvController
 DS_REFIMM_Controller refimmController = new DS_REFIMM_Controller(sc); //refimmController
 DS_MILITARY_Controller militaryController = new DS_MILITARY_Controller(sc); //militaryController
 DS_HEALTH_Controller healthController = new DS_HEALTH_Controller(sc); //healthController
  
 //variables
 //Demo
 //skipLogic determining values
    obj.RREF__c= true;
    String CUREPI='0'; 
    Boolean BINFOTHR=true;
    String BGUARD='98';
    Boolean BREFSRO=true;
    String ETHNIC='1';
    Boolean ETHNICHO=true; 
    String BUSBORN='0'; 
    String BPUSBORN='0'; 
    String BSIBLING='1'; 
    Boolean BTREATO=true;
    Boolean BPROTHNW=true; 
    String BTRT='1'; 
    Boolean BTRTOTHR=true; 
    String BHSR='1';
    String BDEVCON='1';
    Boolean BDEVOTHR=true; 
    String BDVTR='1';
    Boolean BDVTROTR=true; 
    String BDVSR='1'; 
    Boolean BRHCO=true; 
 //Insdomenv
 String BCINANY = '1';
Boolean BCINOPUB = true;
String BCINOPSP= 'null'; 
//Domenv
String BLANGHOM = '1';
Boolean BCHHOMECHECK= true;
String BLOTHRSP= 'null'; 
   //Refimm 
String BREFCAMP= '1';
Boolean BPSTNONE  = true;
String BCAMPMO= 'null';    
   //Military
String BMFMR2= '98';
Boolean BSELFMIL= true;
String BMFMR2SP='null';
   //Health
//String BTRT= '1';
//Boolean BTRTOTHR= true;
String BTRTOTSP= 'null'; 

  obj.FORM__c = 'DS_DEMO';
  obj.BMET__c = '1';


 
 insert obj;
 
 //asserts
 //Demo     
    //assert not equals. if test object value does not equal the test condition variable, skiplogic is not triggered, opposite message displayed
    System.assertNotEquals(obj.CUREPI__c, CUREPI, 'This is the first visit.');//3
    System.assertNotEquals(obj.BINFOTHR__c,BINFOTHR,'Information NOT collected from other source.');//4
    System.assertNotEquals(obj.BGUARD__c,BGUARD ,'Standard legal guardian.');//5
    System.assertNotEquals(obj.BREFSRO__c,BREFSRO ,'Not referred by other means.');//6
    System.assertNotEquals(obj.BTREATO__c,BTREATO ,'Standard services intended');//7
    System.assertNotEquals(obj.ETHNIC__c,ETHNIC ,'Child is not Hispanic');//1
    System.assertNotEquals(obj.ETHNICHO__c,ETHNICHO  ,'Standard Hispanic or Latino ethnic group.');//1a
    System.assertNotEquals(obj.BUSBORN__c,BUSBORN  ,'Born in the US');//3
    System.assertNotEquals(obj.BPUSBORN__c,BPUSBORN ,'Parent born in the US');//4
    System.assertNotEquals(obj.BSIBLING__c,BSIBLING  ,'No siblings in data set');//5
    System.assertNotEquals(obj.BRHCO__c,BRHCO  ,'Standard regular health provider');//11
    System.assertNotEquals(obj.BPROTHNW__c,BPROTHNW ,'Standard current healthcare provider');//12

 //Insdomenv
 System.assertNotEquals(obj.BCINANY__c, BCINANY, 'Child NOT currently covered by any type of public or private health insurance .'); 
System.assertNotEquals(obj.BCINOPUB__c, BCINOPUB, 'Child NOT currently covered by other type of public health insurance.'); 
System.assertNotEquals(obj.BCINOPSP__c, BCINOPSP, 'Child covered by '+obj.BCINOPSP__c +'public health insurance.');
//Domenv
 System.assertNotEquals(obj.BLANGHOM__c,BLANGHOM,'Language at home is NOT English.');
  System.assertNotEquals(obj.BCHHOMECHECK__c,BCHHOMECHECK,'Total number of children is known.');
   System.assertNotEquals(obj.BLOTHRSP__c,BLOTHRSP,'Other adult is specified as '+obj.BLOTHRSP__c+'.');
   //Refimm   
 System.assertNotEquals(obj.BREFCAMP__c,BREFCAMP,'Child has NOT lived in refugee/detention camp.');
 System.assertNotEquals(obj.BPSTNONE__c,BPSTNONE,'Child has had Refugee, Asylee, or Immigrant status, or status is unknown.');
 System.assertNotEquals(obj.BCAMPMO__c,BCAMPMO,'Child lived '+obj.BCAMPMO__c+' months in a detention/refugee camp.');
   //Military
 System.assertNotEquals(obj.BMFMR2__c,BMFMR2,'NOT other family member.');
 System.assertNotEquals(obj.BSELFMIL__c,BSELFMIL,'Child is NOT in the military.');
 System.assertNotEquals(obj.BMFMR2SP__c,BMFMR2SP,'Other family member is specified as '+obj.BMFMR2SP__c+'.');
   //Health
// System.assertNotEquals(obj.BTRT__c,BTRT,'Child does NOT have current course of treatment.');
 //System.assertNotEquals(obj.BTRTOTHR__c,BTRTOTHR,'Other condition NOT selected.');
 System.assertNotEquals(obj.BTRTOTSP__c,BTRTOTSP,'Condition is specified as '+obj.BTRTOTSP__c+'.');

 

    demoController.save();
   demoController.cancel();
   
    indsevController.save();
   indsevController.cancel();
   
    domenvController.save();
   domenvController.cancel();
   
    refimmController.save();
   refimmController.cancel();
   
    militaryController.save();
   militaryController.cancel();
   
    healthController.save();
   healthController.cancel();
 
 
}*/
}