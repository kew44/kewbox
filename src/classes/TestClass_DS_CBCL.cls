@isTest
private class TestClass_DS_CBCL {
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    static TestMethod void Test_Baseline_Controller_Young() {
        
        // Young client
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 3));
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_CBCL_0_5', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        DS_CBCL_B__c cbcl = new DS_CBCL_B__c();
        
        cbcl.client__c = client.id;
        cbcl.BDOACY__c = date.today();
        cbcl.BCBYMETH__c = '1';
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cbcl);  
        DS_CBCL_0_5_Controller controller = new DS_CBCL_0_5_Controller(sc); 
        
        List<SelectOption> nsvu = controller.getNSVItems();
        
        controller.save();
        controller.saveview();
        controller.cancel();
        
    }
    
    static TestMethod void Test_Baseline_Controller_Old() {
        
        // Old client
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 10));
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_CBCL_6_18', '0');
        System.debug(client);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        DS_CBCL_B__c cbcl = new DS_CBCL_B__c();
        
        cbcl.client__c = client.id;
        cbcl.BDOACO__c = date.today();
        cbcl.BCBOMETH__c = '1';
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cbcl);  
        DS_CBCL_6_18_Controller controllerOld = new DS_CBCL_6_18_Controller(sc); 
        
        List<SelectOption> nsvu = controllerOld.getNSVItems();
        
        controllerOld.save();
        controllerOld.saveview();
        controllerOld.cancel();
        
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller_Young() {
        
        // Young client
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 3));
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_CBCL_0_5', section);
        System.debug(client);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_CBCL_B__c obj = new DS_CBCL_B__c();    
        obj.STATUS_CBCL_0_5__c = 'Complete';
        obj.client__c = client.id;   
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_CBCL_0_5_Controller controller = new DS_CBCL_0_5_Controller(sc); 
        
        List<SelectOption> nsvu = controller.getNSVItems();
                
        controller.save();
        controller.cancel();
        
    }
    
    static TestMethod void Test_Followup_Controller_Old() {
        
        // Old client
        Client__C client = test_ut.createClient(test_ut.getClient('Male', 10));
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_CBCL_6_18', section);
        System.debug(client);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_CBCL_B__c obj = new DS_CBCL_B__c();    
        obj.STATUS_CBCL_6_18__c = 'Complete';
        obj.client__c = client.id;   
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_CBCL_6_18_Controller controllerOld = new DS_CBCL_6_18_Controller(sc); 
        
        List<SelectOption> nsvu = controllerOld.getNSVItems();
                
        controllerOld.save();
        controllerOld.cancel();
        
    }
    
    static TestMethod void Test_CBCL_Baseline_Blank_Old() {
                
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 14));
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_B__c');
        SObject obj = objType.newSObject();
        
        obj.put('Client__c', client.id);
        obj.put('BCBOMETH__c', '1');
        obj.put('STATUS_CBCL_6_18__c', 'Complete');
        obj.put('BDOACO__c', date.today());
        
        System.debug(client);
        
        Map<String, Integer> ans = new Map<String, Integer>(); 
        
        insert obj;
        
    }
    
    static TestMethod void Test_CBCL_Baseline_Blank_Young() {
                
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 4));
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_B__c');
        SObject obj = objType.newSObject();
        
        obj.put('Client__c', client.id);
        obj.put('BCBYMETH__c', '1');
        obj.put('STATUS_CBCL_0_5__c', 'Complete');
        obj.put('BDOACY__c', date.today());
        
        Map<String, Integer> ans = new Map<String, Integer>(); 
        
        for(String key : ans.keySet()) {
            obj.put('BCBY'+key+'__c', String.valueof(ans.get(key)));
        }
        
        System.debug(client);
        
        insert obj;
        
    }
    
    static TestMethod void Test_CBCL_Baseline_Boy_12_18() {
                
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 14));
        
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
        
        // Tought Problems
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
        
        System.debug(client);
        
        insert obj;
        
    }
    
    static TestMethod void Test_Report_Controller_Young() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 3));
        
        // Add Baseline record
        DS_CBCL_B__c baseline = new DS_CBCL_B__c();
        
        baseline.client__c = client.id;
        baseline.BCBYMETH__c = '1';
        baseline.BDOACY__c = System.today();//Date.today();
        
        insert baseline;
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_CBCL_0_5', section);
        
        System.debug(client);
        
        // Add Follow-up record
        DS_CBCL_F__c follow = new DS_CBCL_F__c();
        
        follow.client__c = client.id;
        follow.FCBYMETH__c = '1';
        follow.FDOACY__c = System.today();//Date.today();
        follow.SECTION__c = section;
        
        System.debug(client);
        
        insert follow;       
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(follow);  
        DS_CBCL_0_5_Report_Controller controller = new DS_CBCL_0_5_Report_Controller(sc); 
        
        controller.init();
        controller.editRecord();
        
    }
    
    static TestMethod void Test_Report_Controller_Old() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 14));
        
        // Add Baseline record
        DS_CBCL_B__c baseline = new DS_CBCL_B__c();
        
        baseline.client__c = client.id;
        baseline.BCBOMETH__c = '1';
        baseline.BDOACO__c = System.today();//Date.today();
        
        System.debug(client);
        
        insert baseline;
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_CBCL_6_18', section);
        
        // Add Follow-up record
        DS_CBCL_F__c follow = new DS_CBCL_F__c();
        
        follow.client__c = client.id;
        follow.FCBOMETH__c = '1';
        follow.FDOACO__c = System.today();//Date.today();
        follow.SECTION__c = section;
        
        System.debug(client);
        
        insert follow;       
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(follow);  
        DS_CBCL_6_18_Report_Controller controller = new DS_CBCL_6_18_Report_Controller(sc); 
        
        controller.init();
        controller.editRecord();
        
    }
    
    static TestMethod Client__c Test_CBCL_Baseline_Girl_6_11() {
                
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 7));
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_B__c');
        SObject obj = objType.newSObject();
        
        obj.put('Client__c', client.id);
        obj.put('BCBOMETH__c', '1');
        obj.put('STATUS_CBCL_6_18__c', 'Complete');
        obj.put('BDOACO__c', date.today());
        
        System.debug(client);
        
        Map<String, Integer> ans = new Map<String, Integer>(); 
        
        // Anxious/Depressed
        ans.put('14', 0); ans.put('29', 0); ans.put('30', 0); ans.put('31', 0); 
        ans.put('32', 0); ans.put('33', 0); ans.put('35', 0); ans.put('45', 0);
        ans.put('50', 0); ans.put('52', 0); ans.put('71', 1); ans.put('91', 0);
        ans.put('112', 1); 
        
        // Withdrawn/Depressed
        ans.put('5', 1); ans.put('42', 1); ans.put('65', 1); ans.put('69', 0); 
        ans.put('75', 2); ans.put('102', 1); ans.put('103', 2); ans.put('111', 2);
        
        // Somatic Complaints
        ans.put('47', 0); ans.put('49', 0); ans.put('51', 0); ans.put('54', 1);
        ans.put('56a', 0); ans.put('56b', 0); ans.put('56c', 0); ans.put('56d', 0);
        ans.put('56e', 0); ans.put('56f', 0); ans.put('56g', 0); 
        
        // Social Problems
        ans.put('11', 1); ans.put('12', 1); ans.put('25', 0); ans.put('27', 1);
        ans.put('34', 0); ans.put('36', 0); ans.put('38', 0); ans.put('48', 0);
        ans.put('62', 1); ans.put('64', 1); ans.put('79', 0); 
        
        // Tought Problems
        ans.put('9', 0); ans.put('18', 0); ans.put('40', 0); ans.put('46', 0);
        ans.put('58', 0); ans.put('59', 0); ans.put('60', 0); ans.put('66', 0);
        ans.put('70', 0); ans.put('76', 2); ans.put('83', 0); ans.put('84', 0);
        ans.put('85', 0); ans.put('92', 1); ans.put('100', 2); 
        
        // Attention Problems
        ans.put('1', 1); ans.put('4', 2); ans.put('8', 1); ans.put('10', 0);
        ans.put('13', 0); ans.put('17', 1); ans.put('41', 0); ans.put('61', 1);
        ans.put('78', 0); ans.put('80', 1); 
        
        // Rule-breaking Behavior
        ans.put('2', 0); ans.put('26', 0); ans.put('28', 0); ans.put('39', 0);
        ans.put('43', 0); ans.put('63', 1); ans.put('67', 0); ans.put('72', 0);
        ans.put('73', 0); ans.put('81', 0); ans.put('82', 0); ans.put('90', 0);
        ans.put('96', 0); ans.put('99', 0); ans.put('101', 0); ans.put('105', 0);
        ans.put('106', 0); 
        
        // Aggressive Behavior
        ans.put('3', 0); ans.put('16', 0); ans.put('19', 1); ans.put('20', 1);
        ans.put('21', 0); ans.put('22', 0); ans.put('23', 0); ans.put('37', 0);
        ans.put('57', 0); ans.put('68', 0); ans.put('86', 2); ans.put('87', 2);
        ans.put('88', 1); ans.put('89', 1); ans.put('94', 1); ans.put('95', 2);
        ans.put('97', 0); ans.put('104', 0); 
        
        // Other Problems
        ans.put('6', 0); ans.put('7', 0); ans.put('15', 1); ans.put('24', 0);
        ans.put('44', 0); ans.put('53', 0); ans.put('55', 0); ans.put('56h', 0);
        ans.put('74', 0); ans.put('77', 0); ans.put('93', 0); ans.put('98', 1);
        ans.put('107', 0); ans.put('108', 0); ans.put('109', 0); ans.put('110', 0);
        ans.put('113', 2); 
        
        for(String key : ans.keySet()) {
            obj.put('BCBO'+key+'__c', String.valueof(ans.get(key)));
        }
        
        insert obj;
        
        return client;
        
    }
    
    static TestMethod Client__c Test_CBCL_Baseline_Girl_1_5_5() {
                
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 4));
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_B__c');
        SObject obj = objType.newSObject();
        
        System.debug(client);
        
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
        
        return client;
        
    }

}