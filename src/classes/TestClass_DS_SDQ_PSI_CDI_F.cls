/****
*@description This test provides code coverage for DS_SDQ_PSI_CDI_F
*includes
*Trigger 
*Controllers:
    *SDQ_P_04_10, SDQ_P_11_17, SDQ_S_11_17, PSI
*Bulkified testing
*Asserted Variables
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_SDQ_PSI_CDI_F.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
*
*@date 1/27/2016
*@modified date
*Purpose: PSI coverage
****/

@isTest (SeeAllData=false)
private class TestClass_DS_SDQ_PSI_CDI_F  {

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
        Client__c client = test_ut.createClientSummary();
        
        //init list of object
        List<DS_SDQ_PSI_CDI_F__c> bulkObj = new List<DS_SDQ_PSI_CDI_F__c>();
        
        ///begin bulk insert     
        for (Integer i=0;i<200;i++){            
            bulkObj.add(new DS_SDQ_PSI_CDI_F__c(client__c = client.id,
                                                FEMONULLP__c = 0, FBEHNULLP__c = 0, FHYPNULLP__c = 0, FOTCNULLP__c = 0, FKHBNULLP__c = 0,//null counts parent
                                                FEMONULLS__c = 0, FBEHNULLS__c = 0, FHYPNULLS__c = 0, FOTCNULLS__c = 0, FKHBNULLS__c = 0,//null counts self
                                                FDOASDYP__c = System.today(), FDOASDOP__c = System.today(), FDOASDOS__c = System.today(),
                                                FMETSDYP__c = '1', FMETSDOP__c = '1', FMETSDOS__c = '1',
                                                          FPSIPD__c = 13, FPSIPD_PTLE__c = 81, 
                                                            FPSIPD2__c = 13, FPSIPD_PTLE2__c = 81,
                                                          FPSIPCDI__c = 13, FPSIPCDI_PTLE__c = 81, 
                                                            FPSIPCDI2__c = 13, FPSIPCDI_PTLE2__c = 81,
                                                          FPSIDC__c = 13, FPSIDC_PTLE__c = 81, 
                                                            FPSIDC2__c = 13, FPSIDC_PTLE2__c = 81,
                                                          FPSITS__c = 38, FPSITS_PTLE__c = 81, 
                                                            FPSITS2__c = 38, FPSITS_PTLE2__c = 81,
                                                          FPSIDR__c = 9, FPSIDR_PTLE__c = 81, 
                                                            FPSIDR2__c = 9, FPSIDR_PTLE2__c = 81,
                                                          FDOAPSI__c = System.today(),
                                                SECTION__c = '1'));      
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
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 6));         
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_SDQ_P_04_10'
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '1',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'FollowUp',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
        
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();     
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_P_04_10', '1');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_F__c> ObjList = new List<DS_SDQ_PSI_CDI_F__c>();
        
        //init object w/ required vals
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c(client__c = client.id,
                                                            FEMONULLP__c = 0, FBEHNULLP__c = 0, FHYPNULLP__c = 0, FOTCNULLP__c = 0, FKHBNULLP__c = 0,//null counts
                                                            FSDPTANT__c = '1', FSDPOBEY__c = '1', FSDPFIGH__c = '1', FSDPLIES__c = '1', FSDPSTEA__c = '1',//behavioral responses parent
                                                            FSDPREST__c = '1', FSDPFIDG__c = '1', FSDPDIST__c = '1', FSDPREFL__c = '1', FSDPATTE__c= '2',//hyperactive responses parent
                                                            FDOASDYP__c = System.today(), 
                                                            FMETSDYP__c = '1', 
                                                            SECTION__c = '1');  
                
        //set form's status         
        obj.STATUS_SDQ_P_04_10__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.FSDPETYP__c;
        score.BTYP=obj.FSDPBTYP__c;
        score.HTYP=obj.FSDPHTYP__c;
        score.OTYP=obj.FSDPOTYP__c;
        score.KTYP=obj.FSDPKTYP__c;
        score.ITYP=obj.FSDPITYP__c;
        
        //init difficulties present to scoring class
        score.EBDD=obj.FSDPEBDD__c;
        
        //init parent/self variable to scoring class
        score.Pors='P';
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_P_04_10_Controller controller = new DS_SDQ_P_04_10_Controller(sc);    
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();
        
        //save/cancel
        controller.save();
        controller.cancel();
        controller.saveview();        
        
        //init variable alias to be tested    
        String FSDPINFOR= '0';
        String FSDPFIDG= '2';
        String FSDPFIGH = '1';
        Date FDOASDYP=system.today();
        //Negative assert statements
        System.assertNotEquals(obj.FSDPINFOR__c,FSDPINFOR,'Mother was NOT informant ');
        System.assertNotEquals(obj.FSDPFIDG__c,FSDPFIDG,'Child is certainally NOT fidgety. ');
        System.assertEquals(obj.FDOASDYP__c,FDOASDYP,'Administered  today,  '+obj.FDOASDYP__c+'. ');
        System.assertEquals(obj.FSDPFIGH__c, FSDPFIGH, 'Child sometimes fights with or bullies other children.');
    }
    
    /****
    *@description method to test controllers associated with object 
    *Old Child, Parent Form
    ****/
    static TestMethod void assertControllerOP() {
    
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 11));         
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_SDQ_P_11_17'
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = '1',
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'FollowUp',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
        
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();     
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_P_11_17', '1');
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_F__c> ObjList = new List<DS_SDQ_PSI_CDI_F__c>();
        
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c(client__c = client.id,
                                                            FEMONULLP__c = 0, FBEHNULLP__c = 0, FHYPNULLP__c = 0, FOTCNULLP__c = 0, FKHBNULLP__c = 0,//null counts
                                                            FSDPSOMA__c = '1', FSDPWORR__c = '1', FSDPUNHA__c = '1', FSDPCLIN__c= '1', FSDPAFRA__c = '1',//emotional responses parent
                                                            FSDPCONS__c = '1', FSDPSHAR__c = '1', FSDPCARI__c = '1', FSDPKIND__c = '0', FSDPHELP__c = '1',//prosocial responses parent
                                                            FDOASDOP__c = System.today(), 
                                                            FMETSDOP__c = '1', 
                                                            SECTION__c = '1',
                                                            FSDPTIME__c = '1');  
                
        //set form's status  
        obj.STATUS_SDQ_P_11_17__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.FSDPETYP__c;
        score.BTYP=obj.FSDPBTYP__c;
        score.HTYP=obj.FSDPHTYP__c;
        score.OTYP=obj.FSDPOTYP__c;
        score.KTYP=obj.FSDPKTYP__c;
        score.ITYP=obj.FSDPITYP__c;
        
        //init difficulties present to scoring class
        score.EBDD=obj.FSDPEBDD__c;
        
        //init parent/self variable to scoring class
        score.Pors='P';
        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_P_11_17_Controller controller = new DS_SDQ_P_11_17_Controller(sc);   
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Difficult = controller.getDegreeItems();
        
        //save/cancel
        controller.save();
        controller.cancel();
        controller.saveview();
             
        //init variable alias to be tested 
        String FSDPCLIN= '1' ; 
        String FSDPCOMM= 'null';
        String FSDPKIND = '0';
        
        //Negative assert statements 
        System.assertEquals(obj.FSDPCLIN__c,FSDPCLIN,'Child is somewhat nervous or clingy. ');
        System.assertNotEquals(obj.FSDPCOMM__c,FSDPCOMM,'Parent comments have been filled in. ');
        System.assertEquals(obj.FSDPKIND__c, FSDPKIND, 'Child is NOT kind to younger children. ');
    }
    
    /****
    *@description method to test controllers associated with object 
    *Old Child, Self Form
    ****/
    static TestMethod void assertControllerOS() {
    
        //create test client 
        Client__c client = test_ut.createClient();           
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_SDQ_S_11_17' 
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = section,
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'FollowUp',
                                                            STATUS__c = 'Complete');
        
        insert summary;   
        
        //call to sdq scoring class
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();     
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_SDQ_S_11_17', section);
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_F__c> ObjList = new List<DS_SDQ_PSI_CDI_F__c>(); 
        
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c(client__c = client.id,
                                                            FEMONULLS__c = 0, FBEHNULLS__c = 0, FHYPNULLS__c = 0, FOTCNULLS__c = 0, FKHBNULLS__c = 0,//null counts
                                                            FSDSSOMA__c = '1', FSDSWORR__c = '1', FSDSUNHA__c = '1', FSDSCLIN__c= '1', FSDSAFRA__c = '1',//emotional responses self
                                                            FSDSREST__c = '1', FSDSFIDG__c = '1', FSDSDIST__c = '1', FSDSREFL__c = '1', FSDSATTE__c= '2',//hyperactive responses self
                                                            FSDSLONE__c = '1', FSDSFRIE__c = '1', FSDSPOPU__c = '0', FSDSBULL__c = '1',FSDSOLDB__c = '1',//peer responses self
                                                            FDOASDOS__c = System.today(), 
                                                            FMETSDOS__c = '1', 
                                                            SECTION__c = section);  
                
        //set form's status  
        obj.STATUS_SDQ_S_11_17__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
        
        //init subscale values to scoring class
        score.ETYP=obj.FSDSETYP__c;
        score.BTYP=obj.FSDSBTYP__c;
        score.HTYP=obj.FSDSHTYP__c;
        score.OTYP=obj.FSDSOTYP__c;
        score.KTYP=obj.FSDSKTYP__c;
        score.ITYP=obj.FSDSITYP__c;
        
        //init difficulties present to scoring class
        score.EBDD=obj.FSDSEBDD__c;
        
        //init parent/self variable to scoring class
        score.Pors='S';
                        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
          
        //controllers
        DS_SDQ_S_11_17_Controller controller = new DS_SDQ_S_11_17_Controller(sc); 
        
        //non-standard list options
        List<SelectOption> Overall = controller.getOverallItems();
        List<SelectOption> HowLong = controller.getHowLongItems();
        List<SelectOption> Improve = controller.getImprovementItems();
        List<SelectOption> Degree = controller.getDegreeItems();
        
        //save/cancel    
        controller.save();
        controller.cancel();
        controller.saveview();
             
        //init variable alias to be tested  
        String FSDSPOPU= '0';
        String FSDSSOMA= '1';
        String FSDSATTE= '2';
        // assert statements 
        System.assertEquals(obj.FSDSPOPU__c,FSDSPOPU,'I am certainally popular. ');
        System.assertEquals(obj.FSDSSOMA__c,FSDSSOMA,'I feel sick sometimes. ');
        System.assertEquals(obj.FSDSATTE__c,FSDSATTE,'I certainally do not have a good attention span. ');

    }

    /****
    *@description method to test controllers associated with object
    *PSI
    ****/
    static TestMethod void assertControllerPSI(){
    
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Male', 12));         
        
        // add a new follow-up visit
        String section = test_ut.addNewFollowupVisit(client);
        
        DS_DATA__c dataPage = [SELECT id FROM DS_DATA__c 
                                WHERE Page__c = 'DS_PSI'
                                AND File_name__c = 'FOLLOWUP'
                                AND Category__c = 'Assessment'];
        
        String dpID = String.valueOf(dataPage.id);                      
        
        Client_Summary__c summary = new Client_Summary__c(Client__c = client.id,
                                                            SECTION__c = section,
                                                            Page__c = dpID,
                                                            FORM_TYPE__c = 'FollowUp',
                                                            STATUS__c = 'Complete');
        
        insert summary;  
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_PSI', section);
        
        //encoded parameters        
        String cimi= ut.urlEncode('c='+client.id+'&summary='+summaryId);
        ApexPages.currentPage().getParameters().put('cimi',cimi);   
        
        //init list of object
        List<DS_SDQ_PSI_CDI_F__c> ObjList = new List<DS_SDQ_PSI_CDI_F__c>();  
        
        DS_SDQ_PSI_CDI_F__c obj = new DS_SDQ_PSI_CDI_F__c(client__c = client.id,
                                                          FPSIPD__c = 13, FPSIPD_PTLE__c = 90, 
                                                            FPSIPD2__c = 13, FPSIPD_PTLE2__c = 90,
                                                          FPSIPCDI__c = 13, FPSIPCDI_PTLE__c = 90, 
                                                            FPSIPCDI2__c = 13, FPSIPCDI_PTLE2__c = 90,
                                                          FPSIDC__c = 13, FPSIDC_PTLE__c = 90, 
                                                            FPSIDC2__c = 13, FPSIDC_PTLE2__c = 90,
                                                          FPSITS__c = 38, FPSITS_PTLE__c = 90, 
                                                            FPSITS2__c = 38, FPSITS_PTLE2__c = 90,
                                                          FPSIDR__c = 9, FPSIDR_PTLE__c = 90, 
                                                            FPSIDR2__c = 9, FPSIDR_PTLE2__c = 90,
                                                          FDOAPSI__c = System.today(),
                                                          SECTION__c = '1');  
                                                            
        //set form's status    
        obj.STATUS_PSI__c = 'Complete';
        
        //insert object
        insert obj;
        
        //add obj to obj list
        ObjList.add(obj);
                        
        //init controller for pages
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);  
        
        //controllers
        DS_PSI_Controller controller = new DS_PSI_Controller(sc);    
        DS_PSI_Report_Controller RC = new DS_PSI_Report_Controller(sc);    

        //save/cancel    
        controller.save();
        controller.cancel();
        controller.saveview();
        
        RC.init();
        RC.editRecord();
        
        //init variable alias to be tested  
        // assert statements 
            
    }
}