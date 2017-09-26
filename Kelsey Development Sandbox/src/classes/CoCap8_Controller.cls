/****
*@description another cocap mockup
*
*@date    3/6/17
*@author    KW
*
*@group cocap
*@group-content /ApexDocContent/Cocap8_Controller.htm
****/
public with sharing class CoCap8_Controller {
    
    //init start and end dates
    public Date StartDate{get;set;}
    public Date EndDate{get;set;}
    
    //lists of objects
    public List<ClientBackground> BaselineClients{get;set;}
    public List<ClientBackground> FollowupClients{get;set;}
    public List<ClientBackground> FullClients{get;set;}
    public List<ClientBackground> ClosedClients{get;set;} 
    public List<ClientBackground> TxCompleteClients{get;set;} 
    public List<ClientBackground> OpenClients{get;set;}    
    
    public List<DS_CBCL_B__c> cbclBs{get;set;}
    public List<DS_CBCL_F__c> cbclFs{get;set;}
    public List<DS_PTSD_CA_B__c> ptsdBs{get;set;}
    public List<DS_PTSD_CA_F__c> ptsdFs{get;set;}
    public List<DS_SDQ_PSI_CDI_B__c> sdqBs{get;set;}
    public List<DS_SDQ_PSI_CDI_F__c> sdqFs{get;set;}
    public List<DS_TSCC_TSCYC_B__c> tsccBs{get;set;}
    public List<DS_TSCC_TSCYC_F__c> tsccFs{get;set;}
    
    //initially loaded values
    public Cocap8_Controller(ApexPages.StandardController controller){
    }
    
    //composite baseline/followup client information
    public class ClientBackground{
        public Id clientID{get;set;}
        
        //age
        public Integer currentAge{get;set;}     
    
        //gender
        public String genderId{get;set;}    
        
        //ethnic
        public String ethnic{get;set;}  
        
        //race
        public String raceNtvAmerican{get;set;} 
        public String raceAlaskanNtv{get;set;}  
        public String raceIndian{get;set;}  
        public String raceChinese{get;set;} 
        public String raceFilipino{get;set;}    
        public String raceJapanese{get;set;}    
        public String raceKorean{get;set;}  
        public String raceVietnamese{get;set;}  
        public String raceOAsian{get;set;}  
        public String raceBlack{get;set;}   
        public String raceHawaiian{get;set;}    
        public String raceGuam{get;set;}    
        public String raceSamoan{get;set;}  
        public String raceOPIslander{get;set;}  
        public String raceWhite{get;set;}   
        public String raceRef{get;set;} 
        public String raceUnk{get;set;} 
        
        //military
        public String milFamilyB{get;set;}  
        public String milSelfB{get;set;}
        public String milStatusF{get;set;}  
        
        //status
        public String followupType{get;set;}    
        public String followupCompletion{get;set;}  
        
        //dates
        public Date bdov{get;set;}
        public Date fdov{get;set;}  
        
        public ClientBackground(){
            this.clientID= null;
        }
    }
    
    //function run on click
    public void getData(){
        
        //records of all clients with a baseline
        List<ClientBackground> BaselineClients = getBaseClients();
        
        //followup
        List<ClientBackground> FollowupClients = getFollowupClients();
        
        //full list of client records
        List<ClientBackground> FullClients = getFullClients(BaselineClients, FollowupClients);
        
        //clients who are currently closed
        List<ClientBackground> ClosedClients = getClosedClients(FullClients);
        
        //completed as planned
        List<ClientBackground> TxCompleteClients = getTxCompletedClients(ClosedClients);
        
        //clients who have NOT been closed
        List<ClientBackground> OpenClients = getOpenClients(FullClients, ClosedClients);
        
    }
    
    //get all clients with baseline
    public List<ClientBackground> getBaseClients(){
    
        List<ClientBackground> BaselineClients = new List<ClientBackground>();
        
        List<DS_Background_Family_Info_B__c>  baselineInfo = [SELECT name, Client__c, Client__r.id, SECTION__c,BDOV__c, Client__r.CURRENT_AGE__c,
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
                                                                ];
                                                                
        for(DS_Background_Family_Info_B__c b:baselineInfo){
            ClientBackground cb = new ClientBackground();
            
            cb.clientID = b.Client__r.id;
            //age
            cb.currentAge = Integer.valueOf(b.Client__r.CURRENT_AGE__c);
            //gender
            cb.genderId = String.valueOf(b.BIDENT__c);      
            //ethnic
            cb.ethnic   = String.valueOf(b.ETHNIC__c);              
            //race
            cb.raceNtvAmerican  = String.valueOf(b.RINDIAN__c);     
            cb.raceAlaskanNtv   = String.valueOf(b.RAKNTV__c);  
            cb.raceIndian   = String.valueOf(b.RASIANIN__c);        
            cb.raceChinese  = String.valueOf(b.RCHINESE__c);        
            cb.raceFilipino = String.valueOf(b.RFILIPINO__c);       
            cb.raceJapanese = String.valueOf(b.RJAPANESE__c);       
            cb.raceKorean   = String.valueOf(b.RKOREAN__c);     
            cb.raceVietnamese   = String.valueOf(b.RVIETNAMESE__c);     
            cb.raceOAsian   = String.valueOf(b.ROASIAN__c);     
            cb.raceBlack    = String.valueOf(b.RBLACK__c);      
            cb.raceHawaiian = String.valueOf(b.RHAWAN__c);      
            cb.raceGuam = String.valueOf(b.RGUAM__c);       
            cb.raceSamoan   = String.valueOf(b.RSAMOA__c);      
            cb.raceOPIslander   = String.valueOf(b.ROPI__c);        
            cb.raceWhite    = String.valueOf(b.RWHITE__c);      
            cb.raceRef  = String.valueOf(b.RREF__c);        
            cb.raceUnk  = String.valueOf(b.RUNK__c);                    
            //military  
            cb.milFamilyB   = String.valueOf(b.BMILFAMILY__c);      
            cb.milSelfB = String.valueOf(b.BMILSELF__c);        
            cb.milStatusF   = 'No Followup';                
            //status    
            cb.followupType= 'No Followup';        
            cb.followupCompletion= 'No Followup';                
            //dates 
            cb.bdov = b.BDOV__c;
            //cb.fdov   = null;     
            
            System.debug(b);
            System.debug(cb);
            BaselineClients.add(cb);
        }
        
        System.debug(BaselineClients);
        System.debug(BaselineClients.size());
        return BaselineClients;
    }
    
    //get all followup records
    public List<ClientBackground> getFollowupClients(){
        List<ClientBackground> FollowupClients = new List<ClientBackground>();
                       
        List<DS_Background_Family_Info_F__c> followupInfo = [SELECT Client__r.id, SECTION__c, 
                                                            FMSTAT__c, 
                                                            FDOV__c, FETSTAT__c, FUTYPE__c
                                                            FROM DS_Background_Family_Info_F__c
                                                            ];                
                                                            
        for(DS_Background_Family_Info_F__c f: followupInfo){
            ClientBackground cb = new ClientBackground(); 
            cb.clientID = f.Client__r.id;
            cb.milStatusF = String.valueOf(f.FMSTAT__c);
            cb.followupType = String.valueOf(f.FUTYPE__c);
            cb.followupCompletion = String.valueOf(f.FETSTAT__c);
            cb.fdov = f.FDOV__c;
            System.debug(f);
            System.debug(cb);
            FollowupClients.add(cb);
        }           
        
        System.debug(FollowupClients);
        System.debug(FollowupClients.size());
        return FollowupClients;
    }
    
    //flatten baseline and followup
    public List<ClientBackground> getFullClients(List<ClientBackground> BaselineClients, List<ClientBackground> FollowupClients){
        List<ClientBackground> FullClients = new List<ClientBackground>();
        System.debug(BaselineClients);
        System.debug(FollowupClients);
        
        for(ClientBackground b: BaselineClients){
            
            for(ClientBackground f: FollowupClients){            
                if(b.clientId == f.clientId){
                    
                    b.milStatusF = String.valueOf(f.milStatusF );
                    b.followupType = String.valueOf(f.followupType );
                    b.followupCompletion = String.valueOf(f.followupCompletion );
                    b.fdov = f.fdov;
                }                
            }
            System.debug(b);
            FullClients.add(b);
        }
        System.debug(FullClients);
        System.debug(FullClients.size());
        
        return FullClients;
    }    
    
    //get the closed clients
    public List<ClientBackground> getClosedClients(List<ClientBackground> FullClients){
        List<ClientBackground> ClosedClients = new List<ClientBackground>();
        
        for(ClientBackground c:FullClients){
            if(c.followupType =='2'){
                ClosedClients.add(c);
            }
        }
        System.debug(ClosedClients);
        System.debug(ClosedClients.size());
        return ClosedClients;
    }
    
    //get the clients who have completed treatment as planned
    public List<ClientBackground> getTxCompletedClients(List<ClientBackground> ClosedClients){
        List<ClientBackground> TxCompleteClients = new List<ClientBackground>();
        
        for(ClientBackground c:ClosedClients){
            if(c.followupCompletion =='1'){
                TxCompleteClients.add(c);
            }
        }
        System.debug(TxCompleteClients);
        System.debug(TxCompleteClients.size());
        return TxCompleteClients;
    }
    
    //get the currently open 
    public List<ClientBackground> getOpenClients(List<ClientBackground> BaselineClients, List<ClientBackground> FollowupClients){
        List<ClientBackground> OpenClients = new List<ClientBackground>();
        return OpenClients;
    }
}