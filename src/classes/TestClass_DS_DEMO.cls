@istest(SeeAllData=false)
public class TestClass_DS_DEMO {
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();      
    }
    
    // Test baseline controller 
    static TestMethod void Test_Baseline_Controller() {
        
        Client__c client = test_ut.createClient();
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_DEMO', '0');
        
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();    
        obj.STATUS_DEMO__c = 'Complete';
        obj.client__c = client.id;  
        obj.RREF__c= true;
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        DS_DEMO_Controller controller = new DS_DEMO_Controller(sc);        
        
        List<SelectOption> q4 = controller.getQ4Items();
        List<SelectOption> hisplat = controller.getHispLatItems();
        List<SelectOption> q14 = controller.getQ14Items();
        List<SelectOption> milself = controller.getMilSelfItems();
        List<SelectOption> milfam = controller.getMilFamItems();
        List<SelectOption> overall = controller.getOverAllItems();
        List<SelectOption> geniden = controller.getGenIdenItems();
        List<SelectOption> orient = controller.getOrientItems();
        
        controller.save();
        controller.cancel();
     
    }
    
    static TestMethod void skipTest() {
    
        //create test client 
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);       
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
        
        obj.client__c = client.id; 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        
        obj.RWHITE__c=true;
        
        //skipLogic determining values
        
        String CUREPI='0'; 
        Boolean BINFOTHR=true;
        String BGUARD='98';
        Boolean BREFSRO=true;
        String BETHNIC='1';
        Boolean BETHNICHO=true; 
        String BUSBORN='0'; 
        String BPUSBORN='0'; 
        String BSIBLING='1'; 
        Boolean BTREATO=true;
        Boolean BPROTHNW=true; 
        String BTRT='1'; 
        Boolean BTRTOTHR=true; 
        String BHSR='1';
        String BDEVCON='1';
        Boolean BDEVOTHR=true; 
        String BDVTR='1';
        Boolean BDVTROTR=true; 
        String BDVSR='1'; 
        Boolean BRHCO=true; 
        
        insert obj;
        
        //assert not equals. if test object value does not equal the test condition variable, skiplogic is not triggered, opposite message displayed
        System.assertNotEquals(obj.CUREPI__c, CUREPI, 'This is the first visit.');//3
        System.assertNotEquals(obj.BINFOTHR__c,BINFOTHR,'Information NOT collected from other source.');//4
        System.assertNotEquals(obj.BGUARD__c,BGUARD ,'Standard legal guardian.');//5
        System.assertNotEquals(obj.BREFSRO__c,BREFSRO ,'Not referred by other means.');//6
        System.assertNotEquals(obj.BTREATO__c,BTREATO ,'Standard services intended');//7
        //  System.assertNotEquals(obj.BETHNIC__c,BETHNIC ,'Child is not Hispanic');//1
        //  System.assertNotEquals(obj.BETHNICHO__c,BETHNICHO  ,'Standard Hispanic or Latino ethnic group.');//1a
        System.assertNotEquals(obj.BUSBORN__c,BUSBORN  ,'Born in the US');//3
        System.assertNotEquals(obj.BPUSBORN__c,BPUSBORN ,'Parent born in the US');//4
        System.assertNotEquals(obj.BSIBLING__c,BSIBLING  ,'No siblings in data set');//5
        System.assertNotEquals(obj.BRHCO__c,BRHCO  ,'Standard regular health provider');//11
        System.assertNotEquals(obj.BPROTHNW__c,BPROTHNW ,'Standard current healthcare provider');//12
        
    }
    
    static TestMethod void specifyTest() {
    
        //create test client 
        Client__c client = test_ut.createClientSummary();
        String cimi= ut.urlEncode('c='+client.id);
        ApexPages.currentPage().getParameters().put('cimi',cimi);       
        
        DS_Background_Family_Info_B__c obj = new DS_Background_Family_Info_B__c();
        
        obj.client__c = client.id; 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        
        String CUREPVS = 'null';
        String BINFOSP = 'null';
        String BGUARDSP = 'null';
        String BREFSOSP = 'null';
        String BTREATOSP = 'null';
        String CTYBORN = 'null';
        String BPUSBORNSP = 'null';
        Integer BSIBNUM = 0;
        String BRHCOSP = 'null';
        String BPROSPNW = 'null';
                
        System.assertNotEquals(obj.CUREPVS__c,CUREPVS , 'There have/has been' + obj.CUREPVS__c+' visits.');
        System.assertNotEquals(obj.BINFOSP__c,BINFOSP, 'Information source is'+obj.BINFOSP__c+'.');
        System.assertNotEquals(obj.BGUARDSP__c,BGUARDSP ,'The guardianship is specified as '+obj.BGUARDSP__c+'.');
        System.assertNotEquals(obj.BREFSOSP__c,BREFSOSP , 'Referred by'+obj.BREFSOSP__c+'.');
        System.assertNotEquals(obj.BTREATOSP__c,BTREATOSP , 'Service of '+obj.BTREATOSP__c+' intended.');
        System.assertNotEquals(obj.CTYBORN__c,CTYBORN , 'Child was born in '+ obj.CTYBORN__c+'.');
        System.assertNotEquals(obj.BPUSBORNSP__c,BPUSBORNSP , 'Parent was born in '+obj.BPUSBORNSP__c+'.');
        System.assertNotEquals(obj.BSIBNUM__c,BSIBNUM , 'There is/are '+obj.BSIBNUM__c+' sibling(s).');
        System.assertNotEquals(obj.BRHCOSP__c, BRHCOSP, 'Regular health provider is '+obj.BRHCOSP__c+'.');
        System.assertNotEquals(obj.BPROSPNW__c,BPROSPNW , 'Current health provider is'+obj.BPROSPNW__c+'.');
    }
    
}