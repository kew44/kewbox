/****
*@description This test provides code coverage for DS_Background_Family_Info_F
*includes
*Trigger 
*Controllers:
    *DOMENV, FOLLOWUPINFO, HEALTH, INSDOMENV, MILITARY, NCTSNTREAT, DS_Basic_Form
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_Background_Family_Info_F.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
private class TestClass_DS_Background_Family_Info_F  {
    
    /****
    *@description Initialize reference to TestClass_A_Utility
    ****/
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    /****
    *@description Initialize reference to Utility
    ****/
    public static Utility ut = new Utility();
    
    /****
    *@description Load required data from TestClassData
    ****/
    @testSetup 
    static void setup() {
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();   
        importData.variable();   
    }
    
    /****
    *@description method to test a bulk creation of object
    ****/
    static TestMethod void bulkifyObj(){
            
        //init client
        Client__c client = test_ut.createClientSummary();
         
        //init list of object
        List<DS_Background_Family_Info_F__c> bulkObj = new List<DS_Background_Family_Info_F__c>(); 
        
        ///begin bulk insert     
        for (Integer i=0;i<100;i++){
            //add record with required values
            bulkObj.add(new DS_Background_Family_Info_F__c(client__c = client.id, FMET__c = '1'));
        }
        
        //add list of records to object
        insert bulkObj;     
    }
    
    /****
    *@description method to test controllers associated with object
    *assert methods represent data types from each controller 
    *some variables asserted may represent required values for certain logic
    ****/
    static TestMethod void assertControllers(){
        
        //create test client 
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        //summaryId
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_FOLLOWUPINFO', section);
        
        //encoded parameters
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        //init object w/ required variables
        DS_Background_Family_Info_F__c obj = new DS_Background_Family_Info_F__c(client__c = client.id, 
                                                                                FUTYPE__c = '1', 
                                                                                FHOVERALL__c = '1',
                                                                                FUTIME__c = '6');
                                        
        //set forms' status on object
        obj.STATUS_DOMENV__c = 'Complete';
        obj.STATUS_FOLLOWUPINFO__c = 'Complete';
        obj.STATUS_HEALTH__c = 'Complete';
        obj.STATUS_INSDOMENV__c = 'Complete';
        obj.STATUS_MILITARY__c = 'Complete';
        obj.STATUS_NCTSNTREAT__c = 'Complete';
                       
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);   
        
        //controllers
        DS_DOMENV_Controller DOMENVcontroller = new DS_DOMENV_Controller(sc);
        DS_FOLLOWUPINFO_Controller FOLLOWUPINFOcontroller = new DS_FOLLOWUPINFO_Controller(sc);
        DS_HEALTH_Controller HEALTHcontroller = new DS_HEALTH_Controller(sc);
        DS_INSDOMENV_Controller INSDOMENVcontroller = new DS_INSDOMENV_Controller(sc);
        DS_MILITARY_Controller MILITARYcontroller = new DS_MILITARY_Controller(sc);
        DS_NCTSNTREAT_Controller NCTSNTREATcontroller = new DS_NCTSNTREAT_Controller(sc);
                
        //controller-specific list options          
        List<SelectOption> selectOptions = new List<SelectOption>();
        
        //Domenv        
        List<SelectOption> primerest = DOMENVcontroller.getPrimeRestIems();
        List<SelectOption> howlong = DOMENVcontroller.getHowLongIems();
        List<SelectOption> outplace = DOMENVcontroller.getOutPlaceIems();
        List<SelectOption> livemost = DOMENVcontroller.getLiveMostItems();
        List<SelectOption> ctyrefuse = DOMENVcontroller.getCTYREFUSEItems();
        List<SelectOption> lang = DOMENVcontroller.getLangItems();
        List<SelectOption> income = DOMENVcontroller.getIncomeItems();
        List<SelectOption> famres = DOMENVcontroller.getFamResItems();
        List<SelectOption> caregive = DOMENVcontroller.getCareGiveItems();
        List<SelectOption> grade = DOMENVcontroller.getGradeItems();
        List<SelectOption> absent = DOMENVcontroller.getAbsentItems();
        
        //FollowUpInfo 
        List<SelectOption> typeoption = FOLLOWUPINFOcontroller.getTypeOption();
        List<SelectOption> timeoption = FOLLOWUPINFOcontroller.getTimeOption();
        List<SelectOption> statusoption = FOLLOWUPINFOcontroller.getStatusOption();
        List<SelectOption> guardianoption = FOLLOWUPINFOcontroller.getGuardianOption();
        List<SelectOption> healthoption = FOLLOWUPINFOcontroller.getHealthOption();       
        
        //Military 
        List<SelectOption> move = MILITARYcontroller.getMoveItems();
        List<SelectOption> serve = MILITARYcontroller.getServeItems();
        List<SelectOption> diff = MILITARYcontroller.getIsDiffItems();
        List<SelectOption> relation = MILITARYcontroller.getRelationItems();
        List<SelectOption> branch1 = MILITARYcontroller.getBranch1Items();
        List<SelectOption> branch2 = MILITARYcontroller.getBranch2Items();
        List<SelectOption> status = MILITARYcontroller.getStatusItems();
        List<SelectOption> wartime = MILITARYcontroller.getWartimeItems();
        List<SelectOption> deploy = MILITARYcontroller.getDeployItems();
        List<SelectOption> deployall = MILITARYcontroller.getDeployAllItems();      
        
        //NctsnTreat        
        List<SelectOption> q5 = NCTSNTREATcontroller.getTXMODPRIOption();
        List<SelectOption> q7 = NCTSNTREATcontroller.getTXPRISIPOption();
        List<SelectOption> q10 = NCTSNTREATcontroller.getTXLEADCLOption();       
        
        //save and cancel methods
       /* some controllers are omitted to prevent SOql limit exception*/
        
        NCTSNTREATcontroller.save();
        NCTSNTREATcontroller.cancel();
        
        //init variable alias to be tested
        
        //FollowUpInfo
        Date FDOV=system.today();
        String FMET= '1';
        String FUTIME= '6';
        String FINFOSP= 'null';
        Boolean FZIPCODECHECK=TRUE;

        //Domenv
        String FLANGHOM= '1';
        Boolean FCHHOMECHECK=TRUE;
        String FLOTHRSP= 'null';

        //Insdomenv
        String FCINANY= '1';
        Boolean FCINOPUB=TRUE;
        String FCINOPSP= 'null';

        //Health
        String FTRTOTSP= 'null';
        String FHISWTLS= '2';
        Boolean FHSRHOS=TRUE;

        //Military
        String FMFMR2= '98';
        Boolean FSELFMIL=TRUE;
        String FMFMR2SP= 'null';

        //Nctsntreat
        String FTXRES= '0';
        Boolean FTXITC=TRUE;
        String FTXITCVIS= 'null';
        String FTXMODPRI= '14';
        String FTXLEADCL= '7';
        
        //Negative assert statements
            
        //DOMENV
        System.assertNotEquals(obj.FLANGHOM__c,FLANGHOM,'English is NOT the primary language spoken at home. ');
        System.assertNotEquals(obj.FCHHOMECHECK__c,FCHHOMECHECK,'The total number of children is known. ');
        System.assertNotEquals(obj.FLOTHRSP__c,FLOTHRSP,'Other adult has been specified  as '+obj.FLOTHRSP__c+'. ');
        
        //FOLLOWUPINFO
        System.assertNotEquals(obj.FDOV__c,FDOV,'Care did NOT begin today. Began on '+obj.FDOV__c+'. ');
        System.assertNotEquals(obj.FMET__c,FMET,'Form was NOT administered electronically. ');
        System.assertEquals(obj.FUTIME__c,FUTIME,'This is an 18-month visit. ');
        System.assertNotEquals(obj.FINFOSP__c,FINFOSP,'Other legal guardian has been specified  as '+obj.FINFOSP__c+'. ');
        System.assertNotEquals(obj.FZIPCODECHECK__c,FZIPCODECHECK,'Zip code is known. ');
        
        //HEALTH
        System.assertNotEquals(obj.FTRTOTSP__c,FTRTOTSP,'Other condition has been specified as '+obj.FTRTOTSP__c+'. ');
        System.assertNotEquals(obj.FHISWTLS__c,FHISWTLS,'Child does NOT have moderate weight loss/gain or thyroid problems. ');     
        System.assertNotEquals(obj.FHSRHOS__c,FHSRHOS,'Child has NOT been in the hospital. ');
        
        //INSDOMENV
        System.assertNotEquals(obj.FCINANY__c,FCINANY,'Child does NOT have insurance. ');
        System.assertNotEquals(obj.FCINOPUB__c,FCINOPUB,'Child has standard type of public insurance. ');
        System.assertNotEquals(obj.FCINOPSP__c,FCINOPSP,'Other public health insurance has been specified as '+obj.FCINOPSP__c+'. ');
        
        //MILITARY
        System.assertNotEquals(obj.FMFMR2__c,FMFMR2,'Standard relationship type identified. ');
        System.assertNotEquals(obj.FSELFMIL__c,FSELFMIL,'Relationship is NOT self. ');
        System.assertNotEquals(obj.FMFMR2SP__c,FMFMR2SP,'Other family menber has been specified as '+obj.FMFMR2SP__c+'. ');
        
        //NCTSNTREAT
        System.assertNotEquals(obj.FTXRES__c,FTXRES,'Child HAS received inpatient treatment. ');
        System.assertNotEquals(obj.FTXITC__c,FTXITC,'Child has NOT recieded individual therapy. ');
        System.assertNotEquals(obj.FTXITCVIS__c,FTXITCVIS,'Number of individual therapy treatments has been specified as '+obj.FTXITCVIS__c+'. ');
        System.assertNotEquals(obj.FTXMODPRI__c,FTXMODPRI,'Primary modality of treatment is NOT play therapy. ');
        System.assertNotEquals(obj.FTXLEADCL__c,FTXLEADCL,'Primary provider is NOT Psychiatrist level. ');
    }

}