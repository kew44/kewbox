/****
*@description This test provides code coverage for DS_Background_Family_Info_B
*includes
*Trigger 
*Controllers:
    *DEMO, DOMENV, HEALTH, INSDOMENV, MILITARY, REFIMM, DS_Basic_Form
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_Background_Family_Info_B.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
*
*@modified    9/9/16    KW    custom report coverage
****/

@isTest (SeeAllData=false)
private class TestClass_DS_Background_Family_Info_B  {
        
    /****
    *@description Initialize reference to TestClass_A_Utility
    ****/
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    /****
    *@description Initialize reference to Utility
    ****/
    public static Utility ut = new Utility();
    
    public static ReportBuilder rb = new ReportBuilder();
    
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
        List<DS_Background_Family_Info_B__c> bulkObj = new List<DS_Background_Family_Info_B__c>();   
        
        ///begin bulk insert     
        for (Integer i=0;i<100;i++){
            //add record with required values
            bulkObj.add(new DS_Background_Family_Info_B__c(client__c = client.id, RREF__c= true, BMET__c = '1'));
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
        
        //summaryId     
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_DOMENV','0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        //init object w/ required variables
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c(client__c = client.id, 
                                                                                BMET__c = '1', 
                                                                                RWHITE__c = true, 
                                                                                BDEVCON__c = '1',
                                                                                RREF__c= true,
                                                                                BDVTR__c = '0', 
                                                                                BDVSR__c = '0' );
        
        //set forms' status on object
        obj.STATUS_DEMO__c = 'Complete';
        obj.STATUS_DOMENV__c = 'Complete';
        obj.STATUS_HEALTH__c = 'Complete';
        obj.STATUS_INSDOMENV__c = 'Complete';
        obj.STATUS_MILITARY__c = 'Complete';
        obj.STATUS_REFIMM__c = 'Complete';
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);   
        
        //controllers
        DS_DEMO_Controller DEMOcontroller = new DS_DEMO_Controller(sc);
        DS_DOMENV_Controller DOMENVcontroller = new DS_DOMENV_Controller(sc);
        DS_HEALTH_Controller HEALTHcontroller = new DS_HEALTH_Controller(sc);
        DS_INSDOMENV_Controller INSDOMENVcontroller = new DS_INSDOMENV_Controller(sc);
        DS_MILITARY_Controller MILITARYcontroller = new DS_MILITARY_Controller(sc);
        DS_REFIMM_Controller REFIMMcontroller = new DS_REFIMM_Controller(sc);
        
        //controller-specific list options   
        List<SelectOption> selectOptions = new List<SelectOption>();
        
        //Demo
        List<SelectOption> q4 = DEMOcontroller.getQ4Items();
        List<SelectOption> hisplat = DEMOcontroller.getHispLatItems();
        List<SelectOption> q14 = DEMOcontroller.getQ14Items();
        List<SelectOption> milself = DEMOcontroller.getMilSelfItems();
        List<SelectOption> milfam = DEMOcontroller.getMilFamItems();
        List<SelectOption> overall = DEMOcontroller.getOverAllItems();
        List<SelectOption> geniden = DEMOcontroller.getGenIdenItems();
        List<SelectOption> orient = DEMOcontroller.getOrientItems();
        
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
        
        //Refimm
        List<SelectOption> engwell= REFIMMcontroller.getEngWellItems();
        List<SelectOption> ctdect= REFIMMcontroller.getCTDECT();
        
        //save and cancel methods
        DEMOcontroller.save();
        DEMOcontroller.cancel();
        
        DOMENVcontroller.save();
        DOMENVcontroller.cancel();
        
        HEALTHcontroller.save();
        HEALTHcontroller.cancel();
        
        INSDOMENVcontroller.save();
        INSDOMENVcontroller.cancel();
        
        MILITARYcontroller.save();
        MILITARYcontroller.cancel();
        
        REFIMMcontroller.save();
        REFIMMcontroller.cancel();
        
        //init variable alias to be tested
        
        //Demo
        String CUREPI='0';
        Boolean BINFOTHR=TRUE;
        String BGUARD= '98';
        Boolean BREFSRO=TRUE;
        Boolean BTREATO=TRUE;
        String ETHNIC= '1';
        Boolean ETHNICHO=TRUE;
        String BUSBORN= '0';
        String BPUSBORN= '0';
        String BSIBLING= '1';
        Boolean BRHCO=TRUE;
        Boolean BPROTHNW=TRUE;
        
