/****
*@description This test provides code coverage for DS_Functioning_Forms_F
*includes
*Trigger 
*Controllers:
    *BIS, BSLC, CANSTR, CLINEVAL, FAPGAR, INDSEV, SERVREC, YCINDSEV, DS_Basic_Form
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_Functioning_Forms_F.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
private class TestClass_DS_Functioning_Forms_F  {
    
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
        List<DS_Functioning_Forms_F__c> bulkObj = new List<DS_Functioning_Forms_F__c>();   
        
        ///begin bulk insert     
        for (Integer i=0;i<100;i++){
            //add record with required values
            bulkObj.add(new DS_Functioning_Forms_F__c(client__c = client.id));
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
        String FFAPGAR1='0';
        String FFAPGAR2='1';
        String FFAPGAR3='2';
        String FFAPGAR4='99';
        String FFAPGAR5='99';
        String FFAPGAR_MET = 'Not Met';
        Integer FFAPGAR_RAW = 3;  
        
        //create test client 
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        //summaryId
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_FAPGAR', section);
        
        //encoded parameters
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);     
        
        //init object w/ required variables
        DS_Functioning_Forms_F__c obj = new DS_Functioning_Forms_F__c(client__c = client.id, 
                                                                    FISPSUIC__c = '1', 
                                                                    FISPCRIM__c = '2', 
                                                                    FTXCOMPL__c= '1');   

        //call to FAPGAR Scoring class
        DS_FAPGAR_Scoring FAPGARScore = new DS_FAPGAR_Scoring();
                
        //set forms' status on object
        obj.STATUS_BIS__c = 'Complete';
        obj.STATUS_BSLC__c = 'Complete';
        obj.STATUS_CANSTR__c = 'Complete';
        obj.STATUS_CLINEVAL__c = 'Complete';
        obj.STATUS_FAPGAR__c = 'Complete';
        obj.STATUS_INDSEV__c = 'Complete';
        obj.STATUS_SERVREC__c = 'Complete';
        obj.STATUS_YCINDSEV__c = 'Complete';
        
        //assign FAPGAR score values
        obj.FFAPGAR1__c = FFAPGAR1;
        obj.FFAPGAR2__c = FFAPGAR2;
        obj.FFAPGAR3__c = FFAPGAR3;
        obj.FFAPGAR4__c = FFAPGAR4;
        obj.FFAPGAR5__c = FFAPGAR5;
        obj.FFAPGAR_MET__c = FFAPGAR_MET;
        obj.FFAPGAR_RAW__c = FFAPGAR_RAW;
            
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);   
        
        //controllers
        DS_BIS_Controller BIScontroller = new DS_BIS_Controller(sc);
        DS_BSLC_Controller BSLCcontroller = new DS_BSLC_Controller(sc);
        DS_CANSTR_Controller CANSTRcontroller = new DS_CANSTR_Controller(sc);
        DS_CLINEVAL_Controller CLINEVALcontroller = new DS_CLINEVAL_Controller(sc);
        DS_FAPGAR_Controller FAPGARcontroller = new DS_FAPGAR_Controller(sc);
        DS_INDSEV_Controller INDSEVcontroller = new DS_INDSEV_Controller(sc);
        DS_SERVREC_Controller SERVRECcontroller = new DS_SERVREC_Controller(sc);
        DS_YCINDSEV_Controller YCINDSEVcontroller = new DS_YCINDSEV_Controller(sc);
                
        //blank warning for FAPGAR
        String warning = 'There are blanks.';   
        ApexPages.message message = new ApexPages.message(ApexPages.severity.WARNING, warning);
        blankCount = 0; 
        Boolean showWarning;                    
        Boolean warned = FAPGARcontroller.showWarningMessageForBlank(blankCount, warning);
        Integer cba = test_ut.countBlankAnwer(blankCount);
        
        //controller-specific list options   
        List<SelectOption> selectOptions = new List<SelectOption>();
        
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
        String FCBISRECV='1';
        Boolean FCBISOTHE=TRUE;
        Boolean FCBISCREE=TRUE;
        Boolean FCBISPSYE=FALSE;
        String FCBISOTHS='null';
        Date FCBISTCDT=system.today();
        String FCBISCOMP='1';
        Date FCBISCODT=system.today();
        
        //BSLC
        String FBSLCTREATMENT='1';
        String FNCCTSBSLC='1';
        String FTXTYPE= '98';
        String FTXTYPSP='null';
        Date FTXSTDT=system.today();
        String FTXCOMPL= '1';
        Date FTXLFTDT=system.today();
    
        //Canstr
        String FSTFAM= '1';
        String FSTINTP= '0';
        String FSTEDU= '2';
        String FSTVOC= '97';
        String FSTCOPE= '3';
        String FSTOPT= '3';
        String FSTTAL= '0';
        String FSTSPIR= '3';
        String FSTCOM= '3';
        String FSTRELT= '2';

        //Clineval
        String FCEBIPL= '2';
        String FCEOCD= '1';
        String FCEEXPL= '0';
        String FCEOTHY= '1';
        String FCEOTHER='null';
        String FCEPRIM= '2';

        //FAPGAR
        /* initialized above  */

        //Indsev
        String FOSDET= '0';
        String FOSGROUP= '1';
        String FOSTXFOS= '99';
        Boolean FOSMEN=FALSE;
        Boolean FOSCOGB=TRUE;
        Boolean FOSTOTH=TRUE;
        String FOSTOSP ='null';
        String FISPACAD= '0';
        String FSUITALK= '0';
        String FISPCRSP='null';

        //Ycindsev
        String FIMRISK= '0';
        String FFEEDING= '2';
        String FPRESCH= '99';
        String FDEVEL= '1';
        Boolean FDMICOG=TRUE;
        
        //Negative assert statements
        
        //BIS
        System.assertNotEquals(obj.FCBISRECV__c,FCBISRECV,'Child/family is NOT receiving brief intervention services. ');
        System.assertNotEquals(obj.FCBISOTHE__c,FCBISOTHE,'Component(s) received are part of the standard list. ');
        System.assertNotEquals(obj.FCBISCREE__c,FCBISCREE,'Screening Component is NOT received. ');
        System.assertNotEquals(obj.FCBISOTHS__c,FCBISOTHS,'Other component has been specified as '+obj.FCBISOTHS__c+'. ');
        System.assertNotEquals(obj.FCBISTCDT__c,FCBISTCDT,'Care did NOT begin today. Began on '+obj.FCBISTCDT__c+'. ');
        System.assertNotEquals(obj.FCBISCOMP__c,FCBISCOMP,'Child/family did NOT complete treatment component(s). ');
        System.assertNotEquals(obj.FCBISCODT__c,FCBISCODT,'Treatment did NOT complete today. Completed on '+obj.FCBISCODT__c+'. ');
        
        //BSLC
        System.assertNotEquals(obj.FBSLCTREATMENT__c,FBSLCTREATMENT,'Child/family is NOT receiving treatment through a breakthrough series or learning collaborative. ');
        System.assertNotEquals(obj.FNCCTSBSLC__c,FNCCTSBSLC,'Breakthrough series/Learning collaborative series is NOT led by the UCLA-Duke NCCTS. ');
        System.assertNotEquals(obj.FTXTYPE__c,FTXTYPE,'Treatment received IS part of the standard list. ');
        System.assertNotEquals(obj.FTXTYPSP__c,FTXTYPSP,'Other treatment has been specified as '+obj.FTXTYPSP__c+'. ');
        System.assertNotEquals(obj.FTXSTDT__c,FTXSTDT,'Treatment did NOT begin today. Began on '+obj.FTXSTDT__c+'. ');
        System.assertNotEquals(obj.FTXLFTDT__c,FTXLFTDT,'Treatment did NOT terminate without completion today. Left treatment on '+obj.FTXLFTDT__c+'. ');
        
        //CANSTR
        System.assertNotEquals(obj.FSTFAM__c,FSTFAM,'Child is NOT considered to have a moderate level of family strength. ');
        System.assertNotEquals(obj.FSTINTP__c,FSTINTP,'Child does NOT have significant interpersonal strength. ');
        System.assertNotEquals(obj.FSTEDU__c,FSTEDU,'Educational strength has NOT been identified. ');
        System.assertNotEquals(obj.FSTVOC__c,FSTVOC,'The child is at least 14 and this item IS applicable. ');
        System.assertNotEquals(obj.FSTCOPE__c,FSTCOPE,'Coping/savoring strength HAS been identified. ');
        System.assertNotEquals(obj.FSTOPT__c,FSTOPT,'Optimism strength HAS been identified. ');
        System.assertNotEquals(obj.FSTTAL__c,FSTTAL,'Talents/Interests strength is NOT well-developed. ');
        System.assertNotEquals(obj.FSTSPIR__c,FSTSPIR,'Spiritual strength HAS been identified. ');
        System.assertNotEquals(obj.FSTCOM__c,FSTCOM,'Community strength has NOT been identified. ');
        System.assertNotEquals(obj.FSTRELT__c,FSTRELT,'Relationship permanence strength has NOT been identified. ');
                
        //CLINEVAL
        System.assertNotEquals(obj.FCEBIPL__c,FCEBIPL,'Child does NOT have a definate indication of Bipolar disorder. ');
        System.assertNotEquals(obj.FCEOCD__c,FCEOCD,'It is not probable that the child has OCD. ');
        System.assertNotEquals(obj.FCEEXPL__c,FCEEXPL,'Child HAS Intermittent Explosive Disorder. ');
        System.assertNotEquals(obj.FCEOTHY__c,FCEOTHY,'NO additional problems/symptoms. ');
        System.assertNotEquals(obj.FCEOTHER__c,FCEOTHER,'Other problem/symptom specified as '+obj.FCEOTHER__c+'. ');
        System.assertNotEquals(obj.FCEPRIM__c,FCEPRIM,'Primary problem is NOT Bipolar disorder. ');
        
        //FAPGAR *using positive asserts
        System.assertEquals(obj.FFAPGAR1__c,FFAPGAR1,'My family hardly ever helps me. ');
        System.assertEquals(obj.FFAPGAR2__c,FFAPGAR2,'I am sometimes satisfied with how my family discussed common interests. ');
        System.assertEquals(obj.FFAPGAR3__c,FFAPGAR3,'My family almost always accept my wishes or choices. ');
        System.assertEquals(obj.FFAPGAR4__c,FFAPGAR4,'I do not know my satisfaction level of the way my family expresses affection. ');
        System.assertEquals(obj.FFAPGAR5__c,FFAPGAR5,'I do not know my satisfaction level in the amount of time my family spends together. ');
        
        //SERVREC
        System.assertNotEquals(obj.FOSDET__c,FOSDET,'Child HAS been to detention center, jail, or prison since the lase CIMI visit. ');
        System.assertNotEquals(obj.FOSGROUP__c,FOSGROUP,'Child has NOT been in a group home since the lase CIMI visit. ');
        System.assertNotEquals(obj.FOSTXFOS__c,FOSTXFOS,'Treatment foster care status since the lase CIMI visit IS known. ');
        System.assertNotEquals(obj.FOSCOGB__c,FOSCOGB,'Child has NOT received CBT since the lase CIMI visit. ');
        System.assertNotEquals(obj.FOSTOTH__c,FOSTOTH,'Services received since the lase CIMI visit are part of standard list. ');
        System.assertNotEquals(obj.FOSTOSP__c,FOSTOSP ,'Other service received since the lase CIMI visit is specified as '+obj.FOSTOSP__c+'. ');
        
        //INDSEV
        System.assertNotEquals(obj.FISPACAD__c,FISPACAD,'Child HAS academic problems. ');
        System.assertNotEquals(obj.FSUITALK__c,FSUITALK,'Child has NOT talked about suicide ');
        System.assertNotEquals(obj.FISPCRSP__c,FISPCRSP,'Child has reported being arrested  as '+obj.FISPCRSP__c+'. ');
        
        //YCINDSEV
        System.assertNotEquals(obj.FIMRISK__c,FIMRISK,'Child HAS immediate risk of self-harm. ');
        System.assertNotEquals(obj.FFEEDING__c,FFEEDING,'Child does NOT have moderate feeding problems. ');
        System.assertNotEquals(obj.FPRESCH__c,FPRESCH,'Behavior in preschool/daycare IS known. ');
        System.assertNotEquals(obj.FDEVEL__c,FDEVEL,'Child is NOT close to meeting all developmental milestones. ');
        System.assertNotEquals(obj.FDMICOG__c,FDMICOG,'Child does NOT need cognitive considerations. ');
    }
}