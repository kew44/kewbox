/****
*@description This test provides code coverage for Client Summary Report
*
*@group Test Script 
*@group-content /ApexDocContent/Test/ClientSummaryReport.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
*
*@author KW
*@date 2/3/16
*@modified date
*Purpose: Coverage for ClientSummaryController
*
*@modified	10/31/16	KW	reduce SOQL with testStart/Stop()s
*@modified	11/1/16		KW	clean, try to increase coverage, add tscc section
****/

@isTest (SeeAllData=false)
public class TestClass_ClientSummaryReport {

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
        importData.cbcl();     
        importData.ptsd();      
    }
    
    /****
    *@description method to test controller with data from baseline objects
    *Young (<6) Child, Female test client 
    ****/
    static TestMethod void Test_ClientSummaryReportBaselineYoung() {
        
        TestClass_ClientSummaryReport clientSummary = new TestClass_ClientSummaryReport();
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 4));
        
        DS_Background_Family_Info_B__c background = new DS_Background_Family_Info_B__c(Client__c = client.id);
        
        background.BMET__c = '1';
        background.BDOV__c = date.today();
        background.RWHITE__c = true;
        
        DS_Functioning_Forms_B__c functioning = new DS_Functioning_Forms_B__c(Client__c = client.id);
        
        // Strengths
        functioning.BSTFAM__c = '2';
        functioning.BSTINTP__c = '1';
        functioning.BSTEDU__c = '0';
        
        // Indicators of Severity of Problems 6- (YC)
        functioning.BIMRISK__c = '2';
        functioning.BEMREG__c = '3';
        functioning.BFEEDING__c = '1';
        functioning.BIMRISK__c = '3';
        functioning.BISPSUIC__c = '2';
        functioning.BISPSINJ__c = '2';
        
        // Service Use
        functioning.BOSINPSY__c = '1';
        functioning.BLTINPSY__c = '1';
        functioning.BOSRES__c = '1';
        functioning.BLTRES__c = '1';
        
        // Clinical Evaluation
        functioning.BCEADHD__c = '1';
        functioning.BCEBIPL__c = '1';
        functioning.BCEPRIM__c = '2';
        
        //SDQ
        DS_SDQ_PSI_CDI_B__c sdq = new DS_SDQ_PSI_CDI_B__c(client__c = client.id);
        
        //method required
      //  sdq.BMETSDOP__c = '0';
        //sdq.BMETSDOS__c = '0';
        sdq.BMETSDYP__c = '0';
        
        //Date required
        sdq.BDOASDYP__c = date.today();
       // sdq.BDOASDOS__c = date.today();
        //sdq.BDOASDOP__c = date.today();
        
        //PSI
        //date required
        sdq.BDOAPSI__c = date.today();
        
        //all responses required, double entry
        sdq.BPSIPD_PTLE__c = sdq.BPSIPD_PTLE2__c = 50;
        sdq.BPSIPCDI_PTLE__c = sdq.BPSIPCDI_PTLE2__c = 50;
        sdq.BPSIDR_PTLE__c = sdq.BPSIDR_PTLE2__c = 50;
        sdq.BPSIDC_PTLE__c = sdq.BPSIDC_PTLE2__c = 50;
        sdq.BPSITS_PTLE__c = sdq.BPSITS_PTLE2__c = 50;
        sdq.BPSITS__c = sdq.BPSITS2__c = 38;
        sdq.BPSIPD__c = sdq.BPSIPD2__c = 13;
        sdq.BPSIPCDI__c = sdq.BPSIPCDI2__c = 13;
        sdq.BPSIDC__c = sdq.BPSIDC2__c = 13;
        sdq.BPSIDR__c = sdq.BPSIDR2__c = 9;        
        
        // Trauma
        DS_GTRAUMA__c trauma = new DS_GTRAUMA__c(client__c = client.id);
        
        trauma.GT1R__c = trauma.GT2R__c = trauma.GT3R__c = trauma.GT4R__c = '1';
        trauma.GT5R__c = trauma.GT6R__c = trauma.GT7R__c = trauma.GT8R__c = '1';
        trauma.GT9R__c = trauma.GT10R__c = trauma.GT11R__c = trauma.GT12R__c = '1';
        trauma.GT13R__c = trauma.GT14R__c = trauma.GT15R__c = trauma.GT16R__c = '1';
        trauma.GT17R__c = trauma.GT18R__c = trauma.GT19R__c = trauma.GT20R__c = '1';
        trauma.GT21R__c = trauma.GT22R__c = trauma.GT23R__c = '1';
        
        trauma.GT1RA0__c = true;
        trauma.GT2RA0__c = true;
        
        //CBCL Young
        DS_CBCL_B__c cbcl = new DS_CBCL_B__c(client__c = client.id);
        
        //required values
        cbcl.BDOACY__c = date.today(); 
        cbcl.BCBYMETH__c = '1';
        cbcl.BCBAPPCN__c = 0;
        
        //PTSD
        DS_PTSD_CA_B__c ptsd = new DS_PTSD_CA_B__c(client__c = client.id);
        
        ptsd.BMETPTSD__c = '1';
        ptsd.BMETPTSDP__c = '1';
        ptsd.BDOAPTSD__c = date.today();
        ptsd.BDOAPTSDP__c = date.today();
        ptsd.STATUS_PTSD_CA__c = 'Complete';
        ptsd.STATUS_PTSD_PA__c = 'Complete';
        
        //TSCYC
        DS_TSCC_TSCYC_B__c tscc = new DS_TSCC_TSCYC_B__c(client__c = client.id); 
        
        tscc.BDOATSCYC__c= date.today();                                                                                           
        tscc.BPTSTOT_R__c= tscc.BPTSTOT_R2__c= 70;
        tscc.BPTSTOT_T__c= tscc.BPTSTOT_T2__c= 67;
        tscc.BANX_T__c   = tscc.BANX_T2__c   = 67;
        tscc.BDEP_T__c   = tscc.BDEP_T2__c   = 67;
        tscc.BATR_T__c   = tscc.BATR_T2__c   = 67;
        tscc.BPTSAR_T__c = tscc.BPTSAR_T2__c = 67;
        tscc.BPTSAV_T__c = tscc.BPTSAV_T2__c = 67;
        tscc.BPTSI_T__c  = tscc.BPTSI_T2__c  = 67;
        tscc.BDIS_T__c   = tscc.BDIS_T2__c   = 67;
        tscc.BSC_T__c    = tscc.BSC_T2__c    = 67;
        tscc.BANG_T__c   = tscc.BANG_T2__c   = 67;    
        tscc.BRL_T__c    = tscc.BRL_T2__c    = 67;
        tscc.BANX_R__c   = tscc.BANX_R2__c   = 30;
        tscc.BATR_R__c   = tscc.BATR_R2__c   = 30;
        tscc.BDEP_R__c   = tscc.BDEP_R2__c   = 30;
        tscc.BANG_R__c   = tscc.BANG_R2__c   = 30;
        tscc.BSC_R__c    = tscc.BSC_R2__c    = 30;
        tscc.BDIS_R__c   = tscc.BDIS_R2__c   = 30;
        tscc.BPTSI_R__c  = tscc.BPTSI_R2__c  = 30;
        tscc.BPTSAV_R__c = tscc.BPTSAV_R2__c = 30;
        tscc.BPTSAR_R__c = tscc.BPTSAR_R2__c = 30;  
        tscc.BRL_R__c = tscc.BRL_R2__c = 6;   
          
		tscc.SECTION__c = '0';  
        tscc.STATUS_TSCYC__c = 'Complete';
		
		//try inserting all inside of the test block		
		test.startTest();
			insert background;
			insert functioning;
			insert trauma;
			insert cbcl;
			insert ptsd;
			insert sdq;
			insert tscc;
		test.stopTest();
                
        String cimi = ut.urlEncode('c='+client.id+'&section=0');
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        ClientSummaryReportController controller= new ClientSummaryReportController(sc);        
        
    }
    
    /****
    *@description method to test controller with data from baseline objects
    *Old (>6) Child, Male test client 
    ****/
    static TestMethod void Test_ClientSummaryReportBaselineOld() {
        
        TestClass_ClientSummaryReport clientSummary = new TestClass_ClientSummaryReport();
        
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 14));
                
        DS_Background_Family_Info_B__c background = new DS_Background_Family_Info_B__c();
        
        background.Client__c = client.id;
        background.BMET__c = '1';
        background.BDOV__c = date.today();
        background.RWHITE__c = true;
        
        DS_Functioning_Forms_B__c functioning = new DS_Functioning_Forms_B__c();
        
        functioning.Client__c = client.id;
        
        // Indicators of Severity of Problems 
        functioning.BISPACAD__c = '2';
        functioning.BISPBEHS__c = '3';
        functioning.BISPSKPS__c = '1';
        functioning.BISPSUIC__c = '2';
        functioning.BISPSINJ__c = '2';
                
       //SDQ
        DS_SDQ_PSI_CDI_B__c sdq= new DS_SDQ_PSI_CDI_B__c(client__c = client.id);
        
        //method required
        sdq.BMETSDOP__c = '0';
        sdq.BMETSDOS__c = '0';
       // sdq.BMETSDYP__c = '0';
        
        //Date required
      //  sdq.BDOASDYP__c = date.today();
        sdq.BDOASDOS__c = date.today();
        sdq.BDOASDOP__c = date.today();
        
        //PSI
        //date required
        sdq.BDOAPSI__c = date.today();
        
        //all responses required, double entry
        sdq.BPSIPD_PTLE__c = sdq.BPSIPD_PTLE2__c = 50;
        sdq.BPSIPCDI_PTLE__c = sdq.BPSIPCDI_PTLE2__c = 50;
        sdq.BPSIDR_PTLE__c = sdq.BPSIDR_PTLE2__c = 50;
        sdq.BPSIDC_PTLE__c = sdq.BPSIDC_PTLE2__c = 50;
        sdq.BPSITS_PTLE__c = sdq.BPSITS_PTLE2__c = 50;
        sdq.BPSITS__c = sdq.BPSITS2__c = 38;
        sdq.BPSIPD__c = sdq.BPSIPD2__c = 13;
        sdq.BPSIPCDI__c = sdq.BPSIPCDI2__c = 13;
        sdq.BPSIDC__c = sdq.BPSIDC2__c = 13;
        sdq.BPSIDR__c = sdq.BPSIDR2__c = 9;      
        
        //CBCL
        DS_CBCL_B__c cbcl = new DS_CBCL_B__c(client__c = client.id);
        
        //required values
        cbcl.BDOACO__c = date.today(); 
        cbcl.BCBOMETH__c = '1';
       
        //PTSD 
        DS_PTSD_CA_B__c ptsd = new DS_PTSD_CA_B__c(client__c = client.id);
        
        ptsd.BMETPTSD__c = '1';
        ptsd.BMETPTSDP__c = '1';
        ptsd.BDOAPTSD__c = date.today();
        ptsd.BDOAPTSDP__c = date.today();  
        ptsd.STATUS_PTSD_CA__c = 'Complete';
        ptsd.STATUS_PTSD_PA__c = 'Complete';
        
        ptsd.BPTSV1__c = ptsd.BPTSV2__c = ptsd.BPTSV3__c = ptsd.BPTSV4__c = '1';
        ptsd.BPTSV6__c = ptsd.BPTSV7__c = ptsd.BPTSV8__c = ptsd.BPTSV9__c = ptsd.BPTSV10__c = '4';
        ptsd.BPTSV11__c = ptsd.BPTSV12__c = ptsd.BPTSV13__c = ptsd.BPTSV14__c = ptsd.BPTSV15__c = '4';
        ptsd.BPTSV16__c = ptsd.BPTSV17__c = ptsd.BPTSV18__c = ptsd.BPTSV19__c = ptsd.BPTSV20__c ='2';
        ptsd.BPTSV21__c = ptsd.BPTSV22__c = ptsd.BPTSV23__c = ptsd.BPTSV24__c = ptsd.BPTSV25__c ='3';
        ptsd.BPTSV26__c = ptsd.BPTSV27__c = ptsd.BPTSV28__c = ptsd.BPTSV29__c = ptsd.BPTSV30__c ='1';
                
       //TSCC-A
        DS_TSCC_TSCYC_B__c tscc= new DS_TSCC_TSCYC_B__c(client__c = client.id );
        
        tscc.BDOATSCC__c = date.today();         
        tscc.BTSCHYTN__c = tscc.BTSCHYTN2__c = 90; 
        tscc.BTSCNTN__c  = tscc.BTSCNTN2__c  = 67;                                                
        tscc.BTSCAXTN__c = tscc.BTSCAXTN2__c = tscc.BTSCDPTN__c = tscc.BTSCDPTN2__c= tscc.BTSCPTTN2__c= tscc.BTSCDSTN__c = tscc.BTSCDSTN2__c = 62;    
        tscc.BTSCODTN__c = tscc.BTSCODTN2__c = tscc.BTSCFNTN__c = tscc.BTSCAGTN__c = tscc.BTSCPTTN__c = tscc.BTSCAGTN2__c= tscc.BTSCFNTN2__c = 62;  
        tscc.BTSCAXN__c  = tscc.BTSCDPN2__c  = tscc.BTSCAGG__c  = tscc.BTSCDSN__c  = tscc.BTSCODN__c  = tscc.BTSCODN2__c   = 20;
        tscc.BTSCDPN__c  = tscc.BTSCAXN2__c  = tscc.BTSCPTN__c  = tscc.BTSCAGG2__c = tscc.BTSCPTN2__c = tscc.BTSCDSN2__c   = 20;          
        tscc.BTSCFNN__c  = tscc.BTSCFNN2__c  =  7;  
        tscc.BTSCHYN__c  = tscc.BTSCHYN2__c  =  5; 
        tscc.BTSCUNN__c  = tscc.BTSCUNN2__c  =  3;  
		
		tscc.SECTION__c = '0';  
        tscc.STATUS_TSCC_A__c = 'Complete'; 
        
		//try inserting all inside of the test block		
		test.startTest();
			insert background;
			insert functioning;
			insert cbcl;
			insert ptsd;
			insert sdq;
			insert tscc;
		test.stopTest();
		
        String cimi = ut.urlEncode('c='+client.id+'&section=0');
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        ClientSummaryReportController controller= new ClientSummaryReportController(sc);
        
    }
    
}