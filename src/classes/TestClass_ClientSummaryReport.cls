@isTest (SeeAllData=false)
public class TestClass_ClientSummaryReport {
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    // Age < 6
    static TestMethod void Test_ClientSummaryReportBaselineYoung() {
        
        Utility ut = new Utility();
        
        TestClass_A_Utility test_ut = new TestClass_A_Utility(); 
        TestClass_ClientSummaryReport clientSummary = new TestClass_ClientSummaryReport();
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 4));
        
        DS_Background_Family_Info_B__c background = new DS_Background_Family_Info_B__c();
        
        background.Client__c = client.id;
        background.BMET__c = '1';
        background.BDOV__c = date.today();
        background.RWHITE__c = true;
        
        insert background;
        
        DS_Functioning_Forms_B__c functioning = new DS_Functioning_Forms_B__c();
        
        functioning.Client__c = client.id;
        
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
        
        insert functioning;
        
        //SDQ
        DS_SDQ_PSI_CDI_B__c sdq = new DS_SDQ_PSI_CDI_B__c(client__c = client.id);
        
        //method required
        sdq.BMETSDOP__c = '0';
        sdq.BMETSDOS__c = '0';
        sdq.BMETSDYP__c = '0';
        
        //Date required
        sdq.BDOASDYP__c = date.today();
        sdq.BDOASDOS__c = date.today();
        sdq.BDOASDOP__c = date.today();
        
        insert sdq;
        
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
        
        //insert trauma;
        
        //CBCL Young
        clientSummary.insertCBCLYoung(client);
        
        String cimi = ut.urlEncode('c='+client.id+'&section=0');
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        ClientSummaryReportController controller= new ClientSummaryReportController(sc);
        
        
    }
    
    // Age > 6
    static TestMethod void Test_ClientSummaryReportBaselineOld() {
        
        Utility ut = new Utility();
        
        TestClass_A_Utility test_ut = new TestClass_A_Utility(); 
        TestClass_ClientSummaryReport clientSummary = new TestClass_ClientSummaryReport();
        
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 14));
                
        DS_Background_Family_Info_B__c background = new DS_Background_Family_Info_B__c();
        
        background.Client__c = client.id;
        background.BMET__c = '1';
        background.BDOV__c = date.today();
        background.RWHITE__c = true;
        
        insert background;
        
        DS_Functioning_Forms_B__c functioning = new DS_Functioning_Forms_B__c();
        
        functioning.Client__c = client.id;
        
        // Indicators of Severity of Problems 
        functioning.BISPACAD__c = '2';
        functioning.BISPBEHS__c = '3';
        functioning.BISPSKPS__c = '1';
        functioning.BISPSUIC__c = '2';
        functioning.BISPSINJ__c = '2';
        
        insert functioning;
        
        //PTSD 
        DS_PTSD_CA_B__c ptsd = new DS_PTSD_CA_B__c(client__c = client.id);
        
        ptsd.BMETPTSD__c = '1';
        ptsd.BDOAPTSD__c = date.today();  
        
        ptsd.BPTSV1__c = ptsd.BPTSV2__c = ptsd.BPTSV3__c = ptsd.BPTSV4__c = '1';
        ptsd.BPTSV6__c = ptsd.BPTSV7__c = ptsd.BPTSV8__c = ptsd.BPTSV9__c = ptsd.BPTSV10__c = '4';
        ptsd.BPTSV11__c = ptsd.BPTSV12__c = ptsd.BPTSV13__c = ptsd.BPTSV14__c = ptsd.BPTSV15__c = '4';
        ptsd.BPTSV16__c = ptsd.BPTSV17__c = ptsd.BPTSV18__c = ptsd.BPTSV19__c = ptsd.BPTSV20__c ='2';
        ptsd.BPTSV21__c = ptsd.BPTSV22__c = ptsd.BPTSV23__c = ptsd.BPTSV24__c = ptsd.BPTSV25__c ='3';
        ptsd.BPTSV26__c = ptsd.BPTSV27__c = ptsd.BPTSV28__c = ptsd.BPTSV29__c = ptsd.BPTSV30__c ='1';
        
        insert ptsd;
        
        // CBCL Old
        clientSummary.insertCBCLOld(client);
        
        String cimi = ut.urlEncode('c='+client.id+'&section=0');
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        ApexPages.StandardController sc= new ApexPages.StandardController(client);
        
        ClientSummaryReportController controller= new ClientSummaryReportController(sc);
        
    }
    
    public void insertCBCLYoung(Client__c client) {
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_B__c');
        SObject obj = objType.newSObject();
        
        obj.put('Client__c', client.id);
        obj.put('BCBYMETH__c', '1');
        obj.put('STATUS_CBCL_0_5__c', 'Complete');
        obj.put('BDOACY__c', date.today());
        
        Map<String, Integer> ans = new Map<String, Integer>(); 
        
        // Emotionally Reactive 
        ans.put('21', 2); ans.put('46', 0); ans.put('51', 0); ans.put('79', 0); 
        ans.put('82', 0); ans.put('83', 0); ans.put('92', 2); ans.put('97', 0);
        ans.put('99', 1); 
        
        // Anxious/Depressed
        ans.put('10', 2); ans.put('33', 2); ans.put('37', 2); ans.put('43', 1); 
        ans.put('47', 0); ans.put('68', 0); ans.put('87', 2); ans.put('90', 1);
        
        // Somatic Complaints
        ans.put('1', 0); ans.put('7', 0); ans.put('12', 0); ans.put('19', 0);
        ans.put('24', 0); ans.put('39', 1); ans.put('45', 1); ans.put('52', 0);
        ans.put('78', 2); ans.put('86', 0); ans.put('93', 0); 
        
        // Withdrawn
        ans.put('2', 1); ans.put('4', 0); ans.put('23', 0); ans.put('62', 2);
        ans.put('67', 0); ans.put('70', 0); ans.put('71', 1); ans.put('98', 0);
        
        // Sleep Problems
        ans.put('22', 2); ans.put('38', 2); ans.put('48', 1); ans.put('64', 2);
        ans.put('74', 0); ans.put('84', 1); ans.put('94', 2); 
        
        // Attention Problems
        ans.put('5', 0); ans.put('6', 0); ans.put('56', 0); ans.put('59', 0);
        ans.put('95', 0); 
        
        // Aggressive Behavior
        ans.put('8', 0); ans.put('15', 0); ans.put('16', 0); ans.put('18', 0);
        ans.put('20', 0); ans.put('27', 0); ans.put('29', 1); ans.put('35', 0);
        ans.put('40', 0); ans.put('42', 0); ans.put('44', 0); ans.put('53', 0);
        ans.put('58', 0); ans.put('66', 0); ans.put('69', 0); ans.put('81', 1);
        ans.put('85', 0); ans.put('88', 0); ans.put('96', 2); 
        
        // Other Problems
        ans.put('3', 2); ans.put('9', 1); ans.put('11', 0); ans.put('13', 0);
        ans.put('14', 0); ans.put('17', 0); ans.put('25', 2); ans.put('26', 1);
        ans.put('28', 1); ans.put('30', 0); ans.put('31', 0); ans.put('32', 0);
        ans.put('34', 0); ans.put('36', 0); ans.put('41', 0); ans.put('49', 0);
        ans.put('50', 0); ans.put('54', 0); ans.put('55', 0); ans.put('57', 0);
        ans.put('60', 0); ans.put('61', 0); ans.put('63', 1); ans.put('65', 0);
        ans.put('72', 0); ans.put('73', 1); ans.put('75', 0); ans.put('76', 0);
        ans.put('77', 1); ans.put('80', 2); ans.put('89', 0); ans.put('91', 0);
        ans.put('100', 0);
        
        for(String key : ans.keySet()) {
            obj.put('BCBY'+key+'__c', String.valueof(ans.get(key)));
        }
        
        insert obj;
        
    }
    
    public void insertCBCLOld(Client__c client) {
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_B__c');
        SObject obj = objType.newSObject();
        
        obj.put('Client__c', client.id);
        obj.put('BCBOMETH__c', '1');
        obj.put('STATUS_CBCL_6_18__c', 'Complete');
        obj.put('BDOACO__c', date.today());
        
        Map<String, Integer> ans = new Map<String, Integer>(); 
        
        // Anxious/Depressed
        ans.put('14', 0); ans.put('29', 1); ans.put('30', 0); ans.put('31', 0); 
        ans.put('32', 0); ans.put('33', 2); ans.put('35', 2); ans.put('45', 2);
        ans.put('50', 0); ans.put('52', 0); ans.put('71', 2); ans.put('91', 0);
        ans.put('112', 2); 
        
        // Withdrawn/Depressed
        ans.put('5', 1); ans.put('42', 1); ans.put('65', 1); ans.put('69', 1); 
        ans.put('75', 0); ans.put('102', 1); ans.put('103', 2); ans.put('111', 1);
        
        // Somatic Complaints
        ans.put('47', 0); ans.put('49', 0); ans.put('51', 1); ans.put('54', 2);
        ans.put('56a', 0); ans.put('56b', 0); ans.put('56c', 0); ans.put('56d', 0);
        ans.put('56e', 0); ans.put('56f', 0); ans.put('56g', 0); 
        
        // Social Problems
        ans.put('11', 2); ans.put('12', 0); ans.put('25', 1); ans.put('27', 1);
        ans.put('34', 1); ans.put('36', 2); ans.put('38', 0); ans.put('48', 1);
        ans.put('62', 0); ans.put('64', 0); ans.put('79', 0); 
        
        // Thought Problems
        ans.put('9', 1); ans.put('18', 0); ans.put('40', 0); ans.put('46', 0);
        ans.put('58', 0); ans.put('59', 0); ans.put('60', 0); ans.put('66', 1);
        ans.put('70', 0); ans.put('76', 0); ans.put('83', 1); ans.put('84', 0);
        ans.put('85', 1); ans.put('92', 1); ans.put('100', 0); 
        
        // Attention Problems
        ans.put('1', 2); ans.put('4', 0); ans.put('8', 2); ans.put('10', 2);
        ans.put('13', 2); ans.put('17', 1); ans.put('41', 2); ans.put('61', 1);
        ans.put('78', 2); ans.put('80', 1); 
        
        // Rule-breaking Behavior
        ans.put('2', 0); ans.put('26', 2); ans.put('28', 2); ans.put('39', 0);
        ans.put('43', 0); ans.put('63', 0); ans.put('67', 0); ans.put('72', 0);
        ans.put('73', 0); ans.put('81', 0); ans.put('82', 0); ans.put('90', 2);
        ans.put('96', 0); ans.put('99', 0); ans.put('101', 0); ans.put('105', 0);
        ans.put('106', 0); 
        
        // Aggressive Behavior
        ans.put('3', 1); ans.put('16', 1); ans.put('19', 1); ans.put('20', 0);
        ans.put('21', 0); ans.put('22', 1); ans.put('23', 2); ans.put('37', 2);
        ans.put('57', 0); ans.put('68', 2); ans.put('86', 2); ans.put('87', 1);
        ans.put('88', 1); ans.put('89', 1); ans.put('94', 0); ans.put('95', 2);
        ans.put('97', 2); ans.put('104', 0); 
        
        // Other Problems
        ans.put('6', 0); ans.put('7', 1); ans.put('15', 0); ans.put('24', 0);
        ans.put('44', 0); ans.put('53', 0); ans.put('55', 0); ans.put('56h', 2);
        ans.put('74', 1); ans.put('77', 0); ans.put('93', 1); ans.put('98', 0);
        ans.put('107', 0); ans.put('108', 0); ans.put('109', 1); ans.put('110', 0);
        ans.put('113', 0); 
        
        for(String key : ans.keySet()) {
            obj.put('BCBO'+key+'__c', String.valueof(ans.get(key)));
        }
        
        insert obj;
    }
    
}