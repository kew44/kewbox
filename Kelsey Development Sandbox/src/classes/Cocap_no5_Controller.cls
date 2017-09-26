/****
*@description another cocap mockup
*
*@date    2/14/17
*@author    KW
****/
public with sharing class Cocap_no5_Controller {

    //start and end dates entered
    public Date StartDate{get;set;}
    public Date EndDate{get;set;}
        
   //all data queries
    public List<Client__c> clients{get;set;}
    public List<DS_Background_Family_Info_B__c> backgroundBs{get;set;}
    public List<DS_Background_Family_Info_F__c> backgroundFs{get;set;}
    public List<DS_CBCL_B__c> cbclBs {get;set;}
    
    //classses for subcategories
    public List<genderClass> genderRecs{get;set;}
    
    //counts
    //age
    public Integer countAge0_4{get;set;}
    public Integer countAge5_9{get;set;}
    public Integer countAge10_12{get;set;}
    public Integer countAge13_17{get;set;}
    public Integer countAge18_21{get;set;}
    //gender
    public Integer countGenMale{get;set;}
    public Integer countGenFemale{get;set;}
    public Integer countGenTrans{get;set;}
    public Integer countGenOther{get;set;}
    public Integer countGenRef_Unk{get;set;}
    public Integer countGenMissing{get;set;}
    //ethnic
    public Integer countEthHispanic{get;set;}
    public Integer countEthNon_Hisp{get;set;}
    public Integer countEthRef_Unk{get;set;}
    public Integer countEthMissing{get;set;}
    //race
    public Integer countRaceNat_Amer{get;set;}
    public Integer countRaceAsian{get;set;}
    public Integer countRaceBlack{get;set;}
    public Integer countRaceIsland{get;set;}
    public Integer countRaceWhite{get;set;}
    public Integer countRaceMulti{get;set;}
    public Integer countRaceRef_Unk{get;set;}
    //service-related
    public Integer countNew{get;set;}
    public Integer countService{get;set;}
    public Integer countClinical{get;set;}
    public Integer countEnded{get;set;}
    public Integer countEnded_Planned{get;set;}
    //military
    public Integer countMilYes{get;set;}
    public Integer countMilNo{get;set;}
    public Integer countMilMissing{get;set;}       
         
    public class genderClass{
      //  public String genderClassString{get;set;}
      
        public String cid{get;set;}
        
        public String genIdentity{get;set;}        
        
        public Boolean genMale{get;set;}
        public Boolean genFemale{get;set;} 
        public Boolean genTrans{get;set;}
        public Boolean genOther{get;set;} 
        public Boolean genUnknown{get;set;}
        public Boolean genMissing{get;set;}        
        
        
        public genderClass(String cliId, List<DS_Background_Family_Info_B__c> backgroundBs){//List<Client__c> clients, 
            
            System.debug(cliId);
            String cid;
            
            String genIdentity;
            genMale= FALSE;
            genFemale= FALSE;
            genTrans= FALSE;
            genOther= FALSE;
            genUnknown= FALSE;
            genMissing= FALSE;
                        
            System.debug(cid);
            System.debug(genIdentity);
            System.debug(genMale);
            System.debug(genFemale);
            System.debug(genTrans);
            System.debug(genOther);
            System.debug(genUnknown);
            System.debug(genMissing);
                
                for(DS_Background_Family_Info_B__c b: backgroundBs){                
                    
                    System.debug(cid);
                    System.debug(genIdentity);
                    System.debug(genMale);
                    System.debug(genFemale);
                    System.debug(genTrans);
                    System.debug(genOther);
                    System.debug(genUnknown);
                    System.debug(genMissing);
            
                    String bid = String.valueOf(b.Client__c);
                    System.debug(bid);
                  //      if(bid ==cid){ 
                            
                           Integer genId = Integer.valueOf(b.get('BIDENT__c'));
                               
                            if(genId == 1){
                                genIdentity = 'Male';
                                genMale = TRUE;
                            }
                            else if(genId == 2){
                                genIdentity = 'Female';
                                genFemale = TRUE;
                            }
                            else if((genId == 3) || (genId == 4)){
                                genIdentity = 'Transgender';
                                genTrans = TRUE;
                            }
                            else if(genId == 98){
                                genIdentity = 'Other';
                                genOther = TRUE;
                            }
                            else if((genId == 96) || (genId == 99)){
                                genIdentity = 'Unknown or declined to provide';
                                genUnknown = TRUE;
                            }
                            else{
                                genIdentity = 'Gender Identity is Missing';
                                genMissing = TRUE;
                            }
                    this.cid = bid;
                    this.genIdentity = genIdentity; 
                    this.genMale = genMale ; 
                    this.genFemale = genFemale ; 
                    this.genTrans = genTrans ; 
                    this.genOther = genOther ; 
                    this.genUnknown = genUnknown ; 
                    this.genMissing = genMissing ; 
                    
                    }       
        }
    }

    public PageReference getData(){
    
        Integer countGenMale =0;
        Integer countGenFemale =0;
        Integer countGenTrans =0;
        Integer countGenOther =0;
        Integer countGenRef_Unk =0 ;
        Integer countGenMissing=0;
    
        List<Client__c> clients = getClients();//get client
        Client__c client;
        String cliId;
        System.debug(StartDate);
        System.debug(EndDate);
        List<DS_Background_Family_Info_B__c> backgroundBs;//= getBackBs(cliId, StartDate, EndDate);     
       // List<DS_Background_Family_Info_F__c> backgroundFs= getBackFs(clients);
        //List<DS_CBCL_B__c> cbclBs=getCbclBs(clients);
        List<genderClass> genderRecs = new List<genderClass>();
        System.debug(clients);
        System.debug(StartDate);
        System.debug(EndDate);
        System.debug(clients);
        System.debug(backgroundBs);
    //    System.debug(backgroundFs);
     //   System.debug(cbclBs);
        
        for(Client__c c : clients){ 
            cliId = String.valueOf(c.id);
            backgroundBs= getBackBs(cliId, StartDate, EndDate);
            genderClass g = new genderClass(cliId, backgroundBs);//clients
            System.debug(g);
            genderRecs.add(g); 
        }
        System.debug(genderRecs);
        System.debug(genderRecs.size());
        
        for(genderClass g:genderRecs){
            if(g.genFemale == TRUE){
                countGenFemale = countGenFemale + 1;
            }
           // countGenFemale = countGenFemale +Integer.valueOf(g.genFemale);  
            System.debug(countGenFemale );
            System.debug(g.genFemale);
        }
        System.debug(countGenFemale );
//        countGenFemale = Apexpages.currentPage().getParameters().set('totFemale');
        PageReference getFemaleCount = new PageReference('countGenFemale') ;
        return getFemaleCount;
        return null;
    }
    public PageReference getFemaleCount(){
        System.debug(countGenFemale);
        return null;
    }
        

    public Cocap_no5_Controller(ApexPages.StandardController controller) {
    
        System.debug(StartDate);
        System.debug(genderRecs);
        getFemaleCount();
    }
    

    
    public List<Client__c> getClients(){
       // return getClients(); 
        List<Client__c> clients = [SELECT id, Clinician__c, Center__c, Age__c, CURRENT_AGE__c, INIT__c
                                    FROM Client__c];
        System.debug(clients);
        return clients;
    }
    
    public List<DS_Background_Family_Info_B__c> getBackBs(String cliId, Date StartDate, Date EndDate){
        System.debug(cliId);
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
                                                            WHERE Client__c  =:  cliId
                                                            AND BDOV__c >=: StartDate 
                                                            AND BDOV__c <=: EndDate];
        System.debug(backgroundBs);
        System.debug(backgroundBs.size());
        return(backgroundBs);
    }
}