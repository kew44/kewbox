/****
*@description This test provides code coverage for DS_TSCC_TSCYC_B
*includes
*Trigger 
*Controllers:
    *TSCC_A, TSCC_A_Report, TSCYC, TSCYC_Report
*Bulkified testing
*Asserted Variables
*
*@author Kelsey Willett
*@date 1/27/2016
*@modified date
*Tscc/YC coverage
*
*@date 2/8/16
*@modified date
*Purpose: TSCC/YC assert
*
*@date 3/2/16
*@modified date
*@author KW
*Purpose: update bulk insert,asserts
*
*@modified    4/19/17    KW    test.starttest() & test.stoptest()
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_TSCC_TSCYC_B.htm
****/

@isTest (SeeAllData=false)
private class TestClass_DS_TSCC_TSCYC_B {

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
        Client__c client = test_ut.createClient();
        
        //init list of object
        List<DS_TSCC_TSCYC_B__c> bulkObj = new List<DS_TSCC_TSCYC_B__c>();
        
        ///begin bulk insert     
        for (Integer i=0;i<200;i++){          
            bulkObj.add(new DS_TSCC_TSCYC_B__c(client__c = client.id,                                                           //client
                                                SECTION__c = '0',                                                               //section
                                                BDOATSCYC__c = System.today(), BDOATSCC__c = System.today(),                    //dates                                             
                                                BPTSTOT_R__c= 30,  BPTSTOT_R2__c = 30,  BPTSTOT_T__c= 71, BPTSTOT_T2__c= 71,    //YC tot
                                                BANX_R__c   = 10,  BANX_R2__c    = 10,  BANX_T__c   = 71, BANX_T2__c   = 71,    //YC anx
                                                BDEP_R__c   = 10,  BDEP_R2__c    = 10,  BDEP_T__c   = 71, BDEP_T2__c   = 71,    //YC dep
                                                BANG_R__c   = 10,  BANG_R2__c    = 10,  BANG_T__c   = 71, BANG_T2__c   = 71,    //YC ang
                                                BSC_R__c    = 10,  BSC_R2__c     = 10,  BSC_T__c    = 71, BSC_T2__c    = 71,    //YC sc
                                                BDIS_R__c   = 10,  BDIS_R2__c    = 10,  BDIS_T__c   = 71, BDIS_T2__c   = 71,    //YC dis
                                                BPTSI_R__c  = 10,  BPTSI_R2__c   = 10,  BPTSI_T__c  = 71, BPTSI_T2__c  = 71,    //YC pts i 
                                                BPTSAV_R__c = 10,  BPTSAV_R2__c  = 10,  BPTSAV_T__c = 71, BPTSAV_T2__c = 71,    //YC pts av
                                                BPTSAR_R__c = 10,  BPTSAR_R2__c  = 10,  BPTSAR_T__c = 71, BPTSAR_T2__c = 71,    //YC pts ar
                                                BRL_R__c    = 2,   BRL_R2__c     = 2,   BRL_T__c    = 71, BRL_T2__c    = 71,    //YC rl
                                                BATR_R__c   = 10,  BATR_R2__c    = 10,  BATR_T__c   = 71, BATR_T2__c   = 71,    //YC atr
                                                
                                                BTSCAXN__c  = 15,  BTSCAXN2__c   = 15,  BTSCAXTN__c = 67, BTSCAXTN2__c = 67,    //A anx
                                                BTSCDPN__c  = 15,  BTSCDPN2__c   = 15,  BTSCDPTN__c = 67, BTSCDPTN2__c = 67,    //A dep
                                                BTSCAGG__c  = 15,  BTSCAGG2__c   = 15,  BTSCAGTN__c = 67, BTSCAGTN2__c = 67,    //A ang
                                                BTSCPTN__c  = 15,  BTSCPTN2__c   = 15,  BTSCPTTN__c = 67, BTSCPTTN2__c = 67,    //A pts
                                                BTSCDSN__c  = 15,  BTSCDSN2__c   = 15,  BTSCDSTN__c = 67, BTSCDSTN2__c = 67,    //A dis
                                                BTSCODN__c  = 15,  BTSCODN2__c   = 15,  BTSCODTN__c = 67, BTSCODTN2__c = 67,    //A dis o
                                                BTSCFNN__c  = 2,   BTSCFNN2__c   =  2,  BTSCFNTN__c = 67, BTSCFNTN2__c = 67,    //A dis f
                                                BTSCUNN__c  = 8,   BTSCUNN2__c   =  8,  BTSCNTN__c  = 71, BTSCNTN2__c  = 71,    //A und
                                                BTSCHYN__c  = 4,   BTSCHYN2__c   =  4,  BTSCHYTN__c = 91, BTSCHYTN2__c = 91     //A hyp
                                                ));         
        }
        
