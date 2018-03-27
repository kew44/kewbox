/****
*@description This test provides code coverage for DS_Functioning_Forms_B
*includes
*Trigger 
*Controllers:
    *BIS, BSLC, CANSTR, CLINEVAL, FAPGAR, INDSEV, NOMS, SERVREC, YCINDSEV, DS_Basic_Form
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_Functioning_Forms_B.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
private class TestClass_DS_Functioning_Forms_B  {
    
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
        List<DS_Functioning_Forms_B__c> bulkObj = new List<DS_Functioning_Forms_B__c>();     
    
        ///begin bulk insert     
        for (Integer i=0;i<100;i++){
            //add record with required values
            bulkObj.add(new DS_Functioning_Forms_B__c(client__c = client.id));
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
        
        //init variable alias for FAPGAR only
        Integer blankCount;                
        String BFAPGAR1='0';
        String BFAPGAR2='1';
        String BFAPGAR3='2';
        String BFAPGAR4='99';
        String BFAPGAR5='99';
        String BFAPGAR_MET = 'Not Met';
        Integer BFAPGAR_RAW = 3;  
        
        //create test client 
        Client__c client = test_ut.createClient();
        
        //summaryId     
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_NOMS','0');
        
        //encoded parameters
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);     
        
        //init object w/ required variables
        DS_Functioning_Forms_B__c obj = new DS_Functioning_Forms_B__c(client__c = client.id, 
                                                                      BISPSUIC__c = '1', 
                                                                      BISPCRIM__c = '2', 
                                                                      BTXCOMPL__c= '1');
        
        //call to FAPGAR Scoring class
        DS_FAPGAR_Scoring FAPGARScore = new DS_FAPGAR_Scoring();
                
        //set forms' status on object
        obj.STATUS_BIS__c = 'Complete';
        obj.STATUS_BSLC__c = 'Complete';
        obj.STATUS_CANSTR__c = 'Complete';
        obj.STATUS_CLINEVAL__c = 'Complete';
        obj.STATUS_FAPGAR__c = 'Complete';
        obj.STATUS_INDSEV__c = 'Complete';
        obj.STATUS_NOMS__c = 'Complete';
        obj.STATUS_SERVREC__c = 'Complete';
        obj.STATUS_YCINDSEV__c = 'Complete';        
        
        //assign FAPGAR score values
        obj.BFAPGAR1__c = BFAPGAR1;
        obj.BFAPGAR2__c = BFAPGAR2;
        obj.BFAPGAR3__c = BFAPGAR3;
        obj.BFAPGAR4__c = BFAPGAR4;
        obj.BFAPGAR5__c = BFAPGAR5;
        obj.BFAPGAR_MET__c = BFAPGAR_MET;
        obj.BFAPGAR_RAW__c = BFAPGAR_RAW;
    
        //insert & update object
        insert obj;
        update obj;
        
        //record of FAPGAR Raw and met scores
        DS_Functioning_Forms_B__c checkObj = [SELECT BFAPGAR_MET__c, BFAPGAR_RAW__c FROM DS_Functioning_Forms_B__c WHERE id =: obj.id];
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);   
        
        //controllers
        DS_BIS_Controller BIScontroller = new DS_BIS_Controller(sc);
        DS_BSLC_Controller BSLCcontroller = new DS_BSLC_Controller(sc);
        DS_CANSTR_Controller CANSTRcontroller = new DS_CANSTR_Controller(sc);
        DS_CLINEVAL_Controller CLINEVALcontroller = new DS_CLINEVAL_Controller(sc);
        DS_FAPGAR_Controller FAPGARcontroller = new DS_FAPGAR_Controller(sc);
        DS_INDSEV_Controller INDSEVcontroller = new DS_INDSEV_Controller(sc);
        DS_NOMS_Controller NOMScontroller = new DS_NOMS_Controller(sc);
        DS_SERVREC_Controller SERVRECcontroller = new DS_SERVREC_Controller(sc);
        DS_YCINDSEV_Controller YCINDSEVcontroller = new DS_YCINDSEV_Controller(sc);
                
        //blank warning for FAPGAR
        String warning = 'There are blanks.';   
        ApexPages.message message = new ApexPages.message(ApexPages.severity.WARNING, warning);
        blankCount = 0; 
        Boolean showWarning;                    
        Boolean warned = FAPGARcontroller.showWarningMessageForBlank(blankCount, warning);
        Integer cba = test_ut.countBlankAnwer(blankCount);
        
        //list options 
        
        //standard options to improve coverage of DS_Basic_Form
        List<SelectOption> option = new List<SelectOption>();
        option = FAPGARcontroller.getNYOptionWithBlank();
        option = FAPGARcontroller.getNYOption();
        option = FAPGARcontroller.getNYUOptionWithBlank();
        option = FAPGARcontroller.getNYUOption();
        option = FAPGARcontroller.getBMETOption();
        
        //BIS
        List<SelectOption> YNC = BIScontroller.getYNCompletedIems(); 
        
        //BSLC
        List<SelectOption> treat = BSLCcontroller.getTreatIems();
        List<SelectOption> YNCbslc = BSLCcontroller.getYNCompletedIems();
        
        //CANSTR
        List<SelectOption> fam = CANSTRcontroller.getStrongFamItems();
        List<SelectOption> intc = CANSTRcontroller.getStrongIntItems();
        List<SelectOption> edu = CANSTRcontroller.getStrongEduItems();
        List<SelectOption> voc = CANSTRcontroller.getStrongVocItems();
        List<SelectOption> cope = CANSTRcontroller.getStrongCopeItems();
        List<SelectOption> opt = CANSTRcontroller.getStrongOptItems();
        List<SelectOption> talent = CANSTRcontroller.getStrongTalentItems();
        List<SelectOption> spirit = CANSTRcontroller.getStrongSpiritItems();
        List<SelectOption> com = CANSTRcontroller.getStrongComItems();
        List<SelectOption> relate = CANSTRcontroller.getStrongRelateItems();
        List<SelectOption> res = CANSTRcontroller.getStrongResItems();
        
        //CLINEVAL      
        List<SelectOption> primaryprob = CLINEVALcontroller.getPrimaryProbIems();
        
        //FAPGAR
        List<SelectOption> nsvuf = FAPGARcontroller.getNSVUItems();
        
        //INDSEV        
        List<SelectOption> nsvui = INDSEVcontroller.getNSVUItems();
        List<SelectOption> refunk = INDSEVcontroller.getRefUnkItems();
        
        //NOMS
        List<SelectOption> admin = NOMScontroller.getAdminItems();
        
        //YCINDSEV
        List<SelectOption> nsvuy = YCINDSEVcontroller.getNSVUItems();
        List<SelectOption> nyu = YCINDSEVcontroller.getNYUItems();
        List<SelectOption> feed = YCINDSEVcontroller.getFeedItems();
        List<SelectOption> sleep = YCINDSEVcontroller.getSleepItems();
        List<SelectOption> play = YCINDSEVcontroller.getPlayItems();
        List<SelectOption> precare = YCINDSEVcontroller.getPreCareItems();
        List<SelectOption> social = YCINDSEVcontroller.getSocialItems();
        List<SelectOption> aggressive = YCINDSEVcontroller.getAggressiveItems();
        List<SelectOption> sexualized = YCINDSEVcontroller.getSexualizedItems();
        List<SelectOption> attachment = YCINDSEVcontroller.getAttachmentItems();
        List<SelectOption> atypical = YCINDSEVcontroller.getAtypicalItems();
        List<SelectOption> dev = YCINDSEVcontroller.getDevItems();
        
        //save/cancel
       /* some controllers are omitted to prevent SOql limit exception*/
                
        FAPGARcontroller.save();
        FAPGARcontroller.countBlankAnswer();
        
        //init variable alias to be tested  
        
        //BIS
        String BCBISRECV='1';
        Boolean BCBISOTHE=TRUE;
        Boolean BCBISCREE=TRUE;
        Boolean BCBISPSYE=FALSE;
        String BCBISOTHS='null';
        Date BCBISTCDT=system.today();
        String BCBISCOMP='1';
        Date BCBISCODT=system.today();
        
        //BSLC
        String BBSLCTREATMENT='1';
        String BNCCTSBSLC='1';
        String BTXTYPE= '98';
        String BTXTYPSP='null';
        Date BTXSTDT=system.today();
        String BTXCOMPL= '1';
        Date BTXLFTDT=system.today();
        
        //Canstr
        String BSTFAM= '1';
        String BSTINTP= '0';
        String BSTEDU= '2';
        String BSTVOC= '97';
        String BSTCOPE= '3';
        String BSTOPT= '3';
        String BSTTAL= '0';
        String BSTSPIR= '3';
        String BSTCOM= '3';
        String BSTRELT= '2';
        
        //Clineval
        String BCEBIPL= '2';
        String BCEOCD= '1';
        String BCEEXPL= '0';
        String BCEOTHY= '1';
        String BCEOTHER='null';
        String BCEPRIM= '2';
        
        //FAPGAR
       /* initialized above  */
        
        //NOMS
        String BNDAILYL= '1';
        String BNRESTLESS= '2';
        String BNHALLUCIN= '3';
        String BNSOTHER= '4';
        String BNSOTHERSP='null';
        String BNSCENJOY= '5';
        
        //Indsev
        String BOSDET= '0';
        String BLTGROUP= '1';
        String BTRTXFOS= '99';
        Boolean BOSMEN=FALSE;
        Boolean BOSCOGB=TRUE;
        Boolean BLTTOTH=TRUE;
        String BOSTOSP ='null';        
        String BISPACAD= '0';
        String BSUITALK= '0';
        String BISPCRSP='null';
        
        //Ycindsev
        String BIMRISK= '0';
        String BFEEDING= '2';
        String BPRESCH= '99';
        String BDEVEL= '1';
        Boolean BDMICOG=TRUE;
 
        //Negative assert statements
        
        //BIS
        System.assertNotEquals(obj.BCBISRECV__c,BCBISRECV,'Child/family is NOT receiving brief intervention services. ');
        System.assertNotEquals(obj.BCBISOTHE__c,BCBISOTHE,'Component(s) received are part of the standard list. ');
        System.assertNotEquals(obj.BCBISCREE__c,BCBISCREE,'Screening Component is NOT received. ');
        System.assertNotEquals(obj.BCBISOTHS__c,BCBISOTHS,'Other component has been specified as '+obj.BCBISOTHS__c+'. ');
        System.assertNotEquals(obj.BCBISCODT__c,BCBISCODT,'Treatment did NOT complete today. Completed on '+obj.BCBISCODT__c+'. ');
        
        //BSLC
        System.assertNotEquals(obj.BBSLCTREATMENT__c,BBSLCTREATMENT,'Child/family is NOT receiving treatment through a breakthrough series or learning collaborative. ');
        System.assertNotEquals(obj.BNCCTSBSLC__c,BNCCTSBSLC,'Breakthrough series/Learning collaborative series is NOT led by the UCLA-Duke NCCTS. ');
        System.assertNotEquals(obj.BTXTYPE__c,BTXTYPE,'Treatment received IS part of the standard list. ');
        System.assertNotEquals(obj.BTXTYPSP__c,BTXTYPSP,'Other treatment has been specified as '+obj.BTXTYPSP__c+'. ');
        System.assertNotEquals(obj.BTXSTDT__c,BTXSTDT,'Treatment did NOT begin today. Began on '+obj.BTXSTDT__c+'. ');
        System.assertNotEquals(obj.BTXLFTDT__c,BTXLFTDT,'Treatment did NOT terminate without completion today. Left treatment on '+obj.BTXLFTDT__c+'. ');
        
        //CANSTR
        System.assertNotEquals(obj.BSTFAM__c,BSTFAM,'Child is NOT considered to have a moderate level of family strength. ');
        System.assertNotEquals(obj.BSTINTP__c,BSTINTP,'Child does NOT have significant interpersonal strength. ');
        System.assertNotEquals(obj.BSTEDU__c,BSTEDU,'Educational strength has NOT been identified. ');
        System.assertNotEquals(obj.BSTVOC__c,BSTVOC,'The child is at least 14 and this item IS applicable. ');
        System.assertNotEquals(obj.BSTCOPE__c,BSTCOPE,'Coping/savoring strength HAS been identified. ');
        System.assertNotEquals(obj.BSTOPT__c,BSTOPT,'Optimism strength HAS been identified. ');
        System.assertNotEquals(obj.BSTTAL__c,BSTTAL,'Talents/Interests strength is NOT well-developed. ');
        System.assertNotEquals(obj.BSTSPIR__c,BSTSPIR,'Spiritual strength HAS been identified. ');
        System.assertNotEquals(obj.BSTCOM__c,BSTCOM,'Community strength has NOT been identified. ');
        System.assertNotEquals(obj.BSTRELT__c,BSTRELT,'Relationship permanence strength has NOT been identified. ');
        
        //CLINEVAL
        System.assertNotEquals(obj.BCEBIPL__c,BCEBIPL,'Child does NOT have a definate indication of Bipolar disorder. ');
        System.assertNotEquals(obj.BCEOCD__c,BCEOCD,'It is not probable that the child has OCD. ');
        System.assertNotEquals(obj.BCEEXPL__c,BCEEXPL,'Child HAS Intermittent Explosive Disorder. ');
        System.assertNotEquals(obj.BCEOTHY__c,BCEOTHY,'NO additional problems/symptoms. ');
        System.assertNotEquals(obj.BCEOTHER__c,BCEOTHER,'Other problem/symptom specified as '+obj.BCEOTHER__c+'. ');
        System.assertNotEquals(obj.BCEPRIM__c,BCEPRIM,'Primary problem is NOT Bipolar disorder. ');
        
        //FAPGAR *using positive asserts
        System.assertEquals(obj.BFAPGAR1__c,BFAPGAR1,'My family hardly ever helps me. ');
        System.assertEquals(obj.BFAPGAR2__c,BFAPGAR2,'I am sometimes satisfied with how my family discussed common interests. ');
        System.assertEquals(obj.BFAPGAR3__c,BFAPGAR3,'My family almost always accept my wishes or choices. ');
        System.assertEquals(obj.BFAPGAR4__c,BFAPGAR4,'I do not know my satisfaction level of the way my family expresses affection. ');
        System.assertEquals(obj.BFAPGAR5__c,BFAPGAR5,'I do not know my satisfaction level in the amount of time my family spends together. ');
        
        //INDSEV
        System.assertNotEquals(obj.BISPACAD__c,BISPACAD,'Child HAS academic problems. ');
        System.assertNotEquals(obj.BSUITALK__c,BSUITALK,'Child has NOT talked about suicide ');
        System.assertNotEquals(obj.BISPCRSP__c,BISPCRSP,'Child has reported being arrested  '+obj.BISPCRSP__c+' time(s) in the past 30 days. ');
        
        //NOMS
        System.assertNotEquals(obj.BNDAILYL__c,BNDAILYL,'I do NOT strongly disagree that I/my child is handling daily life. ');
        System.assertNotEquals(obj.BNRESTLESS__c,BNRESTLESS,'I am/my child is NOT restless or fidgety some of the time. ');
        System.assertNotEquals(obj.BNHALLUCIN__c,BNHALLUCIN,'I do/my child does NOT use hallucinogens weekly. ');
        System.assertNotEquals(obj.BNSOTHER__c,BNSOTHER,'I do/my child does NOT use another substance daily or almost daily. ');
        System.assertNotEquals(obj.BNSOTHERSP__c,BNSOTHERSP,'Other substance is specified as '+obj.BNSOTHERSP__c+'. ');
        System.assertNotEquals(obj.BNSCENJOY__c,BNSCENJOY,'I do NOT strongly agree that I/my child have people with which they can enjoy activities. ');
        
        //SERVREC
        System.assertNotEquals(obj.BOSDET__c,BOSDET,'Child HAS been to detention center, jail, or prison is the last 30 days. ');
        System.assertNotEquals(obj.BLTGROUP__c,BLTGROUP,'Child has NOT been in a group home in lifetime. ');
        System.assertNotEquals(obj.BTRTXFOS__c,BTRTXFOS,'Treatment foster care status as a result of trauma IS known. ');
        System.assertNotEquals(obj.BOSCOGB__c,BOSCOGB,'Child has NOT received CBT in the past 30 days. ');
        System.assertNotEquals(obj.BLTTOTH__c,BLTTOTH,'Services received in lifetime are part of standard list. ');
        System.assertNotEquals(obj.BOSTOSP__c,BOSTOSP ,'Other service received in lifetime is specified as '+obj.BOSTOSP__c+'. ');
        
        //YCINDSEV
        System.assertNotEquals(obj.BIMRISK__c,BIMRISK,'Child HAS immediate risk of self-harm. ');
        System.assertNotEquals(obj.BFEEDING__c,BFEEDING,'Child does NOT have moderate feeding problems. ');
        System.assertNotEquals(obj.BPRESCH__c,BPRESCH,'behavior in preschool/daycare IS known. ');
        System.assertNotEquals(obj.BDEVEL__c,BDEVEL,'Child is NOT close to meeting all developmental milestones. ');
        System.assertNotEquals(obj.BDMICOG__c,BDMICOG,'Child does NOT need cognitive considerations. ');
    }
}