        //Domenv                
        String BLANGHOM= '1';
        Boolean BCHHOMECHECK=TRUE;
        String BLOTHRSP='null';

        //Insdomenv
        String BCINANY= '1';
        Boolean BCINOPUB=TRUE;
        String BCINOPSP= 'null';

        //Health
        String BTRTOTSP= 'null';
        String BHISWTLS= '2';
        Boolean BHSRHOS=TRUE;

        //Military
        String BMFMR2= '98';
        Boolean BSELFMIL=TRUE;
        String BMFMR2SP= 'null';

        //Refimm
        String BREFCAMP= '1';
        Boolean BPSTNONE=TRUE;
        String BCAMPMO= 'null';
        
        //Negative assert statements
        
        //DEMO
        System.assertNotEquals(obj.CUREPI__c,CUREPI,'This IS the first visit. ');
        System.assertNotEquals(obj.BINFOTHR__c,BINFOTHR,'Information NOT collected from other source. ');
        System.assertNotEquals(obj.BGUARD__c,BGUARD,'Standard legal guardian. ');
        System.assertNotEquals(obj.BREFSRO__c,BREFSRO,'Not referred by other means. ');
        System.assertNotEquals(obj.BTREATO__c,BTREATO,'Standard services intended. ');
        System.assertNotEquals(obj.ETHNIC__c,ETHNIC,'Child is NOT Hispanic. ');
        System.assertNotEquals(obj.ETHNICHO__c,ETHNICHO,'Standard Hispanic or Latino ethnic group. ');
        System.assertNotEquals(obj.BUSBORN__c,BUSBORN,'Child WAS born in the US. ');
        System.assertNotEquals(obj.BPUSBORN__c,BPUSBORN,'Parent WAS born in the US. ');
        System.assertNotEquals(obj.BSIBLING__c,BSIBLING,'NO sibling(s) in data set. ');
        System.assertNotEquals(obj.BRHCO__c,BRHCO,'Standard provider gives regular health care. ');
        System.assertNotEquals(obj.BPROTHNW__c,BPROTHNW,'Standard provider currently gives health care. ');
        
        //DOMENV
        System.assertNotEquals(obj.BLANGHOM__c,BLANGHOM,'English is NOT the primary language spoken at home. ');
        System.assertNotEquals(obj.BCHHOMECHECK__c,BCHHOMECHECK,'The total number of children is known. ');
        System.assertNotEquals(obj.BLOTHRSP__c,BLOTHRSP,'Other adult has been specified  as '+obj.BLOTHRSP__c+'. ');
        
        //INSDOMENV
        System.assertNotEquals(obj.BCINANY__c,BCINANY,'Child does NOT have insurance. ');
        System.assertNotEquals(obj.BCINOPUB__c,BCINOPUB,'Child has standard type of public insurance. ');
        System.assertNotEquals(obj.BCINOPSP__c,BCINOPSP,'Other public health insurance has been specified as '+obj.BCINOPSP__c+'. ');
        
        //HEALTH
        System.assertNotEquals(obj.BTRTOTSP__c,BTRTOTSP,'Other condition has been specified as '+obj.BTRTOTSP__c+'. ');
        System.assertNotEquals(obj.BHISWTLS__c,BHISWTLS,'Child does NOT have moderate weight loss/gain or thyroid problems. ');     
        System.assertNotEquals(obj.BHSRHOS__c,BHSRHOS,'Child has NOT been in the hospital. ');
        
        //MILITARY
        System.assertNotEquals(obj.BMFMR2__c,BMFMR2,'Standard relationship type identified. ');
        System.assertNotEquals(obj.BSELFMIL__c,BSELFMIL,'Relationship is NOT self. ');
        System.assertNotEquals(obj.BMFMR2SP__c,BMFMR2SP,'Other family menber has been specified as '+obj.BMFMR2SP__c+'. ');
        
        //REFIMM
        System.assertNotEquals(obj.BREFCAMP__c,BREFCAMP,'Child has NOT lived in refugee/detention camp. ');
        System.assertNotEquals(obj.BPSTNONE__c,BPSTNONE,'Parent HAS had refugee, asylee, ot immigrant status or status is unknown. ');
        System.assertNotEquals(obj.BCAMPMO__c,BCAMPMO,'Child has reported the number of months in detention/refugee camp as '+obj.BCAMPMO__c+'. ');
    }

}