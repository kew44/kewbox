public with sharing class CoCap_v4_Controller {
    
    //external processing class initialization
   // public ReportBuilder rb;//on class first
    
    //start and end dates entered
    public Date StartDate{get;set;}
    public Date EndDate{get;set;}
    
   //all data queries
    public List<Client__c> clients{get;set;}
    public List<DS_Background_Family_Info_B__c> backgroundBs{get;set;}
    public List<DS_Background_Family_Info_F__c> backgroundFs{get;set;}
    public List<DS_CBCL_B__c> cbclBs {get;set;}
    
    public List<cocapRec> CocapRecordList {get;set;}
    public Map<String, List<cocapRec>> cocapMap {get;set;} 
    
    public class cocapRec{
        public String cocapRecString{get;set;}      
        
            //client info
          //  public String clientId;
            //age info
            //Integer cAge; 
            public String  ageGroup;
            public Boolean age0_4; 
            public Boolean age5_9; 
            public Boolean age10_12; 
            public Boolean age13_17; 
            public Boolean age18_21;
            //gender info
            public String  genIdentity;  
            public Boolean genMale; 
            public Boolean genFemale; 
            public Boolean genTrans; 
            public Boolean genOther;  
            public Boolean genUnknown;  
            public Boolean genMissing;
            //ethnicity info
            public String ethnicGroup;  
            public Boolean ethnicHispanic; 
            public Boolean ethnicNonHispanic;  
            public Boolean ethnicUnknown;  
            public Boolean ethnicMissing; 
            //race info
            public String  raceGroup;  
            public Boolean raceBlack;  
            public Boolean raceWhite;  
            public Boolean raceAINAK; 
            public Boolean raceAsian;  
            public Boolean raceHIOPI;  
            public Boolean raceUnkNR;  
            public Boolean raceMulti;  
            //military info
            public Boolean milAssociated; 
            //services info
            public Boolean treatMissing;  
            public Boolean treatEnded; 
            public Boolean treatAsPlanned;
        
        public cocapRec(){
            this.cocapRecString = null;
        }
                                                    
    }
    
    public CoCap_v4_Controller(ApexPages.StandardController controller) {
   // ReportBuilder rb = new ReportBuilder();
    cocapRec p = new cocapRec();
        
        System.debug(StartDate);
        System.debug(EndDate);
        System.debug(clients);
        System.debug(backgroundBs);
        System.debug(backgroundFs);
            
    }       
 
    public PageReference getData(){
        cocapRec p = new cocapRec();
        List<cocapRec> l = new List<cocapRec>();
    
        List<Client__c> clients = getClients();//get client
        List<DS_Background_Family_Info_B__c> backgroundBs= getBackBs(clients);     
        List<DS_Background_Family_Info_F__c> backgroundFs= getBackFs(clients);
        List<DS_CBCL_B__c> cbclBs=getCbclBs(clients);
        System.debug(clients);
        System.debug(StartDate);
        System.debug(EndDate);
        System.debug(clients);
        System.debug(backgroundBs);
        System.debug(backgroundFs);
        System.debug(cbclBs);
        System.debug(CocapRecordList);
        
        findGender(backgroundBs);
        genderMapList(clients, backgroundBs);
        System.debug(l);
        return null;
    }
    ////////////////////////////////////////////
    public Map<String, List<Boolean>> genderMapList(List<Client__c> clients, List<DS_Background_Family_Info_B__c> backgroundBs){
        System.debug(clients);
        System.debug(backgroundBs);
        
        List<String> genderList= new List<String>();
        String genderidentity; 
        
        Boolean genMale; 
        Boolean genFemale; 
        Boolean genTrans; 
        Boolean genOther;  
        Boolean genUnknown;  
        Boolean genMissing;
        
        for(Client__c c:clients){
            for(DS_Background_Family_Info_B__c b: backgroundBs){
                if(c.id == b.get('Client__c')){
                   Integer genId = Integer.valueOf(b.get('BIDENT__c'));
                       
                    if(genId == 1){
                        genderidentity = 'Male';
                        genMale = TRUE;
                    }
                    else if(genId == 2){
                        genderidentity = 'Female';
                        genFemale = TRUE;
                    }
                    else if((genId == 3) || (genId == 4)){
                        genderidentity = 'Transgender';
                        genTrans = TRUE;
                    }
                    else if(genId == 98){
                        genderidentity = 'Other';
                        genOther = TRUE;
                    }
                    else if((genId == 96) || (genId == 99)){
                        genderidentity = 'Unknown or declined to provide';
                        genUnknown = TRUE;
                    }
                    else{
                        genderidentity = 'Gender Identity is Missing';
                        genMissing = TRUE;
                    }
                /*    genderList.add(Boolean.valueOf(genMale));
                    genderList.add(genFemale);
                    genderList.add(genTrans);
                    genderList.add(genOther);
                    genderList.add(genUnknown);
                    genderList.add(genMissing );*/
                }
            }
        }
        System.debug(genderidentity);
        System.debug(genderList);
//        genderMapList.put(genderidentity, genderList);
       // Map<String, List<Boolean>> genderListMap = genderMapList;
        
//        return genderListMap<>(genderMapList);//genderidentity, genderList>();
return null;
    }
    
    public void findGender(List<DS_Background_Family_Info_B__c> backgroundBs){
    
        cocapRec p = new cocapRec();
        List<cocapRec> l = new List<cocapRec>();
        System.debug(p);
        System.debug(l);
        
        for(DS_Background_Family_Info_B__c b: backgroundBs){
            
           Integer genId = Integer.valueOf(b.get('BIDENT__c'));
               
            if(genId == 1){
                p.genIdentity = 'Male';
                p.genMale = TRUE;
            }
            else if(genId == 2){
                p.genIdentity = 'Female';
                p.genFemale = TRUE;
            }
            else if((genId == 3) || (genId == 4)){
                p.genIdentity = 'Transgender';
                p.genTrans = TRUE;
            }
            else if(genId == 98){
                p.genIdentity = 'Other';
                p.genOther = TRUE;
            }
            else if((genId == 96) || (genId == 99)){
                p.genIdentity = 'Unknown or declined to provide';
                p.genUnknown = TRUE;
            }
            else{
                p.genIdentity = 'Gender Identity is Missing';
                p.genMissing = TRUE;
            }
            System.debug(p.genIdentity );
            System.debug(p);
            l.add(p);
        }
        System.debug(l);
       // return l;
    }
  //////////////////////////////////////////////////////////////  

    public List<Client__c> getClients(){
       // return getClients(); 
        List<Client__c> clients = [SELECT id, Clinician__c, Center__c, Age__c, CURRENT_AGE__c, INIT__c
                                    FROM Client__c];
        System.debug(clients);
        return clients;
    }
    
    public List<DS_Background_Family_Info_B__c> getBackBs(List<Client__c> clients){
        System.debug(clients);
        System.debug(StartDate);
        System.debug(EndDate);
        
        List<DS_Background_Family_Info_B__c>  backgroundBs = [SELECT name, Client__c, SECTION__c,BDOV__c,
                                                            BMILFAMILY__c, BMILSELF__c,
                                                            BIDENT__c, 
                                                            ETHNIC__c,
                                                            RINDIAN__c, RAKNTV__c, 
                                                            RASIANIN__c, RCHINESE__c, RFILIPINO__c, RJAPANESE__c, RKOREAN__c, RVIETNAMESE__c, ROASIAN__c,
                                                            RBLACK__c,
                                                            RHAWAN__c, RGUAM__c, RSAMOA__c, ROPI__c,
                                                            RWHITE__c,
                                                            RREF__c, RUNK__c  
                                                            FROM DS_Background_Family_Info_B__c  
                                                            WHERE Client__c  IN :  clients];
        System.debug(backgroundBs);
        return(backgroundBs);
    }
    
    public List<DS_Background_Family_Info_F__c> getBackFs(List<Client__c> clients){
        System.debug(clients);
        System.debug(StartDate);
        System.debug(EndDate);
        
        List<DS_Background_Family_Info_F__c>  backgroundFs = [SELECT name, Client__c, SECTION__c,FDOV__c ,FUTYPE__c, FETSTAT__c, FMSTAT__c 
                                                            FROM DS_Background_Family_Info_F__c  
                                                            WHERE Client__c  IN :  clients];
        System.debug(backgroundFs);
        return(backgroundFs);
    }
    
    public List<DS_CBCL_B__c> getCbclBs(List<Client__c> clients){
        List<DS_CBCL_B__c> cbclBs = [SELECT Client__c,BDOACO__c, BDOACY__c
                                FROM DS_CBCL_B__c
                                WHERE Client__c  IN: clients];
        return(cbclBs);
    }
}