/****
*@description This test provides code coverage for Report Builder and custom reports
*
*@group Test Script 
*@group-content /ApexDocContent/Test/ReportBuilder.htm
*
*@author Kelsey Willett
*@date 8/31/16
*
*@modified 9/1/16    KW    code coverage
*@modified 9/15-16/16    KW    code coverage
*
****/

@isTest (SeeAllData=false)
public class TestClass_ReportBuilder {

    /****
    *@description Initialize reference to TestClass_A_Utility
    ****/
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    /****
    *@description Initialize reference to Utility
    ****/
    public static Utility ut = new Utility();
    public static ReportBuilder rb = new ReportBuilder();
    
    /****
    *@description Load required data from TestClassData
    ****/
    @testSetup 
    static void setup() {
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();  
        importData.variable(); 
        importData.cbcl();     
        importData.ptsd();      
    }
    
    /****
    *@description method to test a bulk creation of object
    ****/
    static TestMethod void bulkifyObj(){
            
        //init client
        Client__c client = test_ut.createClientSummary();
        
        //init list of object
        List<Custom_Reporting__c> bulkObj = new List<Custom_Reporting__c>();   
        
        ///begin bulk insert     
        for (Integer i=0;i<100;i++){
            //add record with required values
            bulkObj.add(new Custom_Reporting__c());
        }
        
        //add list of records to object
        insert bulkObj;     
    }
    
    static DS_Background_Family_Info_B__c backgroundB(Client__c client){
            
        //background required fields for reports
        DS_Background_Family_Info_B__c bb = new DS_Background_Family_Info_B__c();
            
            bb.Client__c = client.id;           
            bb.BDOV__c = date.today();
            bb.BMILFAMILY__c = '1';
            bb.BMILSELF__c = '0';
            bb.BIDENT__c = '2';
            bb.ETHNIC__c = '2';
            bb.RINDIAN__c = TRUE;           
            bb.RASIANIN__c = TRUE;
            bb.RBLACK__c = TRUE;
            bb.RHAWAN__c = TRUE;
            bb.RWHITE__c = TRUE;
            
        insert bb;
        return bb;
    }
    
