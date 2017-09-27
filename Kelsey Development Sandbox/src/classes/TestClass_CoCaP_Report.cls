/****
*@description This test provides code coverage CoCaP reports
*
*@group Test Script 
*@group-content /ApexDocContent/Test/CoCaP.htm
*
*@author Kelsey Willett
*@date 3/27/17
*
*@modified    3/30/17    KW update Cocap name
*@modified  4/10-11/17 KW  increase coverage
*@modified  4/20/17 KW  describe test methods, separate tscc/yc testing to avoid soql limits 
*@modified	6/26-7/17	KW	updates based on data team feedback coverage
*@modified	7/18/17		KW	update coverage
*@modified	8/2-3/2017	KW remove unused methods, simplified names (age range_gender identity_other conditions), add more conditions
*@modified	8/10/17	KW	gender/sex update , CoCaP case
*
****/
@isTest (SeeAllData=false)
public class TestClass_CoCaP_Report{

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
    }
    
    /****
    *@description test client 
	* 0-4
	* Gender Identity Missing
	* no start/end dates or dov
	****/
    static TestMethod void Test_04_Null_noDates(){
		
       TestClass_CoCaP_Report testReport = new TestClass_CoCaP_Report() ;
        
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 4));
		
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        CoCaP_Report_Controller controller= new CoCaP_Report_Controller(sc);
        controller.getData();
		controller.getTime();
		
       List<DS_Background_Family_Info_B__c> baselineList  = controller.getBaselineRecords();
       controller.printReport = false;
       controller.init();
	}
	
    /****
    *@description test client 
	* 0-4
	* Male
	* Military Missing
	* Non-Hispanic
	* Native American
	* Baseline in range
	* CBCLY B&F, PSI B&F, SDQYP B&F, TSCYC B&F
	****/
    static TestMethod void Test_04_M(){
		
       TestClass_CoCaP_Report testReport = new TestClass_CoCaP_Report() ;
        
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 4));
        DS_Background_Family_Info_B__c b = new DS_Background_Family_Info_B__c(Client__c = client.id);	
        DS_CBCL_B__c cb = new DS_CBCL_B__c(Client__c = client.id);	
        DS_CBCL_F__c cf = new DS_CBCL_F__c(Client__c = client.id);	
        DS_SDQ_PSI_CDI_B__c sb = new DS_SDQ_PSI_CDI_B__c(Client__c = client.id);
        DS_SDQ_PSI_CDI_F__c sf = new DS_SDQ_PSI_CDI_F__c(Client__c = client.id);
        DS_TSCC_TSCYC_B__c tb = new DS_TSCC_TSCYC_B__c(Client__c = client.id);
        DS_TSCC_TSCYC_F__c tf = new DS_TSCC_TSCYC_F__c(Client__c = client.id);
		
		//baseline
        b.BDOV__c = date.today();
        b.BIDENT__c = '1';
        b.ETHNIC__c = '2';
        b.RINDIAN__c = true;
		
		//assessments
		//cbcly
		cb.BDOACY__c = date.today();
        cb.BCBYMETH__c = '1';
		cf.FDOACY__c = date.today();
        cf.FCBYMETH__c = '1';
		//psi & sdqyp
		sb.BDOAPSI__c = date.today();
		sb.BDOASDYP__c = date.today();
		sf.FDOAPSI__c = date.today();
		sf.FDOASDYP__c = date.today();
		//tscyc
		tb.BDOATSCYC__c = date.today();	
		tf.FDOATSCYC__c = date.today();	
		tb.SECTION__c ='0';
		tf.SECTION__c = '1';
		
        test.startTest();
            insert b;
			insert cb;
			insert cf;
			insert sb;
			insert sf;
			insert tb;
			insert tf;
        test.stopTest();
		
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        CoCaP_Report_Controller controller= new CoCaP_Report_Controller(sc);

        controller.StartDate  = System.today(); 
        controller.EndDate  = System.today(); 
        controller.getData();
		controller.getTime();
		
       List<DS_Background_Family_Info_B__c> baselineList  = controller.getBaselineRecords();
	   List<DS_Background_Family_Info_F__c> followupList = controller.getFollowupRecords();
	   String genderId = controller.getGenderLabel(b.BIDENT__c, client.GENDER__c);
	   String ethnicGroup = controller.getEthnicGroup(b.ETHNIC__c);
	   Set<String> cbclBClients = controller.getCbclBClients();
	   Set<String> cbclFClients = controller.getCbclFClients();
	   Set<String> sdqpsiBClients = controller.getSdqPsiBClients();
	   Set<String> sdqpsiFClients = controller.getSdqPsiFClients();
	   Set<String> tsccaycBClients = controller.getTsccAYcBClients();
	   Set<String> tsccaycFClients = controller.getTsccAYcFClients();
       controller.printReport = false;
       controller.init();
	}
	
    /****
    *@description test client 
	* 5-9
	* Female
	* Gender Identity Missing
	* Non-Military
	* Ethnicity missing
	* Multiracial
	* Baseline in range
	* CBCLO B&F
	****/
    static TestMethod void Test_59_F(){	
		
       TestClass_CoCaP_Report testReport = new TestClass_CoCaP_Report();
        
        Client__c client = test_ut.createClient(test_ut.getClient('', 6));	
        DS_Background_Family_Info_B__c b = new DS_Background_Family_Info_B__c(Client__c = client.id);
        DS_CBCL_B__c cb = new DS_CBCL_B__c(Client__c = client.id);	
        DS_CBCL_F__c cf = new DS_CBCL_F__c(Client__c = client.id);	
		
		b.BIDENT__c = '2';
        b.BDOV__c = date.today();
        //race
        b.RINDIAN__c = true;
        b.RAKNTV__c = true;
        b.RASIANIN__c = true;
        b.RCHINESE__c = true;
        b.RFILIPINO__c = true;
        b.RJAPANESE__c = true;
        b.RKOREAN__c = true;
        b.RVIETNAMESE__c = true;
        b.ROASIAN__c = true;
        b.ROASIAN__c = true;
        b.RBLACK__c = true;
        b.RHAWAN__c = true;
        b.RGUAM__c = true;
        b.RSAMOA__c = true;
        b.ROPI__c = true;
        b.RWHITE__c = true;
		b.RUNK__c = true;
		b.BMILSELF__c = '0';
		//assessments
		//cbclo
		cb.BDOACO__c = date.today();
        cb.BCBOMETH__c = '1';
		cf.FDOACO__c = date.today();
        cf.FCBOMETH__c = '1';
		
        test.startTest();
            insert b;
			insert cb;
			insert cf;
        test.stopTest();
				
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        CoCaP_Report_Controller controller= new CoCaP_Report_Controller(sc);

        controller.StartDate  = System.today(); 
        controller.EndDate  = System.today(); 
        controller.getData();
		controller.getTime();
		
       List<DS_Background_Family_Info_B__c> baselineList  = controller.getBaselineRecords();
	   List<DS_Background_Family_Info_F__c> followupList = controller.getFollowupRecords();
	   String genderId = controller.getGenderLabel(b.BIDENT__c, client.GENDER__c);
	   String ethnicGroup = controller.getEthnicGroup(b.ETHNIC__c);
       controller.printReport = false;
       controller.init();
	}
	
    /****
    *@description test client 
	* 10-12
	* Transgender
	* Military
	* Ethnicity refused
	* Black
	* Baseline in range
	* Followup in range, not closed
	* SDQOP B&F, TSCCA B&F
	****/
    static TestMethod void Test_1012_T(){		
		
       TestClass_CoCaP_Report testReport = new TestClass_CoCaP_Report();
        
        Client__c client = test_ut.createClient(test_ut.getClient('Trans', 12));
        DS_Background_Family_Info_B__c b = new DS_Background_Family_Info_B__c(Client__c = client.id);
        DS_Background_Family_Info_F__c f = new DS_Background_Family_Info_F__c(Client__c = client.id);
        DS_SDQ_PSI_CDI_B__c sb = new DS_SDQ_PSI_CDI_B__c(Client__c = client.id);
        DS_SDQ_PSI_CDI_F__c sf = new DS_SDQ_PSI_CDI_F__c(Client__c = client.id);
        DS_TSCC_TSCYC_B__c tb = new DS_TSCC_TSCYC_B__c(Client__c = client.id);
        DS_TSCC_TSCYC_F__c tf = new DS_TSCC_TSCYC_F__c(Client__c = client.id);
		
		//baseline
        //date
        b.BDOV__c = date.today();
        //race
        b.BIDENT__c = '3';
        b.ETHNIC__c = '96';
        b.RBLACK__c = true;
		b.BMILSELF__c = '1';
		b.BMILFAMILY__c ='1';
		
		//followup
		f.FDOV__c = date.today();
        f.FUTYPE__c = '3';
        f.FMSTAT__c = '1';
		
		//assessment sdq op		
		sb.BDOASDOP__c = date.today();
		sf.FDOASDOP__c = date.today();
		
		//tscca
		tb.BDOATSCC__c = date.today();	
		tf.FDOATSCC__c = date.today();	
		tb.SECTION__c ='0';
		tf.SECTION__c = '1';
		
        test.startTest();
            insert b;
			insert f;
			insert sb;
			insert sf;
			insert tb;
			insert tf;
        test.stopTest();
		
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        CoCaP_Report_Controller controller= new CoCaP_Report_Controller(sc);

        controller.StartDate  = System.today(); 
        controller.EndDate  = System.today(); 
        controller.getData();
		controller.getTime();
		
       List<DS_Background_Family_Info_B__c> baselineList  = controller.getBaselineRecords();
	   List<DS_Background_Family_Info_F__c> followupList = controller.getFollowupRecords();
	   String genderId = controller.getGenderLabel(b.BIDENT__c, client.GENDER__c);
	   String ethnicGroup = controller.getEthnicGroup(b.ETHNIC__c);
	   Set<String> sdqpsiBClients = controller.getSdqPsiBClients();
	   Set<String> sdqpsiFClients = controller.getSdqPsiFClients();
	   Set<String> tsccaycBClients = controller.getTsccAYcBClients();
	   Set<String> tsccaycFClients = controller.getTsccAYcFClients();
       controller.printReport = false;
       controller.init();
	}
		
    /****
    *@description test client 
	* 10-12
	* Gender Identity Missing
	* Non-Military
	* Hispanic
	* Asian
	* Baseline BEFORE range
	* 2X Followup in range, different days
	* PTSD B & F 
	****/
    static TestMethod void Test_1012_Null_2Fs(){		
		
       TestClass_CoCaP_Report testReport = new TestClass_CoCaP_Report();
        
        Client__c client = test_ut.createClient(test_ut.getClient('', 11));
        DS_Background_Family_Info_B__c b = new DS_Background_Family_Info_B__c(Client__c = client.id, SECTION__c = '0', BDOV__c = date.today()-7);
        DS_Background_Family_Info_F__c f = new DS_Background_Family_Info_F__c(Client__c = client.id, SECTION__c = '1', FDOV__c = date.today()-3);
        DS_Background_Family_Info_F__c f2 = new DS_Background_Family_Info_F__c(Client__c = client.id, SECTION__c = '2', FDOV__c = date.today()-2);
        DS_PTSD_CA_B__c pb = new DS_PTSD_CA_B__c(Client__c = client.id);
        DS_PTSD_CA_F__c pf = new DS_PTSD_CA_F__c(Client__c = client.id);
		
		//baseline
        b.ETHNIC__c = '1';
        b.ETHNICHSA__c = true;
        b.RASIANIN__c = true;
		b.BMILSELF__c = '0';
		b.BMILFAMILY__c = '0';
		
		//followup
        f.FUTYPE__c = '0';
        f.FETSTAT__c= '1';
		f.FMSTAT__c = '0';
		//f2
        f2.FUTYPE__c = '2';
        f2.FETSTAT__c= '1';
		f2.FMSTAT__c = '0';
		
		//ptsd b+ f 
		pb.BDOAPTSD__c = date.today()-5;
        pb.BMETPTSD__c = '1';
		pb.BDOAPTSDP__c = date.today()-5;
        pb.BMETPTSDP__c = '1';
		pb.SECTION__c ='0';
		pf.SECTION__c = '1';
        pf.FDOAPTSD__c = date.today()-1;
        pf.FMETPTSD__c = '1';
        pf.FDOAPTSDP__c = date.today()-1;
        pf.FMETPTSDP__c = '1';
				
        test.startTest();
            insert b;
			insert f;
			insert f2;
			insert pb;
			insert pf;
        test.stopTest();
		
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        CoCaP_Report_Controller controller= new CoCaP_Report_Controller(sc);
        controller.StartDate  = System.today()-5; 
        controller.EndDate  = System.today(); 
        controller.getData();
		controller.getTime();
		
       List<DS_Background_Family_Info_B__c> baselineList  = controller.getBaselineRecords();
	   String genderId = controller.getGenderLabel(b.BIDENT__c, client.GENDER__c);
	   String ethnicGroup = controller.getEthnicGroup(b.ETHNIC__c);
	}
	
	/****
    *@description test client 
	* 13-17
	* Other Gender
	* Military 
	* Ethnicity Missing
	* Islander
	* Baseline in range
	* 2X Followup in range,same date, both COMPLETED as planned
	* SDQOS B & F
	****/
    static TestMethod void Test_1317_O_2Fs(){
		
       TestClass_CoCaP_Report testReport = new TestClass_CoCaP_Report() ;
        
        Client__c client = test_ut.createClient(test_ut.getClient('Other', 17));
        DS_Background_Family_Info_B__c b = new DS_Background_Family_Info_B__c(Client__c = client.id);
        DS_Background_Family_Info_F__c f = new DS_Background_Family_Info_F__c(Client__c = client.id, SECTION__c = '1' ,FDOV__c = date.today());
        DS_Background_Family_Info_F__c f2 = new DS_Background_Family_Info_F__c(Client__c = client.id, SECTION__c = '2', FDOV__c = date.today());
        DS_SDQ_PSI_CDI_B__c sb = new DS_SDQ_PSI_CDI_B__c(Client__c = client.id);
        DS_SDQ_PSI_CDI_F__c sf = new DS_SDQ_PSI_CDI_F__c(Client__c = client.id);
		
		//baseline
        b.BDOV__c = date.today();
		b.RHAWAN__c = true;
		b.BMILFAMILY__c = '1';
		b.BIDENT__c = '98';
		b.BIDENTSP__c ='Other';
		
		//followup
		f.FUTYPE__c = '2';
		f.FETSTAT__c = '1';
		f2.FUTYPE__c = '2';
		f2.FETSTAT__c = '1';
		
		//assessment sdqos
		sb.BDOASDOS__c = date.today();
		sf.FDOASDOS__c = date.today();
		
        test.startTest();
            insert b;
			insert f;
			insert f2;
			insert sb;
			insert sf;
        test.stopTest();
		
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        CoCaP_Report_Controller controller= new CoCaP_Report_Controller(sc);
        controller.StartDate  = System.today(); 
        controller.EndDate  = System.today(); 
        controller.getData();
		controller.getTime();
		
       List<DS_Background_Family_Info_B__c> baselineList  = controller.getBaselineRecords();
	   List<DS_Background_Family_Info_F__c> followupList = controller.getFollowupRecords();
	   String genderId = controller.getGenderLabel(b.BIDENT__c, client.GENDER__c);
	   String ethnicGroup = controller.getEthnicGroup(b.ETHNIC__c);
	   Set<String> sdqpsiBClients = controller.getSdqPsiBClients();
       controller.printReport = false;
       controller.init();
	}
				
	/****
    *@description test client 
	* 18-21
	* Unknown/declined to provide Gender
	* Non-Military 
	* Ethnicity Missing
	* White
	* Baseline BEFORE range
	* Followup BEFORE range, CLOSED
	****/
    static TestMethod void Test_1821_R(){
		
       TestClass_CoCaP_Report testReport = new TestClass_CoCaP_Report() ;
        
        Client__c client = test_ut.createClient(test_ut.getClient('Refused', 21));
        DS_Background_Family_Info_B__c b = new DS_Background_Family_Info_B__c(Client__c = client.id);
        DS_Background_Family_Info_F__c f = new DS_Background_Family_Info_F__c(Client__c = client.id);
		
		//baseline
        b.BDOV__c = date.today()-7;
		b.RWHITE__c = true;
		b.BMILFAMILY__c = '0';
		b.BIDENT__c = '99';
		
		//followup
		f.FDOV__c = date.today()-5;
		f.FUTYPE__c = '2';
		f.FETSTAT__c = '0';
		
        test.startTest();
            insert b;
			insert f;
        test.stopTest();
		
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        CoCaP_Report_Controller controller= new CoCaP_Report_Controller(sc);
        controller.StartDate  = System.today()-4; 
        controller.EndDate  = System.today()-3; 
        controller.getData();
		controller.getTime();
		
       List<DS_Background_Family_Info_B__c> baselineList  = controller.getBaselineRecords();
	   List<DS_Background_Family_Info_F__c> followupList = controller.getFollowupRecords();
	   String genderId = controller.getGenderLabel(b.BIDENT__c, client.GENDER__c);
	   String ethnicGroup = controller.getEthnicGroup(b.ETHNIC__c);
       controller.printReport = false;
       controller.init();
	}
	
	/****
    *@description test client 
	* 18-21
	* Gender Identity Missing
	* Military refused/unknown
	* Ethnicity Missing
	* Race Unknown
	* Baseline AFTER end date
	* Followup AFTER end date
	* dates not in order
	****/
    static TestMethod void Test_1821_Null(){
		
       TestClass_CoCaP_Report testReport = new TestClass_CoCaP_Report();
        
        Client__c client = test_ut.createClient(test_ut.getClient('', 21));
        DS_Background_Family_Info_B__c b = new DS_Background_Family_Info_B__c(Client__c = client.id);
        DS_Background_Family_Info_F__c f = new DS_Background_Family_Info_F__c(Client__c = client.id);
		
        //date
        b.BDOV__c = date.today();
        //race
		b.RUNK__c = true;
		//military
		b.BMILFAMILY__c = '96';
		b.BMILSELF__c = '99';
		
        //followup
        f.FDOV__c = date.today();
        f.FUTYPE__c = '2';
		
        test.startTest();
            insert b;
			insert f;
        test.stopTest();
		
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        CoCaP_Report_Controller controller= new CoCaP_Report_Controller(sc);
        controller.StartDate  = System.today(); 
        controller.EndDate  = System.today()-10; 
        controller.getData();
		controller.getTime();
		
       List<DS_Background_Family_Info_B__c> baselineList  = controller.getBaselineRecords();
	   List<DS_Background_Family_Info_F__c> followupList = controller.getFollowupRecords();
	   String genderId = controller.getGenderLabel(b.BIDENT__c, client.GENDER__c);
	   String ethnicGroup = controller.getEthnicGroup(b.ETHNIC__c);
       controller.printReport = false;
       controller.init();
	}
	   
	/****
    *@description test client 
	* 18-21
	* Unknown/declined to provide Gender
	* Non-Military
	* Hispanic, unknown group
	* White
	* Baseline in range
	* Followup in range, COMPLETED 
	****/
    static TestMethod void Test_1821_U(){
		
       TestClass_CoCaP_Report testReport = new TestClass_CoCaP_Report();
        
        Client__c client = test_ut.createClient(test_ut.getClient('Unknown', 20));
        DS_Background_Family_Info_B__c b = new DS_Background_Family_Info_B__c(Client__c = client.id);
        DS_Background_Family_Info_F__c f = new DS_Background_Family_Info_F__c(Client__c = client.id);
		
        //date
        b.BDOV__c = date.today();
		b.RWHITE__c = true;
		b.ETHNIC__c = '1';
		b.ETHNICHUK__c = true;
		b.BIDENT__c = '99';
		b.BMILFAMILY__c ='0';
		b.BMILSELF__c='0';
		
        //followup
        f.FDOV__c = date.today();
        f.FUTYPE__c = '2';
		f.FETSTAT__c = '0';
		f.FMSTAT__c = '0';
		
        test.startTest();
            insert b;
			insert f;
        test.stopTest();
		
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        CoCaP_Report_Controller controller= new CoCaP_Report_Controller(sc);
        controller.StartDate  = System.today(); 
        controller.EndDate  = System.today(); 
        controller.getData();
		controller.getTime();
		
       List<DS_Background_Family_Info_B__c> baselineList  = controller.getBaselineRecords();
	   List<DS_Background_Family_Info_F__c> followupList = controller.getFollowupRecords();
	   String genderId = controller.getGenderLabel(b.BIDENT__c, client.GENDER__c);
	   String ethnicGroup = controller.getEthnicGroup(b.ETHNIC__c);
       controller.printReport = false;
       controller.init();
	}
		
}