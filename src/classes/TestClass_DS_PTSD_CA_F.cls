/****
*@description This test provides code coverage for DS_PTSD_CA_F
*includes
*Trigger 
*Controllers:
    *PTSD_CA, PTSD_CA_Report
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_PTSD_CA_F.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
private class TestClass_DS_PTSD_CA_F  {

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
        importData.ptsd();   
        importData.variable();
    }
    
    /****
    @description Initialize reference PTSD Scoring class 
    ****/
    DS_PTSD_Scoring cbclScore = new DS_PTSD_Scoring();  
    
    /****
    *@description method to test a bulk creation of object
    ****/
    static TestMethod void bulkifyObj(){
            
        //Get 200 random clients with age range 7 ~ 18
        List<Client__c> clients = test_ut.createClient(test_ut.getClient(null, '7_18', 200));
        
        //init list of object
        List<DS_PTSD_CA_F__c> bulkObj = new List<DS_PTSD_CA_F__c>(); 
        
        ///begin bulk insert     
        for (Integer i = 0; i < clients.size(); i++){
            //add record with required values
            bulkObj.add(new DS_PTSD_CA_F__c(client__c = clients.get(i).id,
                                        	FMETPTSD__c = '1',
                                        	FDOAPTSD__c = date.today(),
                                           	STATUS_PTSD_CA__c = 'Complete'));
        }
        
        test.startTest();

        //add list of records to object
        insert bulkObj;
        
        test.stopTest();
        
    }
    
    /****
    *@description method to test controllers associated with object
    *assert methods represent data types from each controller 
    *some variables asserted may represent required values for certain logic
    ****/
    static TestMethod void assertControllers(){
    
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_PTSD_CA'
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c();
            summary.Client__c = client.id;        
            summary.SECTION__c = section;
            summary.Page__c = dpID;
            summary.FORM_TYPE__c = 'FollowUp';
            summary.STATUS__c = 'Complete';
        
        insert summary;        
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_PTSD_CA', section);
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        //init list of object
        List<DS_PTSD_CA_F__c> ObjList = new List<DS_PTSD_CA_F__c>();
        
        //init object w/ required variables
        DS_PTSD_CA_F__c obj= new DS_PTSD_CA_F__c(client__c = client.id,
                                                FMETPTSD__c = '1',
                                                FDOAPTSD__c = date.today());
                                                
        //set form's status         
        obj.STATUS_PTSD_CA__c = 'Complete';         
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj); 
        
        //controllers
        DS_PTSD_CA_Controller controller = new DS_PTSD_CA_Controller(sc); 
        DS_PTSD_CA_Report_Controller RC = new DS_PTSD_CA_Report_Controller(sc); 
        
        //non-standard list options
        List<SelectOption> radio = controller.getRadioItems();
        List<SelectOption> radioYesNo = controller.getRadioYesNo();        
        List<SelectOption> nsvu = controller.getRadioItems();
        List<SelectOption> nsvu2 = controller.getRadioYesNo();
        
        //save/cancel
        controller.save();
        controller.saveView();
        controller.cancel();  
        
        RC.init();
        RC.editRecord(); 
        
        //init variable alias to be tested  
        String FPTSV15= '1';
        String FPTSV13= '4' ;
        String FPTSFS1= '2';
        String FMETPTSD= '0';
        
        //Negative assert statements
        System.assertNotEquals(obj.FPTSV15__c,FPTSV15,'Child has NOT been a little mad with someone in the past month. ');
        System.assertNotEquals(obj.FPTSV13__c,FPTSV13,'Child has NOT spent most of the past month trying to avoid thinking of what happened. ');
        System.assertNotEquals(obj.FPTSFS1__c,FPTSFS1,'Child has NOT found it somewhat difficult to do well in school this past month. ');
        System.assertNotEquals(obj.FMETPTSD__c,FMETPTSD,'PTSD_RI was NOT scored by a pen-and-paper assessment only. ');

    }
    
    /****
    *@description method to test a case where there are 2 blanks
    * 
    ****/
    static TestMethod Client__c Test_2Blank() {
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_PTSD_CA_F__c obj = new DS_PTSD_CA_F__c();
        
        obj.client__c = client.id;
        
        obj.FMETPTSD__c = '1';
        obj.FDOAPTSD__c = date.today();  
        
        obj.STATUS_PTSD_CA__c = 'Complete';
        
        // Q5 and Q31 are blank
        
        obj.FPTSV1__c  = obj.FPTSV2__c  = obj.FPTSV3__c  = obj.FPTSV4__c  = '1';
        obj.FPTSV6__c  = obj.FPTSV7__c  = obj.FPTSV8__c  = obj.FPTSV9__c  = obj.FPTSV10__c = '4';
        obj.FPTSV11__c = obj.FPTSV12__c = obj.FPTSV13__c = obj.FPTSV14__c = obj.FPTSV15__c = '4';
        obj.FPTSV16__c = obj.FPTSV17__c = obj.FPTSV18__c = obj.FPTSV19__c = obj.FPTSV20__c = '2';
        obj.FPTSV21__c = obj.FPTSV22__c = obj.FPTSV23__c = obj.FPTSV24__c = obj.FPTSV25__c = '3';
        obj.FPTSV26__c = obj.FPTSV27__c = obj.FPTSV28__c = obj.FPTSV29__c = obj.FPTSV30__c = '1';
        
        test.startTest();
        
        insert obj;
        
        test.stopTest();
        
        DS_PTSD_CA_F__c ptsd = [SELECT FPTSAB1__c, FPTSAB2__c, FPTSAB3__c, FPTSAB4__c, FPTSAB5__c, FPTSAC1__c, FPTSAC2__c,
                               		   FPTSAD1__c, FPTSAD2__c, FPTSAD3__c, FPTSAD4__c, FPTSAD5__c, FPTSAD6__c, FPTSAD7__c,
                               		   FPTSAE1__c, FPTSAE2__c, FPTSAE3__c, FPTSAE4__c, FPTSAE5__c, FPTSAE6__c, 
                                       FPTSVDA1__c,FPTSVDA2__c, FPTSAPPCN__c 
                                  FROM DS_PTSD_CA_F__c WHERE id =: obj.id];
        
        System.assertEquals(2, ptsd.FPTSAB1__c, 'Symptom B1 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB2__c, 'Symptom B2 is wrong.');
        System.assertEquals(2, ptsd.FPTSAB3__c, 'Symptom B3 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB4__c, 'Symptom B4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB5__c, 'Symptom B5 is wrong.');
        
        System.assertEquals(4, ptsd.FPTSAC1__c, 'Symptom C1 is wrong.');
        System.assertEquals(1, ptsd.FPTSAC2__c, 'Symptom C2 is wrong.');
        
        System.assertEquals(3, ptsd.FPTSAD1__c, 'Symptom D1 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD2__c, 'Symptom D2 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD3__c, 'Symptom D3 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD4__c, 'Symptom D4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD5__c, 'Symptom D5 is wrong.');
        System.assertEquals(2, ptsd.FPTSAD6__c, 'Symptom D6 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD7__c, 'Symptom D7 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSAE1__c, 'Symptom E1 is wrong.');
		System.assertEquals(2, ptsd.FPTSAE2__c, 'Symptom E2 is wrong.');
        System.assertEquals(1, ptsd.FPTSAE3__c, 'Symptom E3 is wrong.');
        System.assertEquals(3, ptsd.FPTSAE4__c, 'Symptom E4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAE5__c, 'Symptom E5 is wrong.');
        System.assertEquals(3, ptsd.FPTSAE6__c, 'Symptom E6 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSVDA1__c, 'Symptom A1 is wrong.');
        System.assertEquals(2, ptsd.FPTSVDA2__c, 'Symptom A2 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSAPPCN__c, 'FPTSAPPCNP__c ERROR');
        
        return client;
        
    }
    
    /****
    *@description method to test a case where there are 3+ blanks
    *Female 
    ****/
    static TestMethod Client__c Test_3Blank() {
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_PTSD_CA_F__c obj = new DS_PTSD_CA_F__c();
        
        obj.client__c = client.id;
        
        obj.FMETPTSD__c = '1';
        obj.FDOAPTSD__c = date.today();  
        
        obj.STATUS_PTSD_CA__c = 'Complete';
        
        obj.FPTSV1__c  = obj.FPTSV2__c  = obj.FPTSV3__c  = obj.FPTSV4__c  = '1';
        obj.FPTSV6__c  = obj.FPTSV7__c  = obj.FPTSV8__c  = obj.FPTSV9__c  = '4';
        obj.FPTSV11__c = obj.FPTSV12__c = obj.FPTSV13__c = obj.FPTSV14__c = obj.FPTSV15__c = '4';
        obj.FPTSV16__c = obj.FPTSV17__c = obj.FPTSV18__c = obj.FPTSV19__c = obj.FPTSV20__c = '2';
        obj.FPTSV21__c = obj.FPTSV22__c = obj.FPTSV23__c = obj.FPTSV24__c = obj.FPTSV25__c = '3';
        obj.FPTSV26__c = obj.FPTSV27__c = obj.FPTSV28__c = obj.FPTSV29__c = obj.FPTSV30__c = '1';
        
        test.startTest();
        
        insert obj;
        
        test.stopTest();
        
        DS_PTSD_CA_F__c ptsd = [SELECT FPTSAB1__c, FPTSAB2__c, FPTSAB3__c, FPTSAB4__c, FPTSAB5__c, FPTSAC1__c, FPTSAC2__c,
                               		   FPTSAD1__c, FPTSAD2__c, FPTSAD3__c, FPTSAD4__c, FPTSAD5__c, FPTSAD6__c, FPTSAD7__c,
                               		   FPTSAE1__c, FPTSAE2__c, FPTSAE3__c, FPTSAE4__c, FPTSAE5__c, FPTSAE6__c, 
                                       FPTSVDA1__c,FPTSVDA2__c, FPTSAPPCN__c 
                                  FROM DS_PTSD_CA_F__c WHERE id =: obj.id];
        
        System.assertEquals(0, ptsd.FPTSAPPCN__c, 'FPTSAPPCN__c ERROR');
        
        return client;
        
    }
    
    /****
    *@description method to test a case where there is no blank
    * 
    ****/
    static TestMethod Client__c Test_Scoring() {
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_PTSD_CA_F__c obj = new DS_PTSD_CA_F__c();
        
        obj.client__c = client.id;
        
        obj.FMETPTSD__c = '1';
        obj.FDOAPTSD__c = date.today();  
        
        obj.STATUS_PTSD_CA__c = 'Complete';
                
        obj.FPTSV1__c  = obj.FPTSV2__c  = obj.FPTSV3__c  = obj.FPTSV4__c  = obj.FPTSV5__c  = '1';
        obj.FPTSV6__c  = obj.FPTSV7__c  = obj.FPTSV8__c  = obj.FPTSV9__c  = obj.FPTSV10__c = '4';
        obj.FPTSV11__c = obj.FPTSV12__c = obj.FPTSV13__c = obj.FPTSV14__c = obj.FPTSV15__c = '4';
        obj.FPTSV16__c = obj.FPTSV17__c = obj.FPTSV18__c = obj.FPTSV19__c = obj.FPTSV20__c = '2';
        obj.FPTSV21__c = obj.FPTSV22__c = obj.FPTSV23__c = obj.FPTSV24__c = obj.FPTSV25__c = '3';
        obj.FPTSV26__c = obj.FPTSV27__c = obj.FPTSV28__c = obj.FPTSV29__c = obj.FPTSV30__c = '1';
        obj.FPTSV31__c = '1';
        
        test.startTest();
        
        insert obj;
        
        test.stopTest();
        
        DS_PTSD_CA_F__c ptsd = [SELECT FPTSAB1__c, FPTSAB2__c, FPTSAB3__c, FPTSAB4__c, FPTSAB5__c, FPTSAC1__c, FPTSAC2__c,
                               		   FPTSAD1__c, FPTSAD2__c, FPTSAD3__c, FPTSAD4__c, FPTSAD5__c, FPTSAD6__c, FPTSAD7__c,
                               		   FPTSAE1__c, FPTSAE2__c, FPTSAE3__c, FPTSAE4__c, FPTSAE5__c, FPTSAE6__c, 
                                       FPTSVDA1__c,FPTSVDA2__c, FPTSAPPCN__c 
                                  FROM DS_PTSD_CA_F__c WHERE id =: obj.id];
        
        System.assertEquals(2, ptsd.FPTSAB1__c, 'Symptom B1 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB2__c, 'Symptom B2 is wrong.');
        System.assertEquals(1, ptsd.FPTSAB3__c, 'Symptom B3 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB4__c, 'Symptom B4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB5__c, 'Symptom B5 is wrong.');
        
        System.assertEquals(4, ptsd.FPTSAC1__c, 'Symptom C1 is wrong.');
        System.assertEquals(1, ptsd.FPTSAC2__c, 'Symptom C2 is wrong.');
        
        System.assertEquals(3, ptsd.FPTSAD1__c, 'Symptom D1 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD2__c, 'Symptom D2 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD3__c, 'Symptom D3 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD4__c, 'Symptom D4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD5__c, 'Symptom D5 is wrong.');
        System.assertEquals(2, ptsd.FPTSAD6__c, 'Symptom D6 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD7__c, 'Symptom D7 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSAE1__c, 'Symptom E1 is wrong.');
		System.assertEquals(2, ptsd.FPTSAE2__c, 'Symptom E2 is wrong.');
        System.assertEquals(1, ptsd.FPTSAE3__c, 'Symptom E3 is wrong.');
        System.assertEquals(3, ptsd.FPTSAE4__c, 'Symptom E4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAE5__c, 'Symptom E5 is wrong.');
        System.assertEquals(3, ptsd.FPTSAE6__c, 'Symptom E6 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSVDA1__c, 'Symptom A1 is wrong.');
        System.assertEquals(1, ptsd.FPTSVDA2__c, 'Symptom A2 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSAPPCN__c, 'FPTSAPPCN__c ERROR');
        
        return client;
        
    }
    
    /****
    *@description method to test a case where there is no blank
    * 
    ****/
    static TestMethod Client__c Test_Scoring2() {
               
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 9));
        
        DS_PTSD_CA_F__c obj = new DS_PTSD_CA_F__c();
        
        obj.client__c = client.id;
        
        obj.FMETPTSD__c = '1';
        obj.FDOAPTSD__c = date.today();  
        
        obj.STATUS_PTSD_CA__c = 'Complete';
                
        obj.FPTSV1__c  = obj.FPTSV2__c  = obj.FPTSV3__c  = obj.FPTSV4__c  = obj.FPTSV5__c  = '4';
        obj.FPTSV6__c  = obj.FPTSV7__c  = obj.FPTSV8__c  = obj.FPTSV9__c  = obj.FPTSV10__c = '4';
        obj.FPTSV11__c = obj.FPTSV12__c = obj.FPTSV13__c = obj.FPTSV14__c = obj.FPTSV15__c = '4';
        obj.FPTSV16__c = obj.FPTSV17__c = obj.FPTSV18__c = obj.FPTSV19__c = obj.FPTSV20__c = '4';
        obj.FPTSV21__c = obj.FPTSV22__c = obj.FPTSV23__c = obj.FPTSV24__c = obj.FPTSV25__c = '4';
        obj.FPTSV26__c = obj.FPTSV27__c = obj.FPTSV28__c = obj.FPTSV29__c = obj.FPTSV30__c = '4';
        obj.FPTSV31__c = '4';
        
        obj.FPTSDURA__c = '1';
        obj.FPTSD1__c = '1';
        
        test.startTest();
        
        insert obj;
        
        test.stopTest();
        
        DS_PTSD_CA_F__c ptsd = [SELECT FPTSAB1__c, FPTSAB2__c, FPTSAB3__c, FPTSAB4__c, FPTSAB5__c, FPTSAC1__c, FPTSAC2__c,
                               		   FPTSAD1__c, FPTSAD2__c, FPTSAD3__c, FPTSAD4__c, FPTSAD5__c, FPTSAD6__c, FPTSAD7__c,
                               		   FPTSAE1__c, FPTSAE2__c, FPTSAE3__c, FPTSAE4__c, FPTSAE5__c, FPTSAE6__c, 
                                       FPTSVDA1__c,FPTSVDA2__c, FPTSAPPCN__c, FPTSOCN__c, FPTSORN__c, FPTSBRN__c,
                                	   FPTSCRN__c, FPTSDRN__c, FPTSERN__c, FPTSBMN__c, FPTSCMN__c, FPTSDMN__c,
                                	   FPTSEMN__c
                                  FROM DS_PTSD_CA_F__c WHERE id =: obj.id];
        
        System.assertEquals(4, ptsd.FPTSAB1__c, 'Symptom B1 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB2__c, 'Symptom B2 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB3__c, 'Symptom B3 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB4__c, 'Symptom B4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB5__c, 'Symptom B5 is wrong.');
        
        System.assertEquals(4, ptsd.FPTSAC1__c, 'Symptom C1 is wrong.');
        System.assertEquals(4, ptsd.FPTSAC2__c, 'Symptom C2 is wrong.');
        
        System.assertEquals(4, ptsd.FPTSAD1__c, 'Symptom D1 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD2__c, 'Symptom D2 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD3__c, 'Symptom D3 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD4__c, 'Symptom D4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD5__c, 'Symptom D5 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD6__c, 'Symptom D6 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD7__c, 'Symptom D7 is wrong.');
        
        System.assertEquals(4, ptsd.FPTSAE1__c, 'Symptom E1 is wrong.');
		System.assertEquals(4, ptsd.FPTSAE2__c, 'Symptom E2 is wrong.');
        System.assertEquals(4, ptsd.FPTSAE3__c, 'Symptom E3 is wrong.');
        System.assertEquals(4, ptsd.FPTSAE4__c, 'Symptom E4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAE5__c, 'Symptom E5 is wrong.');
        System.assertEquals(4, ptsd.FPTSAE6__c, 'Symptom E6 is wrong.');
        
        System.assertEquals(4, ptsd.FPTSVDA1__c, 'Symptom A1 is wrong.');
        System.assertEquals(4, ptsd.FPTSVDA2__c, 'Symptom A2 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSAPPCN__c, 'FPTSAPPCN__c ERROR');
        
        System.assertEquals(1, ptsd.FPTSOCN__c, 'Meets UCLA PTSD Diagnostic Criteria DSM-5 is wrong.');
        System.assertEquals(80, ptsd.FPTSORN__c, 'Total Scale Score is wrong.');
        System.assertEquals(20, ptsd.FPTSBRN__c, 'Symptom B score is wrong.');
        System.assertEquals(8, ptsd.FPTSCRN__c, 'Symptom C score is wrong.');
        System.assertEquals(28, ptsd.FPTSDRN__c, 'Symptom D score is wrong.');
        System.assertEquals(24, ptsd.FPTSERN__c, 'Symptom E score is wrong.');
        System.assertEquals(1, ptsd.FPTSBMN__c, 'Meets Symptom B is wrong.');
        System.assertEquals(1, ptsd.FPTSCMN__c, 'Meets Symptom C is wrong.');
        System.assertEquals(1, ptsd.FPTSDMN__c, 'Meets Symptom D is wrong.');
        System.assertEquals(1, ptsd.FPTSEMN__c, 'Meets Symptom E is wrong.');
        
        return client;
        
    }
    
}