    static DS_Background_Family_Info_F__c backgroundF(Client__c client){
       
        //background required fields for reports
        DS_Background_Family_Info_F__c bf = new DS_Background_Family_Info_F__c();
            bf.Client__c = client.id;   
        insert bf;
        return bf;
    }
    static DS_CBCL_B__c cbclB(Client__c client){
        DS_CBCL_B__c cb = new DS_CBCL_B__c();
            cb.Client__c = client.id;
            cb.BDOACO__c = date.today();
            cb.BDOACY__c = date.today();
            cb.BCBOMETH__c = '1';
            cb.BCBYMETH__c = '1';
        insert cb;
        return cb;
    }
    static DS_CBCL_F__c cbclF(Client__c client){
        DS_CBCL_F__c cf = new DS_CBCL_F__c();
            cf.Client__c = client.id;
            cf.FDOACO__c = date.today();
            cf.FDOACY__c = date.today();
            cf.FCBOMETH__c = '1';
            cf.FCBYMETH__c = '1';
        insert cf;
        return cf;
    }
    static DS_PTSD_CA_B__c ptsdB(Client__c client){
        DS_PTSD_CA_B__c pb = new DS_PTSD_CA_B__c();
            pb.Client__c = client.id;
            pb.BMETPTSD__c = '1';
            pb.BDOAPTSD__c = date.today();
            pb.STATUS_PTSD_CA__c = 'Complete';
        insert pb;
        return pb;
    }
    static DS_PTSD_CA_F__c ptsdF(Client__c client){
        DS_PTSD_CA_F__c pf = new DS_PTSD_CA_F__c();
            pf.Client__c = client.id;
            pf.FMETPTSD__c = '1';
            pf.FDOAPTSD__c = date.today();
            pf.STATUS_PTSD_PA__c = 'Complete';
        insert pf;
        return pf;
    }
    static DS_SDQ_PSI_CDI_B__c sdqB(Client__c client){
        DS_SDQ_PSI_CDI_B__c sb = new DS_SDQ_PSI_CDI_B__c();
            sb.Client__c = client.id;
            sb.BEMONULLP__c = 0; 
            sb.BBEHNULLP__c = 0; 
            sb.BHYPNULLP__c = 0; 
            sb.BOTCNULLP__c = 0; 
            sb.BKHBNULLP__c = 0;
            sb.BEMONULLS__c = 0; 
            sb.BBEHNULLS__c = 0; 
            sb.BHYPNULLS__c = 0; 
            sb.BOTCNULLS__c = 0; 
            sb.BKHBNULLS__c = 0;
            sb.BSDPSOMA__c = '1'; 
            sb.BSDPWORR__c = '1'; 
            sb.BSDPUNHA__c = '1'; 
            sb.BSDPCLIN__c= '1'; 
            sb.BSDPAFRA__c = '1';
            sb.BSDPTANT__c = '1'; 
            sb.BSDPOBEY__c = '1'; 
            sb.BSDPFIGH__c = '1'; 
            sb.BSDPLIES__c = '1'; 
            sb.BSDPSTEA__c = '1';
            sb.BSDPREST__c = '1'; 
            sb.BSDPFIDG__c = '1'; 
            sb.BSDPDIST__c = '1'; 
            sb.BSDPREFL__c = '1'; 
            sb.BSDPATTE__c= '2';
            sb.BSDPLONE__c = '1'; 
            sb.BSDPFRIE__c = '1'; 
            sb.BSDPPOPU__c = '0'; 
            sb.BSDPBULL__c = '1'; 
            sb.BSDPOLDB__c = '1';
            sb.BSDPCONS__c = '1'; 
            sb.BSDPSHAR__c = '1'; 
            sb.BSDPCARI__c = '1'; 
            sb.BSDPKIND__c = '0'; 
            sb.BSDPHELP__c = '1';
            sb.BDOASDYP__c = System.today(); 
            sb.BDOASDOP__c = System.today(); 
            sb.BDOASDOS__c = System.today();
            sb.BDOAPSI__c = System.today(); 
            sb.BMETSDYP__c = '1'; 
            sb.BMETSDOP__c = '1'; 
            sb.BMETSDOS__c = '1';
            sb.STATUS_SDQ_P_04_10__c = 'Complete'; 
            sb.STATUS_SDQ_P_11_17__c = 'Complete';
            sb.STATUS_SDQ_S_11_17__c = 'Complete';
            sb.STATUS_PSI__c = 'Complete'; 
            sb.SECTION__c = '0';
        //insert sb;
        return sb;
    }
    static DS_SDQ_PSI_CDI_F__c sdqF(Client__c client){
        DS_SDQ_PSI_CDI_F__c sf = new DS_SDQ_PSI_CDI_F__c();
            sf.Client__c = client.id;
       // insert sf;
        return sf;
    }
    static DS_TSCC_TSCYC_B__c tsccB(Client__c client){
        DS_TSCC_TSCYC_B__c tb = new DS_TSCC_TSCYC_B__c();
            tb.Client__c = client.id;
       // insert tb;
        return tb;
    }
    static DS_TSCC_TSCYC_F__c tsccF(Client__c client){
        DS_TSCC_TSCYC_F__c tf = new DS_TSCC_TSCYC_F__c();
            tf.Client__c = client.id;
      //  insert tf;
        return tf;
    }
    
    static TestMethod void testNewReport(){
        
        //create test client 
        Client__c client = test_ut.createClient(test_ut.getClient('Female', 14));        
        
        String cId = String.valueOf(client.id);
        Integer  cAge = Integer.valueOf(client.CURRENT_AGE__c);
        
        DS_Background_Family_Info_B__c backgroundB = backgroundB(client);//test_ut.
        DS_Background_Family_Info_F__c backgroundF = backgroundF(client);
       // DS_CBCL_B__c cbclB = cbclB(client);
      //  DS_CBCL_F__c cbclF = cbclF(client);
     //   DS_PTSD_CA_B__c ptsdB = ptsdB(client);
     //   DS_PTSD_CA_F__c ptsdF = ptsdF(client);
       // DS_SDQ_PSI_CDI_B__c sdqB = sdqB(client);
       /* DS_SDQ_PSI_CDI_F__c sdqF = sdqF(client);
        DS_TSCC_TSCYC_B__c tsccB = tsccB(client);
        DS_TSCC_TSCYC_F__c tsccF = tsccF(client);*/
        Custom_Reporting__c cReport = new Custom_Reporting__c();
        
        //methods
        rb.findAge(client);
        rb.findRace(backgroundB);
        rb.findEthnic(backgroundB);
        rb.findGender(backgroundB);
        rb.findMilitary(backgroundB, backgroundF);
        rb.findServices(backgroundF);
        
        
    }
    
    
}