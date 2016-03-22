/****
*@description This test provides code coverage for DS_SDQ_PSI_CDI_B
*includes
*Trigger 
*Controllers:
    *SDQ_P_04_10, SDQ_P_11_17, SDQ_S_11_17, SDQ_P_04_10_Report, SDQ_P_11_17_Report, SDQ_S_11_17_Report, PSI, PSI_Report
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_SDQ_PSI_CDI_B.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
*
*@date 1/27/2016
*@modified date
*Purpose: PSI coverage
*
*@date 2/8/16
*@modified date
*Purpose: PSI assert
****/

@isTest (SeeAllData=false)
private class TestClass_DS_SDQ_PSI_CDI_B  {

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
        List<DS_SDQ_PSI_CDI_B__c> bulkObj = new List<DS_SDQ_PSI_CDI_B__c>();
        
        ///begin bulk insert     
        for (Integer i=0;i<200;i++){            
            bulkObj.add(new DS_SDQ_PSI_CDI_B__c(client__c = client.id,
                                                BEMONULLP__c = 0, BBEHNULLP__c = 0, BHYPNULLP__c = 0, BOTCNULLP__c = 0, BKHBNULLP__c = 0,//null counts parent
                                                BEMONULLS__c = 0, BBEHNULLS__c = 0, BHYPNULLS__c = 0, BOTCNULLS__c = 0, BKHBNULLS__c = 0,//null counts self
                                                BDOASDYP__c = System.today(), BDOASDOP__c = System.today(), BDOASDOS__c = System.today(),BDOAPSI__c = System.today(),//dates
                                                BMETSDYP__c = '1', BMETSDOP__c = '1', BMETSDOS__c = '1',//methods
                                                          BPSIPD__c = 13, BPSIPD_PTLE__c = 81, 
                                                            BPSIPD2__c = 13, BPSIPD_PTLE2__c = 81,
                                                          BPSIPCDI__c = 13, BPSIPCDI_PTLE__c = 81, 
                                                            BPSIPCDI2__c = 13, BPSIPCDI_PTLE2__c = 81,
                                                          BPSIDC__c = 13, BPSIDC_PTLE__c = 81, 
                                                            BPSIDC2__c = 13, BPSIDC_PTLE2__c = 81,
                                                          BPSITS__c = 38, BPSITS_PTLE__c = 81, 
                                                            BPSITS2__c = 38, BPSITS_PTLE2__c = 81,
                                                          BPSIDR__c = 9, BPSIDR_PTLE__c = 81, 
                                                            BPSIDR2__c = 9, BPSIDR_PTLE2__c = 81,
                                                STATUS_SDQ_P_04_10__c = 'Complete', STATUS_SDQ_P_11_17__c = 'Complete', //parent status
                                                STATUS_SDQ_S_11_17__c = 'Complete',//self status
                                                STATUS_PSI__c = 'Complete', //psi status         
                                                SECTION__c = '0'));   
        }
        
     //   test.startTest();
        //add list of records to object
   //     insert bulkObj;  
        
