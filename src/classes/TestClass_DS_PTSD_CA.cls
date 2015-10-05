@isTest (SeeAllData=false)
private class TestClass_DS_PTSD_CA {
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    static TestMethod void Test_Baseline_Controller() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_PTSD_CA', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi', cimi);
        
        DS_PTSD_CA_B__c ptsd = new DS_PTSD_CA_B__c();
        
        ptsd.client__c = client.id;
        ptsd.BMETPTSD__c = '1';
        // ptsd.BPTSDATE__c = System.today();//Date.today();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ptsd);  
        DS_PTSD_CA_Controller controller = new DS_PTSD_CA_Controller(sc); 
        
        List<SelectOption> radio = controller.getRadioItems();
        List<SelectOption> radioYesNo = controller.getRadioYesNo();
        
        List<SelectOption> nsvu = controller.getRadioItems();
        List<SelectOption> nsvu2 = controller.getRadioYesNo();
        
        controller.save();
        controller.saveView();
        controller.cancel();
        
        
    }
    
    // Test follow-up controller 
    static TestMethod void Test_Followup_Controller() {
        
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_PTSD_CA', section);
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_PTSD_CA_F__c obj = new DS_PTSD_CA_F__c();    
        obj.STATUS_PTSD_CA__c = 'Complete';
        obj.client__c = client.id;   
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_PTSD_CA_Controller controller = new DS_PTSD_CA_Controller(sc); 
        
        List<SelectOption> nsvu = controller.getRadioItems();
        List<SelectOption> nsvu2 = controller.getRadioYesNo();
                
        controller.save();
        controller.cancel();
        controller.saveView();
        
    }
    
    static TestMethod Client__c Test0_BaselineTestInsertWithMoreeThan3Blank() {
               
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
    
    static TestMethod Client__c Test1_BaselineTestInsertWith2Blank() {
                
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 8));
        
        DS_PTSD_CA_B__c obj = new DS_PTSD_CA_B__c();
        
        obj.client__c = client.id;
        
        obj.BMETPTSD__c = '1';
        obj.BDOAPTSD__c = date.today(); 
        
        obj.BPTSV1__c  = obj.BPTSV2__c  = obj.BPTSV3__c  = obj.BPTSV4__c  = obj.BPTSV5__c  = '2';
        obj.BPTSV6__c  = obj.BPTSV7__c  = obj.BPTSV8__c  = obj.BPTSV9__c  = obj.BPTSV10__c = '4';
        obj.BPTSV11__c = obj.BPTSV12__c = obj.BPTSV13__c = obj.BPTSV14__c = obj.BPTSV15__c = '4';
        obj.BPTSV16__c = obj.BPTSV17__c = obj.BPTSV18__c = obj.BPTSV19__c = obj.BPTSV20__c = '2';
        obj.BPTSV21__c = obj.BPTSV22__c = obj.BPTSV23__c = obj.BPTSV24__c = obj.BPTSV25__c = '3';
        obj.BPTSV26__c = obj.BPTSV27__c = obj.BPTSV28__c = obj.BPTSV29__c = obj.BPTSV30__c = '2';
        
        insert obj;
        
        return client;
        
    }
    
}