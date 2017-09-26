/****
*@description another cocap mockup
*
*@date    2/15/17
*@author    KW
*
*@modified  3/3/17  KW  modify logic for clients with services
*
*@group cocap
*@group-content /ApexDocContent/Cocap7_Controller.htm
****/
public with sharing class CoCap7_Controller {
    
    //init start and end dates
    public Date StartDate{get;set;}
    public Date EndDate{get;set;}
    
    //lists of objects
    public List<DS_Background_Family_Info_B__c> backgroundBs{get;set;}
    public List<DS_Background_Family_Info_F__c> backgroundFs{get;set;}
    public List<DS_CBCL_B__c> cbclBs{get;set;}
    public List<DS_CBCL_F__c> cbclFs{get;set;}
    public List<DS_PTSD_CA_B__c> ptsdBs{get;set;}
    public List<DS_PTSD_CA_F__c> ptsdFs{get;set;}
    public List<DS_SDQ_PSI_CDI_B__c> sdqBs{get;set;}
    public List<DS_SDQ_PSI_CDI_F__c> sdqFs{get;set;}
    public List<DS_TSCC_TSCYC_B__c> tsccBs{get;set;}
    public List<DS_TSCC_TSCYC_F__c> tsccFs{get;set;}
    
    //records lists
    public List<clientRec> clientRecords{get;set;}
    public List<targetRec> genderRecords{get;set;}
    public List<targetRec> ageRecords{get;set;}
    public List<targetRec> ethnicRecords{get;set;}
    public List<targetRec> raceRecords{get;set;}
    public List<targetRec> milRecords{get;set;}
    public List<targetRec> newRecords{get;set;}
    
    //class for records
    public class targetRec{
        public String recLabel{get;set;}
        public Integer recValue{get;set;}
        public targetRec(){
            this.recLabel = null;
        }
    }
        
    //class for clients with services
    public class clientRec{
        public Id clientId{get;set;}
        public Date bdov{get;set;}
        public Integer CurrentAge{get;set;}
        public String gender{get;set;}
        public String ethnic{get;set;}
        public String race{get;set;}
        public String military{get;set;}
        public String txstatus{get;set;}
        public Date fdov{get;set;}
        /*public Date cbclDate{get;set;}
        public Date ptsdDate{get;set;}
        public Date sdqDate{get;set;}
        public Date tscDate{get;set;}*/
        public clientRec(){
            this.clientId = null;
        }
    }
            
    //there shouldn't be anything pre-loaded on page        
    public CoCap7_Controller(ApexPages.StandardController controller) {
    }
    
    //function run on click
    public void getData(){
        
        //get clients with services
        List<clientRec> clients = getClientServiceInfo();
        
        //get the lists of objects (start w/ back b/fs)
        
        //maps for records
        
        //lists of records
        
        //loops for each record type
    }
    
    public List<clientRec> getClientServiceInfo(){  
        List<clientRec> clients =  new List<clientRec>();
        List<DS_Background_Family_Info_F__c> backgroundInfo = [SELECT Client__r.id, 
                                                                Baseline_ID__r.BDOV__c, 
                                                                Client__r.CURRENT_AGE__c, 
                                                                Baseline_ID__r.BIDENT__c, 
                                                                Baseline_ID__r.ETHNIC__c, 
                                                                Baseline_ID__r.RAKNTV__c, Baseline_ID__r.RASIANIN__c , Baseline_ID__r.RBLACK__c, Baseline_ID__r.RCHINESE__c , Baseline_ID__r.RFILIPINO__c, Baseline_ID__r.RGUAM__c, Baseline_ID__r.RHAWAN__c, Baseline_ID__r.RINDIAN__c, Baseline_ID__r.RJAPANESE__c, Baseline_ID__r.RKOREAN__c, Baseline_ID__r.ROASIAN__c, Baseline_ID__r.ROPI__c, Baseline_ID__r.RREF__c, Baseline_ID__r.RSAMOA__c, Baseline_ID__r.RUNK__c, Baseline_ID__r.RVIETNAMESE__c, Baseline_ID__r.RWHITE__c, 
                                                                Baseline_ID__r.BMILFAMILY__c, Baseline_ID__r.BMILSERV__c, FMSTAT__c, 
                                                                FDOV__c, FETSTAT__c, FUTYPE__c
                                                                FROM DS_Background_Family_Info_F__c
                                                                WHERE FDOV__c >: StartDate];
                                                                
        for(DS_Background_Family_Info_F__c b : backgroundInfo){
            clientRec client = new clientRec();
            client.clientId = b.Client__c;
            client.bdov = b.Baseline_ID__r.BDOV__c;
            client.CurrentAge = Integer.valueOf(b.Client__r.CURRENT_AGE__c);
          //  client.gender = b.get(Baseline_ID__r.BIDENT__c);
                
                //genderParsing
                if(b.Baseline_ID__r.BIDENT__c == null){
                    client.gender='Missing';
                }
                else{
                    Integer genId = Integer.valueOf(b.Baseline_ID__r.BIDENT__c);
                    
                    if(genId == 1){
                        client.gender= 'Male';
                    }
                    else if(genId == 2){
                        client.gender = 'Female';
                    }
                    else if((genId == 3) || (genId == 4)){
                        client.gender='Transgender';
                    }
                    else if(genId == 98){
                        client.gender='Other';
                    }
                    else if((genId == 96) || (genId == 99)){
                        client.gender='Refused';
                    }
                }
            //client.ethnic = b.get(Baseline_ID__r.ETHNIC__c);
            
           /* client.race = b.get();
            client.militar = b.get();
            client.txstatus = b.get();
            client.fdov = b.get();*/
            clients.add(client);
        }
                                                              
        System.debug(clients);
        return clients;
    }
        
        //demographics
            //total # ever? or total w/ bdov w/i timeframe?
            
        //military
            //background b, background f 
                //where bmilfamily =1 ||2 ||bmilself ==1 ||fmstat==1
            
        //services
            //new clients
                //# w/ bdov w/i range
                //background family info b where client in clients && date in range
                
            //with services
                //(total clients with ageEntered 0-21) - (background f where futype==2 && fdov < startdate)
                //is same as: background f where futype ==2 && fdov >= startdate?
                    //what about enddate?
                    
            //with assessments
                //clients with a date w/i range
                    //any date
                        //background b, f, cbcl b, f, ptsd b, f, psi b, f, tecc/yc b, f, (sdq?)
            
            //ended treatment
                //clients who ended treatment w/i range
                    //background f w/ fdov w/i range && futype ==2 (ageEntered or current?)
            //as planned
                //&&fetstat ==1
    //}
    
}