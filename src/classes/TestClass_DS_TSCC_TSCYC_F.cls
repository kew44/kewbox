/****
*@description This test provides code coverage for DS_TSCC_TSCYC_F
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
*@date 3/2-3/16
*@modified date
*@author KW
*Purpose: update bulk insert,asserts
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_TSCC_TSCYC_F.htm
****/

@isTest (SeeAllData=false)
private class TestClass_DS_TSCC_TSCYC_F {

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
        List<DS_TSCC_TSCYC_F__c> bulkObj = new List<DS_TSCC_TSCYC_F__c>();
        
        ///begin bulk insert     
        for (Integer i=0;i<200;i++){            
            bulkObj.add(new DS_TSCC_TSCYC_F__c(client__c = client.id,                                                           //client
                                                SECTION__c = '1',                                                               //section
                                                FDOATSCYC__c = System.today(), FDOATSCC__c = System.today(),                    //dates                                             
                                                FPTSTOT_R__c= 50,  FPTSTOT_R2__c = 50,  FPTSTOT_T__c= 99, FPTSTOT_T2__c= 99,    //YC tot
                                                FANX_R__c   = 15,  FANX_R2__c    = 15,  FANX_T__c   = 99, FANX_T2__c   = 99,    //YC anx
                                                FDEP_R__c   = 15,  FDEP_R2__c    = 15,  FDEP_T__c   = 99, FDEP_T2__c   = 99,    //YC dep
                                                FANG_R__c   = 15,  FANG_R2__c    = 15,  FANG_T__c   = 99, FANG_T2__c   = 99,    //YC ang
                                                FSC_R__c    = 15,  FSC_R2__c     = 15,  FSC_T__c    = 99, FSC_T2__c    = 99,    //YC sc
                                                FDIS_R__c   = 15,  FDIS_R2__c    = 15,  FDIS_T__c   = 99, FDIS_T2__c   = 99,    //YC dis
                                                FPTSI_R__c  = 15,  FPTSI_R2__c   = 15,  FPTSI_T__c  = 99, FPTSI_T2__c  = 99,    //YC pts i 
                                                FPTSAV_R__c = 15,  FPTSAV_R2__c  = 15,  FPTSAV_T__c = 99, FPTSAV_T2__c = 99,    //YC pts av
                                                FPTSAR_R__c = 15,  FPTSAR_R2__c  = 15,  FPTSAR_T__c = 99, FPTSAR_T2__c = 99,    //YC pts ar
                                                FRL_R__c    = 3,   FRL_R2__c     = 3,   FRL_T__c    = 99, FRL_T2__c    = 99,    //YC rl
                                                FATR_R__c   = 15,  FATR_R2__c    = 15,  FATR_T__c   = 99, FATR_T2__c   = 99,    //YC atr
                                                
                                                FTSCAXN__c  = 12,  FTSCAXN2__c   = 12,  FTSCAXTN__c = 99, FTSCAXTN2__c = 99,    //A anx
                                                FTSCDPN__c  = 12,  FTSCDPN2__c   = 12,  FTSCDPTN__c = 99, FTSCDPTN2__c = 99,    //A dep
                                                FTSCAGG__c  = 12,  FTSCAGG2__c   = 12,  FTSCAGTN__c = 99, FTSCAGTN2__c = 99,    //A ang
                                                FTSCPTN__c  = 12,  FTSCPTN2__c   = 12,  FTSCPTTN__c = 99, FTSCPTTN2__c = 99,    //A pts
                                                FTSCDSN__c  = 12,  FTSCDSN2__c   = 12,  FTSCDSTN__c = 99, FTSCDSTN2__c = 99,    //A dis
                                                FTSCODN__c  = 12,  FTSCODN2__c   = 12,  FTSCODTN__c = 99, FTSCODTN2__c = 99,    //A dis o
                                                FTSCFNN__c  = 3,   FTSCFNN2__c   =  3,  FTSCFNTN__c = 99, FTSCFNTN2__c = 99,    //A dis f
                                                FTSCUNN__c  = 9,   FTSCUNN2__c   =  9,  FTSCNTN__c  = 99, FTSCNTN2__c  = 99,    //A und
                                                FTSCHYN__c  = 7,   FTSCHYN2__c   =  7,  FTSCHYTN__c = 99, FTSCHYTN2__c = 99     //A hyp
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
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 12));  
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_TSCYC'
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '1',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'FollowUp',
                                                            STATUS__c = 'Complete');
        
        insert summary;  
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_TSCYC', '1');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_TSCC_TSCYC_F__c> ObjList = new List<DS_TSCC_TSCYC_F__c>();
        
