/****
*@description This test provides code coverage for DS_SDQ_PSI_CDI_F
*includes
*Trigger 
*Controllers:
    *SDQ_P_04_10, SDQ_P_11_17, SDQ_S_11_17, PSI
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_SDQ_PSI_CDI_F.htm
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
private class TestClass_DS_SDQ_PSI_CDI_F  {

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
        List<DS_SDQ_PSI_CDI_F__c> bulkObj = new List<DS_SDQ_PSI_CDI_F__c>();
        
        ///begin bulk insert     
        for (Integer i=0;i<200;i++){            
            bulkObj.add(new DS_SDQ_PSI_CDI_F__c(client__c = client.id,
                                                FEMONULLP__c = 0, FBEHNULLP__c = 0, FHYPNULLP__c = 0, FOTCNULLP__c = 0, FKHBNULLP__c = 0,//null counts parent
                                                FEMONULLS__c = 0, FBEHNULLS__c = 0, FHYPNULLS__c = 0, FOTCNULLS__c = 0, FKHBNULLS__c = 0,//null counts self
                                                FDOASDYP__c = System.today(), FDOASDOP__c = System.today(), FDOASDOS__c = System.today(),
                                                FMETSDYP__c = '1', FMETSDOP__c = '1', FMETSDOS__c = '1',
                                                          FPSIPD__c = 13, FPSIPD_PTLE__c = 81, 
                                                            FPSIPD2__c = 13, FPSIPD_PTLE2__c = 81,
                                                          FPSIPCDI__c = 13, FPSIPCDI_PTLE__c = 81, 
                                                            FPSIPCDI2__c = 13, FPSIPCDI_PTLE2__c = 81,
                                                          FPSIDC__c = 13, FPSIDC_PTLE__c = 81, 
                                                            FPSIDC2__c = 13, FPSIDC_PTLE2__c = 81,
                                                          FPSITS__c = 38, FPSITS_PTLE__c = 81, 
                                                            FPSITS2__c = 38, FPSITS_PTLE2__c = 81,
                                                          FPSIDR__c = 9, FPSIDR_PTLE__c = 81, 
                                                            FPSIDR2__c = 9, FPSIDR_PTLE2__c = 81,
                                                          FDOAPSI__c = System.today(),
                                                SECTION__c = '1'));      
        }
        
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
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '1',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'FollowUp',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
        
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();     
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_P_04_10', '1');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_F__c> ObjList = new List<DS_SDQ_PSI_CDI_F__c>();
        
        //init object w/ required vals
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c(client__c = client.id,
                                                            FEMONULLP__c = 0, FBEHNULLP__c = 0, FHYPNULLP__c = 0, FOTCNULLP__c = 0, FKHBNULLP__c = 0,//null counts
                                                            FSDPTANT__c = '1', FSDPOBEY__c = '1', FSDPFIGH__c = '1', FSDPLIES__c = '1', FSDPSTEA__c = '1',//behavioral responses parent
                                                            FSDPREST__c = '1', FSDPFIDG__c = '1', FSDPDIST__c = '1', FSDPREFL__c = '1', FSDPATTE__c= '2',//hyperactive responses parent
                                                            FDOASDYP__c = System.today(), 
                                                            FMETSDYP__c = '1', 
                                                            SECTION__c = '1');  
                
        //set form's status         
        obj.STATUS_SDQ_P_04_10__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.FSDPETYP__c;
        score.BTYP=obj.FSDPBTYP__c;
        score.HTYP=obj.FSDPHTYP__c;
        score.OTYP=obj.FSDPOTYP__c;
        score.KTYP=obj.FSDPKTYP__c;
        score.ITYP=obj.FSDPITYP__c;
        
        //init difficulties present to scoring class
        score.EBDD=obj.FSDPEBDD__c;
        
        //init parent/self variable to scoring class
        score.Pors='P';
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_P_04_10_Controller controller = new DS_SDQ_P_04_10_Controller(sc);    
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();
        
        //save/cancel
        controller.save();
        controller.cancel();
        controller.saveview();        
        
        //init variable alias to be tested    
        String FSDPINFOR= '0';
        String FSDPFIDG= '2';
        String FSDPFIGH = '1';
        Date FDOASDYP=system.today();
        //Negative assert statements
        System.assertNotEquals(obj.FSDPINFOR__c,FSDPINFOR,'Mother was NOT informant ');
        System.assertNotEquals(obj.FSDPFIDG__c,FSDPFIDG,'Child is certainally NOT fidgety. ');
        System.assertEquals(obj.FDOASDYP__c,FDOASDYP,'Administered  today,  '+obj.FDOASDYP__c+'. ');
        System.assertEquals(obj.FSDPFIGH__c, FSDPFIGH, 'Child sometimes fights with or bullies other children.');
    }
    
    /****
    *@description method to test controllers associated with object 
    *Old Child, Parent Form
    ****/
    static TestMethod void assertControllerOP() {
    
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 11));         
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_SDQ_P_11_17'
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '1',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'FollowUp',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
        
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();     
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_P_11_17', '1');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_F__c> ObjList = new List<DS_SDQ_PSI_CDI_F__c>();
        
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c(client__c = client.id,
                                                            FEMONULLP__c = 0, FBEHNULLP__c = 0, FHYPNULLP__c = 0, FOTCNULLP__c = 0, FKHBNULLP__c = 0,//null counts
                                                            FSDPSOMA__c = '1', FSDPWORR__c = '1', FSDPUNHA__c = '1', FSDPCLIN__c= '1', FSDPAFRA__c = '1',//emotional responses parent
                                                            FSDPCONS__c = '1', FSDPSHAR__c = '1', FSDPCARI__c = '1', FSDPKIND__c = '0', FSDPHELP__c = '1',//prosocial responses parent
                                                            FDOASDOP__c = System.today(), 
                                                            FMETSDOP__c = '1', 
                                                            SECTION__c = '1',
                                                            FSDPTIME__c = '1');  
                
        //set form's status  
        obj.STATUS_SDQ_P_11_17__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.FSDPETYP__c;
        score.BTYP=obj.FSDPBTYP__c;
        score.HTYP=obj.FSDPHTYP__c;
        score.OTYP=obj.FSDPOTYP__c;
        score.KTYP=obj.FSDPKTYP__c;
        score.ITYP=obj.FSDPITYP__c;
        
        //init difficulties present to scoring class
        score.EBDD=obj.FSDPEBDD__c;
        
        //init parent/self variable to scoring class
        score.Pors='P';
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_P_11_17_Controller controller = new DS_SDQ_P_11_17_Controller(sc);   
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();
        
        //save/cancel
        controller.save();
        controller.cancel();
        controller.saveview();
             
        //init variable alias to be tested 
        String FSDPCLIN= '1' ; 
        String FSDPCOMM= 'null';
        String FSDPKIND = '0';
        
        //Negative assert statements 
        System.assertEquals(obj.FSDPCLIN__c,FSDPCLIN,'Child is somewhat nervous or clingy. ');
        System.assertNotEquals(obj.FSDPCOMM__c,FSDPCOMM,'Parent comments have been filled in. ');
        System.assertEquals(obj.FSDPKIND__c, FSDPKIND, 'Child is NOT kind to younger children. ');
    }
    
    /****
    *@description method to test controllers associated with object 
    *Old Child, Self Form
    ****/
    static TestMethod void assertControllerOS() {
    
        //create test client 
        Client__c client = test_ut.createClient();           
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_SDQ_S_11_17' 
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = section,
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'FollowUp',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
        
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();     
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_S_11_17', section);
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_F__c> ObjList = new List<DS_SDQ_PSI_CDI_F__c>(); 
        
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c(client__c = client.id,
                                                            FEMONULLS__c = 0, FBEHNULLS__c = 0, FHYPNULLS__c = 0, FOTCNULLS__c = 0, FKHBNULLS__c = 0,//null counts
                                                            FSDSSOMA__c = '1', FSDSWORR__c = '1', FSDSUNHA__c = '1', FSDSCLIN__c= '1', FSDSAFRA__c = '1',//emotional responses self
                                                            FSDSREST__c = '1', FSDSFIDG__c = '1', FSDSDIST__c = '1', FSDSREFL__c = '1', FSDSATTE__c= '2',//hyperactive responses self
                                                            FSDSLONE__c = '1', FSDSFRIE__c = '1', FSDSPOPU__c = '0', FSDSBULL__c = '1',FSDSOLDB__c = '1',//peer responses self
                                                            FDOASDOS__c = System.today(), 
                                                            FMETSDOS__c = '1', 
                                                            SECTION__c = section);  
                
        //set form's status  
        obj.STATUS_SDQ_S_11_17__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.FSDSETYP__c;
        score.BTYP=obj.FSDSBTYP__c;
        score.HTYP=obj.FSDSHTYP__c;
        score.OTYP=obj.FSDSOTYP__c;
        score.KTYP=obj.FSDSKTYP__c;
        score.ITYP=obj.FSDSITYP__c;
        
        //init difficulties present to scoring class
        score.EBDD=obj.FSDSEBDD__c;
        
        //init parent/self variable to scoring class
        score.Pors='S';
                        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_S_11_17_Controller controller = new DS_SDQ_S_11_17_Controller(sc); 
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Degree = controller.getDegreeItems();
        
        //save/cancel    
        controller.save();
        controller.cancel();
        controller.saveview();
             
        //init variable alias to be tested  
        String FSDSPOPU= '0';
        String FSDSSOMA= '1';
        String FSDSATTE= '2';
        // assert statements 
        System.assertEquals(obj.FSDSPOPU__c,FSDSPOPU,'I am certainally popular. ');
        System.assertEquals(obj.FSDSSOMA__c,FSDSSOMA,'I feel sick sometimes. ');
        System.assertEquals(obj.FSDSATTE__c,FSDSATTE,'I certainally do not have a good attention span. ');

    }
    
    /****
    *@description method to test a case for SDQ Parent 4 to 10
    * 
    ****/
    static TestMethod void TestScoringSDQParent4_10() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c(client__c = client.id);
        
        obj.FFORM__c = 'SDQ_P_04_10';
        obj.STATUS_SDQ_P_04_10__c = 'Complete';
       
        obj.FSDPCONS__c = '1';  // 1
        obj.FSDPREST__c = '0';  // 2
        obj.FSDPSOMA__c = '0';  // 3
        obj.FSDPSHAR__c = '1';  // 4
        obj.FSDPTANT__c = '2';  // 5
        obj.FSDPLONE__c = '1';  // 6
        obj.FSDPOBEY__c = '2';  // 7
        obj.FSDPWORR__c = '0';  // 8
        obj.FSDPCARI__c = '1';  // 9
        obj.FSDPFIDG__c = '0';  // 10
        obj.FSDPFRIE__c = '1';  // 11
        obj.FSDPFIGH__c = '2';  // 12
        obj.FSDPUNHA__c = '2';  // 13
        obj.FSDPPOPU__c = '1';  // 14
        obj.FSDPDIST__c = '0';  // 15
        obj.FSDPCLIN__c = '1';  // 16
        obj.FSDPKIND__c = '0';  // 17
        obj.FSDPLIES__c = '2';  // 18
        obj.FSDPBULL__c = '0';  // 19
        obj.FSDPHELP__c = '1';  // 20
        obj.FSDPREFL__c = '1';  // 21
        obj.FSDPSTEA__c = '2';  // 22
        obj.FSDPOLDB__c = '0';  // 23
        obj.FSDPAFRA__c = '0';  // 24
        obj.FSDPATTE__c = '1';  // 25
        
        // How long have these difficulties been present?
        obj.FSDPEBCD__c = '2';
        
        // Do the difficulties upset or distress your child?
        obj.FSDPUPSET__c = '1';
        
        // Do the difficulties interfere with your child's everyday life in the following areas?
        obj.FSDPIMPH__c = '2';
        obj.FSDPIMPF__c = '3';
        obj.FSDPIMPC__c = '2';
        obj.FSDPIMPL__c = '0';
        
        // Do the difficulties put a burden on you or the family as a whole?
        obj.FSDPFAM__c = '3';
        
        test.startTest();
        insert obj;
        test.stopTest();
        
        DS_SDQ_PSI_CDI_F__c sdq = [SELECT FSDPTOT__c, FSDPEMO__c, FSDPBEH__c, FSDPHYP__c,
                                          FSDPOTC__c, FSDPKHB__c, FSDPDCL__c
                                     FROM DS_SDQ_PSI_CDI_F__c
                                    WHERE id =: obj.id];
        
        System.assertEquals(18, sdq.FSDPTOT__c, 'SDQ Parent 4-10 Total Difficulties is wrong.');
        System.assertEquals(3, sdq.FSDPEMO__c, 'SDQ Parent 4-10 Emotional Problems is wrong.');
        System.assertEquals(10, sdq.FSDPBEH__c, 'SDQ Parent 4-10 Behavioral Difficulties is wrong.');
        System.assertEquals(2, sdq.FSDPHYP__c, 'SDQ Parent 4-10 Hyperactivity is wrong.');
        System.assertEquals(3, sdq.FSDPOTC__c, 'SDQ Parent 4-10 Peer Problems is wrong.');
        System.assertEquals(4, sdq.FSDPKHB__c, 'SDQ Parent 4-10 Prosocial is wrong.');
        System.assertEquals(4, sdq.FSDPDCL__c, 'SDQ Parent 4-10 Impact is wrong.');
        
        
    }
    
    /****
    *@description method to test a case for SDQ Parent 11 to 17
    * 
    ****/
    static TestMethod void TestScoringSDQParent11_17() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 12));
        
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c(client__c = client.id);
        
        obj.FFORM__c = 'SDQ_P_11_17';
        obj.STATUS_SDQ_P_11_17__c = 'Complete';
        
        obj.FSDPCONS__c = '2';  // 1
        obj.FSDPREST__c = '1';  // 2
        obj.FSDPSOMA__c = '1';  // 3
        obj.FSDPSHAR__c = '2';  // 4
        obj.FSDPTANT__c = '0';  // 5
        obj.FSDPLONE__c = '2';  // 6
        obj.FSDPOBEY__c = '0';  // 7
        obj.FSDPWORR__c = '2';  // 8
        obj.FSDPCARI__c = '2';  // 9
        obj.FSDPFIDG__c = '0';  // 10
        obj.FSDPFRIE__c = '1';  // 11
        obj.FSDPFIGH__c = '0';  // 12
        obj.FSDPUNHA__c = '2';  // 13
        obj.FSDPPOPU__c = '1';  // 14
        obj.FSDPDIST__c = '0';  // 15
        obj.FSDPCLIN__c = '2';  // 16
        obj.FSDPKIND__c = '2';  // 17
        obj.FSDPLIES__c = '0';  // 18
        obj.FSDPBULL__c = '2';  // 19
        obj.FSDPHELP__c = '2';  // 20
        obj.FSDPREFL__c = '0';  // 21
        obj.FSDPSTEA__c = '0';  // 22
        obj.FSDPOLDB__c = '2';  // 23
        obj.FSDPAFRA__c = '2';  // 24
        obj.FSDPATTE__c = '0';  // 25
        
        // How long have these difficulties been present?
        obj.FSDPEBCD__c = '1';
        
        // Do the difficulties upset or distress your child?
        obj.FSDPUPSET__c = '2';
        
        // Do the difficulties interfere with your child's everyday life in the following areas?
        obj.FSDPIMPH__c = '0';
        obj.FSDPIMPF__c = '1';
        obj.FSDPIMPC__c = '2';
        obj.FSDPIMPL__c = '0';
        
        // Do the difficulties put a burden on you or the family as a whole?
        obj.FSDPFAM__c = '1';
        
        test.startTest();
        insert obj;
        test.stopTest();
        
        DS_SDQ_PSI_CDI_F__c sdq = [SELECT FSDPTOT__c, FSDPEMO__c, FSDPBEH__c, FSDPHYP__c,
                                          FSDPOTC__c, FSDPKHB__c, FSDPDCL__c
                                     FROM DS_SDQ_PSI_CDI_F__c
                                    WHERE id =: obj.id];
        
        System.assertEquals(18, sdq.FSDPTOT__c, 'SDQ Parent 11-17 Total Difficulties is wrong.');
        System.assertEquals(9, sdq.FSDPEMO__c, 'SDQ Parent 11-17 Emotional Problems is wrong.');
        System.assertEquals(0, sdq.FSDPBEH__c, 'SDQ Parent 11-17 Behavioral Difficulties is wrong.');
        System.assertEquals(1, sdq.FSDPHYP__c, 'SDQ Parent 11-17 Hyperactivity is wrong.');
        System.assertEquals(8, sdq.FSDPOTC__c, 'SDQ Parent 11-17 Peer Problems is wrong.');
        System.assertEquals(10, sdq.FSDPKHB__c, 'SDQ Parent 11-17 Prosocial is wrong.');
        System.assertEquals(2, sdq.FSDPDCL__c, 'SDQ Parent 11-17 Impact is wrong.');
        
        
    }
    
    /****
    *@description method to test a case for SDQ self 11 to 17
    * 
    ****/
    static TestMethod void TestScoringSDQSelf11_17() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 15));
        
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c(client__c = client.id);
        
        obj.FFORM__c = 'SDQ_S_11_17';
        obj.STATUS_SDQ_S_11_17__c = 'Complete';
        
        obj.FSDSCONS__c = '1';  // 1
        obj.FSDSREST__c = '2';  // 2
        obj.FSDSSOMA__c = '2';  // 3
        obj.FSDSSHAR__c = '1';  // 4
        obj.FSDSTANT__c = '0';  // 5
        obj.FSDSLONE__c = '0';  // 6
        obj.FSDSOBEY__c = '1';  // 7
        obj.FSDSWORR__c = '2';  // 8
        obj.FSDSCARI__c = '1';  // 9
        obj.FSDSFIDG__c = '2';  // 10
        obj.FSDSFRIE__c = '1';  // 11
        obj.FSDSFIGH__c = '0';  // 12
        obj.FSDSUNHA__c = '0';  // 13
        obj.FSDSPOPU__c = '1';  // 14
        obj.FSDSDIST__c = '2';  // 15
        obj.FSDSCLIN__c = '0';  // 16
        obj.FSDSKIND__c = '1';  // 17
        obj.FSDSLIES__c = '0';  // 18
        obj.FSDSBULL__c = '0';  // 19
        obj.FSDSHELP__c = '1';  // 20
        obj.FSDSREFL__c = '2';  // 21
        obj.FSDSSTEA__c = '0';  // 22
        obj.FSDSOLDB__c = '0';  // 23
        obj.FSDSAFRA__c = '2';  // 24
        obj.FSDSATTE__c = '2';  // 25
       
        //  Overall, do you think that you have had difficulties in one or more of the following areas: emotions, concentration, behavior or being able to get on with other people?
        obj.FSDSEBCD__c = '1';
        
        // Do the difficulties upset or distress you?
        obj.FSDSUPSET__c = '2';
        
        // Do the difficulties interfere with your child's everyday life in the following areas?
        obj.FSDSIMPH__c = '2';
        obj.FSDSIMPF__c = '1';
        obj.FSDSIMPC__c = '3';
        obj.FSDSIMPL__c = '3';
        
        // Do the difficulties put a burden on you or the family as a whole?
        obj.FSDSFAM__c = '1';
        
        test.startTest();
        insert obj;
        test.stopTest();
        
        DS_SDQ_PSI_CDI_F__c sdq = [SELECT FSDSTOT__c, FSDSEMO__c, FSDSBEH__c, FSDSHYP__c,
                                          FSDSOTC__c, FSDSKHB__c, FSDSDCL__c
                                     FROM DS_SDQ_PSI_CDI_F__c
                                    WHERE id =: obj.id];
        
        System.assertEquals(19, sdq.FSDSTOT__c, 'SDQ Self 11-17 Total Difficulties is wrong.');
        System.assertEquals(6, sdq.FSDSEMO__c, 'SDQ Self 11-17 Emotional Problems is wrong.');
        System.assertEquals(1, sdq.FSDSBEH__c, 'SDQ Self 11-17 Behavioral Difficulties is wrong.');
        System.assertEquals(10, sdq.FSDSHYP__c, 'SDQ Self 11-17 Hyperactivity is wrong.');
        System.assertEquals(2, sdq.FSDSOTC__c, 'SDQ Self 11-17 Peer Problems is wrong.');
        System.assertEquals(5, sdq.FSDSKHB__c, 'SDQ Self 11-17 Prosocial is wrong.');
        System.assertEquals(6, sdq.FSDSDCL__c, 'SDQ Self 11-17 Impact is wrong.');
        
        
    }

    /****
    *@description method to test controllers associated with object
    *PSI
    ****/
    static TestMethod void assertControllerPSI(){
    
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 12));         
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_PSI'
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = section,
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'FollowUp',
                                                            STATUS__c = 'Complete');
        
        insert summary;  
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_PSI', section);
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_F__c> ObjList = new List<DS_SDQ_PSI_CDI_F__c>();  
        
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c(client__c = client.id,
                                                          FPSIPD__c = 13, FPSIPD_PTLE__c = 90, 
                                                            FPSIPD2__c = 13, FPSIPD_PTLE2__c = 90,
                                                          FPSIPCDI__c = 13, FPSIPCDI_PTLE__c = 90, 
                                                            FPSIPCDI2__c = 13, FPSIPCDI_PTLE2__c = 90,
                                                          FPSIDC__c = 13, FPSIDC_PTLE__c = 90, 
                                                            FPSIDC2__c = 13, FPSIDC_PTLE2__c = 90,
                                                          FPSITS__c = 38, FPSITS_PTLE__c = 90, 
                                                            FPSITS2__c = 38, FPSITS_PTLE2__c = 90,
                                                          FPSIDR__c = 9, FPSIDR_PTLE__c = 90, 
                                                            FPSIDR2__c = 9, FPSIDR_PTLE2__c = 90,
                                                          FDOAPSI__c = System.today(),
                                                          SECTION__c = '1');  
                                                            
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
        
        //init variable alias to be tested 
        Decimal FPSIPD = 13;
        Decimal FPSIDC_PTLE2 = 90;
        Date today = System.today();
        // assert statements 
        System.assertEquals(obj.FPSIPD__c, FPSIPD,'Incorrect Parental distress raw score.');
        System.assertEquals(obj.FPSIDC_PTLE2__c, FPSIDC_PTLE2,'Incorrect Difficult Child T-score double entry.');
        System.assertEquals(obj.FDOAPSI__c, today,'Date incorrect.');
    }
}