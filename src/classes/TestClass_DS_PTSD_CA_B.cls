/****
*@description This test provides code coverage for DS_PTSD_CA_B
*includes
*Trigger 
*Controllers:
    *PTSD_CA, PTSD_CA_Report
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_PTSD_CA_B.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
private class TestClass_DS_PTSD_CA_B  {

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
    public static DS_PTSD_CA_Scoring ptsdScore = new DS_PTSD_CA_Scoring();
    
    /****
    *@description method to test a bulk creation of object
    ****/
    static TestMethod void bulkifyObj(){
    
        //init client
        Client__c client = test_ut.createClientSummary();
        
        //init list of object
        List<DS_PTSD_CA_B__c> bulkObj = new List<DS_PTSD_CA_B__c>();  
        
        ///begin bulk insert     
        for (Integer i=0;i<200;i++){
            //add record with required values
            bulkObj.add(new DS_PTSD_CA_B__c(client__c = client.id,
                                        BMETPTSD__c = '1',
                                        BDOAPTSD__c = date.today()));
        }
        
        //add list of records to object
        insert bulkObj;
    }
    
    /****
    *@description method to test controllers associated with object
    *assert methods represent data types from each controller 
    *some variables asserted may represent required values for certain logic
    ****/
    static TestMethod void assertControllers(){
    
        //create test client 
        Client__c client = test_ut.createClient();//client = new Client__c();test_ut.createClientPTSD_CA_B();//createClient(client);
                
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_PTSD_CA'
                                AND File_name__c = 'BASELINE'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c();
            summary.Client__c = client.id;        
            summary.SECTION__c = '0';
            summary.Page__c = dpID;
            summary.FORM_TYPE__c = 'Baseline';
            summary.STATUS__c = 'Complete';
        
        insert summary;        
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_PTSD_CA', '0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        //init list of object
        List<DS_PTSD_CA_B__c> ObjList = new List<DS_PTSD_CA_B__c>();
        
        DS_PTSD_CA_B__c obj= new DS_PTSD_CA_B__c(client__c = client.id,
                                                BMETPTSD__c = '1',
                                                BDOAPTSD__c = date.today());    

        //set form's status         
        obj.STATUS_PTSD_CA__c = 'Complete';         
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj); 
        
        //controllers
        DS_PTSD_CA_Controller controller = new DS_PTSD_CA_Controller(sc); 
        DS_PTSD_CA_Report_Controller RC = new DS_PTSD_CA_Report_Controller(sc); 
        
        //non-standard list options
        List<SelectOption> selectOptions = new List<SelectOption>();
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
        String BPTSV15= '1';
        String BPTSV13= '4' ;
        String BPTSFS1= '2';
        String BMETPTSD= '0';

        //Negative assert statements
        System.assertNotEquals(obj.BPTSV15__c,BPTSV15,'Child has NOT been a little mad with someone in the past month. ');
        System.assertNotEquals(obj.BPTSV13__c,BPTSV13,'Child has NOT spent most of the past month trying to avoid thinking of what happened. ');
        System.assertNotEquals(obj.BPTSFS1__c,BPTSFS1,'Child has NOT found it somewhat difficult to do well in school this past month. ');
        System.assertNotEquals(obj.BMETPTSD__c,BMETPTSD,'PTSD_RI was NOT scored by a pen-and-paper assessment only. ');

    }
    
    /****
    *@description method to test a case where there are 3+ blanks
    *Female 
    ****/
    static TestMethod Client__c Test_3Blank() {
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_PTSD_CA_B__c obj = new DS_PTSD_CA_B__c();
        
        obj.client__c = client.id;
        
        obj.BMETPTSD__c = '1';
        obj.BDOAPTSD__c = date.today();  
        
        obj.BPTSV1__c  = obj.BPTSV2__c  = obj.BPTSV3__c  = obj.BPTSV4__c  = '1';
        obj.BPTSV6__c  = obj.BPTSV7__c  = obj.BPTSV8__c  = obj.BPTSV9__c  = obj.BPTSV10__c = '4';
        obj.BPTSV11__c = obj.BPTSV12__c = obj.BPTSV13__c = obj.BPTSV14__c = obj.BPTSV15__c = '4';
        obj.BPTSV16__c = obj.BPTSV17__c = obj.BPTSV18__c = obj.BPTSV19__c = obj.BPTSV20__c = '2';
        obj.BPTSV21__c = obj.BPTSV22__c = obj.BPTSV23__c = obj.BPTSV24__c = obj.BPTSV25__c = '3';
        obj.BPTSV26__c = obj.BPTSV27__c = obj.BPTSV28__c = obj.BPTSV29__c = obj.BPTSV30__c = '1';
        
        insert obj;
        
        return client;
        
    }
}