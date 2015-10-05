@isTest (SeeAllData=false)
private class TestClass_ClientSummary {
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    static TestMethod void Test_ClientSummaryController() {
        
        Utility ut = new Utility();
        
        TestClass_A_Utility test_ut = new TestClass_A_Utility();
        
        Client__c client = test_ut.createClient();
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        ApexPages.currentPage().getParameters().put('id', client.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(client);
        
        ClientSummaryController summary = new ClientSummaryController(sc);
        
        summary.SummaryInit();
        summary.traumaHistoryRowList();
        
        String clientInfo = summary.getClientInfo();
        
        PageReference no = summary.No();
        PageReference yes = summary.Yes();
        
        //String clientInfo = summary.getClientInfo();
        
        
        // need client who has TD record
        
    }
    
    
    
    
}