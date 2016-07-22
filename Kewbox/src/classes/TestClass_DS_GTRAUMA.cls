/****
*@description This test provides code coverage for DS_GTRAUMA
*includes:
*Trigger 
*GTRAUMA Controller
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/GTRAUMA.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
private class TestClass_DS_GTRAUMA  {
    
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
    *@description method to test a bulk creation of object
    ****/
    static TestMethod void bulkifyObj(){
        
        //init client
        Client__c client = test_ut.createClient();
         
        //init list of object
        List<DS_GTRAUMA__c> bulkObj = new List<DS_GTRAUMA__c>();     
    
        ///begin bulk insert     
        for (Integer i=0;i<200;i++){
            //add record with required values
            bulkObj.add(new DS_GTRAUMA__c(client__c = client.id,
                                          GT1R__c = '1',GT2R__c = '1',GT3R__c = '1',GT4R__c = '1',
                                          GT5R__c = '1',GT6R__c = '1',GT7R__c = '1',GT8R__c = '1',
                                          GT9R__c = '1',GT10R__c = '1',GT11R__c = '1',GT12R__c = '1',
                                          GT13R__c = '1',GT14R__c = '1',GT15R__c = '1',GT16R__c = '1',
                                          GT17R__c = '1',GT18R__c = '1',GT19R__c = '1',GT20R__c = '1',
                                          GT21R__c = '1',GT22R__c = '1',GT23R__c = '1'));
        }
        
        //add list of records to object
        insert bulkObj;
    }
    
    /****
    *@description method to test controller associated with object
    *assert methods represent data types from each controller 
    *some variables asserted may represent required values for certain logic
    ****/
    static TestMethod void assertControllers(){
            
        //create test client 
        Client__c client = test_ut.createClientSummary();//
                
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c WHERE Page__c = 'DS_GTRAUMA'AND File_name__c = 'BASELINE'AND Category__c = 'GT'];
        
        String dpID = String.valueOf(dataPage.id);      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '-1',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'GT',
                                                            STATUS__c = 'Complete');
        
        insert summary;                   
        
        //summaryId     
        String summaryId = summary.id;//test_ut.getClientSummaryId(client.id, 'DS_GTRAUMA','-1');
        
        //init object w/ required variables
        DS_GTRAUMA__c obj = new DS_GTRAUMA__c(client__c = client.id, 
                                              GT1R__c = '1',GT2R__c = '1',GT3R__c = '1',GT4R__c = '1',
                                              GT5R__c = '1',GT6R__c = '1',GT7R__c = '1',GT8R__c = '1',
                                              GT9R__c = '1',GT10R__c = '1',GT11R__c = '1',GT12R__c = '1',
                                              GT13R__c = '1',GT14R__c = '1',GT15R__c = '1',GT16R__c = '1',
                                              GT17R__c = '1',GT18R__c = '1',GT19R__c = '1',GT20R__c = '1',
                                              GT21R__c = '1',GT22R__c = '1',GT23R__c = '1');
        
        insert obj;
        update obj;
                
        //encoded parameters
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);     
                
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);   
                
        DS_GTRAUMA_Controller controller = new DS_GTRAUMA_Controller(sc);
        
        //non-standard list options 
        List<SelectOption> radio = controller.getTraumaType();
        List<SelectOption> radioYesNo = controller.getPrimaryType();
        
        controller.rowList();
        
        //save/cancel
        controller.save();
        controller.cancel();
        
        //assert*positive
        System.assertEquals(obj.GT8R__c, '1', 'There is a problem with the variable GT8R.');
        System.assertEquals(obj.GT20R__c, '1', 'There is a problem with the variable GT20R.');
        System.assertEquals(obj.GT8RA0__c, false, 'There is a problem with the variable GT8RA0.');
    }

}