        //add list of records to object
        insert bulkObj;  
    }
    
    /****
    *@description method to test controllers associated with object
    *TSCYC 
    ****/
    static TestMethod void assertControllerTSCYC() {    
    
        //create test client 
        Client__c client = test_ut.createClient();     
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_TSCYC'
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_TSCYC', '0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_TSCC_TSCYC_B__c> ObjList = new List<DS_TSCC_TSCYC_B__c>();
        
        //init object w/ required vals
        DS_TSCC_TSCYC_B__c obj = new DS_TSCC_TSCYC_B__c(client__c = client.id,                                                              //client
                                                        SECTION__c = '0',                                                               //section
                                                        BDOATSCYC__c = System.today(),                                                  //date                                              
                                                        BPTSTOT_R__c= 70,  BPTSTOT_R2__c = 70,  BPTSTOT_T__c= 67, BPTSTOT_T2__c= 67,    //YC tot
                                                        BANX_R__c   = 30,  BANX_R2__c    = 30,  BANX_T__c   = 67, BANX_T2__c   = 67,    //YC anx
                                                        BDEP_R__c   = 30,  BDEP_R2__c    = 30,  BDEP_T__c   = 67, BDEP_T2__c   = 67,    //YC dep
                                                        BANG_R__c   = 30,  BANG_R2__c    = 30,  BANG_T__c   = 67, BANG_T2__c   = 67,    //YC ang
                                                        BSC_R__c    = 30,  BSC_R2__c     = 30,  BSC_T__c    = 67, BSC_T2__c    = 67,    //YC sc
                                                        BDIS_R__c   = 30,  BDIS_R2__c    = 30,  BDIS_T__c   = 67, BDIS_T2__c   = 67,    //YC dis
                                                        BPTSI_R__c  = 30,  BPTSI_R2__c   = 30,  BPTSI_T__c  = 67, BPTSI_T2__c  = 67,    //YC pts i 
                                                        BPTSAV_R__c = 30,  BPTSAV_R2__c  = 30,  BPTSAV_T__c = 67, BPTSAV_T2__c = 67,    //YC pts av
                                                        BPTSAR_R__c = 30,  BPTSAR_R2__c  = 30,  BPTSAR_T__c = 67, BPTSAR_T2__c = 67,    //YC pts ar
                                                        BRL_R__c    = 6,   BRL_R2__c     = 6,   BRL_T__c    = 67, BRL_T2__c    = 67,    //YC rl
                                                        BATR_R__c   = 30,  BATR_R2__c    = 30,  BATR_T__c   = 67, BATR_T2__c   = 67     //YC atr
                                                        );  
                
        //set form's status 
        obj.STATUS_TSCYC__c = 'Complete';        
        
        test.startTest();  
        //insert object
        insert obj;
        test.stopTest();
                
        //add obj to obj list
        ObjList.add(obj);
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_TSCYC_Controller controller = new DS_TSCYC_Controller(sc);    
        DS_TSCYC_Report_Controller RC = new DS_TSCYC_Report_Controller(sc);       
        
        //save/cancel
        controller.save();
        controller.cancel();
        controller.saveview();
        
        RC.init();
        RC.editRecord();
        
        DS_TSCC_TSCYC_B__c tsc = [SELECT BDEP_R__c, BPTSAV_T2__c, SECTION__c
                                    FROM DS_TSCC_TSCYC_B__c
                                    WHERE id =: obj.id];
        
        // assert statements 
        System.assertEquals(tsc.BDEP_R__c, 30,'Incorrect Depression raw score.');
        System.assertEquals(tsc.BPTSAV_T2__c, 67,'Incorrect Avoidance T-score double entry.');
        System.assertEquals(tsc.SECTION__c, '0','Section incorrect: baseline.');
        }
    
    /****
    *@description method to test controllers associated with object
    *TSCC 
    ****/
    static TestMethod void assertControllerTSCC() {   
    
        //create test client 
        Client__c client = test_ut.createClient();     
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_TSCC_A'
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_TSCC_A', '0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_TSCC_TSCYC_B__c> ObjList = new List<DS_TSCC_TSCYC_B__c>(); 
        
        //init object w/ required vals
        DS_TSCC_TSCYC_B__c obj = new DS_TSCC_TSCYC_B__c(client__c = client.id,                                                          //client
                                                        SECTION__c = '0',                                                               //section     
                                                        BDOATSCC__c = System.today(),                                                   //date    
                                                        BTSCAXN__c  = 20,  BTSCAXN2__c   = 20,  BTSCAXTN__c = 62, BTSCAXTN2__c = 62,    //A anx
                                                        BTSCDPN__c  = 20,  BTSCDPN2__c   = 20,  BTSCDPTN__c = 62, BTSCDPTN2__c = 62,    //A dep
                                                        BTSCAGG__c  = 20,  BTSCAGG2__c   = 20,  BTSCAGTN__c = 62, BTSCAGTN2__c = 62,    //A ang
                                                        BTSCPTN__c  = 20,  BTSCPTN2__c   = 20,  BTSCPTTN__c = 62, BTSCPTTN2__c = 62,    //A pts
                                                        BTSCDSN__c  = 20,  BTSCDSN2__c   = 20,  BTSCDSTN__c = 62, BTSCDSTN2__c = 62,    //A dis
                                                        BTSCODN__c  = 20,  BTSCODN2__c   = 20,  BTSCODTN__c = 62, BTSCODTN2__c = 62,    //A dis o
                                                        BTSCFNN__c  = 7,   BTSCFNN2__c   =  7,  BTSCFNTN__c = 62, BTSCFNTN2__c = 62,    //A dis f
                                                        BTSCUNN__c  = 3,   BTSCUNN2__c   =  3,  BTSCNTN__c  = 67, BTSCNTN2__c  = 67,    //A und
                                                        BTSCHYN__c  = 5,   BTSCHYN2__c   =  5,  BTSCHYTN__c = 90, BTSCHYTN2__c = 90     //A hyp
                                                        );  
                
        //set form's status 
        obj.STATUS_TSCC_A__c = 'Complete';        
        
        test.startTest();  
        //insert object
        insert obj;
        test.stopTest();
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_TSCC_A_Controller controller = new DS_TSCC_A_Controller(sc);    
        DS_TSCC_A_Report_Controller RC = new DS_TSCC_A_Report_Controller(sc);       
        
        //save/cancel
        controller.save();
        controller.cancel();
        controller.saveview();
        
        RC.init();
        RC.editRecord();
        
        DS_TSCC_TSCYC_B__c tsc = [SELECT BTSCAXN__c, BTSCAGTN2__c, SECTION__c
                                    FROM DS_TSCC_TSCYC_B__c
                                    WHERE id =: obj.id];
        
        // assert statements 
        System.assertEquals(tsc.BTSCAXN__c, 20,'Incorrect Anxiety raw score.');
        System.assertEquals(tsc.BTSCAGTN2__c, 62,'Incorrect Anger T-score double entry.');
        System.assertEquals(tsc.SECTION__c, '0','Section incorrect: baseline.');
    }
}