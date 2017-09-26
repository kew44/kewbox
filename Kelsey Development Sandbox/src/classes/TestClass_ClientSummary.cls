/****
*@description This test provides code coverage for Client Summary
*
*@group Test Script 
*@group-content /ApexDocContent/Test/ClientSummary.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
*
*@modified	10/31/16	KW	reduce SOQL 
****/

@isTest (SeeAllData=false)
private class TestClass_ClientSummary {    
    
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
    }
    
    /****
    *@description method to test ClientSummaryController
    ****/
    static TestMethod void Test_ClientSummaryController() {
        
        //Client__c client = test_ut.createClient();
        Client__c client = test_ut.createClientSummary();
        
        FormBuilder FB = new FormBuilder();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        ApexPages.currentPage().getParameters().put('id', client.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(client);
        
        ClientSummaryController summary = new ClientSummaryController(sc);
        
        String summaryFields = ut.getFields('Client_Summary__c');
        
        String forceRedirect = summary.forceRedirect;
        Decimal sectionNum = summary.sectionNum;
        String visitType = summary.visitType;  
        
        summary.baseline = new List<Client_Summary__c>();
        summary.followUp = new List<Client_Summary__c>();
        
        summary.visitFormList = new List<Client_Summary__c>();
        
        Boolean traumaBtn = summary.traumaBtn;
        Boolean fuBtn = summary.fuBtn;
        Boolean baselineBtn = summary.baselineBtn; 
                    
        summary.SummaryInit();
        summary.traumaHistoryRowList();
        
        String clientInfo = summary.getClientInfo();
        
        PageReference no = summary.No();
		test.startTest();
        PageReference yes = summary.Yes();
		test.stopTest();
        
        summary.showPopup();     
        summary.closePopup();   
        
    }      
}