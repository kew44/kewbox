/****
*@description This test provides code coverage for DS_CBCL_F
*includes
*Trigger 
*Controllers:
    *CBCL_0_5, CBCL_6_18, CBCL_0_5_Report, CBCL_6_18_Report, CBCL_Scoring
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_CBCL_F.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
private class TestClass_DS_CBCL_F  {

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
        importData.cbcl();
        importData.variable();
    }
    
    /****
    @description Initialize reference CBCL Scoring class 
    ****/
    DS_CBCL_Scoring cbclScore = new DS_CBCL_Scoring();
    
    /****
    *@description method to test a bulk creation of object
    ****/
    static TestMethod void bulkifyObj(){
    
        //init client
        Client__c client = test_ut.createClient();
        
        //init list of object
        List<DS_CBCL_F__c> bulkObj = new List<DS_CBCL_F__c>(); 
        
        ///begin bulk insert     
        for (Integer i=0;i<200;i++){
            //add record with required values
            bulkObj.add(new DS_CBCL_F__c(client__c = client.id,
                                        FDOACO__c = date.today(), 
                                        FCBOMETH__c = '1' ));
        }
        
        //add list of records to object
        insert bulkObj;
    }
    
    /****
    *@description method to test controllers associated with object
    *Old child, Female test client
    *assert methods represent data types from each controller 
    *some variables asserted may represent required values for certain logic
    ****/
    static TestMethod void assertControllers(){    
        
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 14));
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_CBCL_6_18'
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c();
            summary.Client__c = client.id;        
            summary.SECTION__c = '1';
            summary.Page__c = dpID;
            summary.FORM_TYPE__c = 'FollowUp';
            summary.STATUS__c = 'Complete';
        
        insert summary; 
                
        //summaryId     
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_CBCL_6_18', section);
                    
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        //init list of object
        List<DS_CBCL_F__c> ObjList = new List<DS_CBCL_F__c>();
        
        //init object w/ required variables
        DS_CBCL_F__c obj = new DS_CBCL_F__c(client__c = client.id, 
                                            FCBOMETH__c = '1', 
                                            FCBYMETH__c = '1', 
                                            FDOACO__c = date.today(),
                                            FDOACY__c = date.today());
                
        //set forms' status on object
        obj.STATUS_CBCL_0_5__c = 'Complete';
        obj.STATUS_CBCL_6_18__c = 'Complete';
                          
        //add obj to obj list
        ObjList.add(obj);
               
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);   
            
        //controllers
        DS_CBCL_0_5_Controller Ycontroller = new DS_CBCL_0_5_Controller(sc); 
        DS_CBCL_6_18_Controller Ocontroller = new DS_CBCL_6_18_Controller(sc); 
        DS_CBCL_0_5_Report_Controller YRC = new DS_CBCL_0_5_Report_Controller(sc); 
        DS_CBCL_6_18_Report_Controller ORC = new DS_CBCL_6_18_Report_Controller(sc); 
    
        //controller-specific list options   
        List<SelectOption> selectOptions = new List<SelectOption>();
        
        //CBCL_0_5
        List<SelectOption> ynsvu = Ycontroller.getNSVItems();
        //CBCL_6_18
        List<SelectOption> onsvu = Ocontroller.getNSVItems();
              
        //save/cancel
        Ycontroller.save();
        Ycontroller.saveview();
        Ycontroller.cancel();
        Ycontroller.countBlankAnswer();
        Ycontroller.showWarningMessageForBlank(0, '');
        
        Ocontroller.save();
        Ocontroller.saveview();
        Ocontroller.cancel();
        Ocontroller.countBlankAnswer();
        Ocontroller.showWarningMessageForBlank(0, '');
        
        YRC.init();
        YRC.editRecord();
        YRC.getAssesmentHistory();
        YRC.addVisit(ObjList, 'F');
        
        ORC.init();
        ORC.editRecord();
        ORC.getAssesmentHistory();
        ORC.addVisit(ObjList, 'F');
        
        //init variable alias to be tested 
        //CBCL_0_5
        String FCBYMETH= '1';
        Date FDOACY=system.today();
        String FCBY81= '0';

        //CBCL_6_18
        Date FDOACO=system.today();
        String FCBO109= '2';
        String FCBO115= '1';
        String FCBO115S= 'null';

        //Negative assert statements
        //Young
        System.assertEquals(obj.FCBYMETH__c,FCBYMETH,'CBCL Young was administered by electronic means only. ');
        System.assertEquals(obj.FDOACY__c,FDOACY,'CBCL Young was administered today. Administered  on '+obj.FDOACY__c+'. ');
        System.assertNotEquals(obj.FCBY81__c,FCBY81,'Child IS stubborn, sullen, and/or irritable. ');
        
        //Old
        System.assertEquals(obj.FDOACO__c,FDOACO,'CBCL Old was administered today. Administered  on '+obj.FDOACO__c+'. ');
        System.assertNotEquals(obj.FCBO109__c,FCBO109,'Child does NOT whine very much or very often. ');
        System.assertNotEquals(obj.FCBO115__c,FCBO115,'Another problem is somewhat true. ');
        System.assertNotEquals(obj.FCBO115S__c,FCBO115S,'Other problem has been specified as '+obj.FCBO115S__c+'. ');   

        }    
            
    /****
    *@description method to test a blank case
    *Young Child
    *Male 
    ****/
    static TestMethod void ScoreBlankY(){
                
        //CBCL Scoring class call
        DS_CBCL_Scoring cbclScoreY = new DS_CBCL_Scoring();
    
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 4));                
        
        //generic SObjectType init
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_F__c');
        SObject obj = objType.newSObject();
                    
        //assign values
        obj.put('Client__c', client.id);
        obj.put('FCBYMETH__c', '1');
        obj.put('STATUS_CBCL_0_5__c', 'Complete');
        obj.put('FDOACY__c', date.today());
        
        Map<String, Integer> ans = new Map<String, Integer>(); 
        
        for(String key : ans.keySet()) {
            obj.put('FCBY'+key+'__c', String.valueof(ans.get(key)));
        }
        
        insert obj;
    }
    
    /****
    *@description method to test a blank case
    *Old Child
    *Male 
    ****/
    static TestMethod void ScoreBlankO(){
                
        //CBCL Scoring class call
        DS_CBCL_Scoring cbclScoreY = new DS_CBCL_Scoring();
    
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 14));                
        
        //generic SObjectType init
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_F__c');
        SObject obj = objType.newSObject();
                    
        //assign values
        obj.put('Client__c', client.id);
        obj.put('FCBOMETH__c', '1');
        obj.put('STATUS_CBCL_6_18__c', 'Complete');
        obj.put('FDOACO__c', date.today());
        
        Map<String, Integer> ans = new Map<String, Integer>(); 
        
        for(String key : ans.keySet()) {
            obj.put('FCBY'+key+'__c', String.valueof(ans.get(key)));
        }
        
        insert obj;
    }
    
    /****
    *@description method to test a scored record
    *Young Child
    *Female 
    ****/
    static TestMethod Client__c ScoreYoungFemale(){
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 4));
           
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_F__c');
        SObject obj = objType.newSObject();
        
        obj.put('Client__c', client.id);
        obj.put('FCBYMETH__c', '1');
        obj.put('STATUS_CBCL_0_5__c', 'Complete');
        obj.put('FDOACY__c', date.today());
        
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
            obj.put('FCBY'+key+'__c', String.valueof(ans.get(key)));
        }
        
        insert obj;
        
        String objFields = ut.getFields('DS_CBCL_F__c');
        
        DS_CBCL_F__c cbcl = 
          Database.query('SELECT ' + objFields + ',' +
                                 'Client__r.Name, Client__r.INIT__c' +  
                         '  FROM DS_CBCL_F__c ' +                          
                         ' WHERE id = \''+ obj.id + '\'');
        
        System.assertEquals(1, cbcl.FCBAPPCNY__c, 'FCBAPPCNY is wrong.');
        
        // Internalizaing problem score
        System.assertEquals(68, cbcl.FCBIBTNY__c, 'Internalizaing problem T-score FCBIBTNY is wrong.');
        System.assertEquals('97', cbcl.FCBIBPY__c, 'Internalizaing problem Percentile FCBIBTNY is wrong.');
        
        // Emotionally Reactive
        System.assertEquals(62, cbcl.FCBERTNY__c, 'Emotionally Reactive T-score FCBERTNY is wrong.');
        System.assertEquals('89', cbcl.FCBERPY__c, 'Emotionally Reactive Percentile FCBERPY is wrong.');
        
        // Anxious/Depressed
        System.assertEquals(74, cbcl.FCBADTNY__c, 'Anxious/Depressed T-score FCBADTNY is wrong.');
        System.assertEquals('98+', cbcl.FCBADPY__c, 'Anxious/Depressed Percentile FCBADPY is wrong.');
        
        // Somatic Complaints
        System.assertEquals(62, cbcl.FCBSCTNY__c, 'Somatic Complaints T-score FCBSCTNY is wrong.');
        System.assertEquals('89', cbcl.FCBSCPY__c, 'Somatic Complaints Percentile FCBSCPY is wrong.');
        
        // Withdrawn
        System.assertEquals(63, cbcl.FCBWTNY__c, 'Withdrawn T-score FCBWTNY is wrong.');
        System.assertEquals('90', cbcl.FCBWPY__c, 'Withdrawn Percentile FCBWPY is wrong.');
        
        // Extenalizing Problems Score
        System.assertEquals(39, cbcl.FCBEBTNY__c, 'Extenalizing Problems T-score FCBEBTNY is wrong.');
        System.assertEquals('<50', cbcl.FCBEBPY__c, 'Extenalizing Problems Percentile FCBEBPY is wrong.');
        
        // Attention Problems
        System.assertEquals(50, cbcl.FCBAPTNY__c, 'Attention Problems T-score FCBAPTNY is wrong.');
        System.assertEquals('50', cbcl.FCBAPPY__c, 'Attention Problems Percentile FCBAPPY is wrong.');
        
        // Aggressive Behavior
        System.assertEquals(50, cbcl.FCBABTNY__c, 'Aggressive Behavior T-score FCBABTNY is wrong.');
        System.assertEquals('50', cbcl.FCBABPY__c, 'Aggressive Behavior Percentile FCBABPY is wrong.');
        
        // Sleep Problems
        System.assertEquals(76, cbcl.FCBSPTNY__c, 'Sleep Problems T-score FCBSPTNY is wrong.');
        System.assertEquals('98+', cbcl.FCBSPPY__c, 'Sleep Problems Percentile FCBSPPY is wrong.');
        
        // Total Problems Score
        System.assertEquals(59, cbcl.FCBTSTNY__c, 'Total Problems T-score FCBTSTNY is wrong.');
        System.assertEquals('81', cbcl.FCBTSPY__c, 'Total Problems Percentile FCBTSPY is wrong.');
        
        return client;
    }
          
    /****
    *@description method to test a scored record
    *Old Child
    *Female 
    ****/
    static TestMethod Client__c ScoreOldFemale(){
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 11));
           
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_F__c');
        SObject obj = objType.newSObject();
        
        obj.put('Client__c', client.id);
        obj.put('FCBOMETH__c', '1');
        obj.put('STATUS_CBCL_6_18__c', 'Complete');
        obj.put('FDOACO__c', date.today());
        
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
            obj.put('FCBO'+key+'__c', String.valueof(ans.get(key)));
        }
        
        insert obj;
        
        String objFields = ut.getFields('DS_CBCL_F__c');
        
        DS_CBCL_F__c cbcl = 
          Database.query('SELECT ' + objFields + ',' +
                                 'Client__r.Name, Client__r.INIT__c' +  
                         '  FROM DS_CBCL_F__c ' +                          
                         ' WHERE id = \''+ obj.id + '\'');
        
        System.assertEquals(1, cbcl.FCBAPPCN__c, 'FCBAPPCN is wrong.');
                
        // Internalizaing problem score
        System.assertEquals(63, cbcl.FCBIBTN__c, 'Internalizaing problem T-score FCBIBTN is wrong.');
        System.assertEquals('90', cbcl.FCBIBP__c, 'Internalizaing problem Percentile FCBIBTN is wrong.');
        
        // Anxious/Depressed
        System.assertEquals(51, cbcl.FCBADTN__c, 'Anxious/Depressed T-score FCBADTN is wrong.');
        System.assertEquals('54', cbcl.FCBADP__c, 'Anxious/Depressed Percentile FCBADP is wrong.');
        
        // Withdrawn/Depressed
        System.assertEquals(80, cbcl.FCBWDTN__c, 'Withdrawn/Depressed T-score FCBWDTN is wrong.');
        System.assertEquals('98+', cbcl.FCBWDP__c, 'Withdrawn/Depressed Percentile FCBWDP is wrong.');
        
        // Somatic Complaints
        System.assertEquals(53, cbcl.FCBSCTN__c, 'Somatic Complaints T-score FCBSCTN is wrong.');
        System.assertEquals('62', cbcl.FCBSCP__c, 'Somatic Complaints Percentile FCBSCP is wrong.');
        
        // Extenalizing Problems Score
        System.assertEquals(60, cbcl.FCBEBTN__c, 'Extenalizing Problems T-score FCBEBTN is wrong.');
        System.assertEquals('84', cbcl.FCBEBP__c, 'Extenalizing Problems Percentile FCBEBP is wrong.');
        
        // Rule Braking Behavior
        System.assertEquals(52, cbcl.FCBRBTN__c, 'Rule Braking Behavior T-score FCBRBTN is wrong.');
        System.assertEquals('58', cbcl.FCBRBP__c, 'Rule Braking Behavior Percentile FCBRBP is wrong.');
        
        // Aggressive Behavior
        System.assertEquals(63, cbcl.FCBABTN__c, 'Aggressive Behavior T-score FCBABTN is wrong.');
        System.assertEquals('90', cbcl.FCBABP__c, 'Aggressive Behavior Percentile FCBABP is wrong.');
        
        // Social Problems
        System.assertEquals(59, cbcl.FCBSOTN__c, 'Social Problems T-score FCBSOTN is wrong.');
        System.assertEquals('81', cbcl.FCBSOP__c, 'Social Problems Percentile FCBSOP is wrong.');
        
		// Thought Problems
        System.assertEquals(66, cbcl.FCBTPTN__c, 'Social Problems T-score FCBTPTN is wrong.');
        System.assertEquals('95', cbcl.FCBTPP__c, 'Social Problems Percentile FCBTPP is wrong.');        
        
        // Attention Problems
        System.assertEquals(62, cbcl.FCBAPTN__c, 'Attention Problems T-score FCBAPTN is wrong.');
        System.assertEquals('89', cbcl.FCBAPP__c, 'Attention Problems Percentile FCBAPP is wrong.');    
        
        // Total Problems Score
        System.assertEquals(63, cbcl.FCBTSTN__c, 'Total Problems T-score FCBTSTN is wrong.');
        System.assertEquals('90', cbcl.FCBTSP__c, 'Total Problems Percentile FCBTSP is wrong.');
        
        return client;
    }
    
    /****
    *@description method to test a scored record
    *Old Child
    *Male 
    ****/
    static TestMethod Client__c ScoreOldMale(){
               
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 15));
           
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_F__c');
        SObject obj = objType.newSObject();
        
        obj.put('Client__c', client.id);
        obj.put('FCBOMETH__c', '1');
        obj.put('STATUS_CBCL_6_18__c', 'Complete');
        obj.put('FDOACO__c', date.today());
        
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
            obj.put('FCBO'+key+'__c', String.valueof(ans.get(key)));
        }
        
        insert obj;
        
        String objFields = ut.getFields('DS_CBCL_F__c');
        
        DS_CBCL_F__c cbcl = 
          Database.query('SELECT ' + objFields + ',' +
                                 'Client__r.Name, Client__r.INIT__c' +  
                         '  FROM DS_CBCL_F__c ' +                          
                         ' WHERE id = \''+ obj.id + '\'');
        
        System.assertEquals(1, cbcl.FCBAPPCN__c, 'FCBAPPCN is wrong.');
                
        // Internalizaing problem score
        System.assertEquals(70, cbcl.FCBIBTN__c, 'Internalizaing problem T-score FCBIBTN is wrong.');
        System.assertEquals('98', cbcl.FCBIBP__c, 'Internalizaing problem Percentile FCBIBTN is wrong.');
        
        // Anxious/Depressed
        System.assertEquals(72, cbcl.FCBADTN__c, 'Anxious/Depressed T-score FCBADTN is wrong.');
        System.assertEquals('98+', cbcl.FCBADP__c, 'Anxious/Depressed Percentile FCBADP is wrong.');
        
        // Withdrawn/Depressed
        System.assertEquals(70, cbcl.FCBWDTN__c, 'Withdrawn/Depressed T-score FCBWDTN is wrong.');
        System.assertEquals('98', cbcl.FCBWDP__c, 'Withdrawn/Depressed Percentile FCBWDP is wrong.');
        
        // Somatic Complaints
        System.assertEquals(61, cbcl.FCBSCTN__c, 'Somatic Complaints T-score FCBSCTN is wrong.');
        System.assertEquals('87', cbcl.FCBSCP__c, 'Somatic Complaints Percentile FCBSCP is wrong.');
        
        // Extenalizing Problems Score
        System.assertEquals(69, cbcl.FCBEBTN__c, 'Extenalizing Problems T-score FCBEBTN is wrong.');
        System.assertEquals('97', cbcl.FCBEBP__c, 'Extenalizing Problems Percentile FCBEBP is wrong.');
        
        // Rule Braking Behavior
        System.assertEquals(62, cbcl.FCBRBTN__c, 'Rule Braking Behavior T-score FCBRBTN is wrong.');
        System.assertEquals('89', cbcl.FCBRBP__c, 'Rule Braking Behavior Percentile FCBRBP is wrong.');
        
        // Aggressive Behavior
        System.assertEquals(73, cbcl.FCBABTN__c, 'Aggressive Behavior T-score FCBABTN is wrong.');
        System.assertEquals('98+', cbcl.FCBABP__c, 'Aggressive Behavior Percentile FCBABP is wrong.');
        
        // Social Problems
        System.assertEquals(69, cbcl.FCBSOTN__c, 'Social Problems T-score FCBSOTN is wrong.');
        System.assertEquals('97', cbcl.FCBSOP__c, 'Social Problems Percentile FCBSOP is wrong.');
        
		// Thought Problems
        System.assertEquals(66, cbcl.FCBTPTN__c, 'Social Problems T-score FCBTPTN is wrong.');
        System.assertEquals('95', cbcl.FCBTPP__c, 'Social Problems Percentile FCBTPP is wrong.');        
        
        // Attention Problems
        System.assertEquals(76, cbcl.FCBAPTN__c, 'Attention Problems T-score FCBAPTN is wrong.');
        System.assertEquals('98+', cbcl.FCBAPP__c, 'Attention Problems Percentile FCBAPP is wrong.');    
        
        // Total Problems Score
        System.assertEquals(71, cbcl.FCBTSTN__c, 'Total Problems T-score FCBTSTN is wrong.');
        System.assertEquals('98+', cbcl.FCBTSP__c, 'Total Problems Percentile FCBTSP is wrong.');
        
        return client;
     }
     
    /****
    *@description method to test inserting a record
    *Young Child
    *Male 
    ****/
    static TestMethod void insertScoreY(){
                
        //CBCL Scoring class call
        DS_CBCL_Scoring cbclScoreY = new DS_CBCL_Scoring();
        
        Map<String, List<DS_DATA__c>> formInfo = new Map<String, List<DS_DATA__c>>();
        List<String> scaleType = new List<String>{'','I','II','III','IV','V','VI','VII','VIII'};
        Map<String, String> resetFieldsYoung = new Map<String, String>();
            
        //cbclScoreY.resetFieldsYoung = ut.getFieldsFromDD('CBCL_SCORES_YOUNG');
        //resetFieldsOld = ut.getFieldsFromDD('CBCL_SCORES_OLD');
        //scaleType = new List<String>{'','I','II','III','IV','V','VI','VII','VIII'};
        
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 5));
        
        //summaryId     
        String summaryId = '1';
        
        //encoded parameters  
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        //init object w/ required variables
        DS_CBCL_F__c obj = new DS_CBCL_F__c(client__c = client.id, 
                                            FCBYMETH__c = '1', 
                                            FCBOMETH__c = '1', 
                                            FDOACO__c = date.today(),
                                            FDOACY__c = date.today());
                        
        //set form's status on object
        obj.STATUS_CBCL_0_5__c = 'Complete';
        obj.STATUS_CBCL_6_18__c = 'Complete';
          
        //insert object
        insert obj;     
                  
     }
           
    /****
    *@description method to test inserting a record
    *Old Child
    *Female 
    ****/    
    static TestMethod void insertScoreO(){
                
        //CBCL Scoring class call
        DS_CBCL_Scoring cbclScoreO = new DS_CBCL_Scoring();
    
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 15));
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        //init object w/ required variables
        DS_CBCL_F__c obj = new DS_CBCL_F__c(client__c = client.id, 
                                            FCBYMETH__c = '1', 
                                            FCBOMETH__c = '1', 
                                            FDOACO__c = date.today(),
                                            FDOACY__c = date.today());
                                            
        //set form's status on object
        obj.STATUS_CBCL_0_5__c = 'Complete';
        obj.STATUS_CBCL_6_18__c = 'Complete';
        
        //insert object
        insert obj;           
    }
}