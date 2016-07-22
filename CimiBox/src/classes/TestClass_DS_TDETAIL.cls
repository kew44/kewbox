/****
*@description This test provides code coverage for Trauma Details
*includes
*TRDETAIL1 Trigger
*TRDETAIL2 Trigger 
*DS_TDETAIL_Controller
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_TDETAIL.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
private class TestClass_DS_TDETAIL {
    
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
    static TestMethod void BulkTraumaDetail() {
        
        Client__c client = test_ut.createClientGTRAUMA();
        
        List<DS_DATA__c> forms = [SELECT Page__c, Weight__c, Object__c
                                  FROM DS_Data__c
                                  WHERE Category__c = 'TD'
                                  AND Data_Type__c = 'DS_Form_Info'
                                  AND weight__c = 1];
        
        SObject TDObject;
        
        List<Sobject> insertObj = new List<Sobject>();
        
        for(DS_Data__c info : forms) {
            
            Schema.SObjectType TDObjectType = Schema.getGlobalDescribe().get(info.Object__c+'__c');
            
            for(Integer i = 0; i < 200; i++) {
                
                TDObject = TDObjectType.newSObject();
                
                TDObject.put('client__c', client.id);
                TDObject.put('T'+info.Weight__c+'RRODT__c', date.today());
                
                //insert TDObject;
                insertObj.add(TDObject);
                
            }            
        }        
        insert insertObj;        
    }
    
    /****
    *@description method to test controller
    ****/
    static TestMethod void Test_DS_TDETAIL_Controller() {
                
        Client__c client = test_ut.createClientGTRAUMA();
        
        Client_Summary__c summary = [SELECT id 
                                     FROM Client_Summary__c
                                     WHERE Page__r.Variable__c = 'GT8R'
                                     AND Client__c = : client.id];    
        
        String cimi = ut.urlEncode('c='+client.id+'&TDF=TRDOMVIO'+'&summary='+summary.id);
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        // TRDOMVIO  
        DS_TDETAIL_Controller controller = new DS_TDETAIL_Controller();
        
        controller.getContent();        
        
        DS_TRDETAIL2__c commvio = new DS_TRDETAIL2__c();
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        controller = new DS_TDETAIL_Controller();
        
        controller.getContent();
        
        Component.Apex.pageBlock block = new Component.Apex.pageBlock();
        
        List<String> questionType = 
            new List<String>{
                    'RBASE',  'RBEN',   'RCG',    'RCMP',   'RCP',    'RD',     'RDIS',   'RDU',  'RDV',
                    'REVAC',  'RFREQ',  'RFRGT',  'RFTB',   'RGANG',  'RHDAM',  'RILL',   'RIMP',
                    'RIN',    'RINC',   'RINJ',   'RINJ_2', 'RINJ_3', 'RINJ_4', 'RLIFE',  'RMED', 'RMEN', 'RMTYP',
                    'RNTYPES','RPAIN',  'RPENET', 'RPER',   'RPER_2', 'RPER_3', 'RPER_4', 'RPICU',
                    'RPORNOG','RPR',    'RPR_2',  'RRE',    'RREPORT','RRES',   'RRESIB',
                    'RREUN',  'RSE',    'RSET_1', 'RSET_2', 'RSET_3', 'RSET_4', 'RSRV',
                    'RST',    'RTHI',   'RTR',    'RTRNSP', 'RTT12C', 'RTVIO',  'RTYP',   'RTYPDS',
                    'RVTYP',  'RWEAPON','RWPN',   'RWPN_2', 'RTYPDS', 'SECTION','STATUS', 'SUBMITBTN', 'null'
                        };
                        
        for(String question : questionType) {
            System.debug(question);
            controller.elementGenerator(block, question, '1', 'test');
        }
        
        controller.save();
        controller.cancel();
        
        DS_TRDETAIL2__c tr = new DS_TRDETAIL2__c(client__c = client.id);
        insert tr;
        
        // Update record
        commvio = [SELECT id FROM DS_TRDETAIL2__c WHERE client__c =: client.id];
        
        controller = new DS_TDETAIL_Controller();
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        controller.save();
        
    }
        
}