/*Page Description:
 *  Test class for DS_Functioning_Forms_B
 *
 * Last Updated on:
 * 7/23/2014
 * Update Purpose:
 * condense all BASELINE2 tests 
 * restructuring
 * batch testing
 * compatibility
 9/10-re-separated individual form methods for easier updating
 * Programmer:
 *  Kelsey
 */
@isTest
private class TestClass_DS_Functioning_Forms_B{
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////   

  static TestMethod void Test_TestInsertUpdateDelete() {
    TestClass_Utility test_ut = new TestClass_Utility();
    Client__c client = test_ut.createClientSummary();
    ///begin bulk insert
    List<DS_Functioning_Forms_B__c> bulkObj = new List<DS_Functioning_Forms_B__c>();     
    for (Integer i=0;i<200;i++){
      bulkObj.add(new DS_Functioning_Forms_B__c(client__c = client.id));
    }
    insert bulkObj;
      ///end bulk insert   
  }
    
static TestMethod void Test_samlpeAsserts(){

    Utility ut = new Utility();
    TestClass_Utility test_ut = new TestClass_Utility();
    
//create test client 
    Client__c client = test_ut.createClientSummary();
String cimi= ut.urlEncode('c='+client.id);
ApexPages.currentPage().getParameters().put('cimi',cimi);

    DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c();
 
      obj.client__c = client.id;
    ApexPages.StandardController sc = new ApexPages.StandardController(obj);
    
    //    controllers
 //DS_SERVREC_Controller servrecController = new DS_SERVREC_Controller(sc);
// DS_CANSTR_Controller canstrController = new DS_CANSTR_Controller(sc); 
 //DS_YCINDSEV_Controller ycindsevController = new DS_YCINDSEV_Controller(sc);
// DS_INDSEV_Controller indsevController = new DS_INDSEV_Controller(sc);
// DS_NOMS_Controller nomsController = new DS_NOMS_Controller(sc);
 DS_FAPGAR_Controller fapgarController = new DS_FAPGAR_Controller(sc);
// DS_BIS_Controller bisController = new DS_BIS_Controller(sc);
// DS_BSLC_Controller bslcController = new DS_BSLC_Controller(sc);
// DS_CLINEVAL_Controller clinevalController = new DS_CLINEVAL_Controller(sc);
 
 //variables
 
        obj.BFAPGAR1__c='99';
        obj.BFAPGAR2__c='99';
        obj.BFAPGAR3__c='99';
        obj.BFAPGAR4__c='99';
        obj.BFAPGAR5__c='99';
       // obj.BFAPGAR_MET = 'Not Met';
 
/*String BOSMEN='99';
Boolean BLTCOGB = true;
String BOSOSP= 'null'; 
 
String BSTFAM='1';
String BSTINTP='0';
String BSTEDU='2';
String BSTVOC='97';
String BSTCOPE='3';
String BSTOPT='3';
String BSTSPIR='3';
String BSTCOM='3';
String BSTRELT='2';
String BSTRESC='3';
 
String BIMRISK='0';
Boolean BDMICOG = true;
 
String BISPACAD='0';
String BSUITALK = '0';//
String BISPCRSP= 'null'; 
 
String BNDAILYL='1';
String BNADMINOSP= 'null'; 


String BCBISRECV = '1';//
Date BCBISTCDT=system.today();
Boolean BCBISOTHE=true;
String BCBISOTHS= 'null'; 
 
String BNCCTSBSLC='1';//
Date BTXSTDT=system.today();
String BTXCOMP = '1';//
String BTXTYPSP= 'null'; 

String BCEPRIM='2';
String BCEOTHY = '1';
String BCEOTHER= 'null'; */
 
 insert obj;
 
 //asserts
/*  System.assertNotEquals(obj.BOSMEN__c,BOSMEN , 'It is known if the child has recieved mentor services or not within the last 30 days.'); 
  System.assertNotEquals(obj.BLTCOGB__c,BLTCOGB , 'Child has NOT recieved cognitive behavioral therapy in lifetime.');
  System.assertNotEquals(obj.BOSOSP__c,BOSOSP , 'Other service is specified as'+obj.BOSOSP__c+'.');
  
  System.assertNotEquals(obj.BSTFAM__c, BSTFAM, 'Child is NOT considered to have moderate level of family strengths.');
  System.assertNotEquals(obj.BSTINTP__c,BSTINTP , 'Child does NOT have significant interpersonal strengths.');
  System.assertNotEquals(obj.BSTEDU__c, BSTEDU, 'School plan (if any) seems to be effective.');
  System.assertNotEquals(obj.BSTVOC__c, BSTVOC, 'The child is at least 14 and this item is applicable.');
  System.assertNotEquals(obj.BSTCOPE__c,BSTCOPE , 'Child has known or identifiable psychological strengths.');
  System.assertNotEquals(obj.BSTOPT__c, BSTOPT, 'Child has known talents, interests, or hobbies.');
  System.assertNotEquals(obj.BSTSPIR__c,BSTSPIR , 'Child is involded in spiritual or religious involvement.');
  System.assertNotEquals(obj.BSTCOM__c, BSTCOM, 'Child has community ties and/or support.');
  System.assertNotEquals(obj.BSTRELT__c,BSTRELT , 'Child has had more than one stable relationship in lifetime.');
  System.assertNotEquals(obj.BSTRESC__c,BSTRESC , 'Child recognizes strengths.');
  
  System.assertNotEquals(obj.BIMRISK__c,BIMRISK , 'Child has self-injurous behaviors.');
  System.assertNotEquals(obj.BDMICOG__c, BDMICOG, 'Cognitive development does NOT need further consideration.');

  System.assertNotEquals(obj.BISPACAD__c,BISPACAD , 'Child has academic problems.');
  System.assertNotEquals(obj.BSUITALK__c,BSUITALK , 'Child has NOT talked about suicide.');
  System.assertNotEquals(obj.BISPCRSP__c,BISPCRSP , 'Child has been arrested '+obj.BISPCRSP__c+' time(s) in the past 30 days');

  System.assertNotEquals(obj.BNDAILYL__c, BNDAILYL, 'I [my child] do[es] NOT strongly disagree that the child is handling dsily life.');
  System.assertNotEquals(obj.BNADMINOSP__c,BNADMINOSP , 'Form was administered by '+obj.BNADMINOSP__c+'.');
  
  
  System.assertNotEquals(obj.BCBISRECV__c, BCBISRECV, 'Child/family is NOT receiving brief intervention services.');
  System.assertNotEquals(obj.BCBISOTHS__c, BCBISOTHS, 'Other treatment component specified as '+obj.BCBISOTHS__c+'.');
  
  System.assertNotEquals(obj.BNCCTSBSLC__c,BNCCTSBSLC , 'Breakthrough series or learning collaborative NOT led by the UCLA-Duke University National Center for Child Traumatic Stress');
  System.assertNotEquals(obj.BTXCOMP__c, BTXCOMP, 'Treatment was NOT completed.');
  System.assertNotEquals(obj.BTXTYPSP__c, BTXTYPSP, 'Other treatment specified as '+obj.BTXTYPSP__c+'.');
  
  System.assertNotEquals(obj.BCEPRIM__c, BCEPRIM, 'The primary problem is NOT Bipolar Disorder.');
  System.assertNotEquals(obj.BCEOTHY__c, BCEOTHY, 'No additional problems.');
  System.assertNotEquals(obj.BCEOTHER__c, BCEOTHER , 'Other problem identified as '+obj.BCEOTHER__c+'.');*/
  
 //save/cancels
 /*   servrecController.save();
   servrecController.cancel();
   
   canstrController.save();
   canstrController.cancel();
   
   ycindsevController.save();
   ycindsevController.cancel();
   
   indsevController.save();
   indsevController.cancel();
   
   nomsController.save();
   nomsController.cancel();*/
   
   fapgarController.save();
   fapgarController.cancel();
   
  /* bisController.save();
   bisController.cancel();
   
   bslcController.save();
   bslcController.cancel();
   
   clinevalController.save();
   clinevalController.cancel();*/
 }
}