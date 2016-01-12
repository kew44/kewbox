/****
*@description This test provides code coverage for DS_PTSD_PA_F
*includes
*Trigger 
*Controllers:
    *PTSD_PA, PTSD_PA_Report
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_PTSD_PA_F.htm
*
*@author Danny Fu
*@date 01/08/2016
*@modified date
****/

@isTest (SeeAllData=false)
public class TestClass_DS_PTSD_PA_F {
    
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
        //importData.variable();
    }
    
    /****
    @description Initialize reference PTSD Scoring class 
    ****/
    DS_PTSD_Scoring cbclScore = new DS_PTSD_Scoring();  
    
    /****
    *@description method to test a bulk creation of object
    ****/
    static TestMethod void bulkifyObj(){
            
        //init client
        Client__c client = test_ut.createClientSummary();
        
        //init list of object
        List<DS_PTSD_CA_F__c> bulkObj = new List<DS_PTSD_CA_F__c>(); 
        
        ///begin bulk insert     
        for (Integer i=0;i<200;i++){
            //add record with required values
            bulkObj.add(new DS_PTSD_CA_F__c(client__c = client.id,
                                        FMETPTSD__c = '1',
                                        FDOAPTSD__c = date.today(),
                                        STATUS_PTSD_PA__c = 'Complete'));
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
    
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_PTSD_PA'
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
        
        System.debug(summary);
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_PTSD_PA', section);
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        //init list of object
        List<DS_PTSD_CA_F__c> ObjList = new List<DS_PTSD_CA_F__c>();
        
        //init object w/ required variables
        DS_PTSD_CA_F__c obj= new DS_PTSD_CA_F__c(client__c = client.id,
                                                FMETPTSDP__c = '1',
                                                FDOAPTSDP__c = date.today());
                                                
        //set form's status         
        obj.STATUS_PTSD_PA__c = 'Complete';         
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj); 
        
        //controllers
        DS_PTSD_PA_Controller controller = new DS_PTSD_PA_Controller(sc); 
        DS_PTSD_PA_Report_Controller RC = new DS_PTSD_PA_Report_Controller(sc); 
        
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
        String FPTSV15P= '1';
        String FPTSV13P= '4' ;
        String FPTSFS1P= '2';
        String FMETPTSDP= '0';
        
        //Negative assert statements
        System.assertNotEquals(obj.FPTSV15__c,FPTSV15P,'Child has NOT been a little mad with someone in the past month. ');
        System.assertNotEquals(obj.FPTSV13__c,FPTSV13P,'Child has NOT spent most of the past month trying to avoid thinking of what happened. ');
        System.assertNotEquals(obj.FPTSFS1__c,FPTSFS1P,'Child has NOT found it somewhat difficult to do well in school this past month. ');
        System.assertNotEquals(obj.FMETPTSD__c,FMETPTSDP,'PTSD_RI was NOT scored by a pen-and-paper assessment only. ');

    }
    
    /****
    *@description method to test a case where there are 2 blanks
    * 
    ****/
    static TestMethod Client__c Test_2Blank() {
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_PTSD_CA_F__c obj = new DS_PTSD_CA_F__c();
        
        obj.client__c = client.id;
        
        obj.FMETPTSDP__c = '1';
        obj.FDOAPTSDP__c = date.today();  
        
        obj.STATUS_PTSD_PA__c = 'Complete';
        
        // Q5 and Q31 are blank
        
        obj.FPTSV1P__c  = obj.FPTSV2P__c  = obj.FPTSV3P__c  = obj.FPTSV4P__c  = '1';
        obj.FPTSV6P__c  = obj.FPTSV7P__c  = obj.FPTSV8P__c  = obj.FPTSV9P__c  = obj.FPTSV10P__c = '4';
        obj.FPTSV11P__c = obj.FPTSV12P__c = obj.FPTSV13P__c = obj.FPTSV14P__c = obj.FPTSV15P__c = '4';
        obj.FPTSV16P__c = obj.FPTSV17P__c = obj.FPTSV18P__c = obj.FPTSV19P__c = obj.FPTSV20P__c = '2';
        obj.FPTSV21P__c = obj.FPTSV22P__c = obj.FPTSV23P__c = obj.FPTSV24P__c = obj.FPTSV25P__c = '3';
        obj.FPTSV26P__c = obj.FPTSV27P__c = obj.FPTSV28P__c = obj.FPTSV29P__c = obj.FPTSV30P__c = '1';
        
        insert obj;
        
        DS_PTSD_CA_F__c ptsd = [SELECT FPTSAB1P__c, FPTSAB2P__c, FPTSAB3P__c, FPTSAB4P__c, FPTSAB5P__c, FPTSAC1P__c, FPTSAC2P__c,
                               		   FPTSAD1P__c, FPTSAD2P__c, FPTSAD3P__c, FPTSAD4P__c, FPTSAD5P__c, FPTSAD6P__c, FPTSAD7P__c,
                               		   FPTSAE1P__c, FPTSAE2P__c, FPTSAE3P__c, FPTSAE4P__c, FPTSAE5P__c, FPTSAE6P__c, 
                                       FPTSVDA1P__c,FPTSVDA2P__c, FPTSAPPCNP__c 
                                  FROM DS_PTSD_CA_F__c WHERE id =: obj.id];
        
        System.assertEquals(2, ptsd.FPTSAB1P__c, 'Symptom B1 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB2P__c, 'Symptom B2 is wrong.');
        System.assertEquals(2, ptsd.FPTSAB3P__c, 'Symptom B3 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB4P__c, 'Symptom B4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB5P__c, 'Symptom B5 is wrong.');
        
        System.assertEquals(4, ptsd.FPTSAC1P__c, 'Symptom C1 is wrong.');
        System.assertEquals(1, ptsd.FPTSAC2P__c, 'Symptom C2 is wrong.');
        
        System.assertEquals(3, ptsd.FPTSAD1P__c, 'Symptom D1 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD2P__c, 'Symptom D2 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD3P__c, 'Symptom D3 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD4P__c, 'Symptom D4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD5P__c, 'Symptom D5 is wrong.');
        System.assertEquals(2, ptsd.FPTSAD6P__c, 'Symptom D6 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD7P__c, 'Symptom D7 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSAE1P__c, 'Symptom E1 is wrong.');
		System.assertEquals(2, ptsd.FPTSAE2P__c, 'Symptom E2 is wrong.');
        System.assertEquals(1, ptsd.FPTSAE3P__c, 'Symptom E3 is wrong.');
        System.assertEquals(3, ptsd.FPTSAE4P__c, 'Symptom E4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAE5P__c, 'Symptom E5 is wrong.');
        System.assertEquals(3, ptsd.FPTSAE6P__c, 'Symptom E6 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSVDA1P__c, 'Symptom A1 is wrong.');
        System.assertEquals(2, ptsd.FPTSVDA2P__c, 'Symptom A2 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSAPPCNP__c, 'FPTSAPPCNP__c ERROR');
        
        return client;
        
    }
    
    /****
    *@description method to test a case where there are 3+ blanks
    * 
    ****/
    static TestMethod Client__c Test_3Blank() {
               
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_PTSD_CA_F__c obj = new DS_PTSD_CA_F__c();
        
        obj.client__c = client.id;
        
        obj.FMETPTSDP__c = '1';
        obj.FDOAPTSDP__c = date.today();  
        
        obj.STATUS_PTSD_PA__c = 'Complete';
        
        // Q5, Q10 and Q31 are blank
        
        obj.FPTSV1P__c  = obj.FPTSV2P__c  = obj.FPTSV3P__c  = obj.FPTSV4P__c  = '1';
        obj.FPTSV6P__c  = obj.FPTSV7P__c  = obj.FPTSV8P__c  = obj.FPTSV9P__c  = '4';
        obj.FPTSV11P__c = obj.FPTSV12P__c = obj.FPTSV13P__c = obj.FPTSV14P__c = obj.FPTSV15P__c = '4';
        obj.FPTSV16P__c = obj.FPTSV17P__c = obj.FPTSV18P__c = obj.FPTSV19P__c = obj.FPTSV20P__c = '2';
        obj.FPTSV21P__c = obj.FPTSV22P__c = obj.FPTSV23P__c = obj.FPTSV24P__c = obj.FPTSV25P__c = '3';
        obj.FPTSV26P__c = obj.FPTSV27P__c = obj.FPTSV28P__c = obj.FPTSV29P__c = obj.FPTSV30P__c = '1';
        
        insert obj;
        
        DS_PTSD_CA_F__c ptsd = [SELECT FPTSAB1P__c, FPTSAB2P__c, FPTSAB3P__c, FPTSAB4P__c, FPTSAB5P__c, FPTSAC1P__c, FPTSAC2P__c,
                               		   FPTSAD1P__c, FPTSAD2P__c, FPTSAD3P__c, FPTSAD4P__c, FPTSAD5P__c, FPTSAD6P__c, FPTSAD7P__c,
                               		   FPTSAE1P__c, FPTSAE2P__c, FPTSAE3P__c, FPTSAE4P__c, FPTSAE5P__c, FPTSAE6P__c, 
                                       FPTSVDA1P__c,FPTSVDA2P__c, FPTSAPPCNP__c 
                                  FROM DS_PTSD_CA_F__c WHERE id =: obj.id];
        
        System.assertEquals(0, ptsd.FPTSAPPCNP__c, 'FPTSAPPCNP__c ERROR');
        
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
        
        obj.FMETPTSDP__c = '1';
        obj.FDOAPTSDP__c = date.today();  
        
        obj.STATUS_PTSD_PA__c = 'Complete';
                
        obj.FPTSV1P__c  = obj.FPTSV2P__c  = obj.FPTSV3P__c  = obj.FPTSV4P__c  = obj.FPTSV5P__c  = '1';
        obj.FPTSV6P__c  = obj.FPTSV7P__c  = obj.FPTSV8P__c  = obj.FPTSV9P__c  = obj.FPTSV10P__c = '4';
        obj.FPTSV11P__c = obj.FPTSV12P__c = obj.FPTSV13P__c = obj.FPTSV14P__c = obj.FPTSV15P__c = '4';
        obj.FPTSV16P__c = obj.FPTSV17P__c = obj.FPTSV18P__c = obj.FPTSV19P__c = obj.FPTSV20P__c = '2';
        obj.FPTSV21P__c = obj.FPTSV22P__c = obj.FPTSV23P__c = obj.FPTSV24P__c = obj.FPTSV25P__c = '3';
        obj.FPTSV26P__c = obj.FPTSV27P__c = obj.FPTSV28P__c = obj.FPTSV29P__c = obj.FPTSV30P__c = '1';
        obj.FPTSV31P__c = '1';
        
        insert obj;
        
        DS_PTSD_CA_F__c ptsd = [SELECT FPTSAB1P__c, FPTSAB2P__c, FPTSAB3P__c, FPTSAB4P__c, FPTSAB5P__c, FPTSAC1P__c, FPTSAC2P__c,
                               		   FPTSAD1P__c, FPTSAD2P__c, FPTSAD3P__c, FPTSAD4P__c, FPTSAD5P__c, FPTSAD6P__c, FPTSAD7P__c,
                               		   FPTSAE1P__c, FPTSAE2P__c, FPTSAE3P__c, FPTSAE4P__c, FPTSAE5P__c, FPTSAE6P__c, 
                                       FPTSVDA1P__c,FPTSVDA2P__c, FPTSAPPCNP__c 
                                  FROM DS_PTSD_CA_F__c WHERE id =: obj.id];
        
        System.assertEquals(2, ptsd.FPTSAB1P__c, 'Symptom B1 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB2P__c, 'Symptom B2 is wrong.');
        System.assertEquals(1, ptsd.FPTSAB3P__c, 'Symptom B3 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB4P__c, 'Symptom B4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAB5P__c, 'Symptom B5 is wrong.');
        
        System.assertEquals(4, ptsd.FPTSAC1P__c, 'Symptom C1 is wrong.');
        System.assertEquals(1, ptsd.FPTSAC2P__c, 'Symptom C2 is wrong.');
        
        System.assertEquals(3, ptsd.FPTSAD1P__c, 'Symptom D1 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD2P__c, 'Symptom D2 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD3P__c, 'Symptom D3 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD4P__c, 'Symptom D4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD5P__c, 'Symptom D5 is wrong.');
        System.assertEquals(2, ptsd.FPTSAD6P__c, 'Symptom D6 is wrong.');
        System.assertEquals(4, ptsd.FPTSAD7P__c, 'Symptom D7 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSAE1P__c, 'Symptom E1 is wrong.');
		System.assertEquals(2, ptsd.FPTSAE2P__c, 'Symptom E2 is wrong.');
        System.assertEquals(1, ptsd.FPTSAE3P__c, 'Symptom E3 is wrong.');
        System.assertEquals(3, ptsd.FPTSAE4P__c, 'Symptom E4 is wrong.');
        System.assertEquals(4, ptsd.FPTSAE5P__c, 'Symptom E5 is wrong.');
        System.assertEquals(3, ptsd.FPTSAE6P__c, 'Symptom E6 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSVDA1P__c, 'Symptom A1 is wrong.');
        System.assertEquals(1, ptsd.FPTSVDA2P__c, 'Symptom A2 is wrong.');
        
        System.assertEquals(1, ptsd.FPTSAPPCNP__c, 'FPTSAPPCNP__c ERROR');
        
        return client;
        
    }

}