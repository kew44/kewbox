/**
 * @author Danny Fu
 * @date 01/08/2016
 * @modified date
 * 
 * @group Test Script 
 * @group-content /ApexDocContent/Test/DS_PTSD_PA_B.htm
 *
 * @description This test provides code coverage for DS_PTSD_PA_B includes
 *  Trigger 
 *  Controllers:
 *   PTSD_PA, PTSD_PA_Report
 *   Bulkified testing
 *   Asserted Variables
 *
**/

@isTest (SeeAllData=false)
private class TestClass_DS_PTSD_PA_B  {

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
    public static DS_PTSD_Scoring ptsdScore = new DS_PTSD_Scoring();
    
    /****
    *@description method to test a bulk creation of object
    ****/
    static TestMethod void bulkifyObj(){
    
        //Get 200 random clients with age range 7 ~ 18
        List<Client__c> clients = test_ut.createClient(test_ut.getClient(null, '7_18', 200));
        
        //init list of object
        List<DS_PTSD_CA_B__c> bulkObj = new List<DS_PTSD_CA_B__c>();  
        
        ///begin bulk insert     
        for (Integer i = 0; i < clients.size(); i++){ 
            //add record with required values
            bulkObj.add(new DS_PTSD_CA_B__c(client__c = clients.get(i).id,
                                        BMETPTSDP__c = '1',
                                        BDOAPTSDP__c = date.today(),
                                        STATUS_PTSD_PA__c = 'Complete'));
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
    
        //create test client 
        Client__c client = test_ut.createClient();//client = new Client__c();test_ut.createClientPTSD_CA_B();//createClient(client);
                
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_PTSD_PA'
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
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_PTSD_PA', '0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        //init list of object
        List<DS_PTSD_CA_B__c> ObjList = new List<DS_PTSD_CA_B__c>();
        
        DS_PTSD_CA_B__c obj= new DS_PTSD_CA_B__c(client__c = client.id,
                                                BMETPTSDP__c = '1',
                                                BDOAPTSDP__c = date.today());    

        //set form's status         
        obj.STATUS_PTSD_PA__c = 'Complete';         
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj); 
        
        //controllers
        DS_PTSD_PA_Controller controller = new DS_PTSD_PA_Controller(sc); 
        DS_PTSD_PA_Report_Controller RC = new DS_PTSD_PA_Report_Controller(sc); 
        
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
        String BPTSV15P= '1';
        String BPTSV13P= '4' ;
        String BPTSFS1P= '2';
        String BMETPTSDP= '0';
        

        //Negative assert statements
        System.assertNotEquals(obj.BPTSV15P__c,BPTSV15P,'Child has NOT been a little mad with someone in the past month. ');
        System.assertNotEquals(obj.BPTSV13P__c,BPTSV13P,'Child has NOT spent most of the past month trying to avoid thinking of what happened. ');
        System.assertNotEquals(obj.BPTSFS1P__c,BPTSFS1P,'Child has NOT found it somewhat difficult to do well in school this past month. ');
        System.assertNotEquals(obj.BMETPTSDP__c,BMETPTSDP,'PTSD_RI was NOT scored by a pen-and-paper assessment only. ');

    }
    
