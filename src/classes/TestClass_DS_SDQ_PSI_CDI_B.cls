/****
*@description This test provides code coverage for DS_SDQ_PSI_CDI_B
*includes
*Trigger 
*Controllers:
    *SDQ_P_04_10, SDQ_P_11_17, SDQ_S_11_17, SDQ_P_04_10_Report, SDQ_P_11_17_Report, SDQ_S_11_17_Report
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_SDQ_PSI_CDI_B.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
private class TestClass_DS_SDQ_PSI_CDI_B  {

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
    *@description method to test a bulk creation of object
    ****/
    static TestMethod void bulkifyObj(){
    
        //init client
        Client__c client = test_ut.createClient();
        
        //init list of object
        List<DS_SDQ_PSI_CDI_B__c> bulkObj = new List<DS_SDQ_PSI_CDI_B__c>();
        
        ///begin bulk insert     
        for (Integer i=0;i<200;i++){            
            bulkObj.add(new DS_SDQ_PSI_CDI_B__c(client__c = client.id,
                                                BEMONULLP__c = 0, BBEHNULLP__c = 0, BHYPNULLP__c = 0, BOTCNULLP__c = 0, BKHBNULLP__c = 0,//null counts parent
                                                BEMONULLS__c = 0, BBEHNULLS__c = 0, BHYPNULLS__c = 0, BOTCNULLS__c = 0, BKHBNULLS__c = 0,//null counts self
                                                BDOASDYP__c = System.today(), BDOASDOP__c = System.today(), BDOASDOS__c = System.today(),
                                                BMETSDYP__c = '1', BMETSDOP__c = '1', BMETSDOS__c = '1',
                                                SECTION__c = '0'));      
        }
        
    }
    
    /****
    *@description method to test controllers associated with object
    *Young Child, Parent Form
    *assert methods represent data types from each controller 
    *some variables asserted may represent required values for certain logic
    ****/
    static TestMethod void assertControllerYP() {    
    
        //create test client 
        Client__c client = test_ut.createClient();        
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_SDQ_P_04_10'
                                AND File_name__c = 'BASELINE'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '0',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'Baseline',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
        
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();     
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_P_04_10', '0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_B__c> ObjList = new List<DS_SDQ_PSI_CDI_B__c>();
        
        //init object w/ required vals
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c(client__c = client.id,
                                                            BEMONULLP__c = 0, BBEHNULLP__c = 0, BHYPNULLP__c = 0, BOTCNULLP__c = 0, BKHBNULLP__c = 0,//null counts 
                                                            BSDPTANT__c = '1', BSDPOBEY__c = '1', BSDPFIGH__c = '1', BSDPLIES__c = '1', BSDPSTEA__c = '1',//behavioral responses parent
                                                            BSDPREST__c = '1', BSDPFIDG__c = '1', BSDPDIST__c = '1', BSDPREFL__c = '1', BSDPATTE__c= '2',//hyperactive responses parent
                                                            BDOASDYP__c = System.today(), 
                                                            BMETSDYP__c = '1', 
                                                            SECTION__c = '0');  
                
        //set form's status 
        obj.STATUS_SDQ_P_04_10__c = 'Complete';        
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.BSDPETYP__c;
        score.BTYP=obj.BSDPBTYP__c;
        score.HTYP=obj.BSDPHTYP__c;
        score.OTYP=obj.BSDPOTYP__c;
        score.KTYP=obj.BSDPKTYP__c;
        score.ITYP=obj.BSDPITYP__c;
        
        //init difficulties present to scoring class
        score.EBCD=obj.BSDPEBCD__c;
        
        //init parent/self variable to scoring class
        score.Pors='P';
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_P_04_10_Controller controller = new DS_SDQ_P_04_10_Controller(sc);    
        DS_SDQ_P_04_10_Report_Controller RC = new DS_SDQ_P_04_10_Report_Controller(sc);       
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();
        
        //save/cancel
        controller.save();
        controller.cancel();
        controller.saveview();
        
        RC.init();
        RC.editRecord();
        RC.addVisit(ObjList, 'B'); 
        
        //init variable alias to be tested    
        String BSDPINFOR= '0';
        String BSDPFIDG= '2';
        String BSDPFIGH = '1';
        Date BDOASDYP=system.today();
        //Negative assert statements
        System.assertNotEquals(obj.BSDPINFOR__c,BSDPINFOR,'Mother was NOT informant ');
        System.assertNotEquals(obj.BSDPFIDG__c,BSDPFIDG,'Child is certainally NOT fidgety. ');
        System.assertEquals(obj.BDOASDYP__c,BDOASDYP,'Administered  today,  '+obj.BDOASDYP__c+'. ');
        System.assertEquals(obj.BSDPFIGH__c, BSDPFIGH, 'Child sometimes fights with or bullies other children.');
    }
    
    /****
    *@description method to test controllers associated with object 
    *Old Child, Parent Form
    ****/
    static TestMethod void assertControllerOP() {
    
        //create test client 
        Client__c client = test_ut.createClient();        
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_SDQ_P_11_17'
                                AND File_name__c = 'BASELINE'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '0',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'Baseline',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
        
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();     
                
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_P_11_17', '0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_B__c> ObjList = new List<DS_SDQ_PSI_CDI_B__c>();
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c(client__c = client.id,
                                                            BEMONULLP__c = 0, BBEHNULLP__c = 0, BHYPNULLP__c = 0, BOTCNULLP__c = 0, BKHBNULLP__c = 0,//null counts
                                                            BSDPSOMA__c = '1', BSDPWORR__c = '1', BSDPUNHA__c = '1', BSDPCLIN__c= '1', BSDPAFRA__c = '1',//emotional responses parent
                                                            BSDPCONS__c = '1', BSDPSHAR__c = '1', BSDPCARI__c = '1', BSDPKIND__c = '0', BSDPHELP__c = '1',//prosocial responses parent
                                                            BDOASDOP__c = System.today(), 
                                                            BMETSDOP__c = '1', 
                                                            SECTION__c = '0',
                                                            BSDPTIME__c = '1');  
               
        //set form's status  
        obj.STATUS_SDQ_P_11_17__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.BSDPETYP__c;
        score.BTYP=obj.BSDPBTYP__c;
        score.HTYP=obj.BSDPHTYP__c;
        score.OTYP=obj.BSDPOTYP__c;
        score.KTYP=obj.BSDPKTYP__c;
        score.ITYP=obj.BSDPITYP__c;
        
        //init difficulties present to scoring class
        score.EBCD=obj.BSDPEBCD__c;
        
        //init parent/self variable to scoring class
        score.Pors='P';
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_P_11_17_Controller controller = new DS_SDQ_P_11_17_Controller(sc);    
        DS_SDQ_P_11_17_Report_Controller RC = new DS_SDQ_P_11_17_Report_Controller(sc);       
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();        
        
        //save/cancel
        controller.save();
        controller.cancel();
        controller.saveview();
        
        RC.init();
        RC.editRecord();
        RC.addVisit(ObjList, 'B');
     
        //init variable alias to be tested 
        String BSDPCLIN= '1' ; 
        String BSDPCOMM= 'null';
        String BSDPKIND = '0';
        //Negative assert statements 
        System.assertEquals(obj.BSDPCLIN__c,BSDPCLIN,'Child is somewhat nervous or clingy. ');
        System.assertNotEquals(obj.BSDPCOMM__c,BSDPCOMM,'Parent comments have been filled in. ');
        System.assertEquals(obj.BSDPKIND__c, BSDPKIND, 'Child is NOT kind to younger children. ');
    }
    
    /****
    *@description method to test controllers associated with object 
    *Old Child, Self Form
    ****/
    static TestMethod void assertControllerOS() {
    
        //create test client 
        Client__c client = test_ut.createClient();       
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_SDQ_S_11_17'
                                AND File_name__c = 'BASELINE'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '0',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'Baseline',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
                
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();    
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_S_11_17', '0');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_B__c> ObjList = new List<DS_SDQ_PSI_CDI_B__c>(); 
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c(client__c = client.id,
                                                            BEMONULLS__c = 0, BBEHNULLS__c = 0, BHYPNULLS__c = 0, BOTCNULLS__c = 0, BKHBNULLS__c = 0,//null counts
                                                            BSDSSOMA__c = '1', BSDSWORR__c = '1', BSDSUNHA__c = '1', BSDSCLIN__c= '1', BSDSAFRA__c = '1',//emotional responses self
                                                            BSDSREST__c = '1', BSDSFIDG__c = '1', BSDSDIST__c = '1', BSDSREFL__c = '1', BSDSATTE__c= '2',//hyperactive responses self
                                                            BSDSLONE__c = '1', BSDSFRIE__c = '1', BSDSPOPU__c = '0', BSDSBULL__c = '1',BSDSOLDB__c = '1',//peer responses self
                                                            BDOASDOS__c = System.today(), 
                                                            BMETSDOS__c = '1', 
                                                            SECTION__c = '0');  
                
        //set form's status  
        obj.STATUS_SDQ_S_11_17__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.BSDSETYP__c;
        score.BTYP=obj.BSDSBTYP__c;
        score.HTYP=obj.BSDSHTYP__c;
        score.OTYP=obj.BSDSOTYP__c;
        score.KTYP=obj.BSDSKTYP__c;
        score.ITYP=obj.BSDSITYP__c;
        
        //init difficulties present to scoring class
        score.EBCD=obj.BSDSEBCD__c;
        
        //init parent/self variable to scoring class
        score.Pors='S';
                        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_S_11_17_Controller controller = new DS_SDQ_S_11_17_Controller(sc);    
        DS_SDQ_S_11_17_Report_Controller RC = new DS_SDQ_S_11_17_Report_Controller(sc);       
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();
            
        //save/cancel    
        controller.save();
        controller.cancel();
        controller.saveview();
        
        RC.init();
        RC.editRecord();
        RC.addVisit(ObjList, 'B');
     
        //init variable alias to be tested  
        String BSDSPOPU= '0';
        String BSDSSOMA= '1';
        String BSDSATTE= '2';
        // assert statements 
        System.assertEquals(obj.BSDSPOPU__c,BSDSPOPU,'I am certainally popular. ');
        System.assertEquals(obj.BSDSSOMA__c,BSDSSOMA,'I feel sick sometimes. ');
        System.assertEquals(obj.BSDSATTE__c,BSDSATTE,'I certainally do not have a good attention span. ');
    }
    
}