        //init object w/ required vals
        DS_TSCC_TSCYC_F__c obj = new DS_TSCC_TSCYC_F__c(client__c = client.id,                                                              //client
                                                        SECTION__c = '1',                                                               //section
                                                        FDOATSCYC__c = System.today(),                                                  //date                                              
                                                        FPTSTOT_R__c= 90,  FPTSTOT_R2__c = 90,  FPTSTOT_T__c= 40, FPTSTOT_T2__c= 40,    //YC tot
                                                        FANX_R__c   = 20,  FANX_R2__c    = 20,  FANX_T__c   = 40, FANX_T2__c   = 40,    //YC anx
                                                        FDEP_R__c   = 20,  FDEP_R2__c    = 20,  FDEP_T__c   = 40, FDEP_T2__c   = 40,    //YC dep
                                                        FANG_R__c   = 20,  FANG_R2__c    = 20,  FANG_T__c   = 40, FANG_T2__c   = 40,    //YC ang
                                                        FSC_R__c    = 20,  FSC_R2__c     = 20,  FSC_T__c    = 40, FSC_T2__c    = 40,    //YC sc
                                                        FDIS_R__c   = 20,  FDIS_R2__c    = 20,  FDIS_T__c   = 40, FDIS_T2__c   = 40,    //YC dis
                                                        FPTSI_R__c  = 20,  FPTSI_R2__c   = 20,  FPTSI_T__c  = 40, FPTSI_T2__c  = 40,    //YC pts i 
                                                        FPTSAV_R__c = 20,  FPTSAV_R2__c  = 20,  FPTSAV_T__c = 40, FPTSAV_T2__c = 40,    //YC pts av
                                                        FPTSAR_R__c = 20,  FPTSAR_R2__c  = 20,  FPTSAR_T__c = 40, FPTSAR_T2__c = 40,    //YC pts ar
                                                        FRL_R__c    = 5,   FRL_R2__c     = 5,   FRL_T__c    = 40, FRL_T2__c    = 40,    //YC rl
                                                        FATR_R__c   = 20,  FATR_R2__c    = 20,  FATR_T__c   = 40, FATR_T2__c   = 40     //YC atr
                                                        );  
                
        //set form's status 
        obj.STATUS_TSCYC__c = 'Complete';        
        
        //insert object
        insert obj;
        
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
        
        DS_TSCC_TSCYC_F__c tsc = [SELECT FDEP_R__c, FPTSAV_T2__c, FDOATSCYC__c
                                    FROM DS_TSCC_TSCYC_F__c
                                    WHERE id =: obj.id];
        
        // assert statements 
        System.assertEquals(tsc.FDEP_R__c, 20,'Incorrect Depression raw score.');
        System.assertEquals(tsc.FPTSAV_T2__c, 40,'Incorrect Avoidance T-score double entry.');
        System.assertEquals(tsc.FDOATSCYC__c, System.today(),'Date incorrect.');
        }
        
    /****
    *@description method to test controllers associated with object
    *TSCC 
    ****/
    static TestMethod void assertControllerTSCC_A() {   
    
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 12));
                
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_TSCC_A'
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '1',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'FollowUp',
                                                            STATUS__c = 'Complete');
        
        insert summary;  
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_TSCC_A', '1');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_TSCC_TSCYC_F__c> ObjList = new List<DS_TSCC_TSCYC_F__c>(); 
        
        //init object w/ required vals
        DS_TSCC_TSCYC_F__c obj = new DS_TSCC_TSCYC_F__c(client__c = client.id,                                                          //client
                                                        SECTION__c = '1',                                                               //section     
                                                        FDOATSCC__c = System.today(),                                                   //date    
                                                        FTSCAXN__c  = 8,  FTSCAXN2__c   = 8,    FTSCAXTN__c = 40, FTSCAXTN2__c = 40,    //A anx
                                                        FTSCDPN__c  = 8,  FTSCDPN2__c   = 8,    FTSCDPTN__c = 40, FTSCDPTN2__c = 40,    //A dep
                                                        FTSCAGG__c  = 8,  FTSCAGG2__c   = 8,    FTSCAGTN__c = 40, FTSCAGTN2__c = 40,    //A ang
                                                        FTSCPTN__c  = 8,  FTSCPTN2__c   = 8,    FTSCPTTN__c = 40, FTSCPTTN2__c = 40,    //A pts
                                                        FTSCDSN__c  = 8,  FTSCDSN2__c   = 8,    FTSCDSTN__c = 40, FTSCDSTN2__c = 40,    //A dis
                                                        FTSCODN__c  = 8,  FTSCODN2__c   = 8,    FTSCODTN__c = 40, FTSCODTN2__c = 40,    //A dis o
                                                        FTSCFNN__c  = 1,  FTSCFNN2__c   = 1,    FTSCFNTN__c = 40, FTSCFNTN2__c = 40,    //A dis f
                                                        FTSCUNN__c  = 6,  FTSCUNN2__c   = 6,    FTSCNTN__c  = 40, FTSCNTN2__c  = 40,    //A und
                                                        FTSCHYN__c  = 2,  FTSCHYN2__c   = 2,    FTSCHYTN__c = 40, FTSCHYTN2__c = 40     //A hyp
                                                        );  
                
        //set form's status 
        obj.STATUS_TSCC_A__c = 'Complete';        
        
        //insert object
        insert obj;
        
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
        
        DS_TSCC_TSCYC_F__c tsc = [SELECT FTSCAXN__c, FTSCAGTN2__c, FDOATSCC__c
                                    FROM DS_TSCC_TSCYC_F__c
                                    WHERE id =: obj.id];
        
        // assert statements 
        System.assertEquals(tsc.FTSCAXN__c, 8,'Incorrect Anxiety raw score.');
        System.assertEquals(tsc.FTSCAGTN2__c, 40,'Incorrect Anger T-score double entry.');
        System.assertEquals(tsc.FDOATSCC__c, System.today(),'Date incorrect.');
    }
}