    /****
    *@description method to test a case where there are 2 blanks
    * 
    ****/
    static TestMethod Client__c Test_2Blank() {
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_PTSD_CA_B__c obj = new DS_PTSD_CA_B__c();
        
        obj.client__c = client.id;
        
        obj.BMETPTSDP__c = '1';
        obj.BDOAPTSDP__c = date.today();  
        
        obj.STATUS_PTSD_PA__c = 'Complete';
        
        // Q5 and Q31 are blank
        
        obj.BPTSV1P__c  = obj.BPTSV2P__c  = obj.BPTSV3P__c  = obj.BPTSV4P__c  = '1';
        obj.BPTSV6P__c  = obj.BPTSV7P__c  = obj.BPTSV8P__c  = obj.BPTSV9P__c  = obj.BPTSV10P__c = '4';
        obj.BPTSV11P__c = obj.BPTSV12P__c = obj.BPTSV13P__c = obj.BPTSV14P__c = obj.BPTSV15P__c = '4';
        obj.BPTSV16P__c = obj.BPTSV17P__c = obj.BPTSV18P__c = obj.BPTSV19P__c = obj.BPTSV20P__c = '2';
        obj.BPTSV21P__c = obj.BPTSV22P__c = obj.BPTSV23P__c = obj.BPTSV24P__c = obj.BPTSV25P__c = '3';
        obj.BPTSV26P__c = obj.BPTSV27P__c = obj.BPTSV28P__c = obj.BPTSV29P__c = obj.BPTSV30P__c = '1';
        
        test.startTest();
        
        insert obj;
        
        test.stopTest();
        
        DS_PTSD_CA_B__c ptsd = [SELECT BPTSAB1P__c, BPTSAB2P__c, BPTSAB3P__c, BPTSAB4P__c, BPTSAB5P__c, BPTSAC1P__c, BPTSAC2P__c,
                               		   BPTSAD1P__c, BPTSAD2P__c, BPTSAD3P__c, BPTSAD4P__c, BPTSAD5P__c, BPTSAD6P__c, BPTSAD7P__c,
                               		   BPTSAE1P__c, BPTSAE2P__c, BPTSAE3P__c, BPTSAE4P__c, BPTSAE5P__c, BPTSAE6P__c, 
                                       BPTSVDA1P__c,BPTSVDA2P__c, BPTSAPPCNP__c 
                                  FROM DS_PTSD_CA_B__c WHERE id =: obj.id];
        
        System.assertEquals(2, ptsd.BPTSAB1P__c, 'Symptom B1 is wrong.');
        System.assertEquals(4, ptsd.BPTSAB2P__c, 'Symptom B2 is wrong.');
        System.assertEquals(2, ptsd.BPTSAB3P__c, 'Symptom B3 is wrong.');
        System.assertEquals(4, ptsd.BPTSAB4P__c, 'Symptom B4 is wrong.');
        System.assertEquals(4, ptsd.BPTSAB5P__c, 'Symptom B5 is wrong.');
        
        System.assertEquals(4, ptsd.BPTSAC1P__c, 'Symptom C1 is wrong.');
        System.assertEquals(1, ptsd.BPTSAC2P__c, 'Symptom C2 is wrong.');
        
        System.assertEquals(3, ptsd.BPTSAD1P__c, 'Symptom D1 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD2P__c, 'Symptom D2 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD3P__c, 'Symptom D3 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD4P__c, 'Symptom D4 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD5P__c, 'Symptom D5 is wrong.');
        System.assertEquals(2, ptsd.BPTSAD6P__c, 'Symptom D6 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD7P__c, 'Symptom D7 is wrong.');
        
        System.assertEquals(1, ptsd.BPTSAE1P__c, 'Symptom E1 is wrong.');
		System.assertEquals(2, ptsd.BPTSAE2P__c, 'Symptom E2 is wrong.');
        System.assertEquals(1, ptsd.BPTSAE3P__c, 'Symptom E3 is wrong.');
        System.assertEquals(3, ptsd.BPTSAE4P__c, 'Symptom E4 is wrong.');
        System.assertEquals(4, ptsd.BPTSAE5P__c, 'Symptom E5 is wrong.');
        System.assertEquals(3, ptsd.BPTSAE6P__c, 'Symptom E6 is wrong.');
        
        System.assertEquals(1, ptsd.BPTSVDA1P__c, 'Symptom A1 is wrong.');
        System.assertEquals(2, ptsd.BPTSVDA2P__c, 'Symptom A2 is wrong.');
       
        System.assertEquals(1, ptsd.BPTSAPPCNP__c, 'BPTSAPPCNP__c ERROR');
        
        return client;
        
    }
    
    /****
    *@description method to test a case where there are 3+ blanks
    *Female 
    ****/
    static TestMethod Client__c Test_3Blank() {
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_PTSD_CA_B__c obj = new DS_PTSD_CA_B__c();
        
        obj.client__c = client.id;
        
        obj.BMETPTSDP__c = '1';
        obj.BDOAPTSDP__c = date.today();  
        obj.STATUS_PTSD_PA__c = 'Complete'; 
        
        obj.BPTSV1P__c  = obj.BPTSV2P__c  = obj.BPTSV3P__c  = obj.BPTSV4P__c  = '1';
        obj.BPTSV6P__c  = obj.BPTSV7P__c  = obj.BPTSV8P__c  = obj.BPTSV9P__c  = '4';
        obj.BPTSV11P__c = obj.BPTSV12P__c = obj.BPTSV13P__c = obj.BPTSV14P__c = obj.BPTSV15P__c = '4';
        obj.BPTSV16P__c = obj.BPTSV17P__c = obj.BPTSV18P__c = obj.BPTSV19P__c = obj.BPTSV20P__c = '2';
        obj.BPTSV21P__c = obj.BPTSV22P__c = obj.BPTSV23P__c = obj.BPTSV24P__c = obj.BPTSV25P__c = '3';
        obj.BPTSV26P__c = obj.BPTSV27P__c = obj.BPTSV28P__c = obj.BPTSV29P__c = obj.BPTSV30P__c = '1';
        
        test.startTest();
        
        insert obj;
        
        test.stopTest();
        
        DS_PTSD_CA_B__c ptsd = [SELECT BPTSAB1P__c, BPTSAB2P__c, BPTSAB3P__c, BPTSAB4P__c, BPTSAB5P__c, BPTSAC1P__c, BPTSAC2P__c,
                               		   BPTSAD1P__c, BPTSAD2P__c, BPTSAD3P__c, BPTSAD4P__c, BPTSAD5P__c, BPTSAD6P__c, BPTSAD7P__c,
                               		   BPTSAE1P__c, BPTSAE2P__c, BPTSAE3P__c, BPTSAE4P__c, BPTSAE5P__c, BPTSAE6P__c, 
                                       BPTSVDA1P__c,BPTSVDA2P__c, BPTSAPPCNP__c 
                                  FROM DS_PTSD_CA_B__c WHERE id =: obj.id];
        
        System.assertEquals(0, ptsd.BPTSAPPCNP__c, 'BPTSAPPCNP__c ERROR');
        
        return client;
        
    }
    
    /****
    *@description method to test a case where there is no blank
    * 
    ****/
    static TestMethod Client__c Test_Scoring() {
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_PTSD_CA_B__c obj = new DS_PTSD_CA_B__c();
        
        obj.client__c = client.id;
        
        obj.BMETPTSDP__c = '1';
        obj.BDOAPTSDP__c = date.today();  
        
        obj.STATUS_PTSD_PA__c = 'Complete';
                
        obj.BPTSV1P__c  = obj.BPTSV2P__c  = obj.BPTSV3P__c  = obj.BPTSV4P__c  = obj.BPTSV5P__c  = '1';
        obj.BPTSV6P__c  = obj.BPTSV7P__c  = obj.BPTSV8P__c  = obj.BPTSV9P__c  = obj.BPTSV10P__c = '4';
        obj.BPTSV11P__c = obj.BPTSV12P__c = obj.BPTSV13P__c = obj.BPTSV14P__c = obj.BPTSV15P__c = '4';
        obj.BPTSV16P__c = obj.BPTSV17P__c = obj.BPTSV18P__c = obj.BPTSV19P__c = obj.BPTSV20P__c = '2';
        obj.BPTSV21P__c = obj.BPTSV22P__c = obj.BPTSV23P__c = obj.BPTSV24P__c = obj.BPTSV25P__c = '3';
        obj.BPTSV26P__c = obj.BPTSV27P__c = obj.BPTSV28P__c = obj.BPTSV29P__c = obj.BPTSV30P__c = '1';
        obj.BPTSV31P__c = '1';
        
        test.startTest();
        
        insert obj;
        
        test.stopTest();
        
        DS_PTSD_CA_B__c ptsd = [SELECT BPTSAB1P__c, BPTSAB2P__c, BPTSAB3P__c, BPTSAB4P__c, BPTSAB5P__c, BPTSAC1P__c, BPTSAC2P__c,
                               		   BPTSAD1P__c, BPTSAD2P__c, BPTSAD3P__c, BPTSAD4P__c, BPTSAD5P__c, BPTSAD6P__c, BPTSAD7P__c,
                               		   BPTSAE1P__c, BPTSAE2P__c, BPTSAE3P__c, BPTSAE4P__c, BPTSAE5P__c, BPTSAE6P__c, 
                                       BPTSVDA1P__c,BPTSVDA2P__c, BPTSAPPCNP__c 
                                  FROM DS_PTSD_CA_B__c WHERE id =: obj.id];
        
        System.assertEquals(2, ptsd.BPTSAB1P__c, 'Symptom B1 is wrong.');
        System.assertEquals(4, ptsd.BPTSAB2P__c, 'Symptom B2 is wrong.');
        System.assertEquals(1, ptsd.BPTSAB3P__c, 'Symptom B3 is wrong.');
        System.assertEquals(4, ptsd.BPTSAB4P__c, 'Symptom B4 is wrong.');
        System.assertEquals(4, ptsd.BPTSAB5P__c, 'Symptom B5 is wrong.');
        
        System.assertEquals(4, ptsd.BPTSAC1P__c, 'Symptom C1 is wrong.');
        System.assertEquals(1, ptsd.BPTSAC2P__c, 'Symptom C2 is wrong.');
        
        System.assertEquals(3, ptsd.BPTSAD1P__c, 'Symptom D1 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD2P__c, 'Symptom D2 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD3P__c, 'Symptom D3 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD4P__c, 'Symptom D4 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD5P__c, 'Symptom D5 is wrong.');
        System.assertEquals(2, ptsd.BPTSAD6P__c, 'Symptom D6 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD7P__c, 'Symptom D7 is wrong.');
        
        System.assertEquals(1, ptsd.BPTSAE1P__c, 'Symptom E1 is wrong.');
		System.assertEquals(2, ptsd.BPTSAE2P__c, 'Symptom E2 is wrong.');
        System.assertEquals(1, ptsd.BPTSAE3P__c, 'Symptom E3 is wrong.');
        System.assertEquals(3, ptsd.BPTSAE4P__c, 'Symptom E4 is wrong.');
        System.assertEquals(4, ptsd.BPTSAE5P__c, 'Symptom E5 is wrong.');
        System.assertEquals(3, ptsd.BPTSAE6P__c, 'Symptom E6 is wrong.');
       
        System.assertEquals(1, ptsd.BPTSVDA1P__c, 'Symptom A1 is wrong.');
        System.assertEquals(1, ptsd.BPTSVDA2P__c, 'Symptom A2 is wrong.');
        
        System.assertEquals(1, ptsd.BPTSAPPCNP__c, 'BPTSAPPCNP__c ERROR');
        
        return client;
        
    }
    
    /****
    *@description method to test a case where there is no blank
    * 
    ****/
    static TestMethod Client__c Test_Scoring2() {
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_PTSD_CA_B__c obj = new DS_PTSD_CA_B__c();
        
        obj.client__c = client.id;
        
        obj.BMETPTSDP__c = '1';
        obj.BDOAPTSDP__c = date.today();  
        
        obj.STATUS_PTSD_PA__c = 'Complete';
                
        obj.BPTSV1P__c  = obj.BPTSV2P__c  = obj.BPTSV3P__c  = obj.BPTSV4P__c  = obj.BPTSV5P__c  = '4';
        obj.BPTSV6P__c  = obj.BPTSV7P__c  = obj.BPTSV8P__c  = obj.BPTSV9P__c  = obj.BPTSV10P__c = '4';
        obj.BPTSV11P__c = obj.BPTSV12P__c = obj.BPTSV13P__c = obj.BPTSV14P__c = obj.BPTSV15P__c = '4';
        obj.BPTSV16P__c = obj.BPTSV17P__c = obj.BPTSV18P__c = obj.BPTSV19P__c = obj.BPTSV20P__c = '4';
        obj.BPTSV21P__c = obj.BPTSV22P__c = obj.BPTSV23P__c = obj.BPTSV24P__c = obj.BPTSV25P__c = '4';
        obj.BPTSV26P__c = obj.BPTSV27P__c = obj.BPTSV28P__c = obj.BPTSV29P__c = obj.BPTSV30P__c = '4';
        obj.BPTSV31P__c = '4';
        
        obj.BPTSDURAP__c = '1';
        obj.BPTSD1P__c = '1';
        
        test.startTest();
        
        insert obj;
        
        test.stopTest();
        
        DS_PTSD_CA_B__c ptsd = [SELECT BPTSAB1P__c, BPTSAB2P__c, BPTSAB3P__c, BPTSAB4P__c, BPTSAB5P__c, BPTSAC1P__c, BPTSAC2P__c,
                               		   BPTSAD1P__c, BPTSAD2P__c, BPTSAD3P__c, BPTSAD4P__c, BPTSAD5P__c, BPTSAD6P__c, BPTSAD7P__c,
                               		   BPTSAE1P__c, BPTSAE2P__c, BPTSAE3P__c, BPTSAE4P__c, BPTSAE5P__c, BPTSAE6P__c, 
                                       BPTSVDA1P__c,BPTSVDA2P__c, BPTSAPPCNP__c, BPTSOCNP__c, BPTSORNP__c, BPTSBRNP__c,
                                	   BPTSCRNP__c, BPTSDRNP__c, BPTSERNP__c, BPTSBMNP__c, BPTSCMNP__c, BPTSDMNP__c,
                                	   BPTSEMNP__c 
                                  FROM DS_PTSD_CA_B__c WHERE id =: obj.id];
        
        System.assertEquals(4, ptsd.BPTSAB1P__c, 'Symptom B1 is wrong.');
        System.assertEquals(4, ptsd.BPTSAB2P__c, 'Symptom B2 is wrong.');
        System.assertEquals(4, ptsd.BPTSAB3P__c, 'Symptom B3 is wrong.');
        System.assertEquals(4, ptsd.BPTSAB4P__c, 'Symptom B4 is wrong.');
        System.assertEquals(4, ptsd.BPTSAB5P__c, 'Symptom B5 is wrong.');
        
        System.assertEquals(4, ptsd.BPTSAC1P__c, 'Symptom C1 is wrong.');
        System.assertEquals(4, ptsd.BPTSAC2P__c, 'Symptom C2 is wrong.');
        
        System.assertEquals(4, ptsd.BPTSAD1P__c, 'Symptom D1 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD2P__c, 'Symptom D2 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD3P__c, 'Symptom D3 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD4P__c, 'Symptom D4 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD5P__c, 'Symptom D5 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD6P__c, 'Symptom D6 is wrong.');
        System.assertEquals(4, ptsd.BPTSAD7P__c, 'Symptom D7 is wrong.');
        
        System.assertEquals(4, ptsd.BPTSAE1P__c, 'Symptom E1 is wrong.');
		System.assertEquals(4, ptsd.BPTSAE2P__c, 'Symptom E2 is wrong.');
        System.assertEquals(4, ptsd.BPTSAE3P__c, 'Symptom E3 is wrong.');
        System.assertEquals(4, ptsd.BPTSAE4P__c, 'Symptom E4 is wrong.');
        System.assertEquals(4, ptsd.BPTSAE5P__c, 'Symptom E5 is wrong.');
        System.assertEquals(4, ptsd.BPTSAE6P__c, 'Symptom E6 is wrong.');
       
        System.assertEquals(4, ptsd.BPTSVDA1P__c, 'Symptom A1 is wrong.');
        System.assertEquals(4, ptsd.BPTSVDA2P__c, 'Symptom A2 is wrong.');
        
        System.assertEquals(1, ptsd.BPTSAPPCNP__c, 'BPTSAPPCNP__c ERROR');
        
        System.assertEquals(1, ptsd.BPTSOCNP__c, 'Meets UCLA PTSD Diagnostic Criteria DSM-5 is wrong.');
        System.assertEquals(80, ptsd.BPTSORNP__c, 'Total Scale Score is wrong.');
        System.assertEquals(20, ptsd.BPTSBRNP__c, 'Symptom B score is wrong.');
        System.assertEquals(8, ptsd.BPTSCRNP__c, 'Symptom C score is wrong.');
        System.assertEquals(28, ptsd.BPTSDRNP__c, 'Symptom D score is wrong.');
        System.assertEquals(24, ptsd.BPTSERNP__c, 'Symptom E score is wrong.');
        System.assertEquals(1, ptsd.BPTSBMNP__c, 'Meets Symptom B is wrong.');
        System.assertEquals(1, ptsd.BPTSCMNP__c, 'Meets Symptom C is wrong.');
        System.assertEquals(1, ptsd.BPTSDMNP__c, 'Meets Symptom D is wrong.');
        System.assertEquals(1, ptsd.BPTSEMNP__c, 'Meets Symptom E is wrong.');
        
        return client;
        
    }
    
}