       // test.stopTest();
        
    }
    
    /****
    *@description method to test controllers associated with object
    *Young Child, Parent Form
    *assert methods represent data types from each controller 
    *some variables asserted may represent required values for certain logic
    ****/
    static TestMethod void assertControllerYP() {    
    
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 6));  
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_SDQ_P_04_10'
                                AND File_name__c = 'BASELINE'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '0',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'Baseline',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
        
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();     
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_P_04_10', '0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_B__c> ObjList = new List<DS_SDQ_PSI_CDI_B__c>();
        
        //init object w/ required vals
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c(client__c = client.id,
                                                            BEMONULLP__c = 0, BBEHNULLP__c = 0, BHYPNULLP__c = 0, BOTCNULLP__c = 0, BKHBNULLP__c = 0,//null counts 
                                                            BSDPTANT__c = '1', BSDPOBEY__c = '1', BSDPFIGH__c = '1', BSDPLIES__c = '1', BSDPSTEA__c = '1',//behavioral responses parent
                                                            BSDPREST__c = '1', BSDPFIDG__c = '1', BSDPDIST__c = '1', BSDPREFL__c = '1', BSDPATTE__c= '2',//hyperactive responses parent
                                                            BDOASDYP__c = System.today(), 
                                                            BMETSDYP__c = '1', 
                                                            SECTION__c = '0');  
                
        //set form's status 
        obj.STATUS_SDQ_P_04_10__c = 'Complete';        
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.BSDPETYP__c;
        score.BTYP=obj.BSDPBTYP__c;
        score.HTYP=obj.BSDPHTYP__c;
        score.OTYP=obj.BSDPOTYP__c;
        score.KTYP=obj.BSDPKTYP__c;
        score.ITYP=obj.BSDPITYP__c;
        
        //init difficulties present to scoring class
        score.EBCD=obj.BSDPEBCD__c;
        
        //init parent/self variable to scoring class
        score.Pors='P';
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_P_04_10_Controller controller = new DS_SDQ_P_04_10_Controller(sc);    
        DS_SDQ_P_04_10_Report_Controller RC = new DS_SDQ_P_04_10_Report_Controller(sc);       
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();
        
        //save/cancel
        controller.save();
        controller.cancel();
        controller.saveview();
        
        RC.init();
        RC.editRecord();
        RC.addVisit(ObjList, 'B'); 
        
        //init test query 
        DS_SDQ_PSI_CDI_B__c sdq = [SELECT  BSDPINFOR__c, BSDPFIDG__c,BSDPFIGH__c, BDOASDYP__c
                                    FROM DS_SDQ_PSI_CDI_B__c
                                    WHERE id =: obj.id];
                                    
        //Negative assert statements
        System.assertNotEquals(obj.BSDPINFOR__c,'0','Mother was NOT informant ');
        System.assertNotEquals(obj.BSDPFIDG__c,'2','Child is certainally NOT fidgety. ');
        //positive asserts
        System.assertEquals(obj.BDOASDYP__c,system.today(),'Administered  today,  '+obj.BDOASDYP__c+'. ');
        System.assertEquals(obj.BSDPFIGH__c, '1', 'Child sometimes fights with or bullies other children.');
    }
    
    /****
    *@description method to test controllers associated with object 
    *Old Child, Parent Form
    ****/
    static TestMethod void assertControllerOP() {
    
        //create test client 
        Client__c client = test_ut.createClient();        
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_SDQ_P_11_17'
                                AND File_name__c = 'BASELINE'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '0',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'Baseline',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
        
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();     
                
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_P_11_17', '0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_B__c> ObjList = new List<DS_SDQ_PSI_CDI_B__c>();
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c(client__c = client.id,
                                                            BEMONULLP__c = 0, BBEHNULLP__c = 0, BHYPNULLP__c = 0, BOTCNULLP__c = 0, BKHBNULLP__c = 0,//null counts
                                                            BSDPSOMA__c = '1', BSDPWORR__c = '1', BSDPUNHA__c = '1', BSDPCLIN__c= '1', BSDPAFRA__c = '1',//emotional responses parent
                                                            BSDPCONS__c = '1', BSDPSHAR__c = '1', BSDPCARI__c = '1', BSDPKIND__c = '0', BSDPHELP__c = '1',//prosocial responses parent
                                                            BDOASDOP__c = System.today(), 
                                                            BMETSDOP__c = '1', 
                                                            SECTION__c = '0',
                                                            BSDPTIME__c = '1');  
               
        //set form's status  
        obj.STATUS_SDQ_P_11_17__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.BSDPETYP__c;
        score.BTYP=obj.BSDPBTYP__c;
        score.HTYP=obj.BSDPHTYP__c;
        score.OTYP=obj.BSDPOTYP__c;
        score.KTYP=obj.BSDPKTYP__c;
        score.ITYP=obj.BSDPITYP__c;
        
        //init difficulties present to scoring class
        score.EBCD=obj.BSDPEBCD__c;
        
        //init parent/self variable to scoring class
        score.Pors='P';
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_P_11_17_Controller controller = new DS_SDQ_P_11_17_Controller(sc);    
        DS_SDQ_P_11_17_Report_Controller RC = new DS_SDQ_P_11_17_Report_Controller(sc);       
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();        
        
        //save/cancel
        controller.save();
        controller.cancel();
        controller.saveview();
        
        RC.init();
        RC.editRecord();
        RC.addVisit(ObjList, 'B');
        
        //init test query 
        DS_SDQ_PSI_CDI_B__c sdq = [SELECT  BSDPCLIN__c, BSDPCOMM__c,BSDPKIND__c
                                    FROM DS_SDQ_PSI_CDI_B__c
                                    WHERE id =: obj.id];     
     
        //Negative assert statement 
        System.assertNotEquals(obj.BSDPCOMM__c,'','Parent comments have been filled in. ');
        //positive asserts
        System.assertEquals(obj.BSDPCLIN__c,'1','Child is somewhat nervous or clingy. ');
        System.assertEquals(obj.BSDPKIND__c, '0', 'Child is NOT kind to younger children. ');
    }
    
    /****
    *@description method to test controllers associated with object 
    *Old Child, Self Form
    ****/
    static TestMethod void assertControllerOS() {
    
        //create test client 
        Client__c client = test_ut.createClient();       
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_SDQ_S_11_17'
                                AND File_name__c = 'BASELINE'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '0',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'Baseline',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
                
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();    
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_S_11_17', '0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_B__c> ObjList = new List<DS_SDQ_PSI_CDI_B__c>(); 
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c(client__c = client.id,
                                                            BEMONULLS__c = 0, BBEHNULLS__c = 0, BHYPNULLS__c = 0, BOTCNULLS__c = 0, BKHBNULLS__c = 0,//null counts
                                                            BSDSSOMA__c = '1', BSDSWORR__c = '1', BSDSUNHA__c = '1', BSDSCLIN__c= '1', BSDSAFRA__c = '1',//emotional responses self
                                                            BSDSREST__c = '1', BSDSFIDG__c = '1', BSDSDIST__c = '1', BSDSREFL__c = '1', BSDSATTE__c= '2',//hyperactive responses self
                                                            BSDSLONE__c = '1', BSDSFRIE__c = '1', BSDSPOPU__c = '0', BSDSBULL__c = '1',BSDSOLDB__c = '1',//peer responses self
                                                            BDOASDOS__c = System.today(), 
                                                            BMETSDOS__c = '1', 
                                                            SECTION__c = '0');  
                
        //set form's status  
        obj.STATUS_SDQ_S_11_17__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.BSDSETYP__c;
        score.BTYP=obj.BSDSBTYP__c;
        score.HTYP=obj.BSDSHTYP__c;
        score.OTYP=obj.BSDSOTYP__c;
        score.KTYP=obj.BSDSKTYP__c;
        score.ITYP=obj.BSDSITYP__c;
        
        //init difficulties present to scoring class
        score.EBCD=obj.BSDSEBCD__c;
        
        //init parent/self variable to scoring class
        score.Pors='S';
                        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_S_11_17_Controller controller = new DS_SDQ_S_11_17_Controller(sc);    
        DS_SDQ_S_11_17_Report_Controller RC = new DS_SDQ_S_11_17_Report_Controller(sc);       
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();
            
        //save/cancel    
        controller.save();
        controller.cancel();
        controller.saveview();
        
        RC.init();
        RC.editRecord();
        RC.addVisit(ObjList, 'B');
        
        //init test query 
        DS_SDQ_PSI_CDI_B__c sdq = [SELECT  BSDSPOPU__c,BSDSSOMA__c,BSDSATTE__c
                                    FROM DS_SDQ_PSI_CDI_B__c
                                    WHERE id =: obj.id];                                    
     
        // assert statements 
        System.assertEquals(obj.BSDSPOPU__c,'0','I am certainally popular. ');
        System.assertEquals(obj.BSDSSOMA__c,'1','I feel sick sometimes. ');
        System.assertEquals(obj.BSDSATTE__c,'2','I certainally do not have a good attention span. ');
    }
    
    /****
    *@description method to test a case for SDQ Parent 4 to 10
    * 
    ****/
    static TestMethod void TestScoringSDQParent4_10() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c(client__c = client.id);
        
        obj.BFORM__c = 'SDQ_P_04_10';
        obj.STATUS_SDQ_P_04_10__c = 'Complete';
        
        obj.BSDPCONS__c = '1';  // 1
        obj.BSDPREST__c = '0';  // 2
        obj.BSDPSOMA__c = '0';  // 3
        obj.BSDPSHAR__c = '1';  // 4
        obj.BSDPTANT__c = '2';  // 5
        obj.BSDPLONE__c = '1';  // 6
        obj.BSDPOBEY__c = '2';  // 7
        obj.BSDPWORR__c = '0';  // 8
        obj.BSDPCARI__c = '1';  // 9
        obj.BSDPFIDG__c = '0';  // 10
        obj.BSDPFRIE__c = '1';  // 11
        obj.BSDPFIGH__c = '2';  // 12
        obj.BSDPUNHA__c = '2';  // 13
        obj.BSDPPOPU__c = '1';  // 14
        obj.BSDPDIST__c = '0';  // 15
        obj.BSDPCLIN__c = '1';  // 16
        obj.BSDPKIND__c = '0';  // 17
        obj.BSDPLIES__c = '2';  // 18
        obj.BSDPBULL__c = '0';  // 19
        obj.BSDPHELP__c = '1';  // 20
        obj.BSDPREFL__c = '1';  // 21
        obj.BSDPSTEA__c = '2';  // 22
        obj.BSDPOLDB__c = '0';  // 23
        obj.BSDPAFRA__c = '0';  // 24
        obj.BSDPATTE__c = '1';  // 25
        
        // How long have these difficulties been present?
        obj.BSDPEBCD__c = '2';
        
        // Do the difficulties upset or distress your child?
        obj.BSDPUPSET__c = '1';
        
        // Do the difficulties interfere with your child's everyday life in the following areas?
        obj.BSDPIMPH__c = '2';
        obj.BSDPIMPF__c = '3';
        obj.BSDPIMPC__c = '2';
        obj.BSDPIMPL__c = '0';
        
        // Do the difficulties put a burden on you or the family as a whole?
        obj.BSDPFAM__c = '3';
        
        test.startTest();
        insert obj;
        test.stopTest();
        
        DS_SDQ_PSI_CDI_B__c sdq = [SELECT BSDPTOT__c, BSDPEMO__c, BSDPBEH__c, BSDPHYP__c,
                                          BSDPOTC__c, BSDPKHB__c, BSDPDCL__c
                                     FROM DS_SDQ_PSI_CDI_B__c
                                    WHERE id =: obj.id];
        
        System.assertEquals(18, sdq.BSDPTOT__c, 'SDQ Parent 4-10 Total Difficulties is wrong.');
        System.assertEquals(3, sdq.BSDPEMO__c, 'SDQ Parent 4-10 Emotional Problems is wrong.');
        System.assertEquals(10, sdq.BSDPBEH__c, 'SDQ Parent 4-10 Behavioral Difficulties is wrong.');
        System.assertEquals(2, sdq.BSDPHYP__c, 'SDQ Parent 4-10 Hyperactivity is wrong.');
        System.assertEquals(3, sdq.BSDPOTC__c, 'SDQ Parent 4-10 Peer Problems is wrong.');
        System.assertEquals(4, sdq.BSDPKHB__c, 'SDQ Parent 4-10 Prosocial is wrong.');
        System.assertEquals(4, sdq.BSDPDCL__c, 'SDQ Parent 4-10 Impact is wrong.');
        
        
    }
    
    /****
    *@description method to test a case for SDQ Parent 11 to 17
    * 
    ****/
    static TestMethod void TestScoringSDQParent11_17() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 12));
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c(client__c = client.id);
        
        obj.BFORM__c = 'SDQ_P_11_17';
        obj.STATUS_SDQ_P_11_17__c = 'Complete';
        
        obj.BSDPCONS__c = '2';  // 1
        obj.BSDPREST__c = '1';  // 2
        obj.BSDPSOMA__c = '1';  // 3
        obj.BSDPSHAR__c = '2';  // 4
        obj.BSDPTANT__c = '0';  // 5
        obj.BSDPLONE__c = '2';  // 6
        obj.BSDPOBEY__c = '0';  // 7
        obj.BSDPWORR__c = '2';  // 8
        obj.BSDPCARI__c = '2';  // 9
        obj.BSDPFIDG__c = '0';  // 10
        obj.BSDPFRIE__c = '1';  // 11
        obj.BSDPFIGH__c = '0';  // 12
        obj.BSDPUNHA__c = '2';  // 13
        obj.BSDPPOPU__c = '1';  // 14
        obj.BSDPDIST__c = '0';  // 15
        obj.BSDPCLIN__c = '2';  // 16
        obj.BSDPKIND__c = '2';  // 17
        obj.BSDPLIES__c = '0';  // 18
        obj.BSDPBULL__c = '2';  // 19
        obj.BSDPHELP__c = '2';  // 20
        obj.BSDPREFL__c = '0';  // 21
        obj.BSDPSTEA__c = '0';  // 22
        obj.BSDPOLDB__c = '2';  // 23
        obj.BSDPAFRA__c = '2';  // 24
        obj.BSDPATTE__c = '0';  // 25
        
        // How long have these difficulties been present?
        obj.BSDPEBCD__c = '1';
        
        // Do the difficulties upset or distress your child?
        obj.BSDPUPSET__c = '2';
        
        // Do the difficulties interfere with your child's everyday life in the following areas?
        obj.BSDPIMPH__c = '0';
        obj.BSDPIMPF__c = '1';
        obj.BSDPIMPC__c = '2';
        obj.BSDPIMPL__c = '0';
        
        // Do the difficulties put a burden on you or the family as a whole?
        obj.BSDPFAM__c = '1';
        
        test.startTest();
        insert obj;
        test.stopTest();
        
        DS_SDQ_PSI_CDI_B__c sdq = [SELECT BSDPTOT__c, BSDPEMO__c, BSDPBEH__c, BSDPHYP__c,
                                          BSDPOTC__c, BSDPKHB__c, BSDPDCL__c
                                     FROM DS_SDQ_PSI_CDI_B__c
                                    WHERE id =: obj.id];
        
        System.assertEquals(18, sdq.BSDPTOT__c, 'SDQ Parent 11-17 Total Difficulties is wrong.');
        System.assertEquals(9, sdq.BSDPEMO__c, 'SDQ Parent 11-17 Emotional Problems is wrong.');
        System.assertEquals(0, sdq.BSDPBEH__c, 'SDQ Parent 11-17 Behavioral Difficulties is wrong.');
        System.assertEquals(1, sdq.BSDPHYP__c, 'SDQ Parent 11-17 Hyperactivity is wrong.');
        System.assertEquals(8, sdq.BSDPOTC__c, 'SDQ Parent 11-17 Peer Problems is wrong.');
        System.assertEquals(10, sdq.BSDPKHB__c, 'SDQ Parent 11-17 Prosocial is wrong.');
        System.assertEquals(2, sdq.BSDPDCL__c, 'SDQ Parent 11-17 Impact is wrong.');
        
        
    }
    
    /****
    *@description method to test a case for SDQ self 11 to 17
    * 
    ****/
    static TestMethod void TestScoringSDQSelf11_17() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 15));
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c(client__c = client.id);
        
        obj.BFORM__c = 'SDQ_S_11_17';
        obj.STATUS_SDQ_S_11_17__c = 'Complete';
        
        obj.BSDSCONS__c = '1';  // 1
        obj.BSDSREST__c = '2';  // 2
        obj.BSDSSOMA__c = '2';  // 3
        obj.BSDSSHAR__c = '1';  // 4
        obj.BSDSTANT__c = '0';  // 5
        obj.BSDSLONE__c = '0';  // 6
        obj.BSDSOBEY__c = '1';  // 7
        obj.BSDSWORR__c = '2';  // 8
        obj.BSDSCARI__c = '1';  // 9
        obj.BSDSFIDG__c = '2';  // 10
        obj.BSDSFRIE__c = '1';  // 11
        obj.BSDSFIGH__c = '0';  // 12
        obj.BSDSUNHA__c = '0';  // 13
        obj.BSDSPOPU__c = '1';  // 14
        obj.BSDSDIST__c = '2';  // 15
        obj.BSDSCLIN__c = '0';  // 16
        obj.BSDSKIND__c = '1';  // 17
        obj.BSDSLIES__c = '0';  // 18
        obj.BSDSBULL__c = '0';  // 19
        obj.BSDSHELP__c = '1';  // 20
        obj.BSDSREFL__c = '2';  // 21
        obj.BSDSSTEA__c = '0';  // 22
        obj.BSDSOLDB__c = '0';  // 23
        obj.BSDSAFRA__c = '2';  // 24
        obj.BSDSATTE__c = '2';  // 25
        
        //  Overall, do you think that you have had difficulties in one or more of the following areas: emotions, concentration, behavior or being able to get on with other people?
        obj.BSDSEBCD__c = '1';
        
        // Do the difficulties upset or distress you?
        obj.BSDSUPSET__c = '2';
        
        // Do the difficulties interfere with your child's everyday life in the following areas?
        obj.BSDSIMPH__c = '2';
        obj.BSDSIMPF__c = '1';
        obj.BSDSIMPC__c = '3';
        obj.BSDSIMPL__c = '3';
        
        // Do the difficulties put a burden on you or the family as a whole?
        obj.BSDSFAM__c = '1';
        
        test.startTest();
        insert obj;
        test.stopTest();
        
        DS_SDQ_PSI_CDI_B__c sdq = [SELECT BSDSTOT__c, BSDSEMO__c, BSDSBEH__c, BSDSHYP__c,
                                          BSDSOTC__c, BSDSKHB__c, BSDSDCL__c
                                     FROM DS_SDQ_PSI_CDI_B__c
                                    WHERE id =: obj.id];
        
        System.assertEquals(19, sdq.BSDSTOT__c, 'SDQ Self 11-17 Total Difficulties is wrong.');
        System.assertEquals(6, sdq.BSDSEMO__c, 'SDQ Self 11-17 Emotional Problems is wrong.');
        System.assertEquals(1, sdq.BSDSBEH__c, 'SDQ Self 11-17 Behavioral Difficulties is wrong.');
        System.assertEquals(10, sdq.BSDSHYP__c, 'SDQ Self 11-17 Hyperactivity is wrong.');
        System.assertEquals(2, sdq.BSDSOTC__c, 'SDQ Self 11-17 Peer Problems is wrong.');
        System.assertEquals(5, sdq.BSDSKHB__c, 'SDQ Self 11-17 Prosocial is wrong.');
        System.assertEquals(6, sdq.BSDSDCL__c, 'SDQ Self 11-17 Impact is wrong.');
        
        
    }
    
    /****
    *@description method to test controllers associated with object
    *PSI
    ****/
    static TestMethod void assertControllerPSI(){
    
        //create test client 
        Client__c client = test_ut.createClient();       
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_PSI'
                                AND File_name__c = 'BASELINE'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '0',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'Baseline',
                                                            STATUS__c = 'Complete');
        
        insert summary;  
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_PSI', '0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_B__c> ObjList = new List<DS_SDQ_PSI_CDI_B__c>();  
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c(client__c = client.id,
                                                          BPSIPD__c = 13, BPSIPD_PTLE__c = 50, 
                                                            BPSIPD2__c = 13, BPSIPD_PTLE2__c = 50,
                                                          BPSIPCDI__c = 13, BPSIPCDI_PTLE__c = 50, 
                                                            BPSIPCDI2__c = 13, BPSIPCDI_PTLE2__c = 50,
                                                          BPSIDC__c = 13, BPSIDC_PTLE__c = 50, 
                                                            BPSIDC2__c = 13, BPSIDC_PTLE2__c = 50,
                                                          BPSITS__c = 38, BPSITS_PTLE__c = 50, 
                                                            BPSITS2__c = 38, BPSITS_PTLE2__c = 50,
                                                          BPSIDR__c = 9, BPSIDR_PTLE__c = 50, 
                                                            BPSIDR2__c = 9, BPSIDR_PTLE2__c = 50,
                                                          BDOAPSI__c = System.today(),
                                                          SECTION__c = '0');  
                                                            
        //set form's status    
        obj.STATUS_PSI__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
                        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
        
        //controllers
        DS_PSI_Controller controller = new DS_PSI_Controller(sc);    
        DS_PSI_Report_Controller RC = new DS_PSI_Report_Controller(sc);    

        //save/cancel    
        controller.save();
        controller.cancel();
        controller.saveview();
        
        RC.init();
        RC.editRecord();
        
        //init test query 
        DS_SDQ_PSI_CDI_B__c sdq = [SELECT  BPSIPD__c,BPSIDC_PTLE2__c,SECTION__c
                                    FROM DS_SDQ_PSI_CDI_B__c
                                    WHERE id =: obj.id];
                                    
        // assert statements 
        System.assertEquals(obj.BPSIPD__c, 13,'Incorrect Parental distress raw score.');
        System.assertEquals(obj.BPSIDC_PTLE2__c, 50,'Incorrect Difficult Child T-score double entry.');
        System.assertEquals(obj.SECTION__c, '0','Section incorrect: baseline.');
    }
}