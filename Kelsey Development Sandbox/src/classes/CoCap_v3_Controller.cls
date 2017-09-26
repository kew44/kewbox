/****
*@description mockup of cocap reporting page
*
*@date    1/23/17
*@author    KW
****/
public with sharing class CoCap_v3_Controller {

    public PageReference runQuery() {
        DisplayRecords();
        System.debug(backBs);
        System.debug(StartDate);
        System.debug(clients);
        
        return null;
    }

    public PageReference getDates(){
        System.debug(StartDate);//Date StartDate = Date.valueOf(Apexpages.currentPage().getParameters().get('StartDate'));
        System.debug(EndDate);//Date EndDate = Date.valueOf(Apexpages.currentPage().getParameters().get('EndDate'));
        
        COCAPRaw r = new COCAPRaw();
        COCAPParsed p = new COCAPParsed();
        
        List<COCAPParsed> parsedList = new List<COCAPParsed>();
           List<SObject> backBs = [SELECT name, Client__c, SECTION__c,
                            BDOV__c, 
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
                        WHERE Client__c  IN :  clients
                        AND BDOV__c >=:StartDate];  
            System.debug(backBs);
            SObject backB;
        return null;
    }
   /* public PageReference getBackground(){
        getDates();
        return null;
    }*/
public Date StartDate{get;set;} //= Date.valueOf(Apexpages.currentPage().getParameters().get('StartDate'));
public Date EndDate{get;set;}// = Date.valueOf(Apexpages.currentPage().getParameters().get('EndDate'));

public List<Client__c> clients{get;set;}

public List<COCAPParsed> parsedList{get;set;}

public SObject backB{get;set;}
public List<SObject> backBs{get;set;}
public List<DS_Background_Family_Info_B__c> backgroundBList{get;set;}

public Integer totalMale{get;set;}
public Integer totalFemale{get;set;}
public Integer totalTrans{get;set;}
public Integer totalUnkGen{get;set;}
public Integer totalMissingGen{get;set;}

public Boolean genMale{get;set;}
public Boolean genFemale{get;set;}
public Boolean genTrans{get;set;}
public Boolean genOther{get;set;}
public Boolean genUnknown{get;set;}
public Boolean genMissing{get;set;}
public Integer genId{get;set;}
public String genIdentity{get;set;}
    //group dates?
    //group cocap raw info
    //group cocap final answers?
    
    public class COCAPDates{
        public String cocapDatesRecord{get;set;}
        
        public Date StartDate{get;set;}
        public Date EndDate{get;set;}
                
        public COCAPDates(){
            this.cocapDatesRecord = null;
        }
    }
    
    public class COCAPRaw{
        public String cocapRawRecord{get;set;}
        
        public List<SObject> backBs{get;set;}
        
        public COCAPRaw(){
            this.cocapRawRecord = null;
        }
    }
    
    public class COCAPParsed{
//        COCAPDates();
        String cocapParsedRecord{get;set;}
        
        public String client{get;set;}
        public String genIdentity{get;set;}
        
        public COCAPParsed(){
            this.cocapParsedRecord = null;
        }
    }
    
    public CoCap_v3_Controller(ApexPages.StandardController controller) {
            
        StartDate = StartDate;
        EndDate = EndDate;
        System.debug(StartDate);
        System.debug(EndDate);
       // InitData();
        
    }
        //public void InitData(){
        public PageReference InitData(){
                      
        COCAPDates c = new COCAPDates();
        COCAPRaw r = new COCAPRaw();
        COCAPParsed p = new COCAPParsed();
        List<COCAPParsed> parsedList = new List<COCAPParsed>();
        
        //clients info
        List<Client__c> clients = [SELECT id, Clinician__c, Center__c, Age__c, CURRENT_AGE__c, INIT__c
                                    FROM Client__c
                                    ];//where allowed by role
        System.debug(clients);
        
        List<SObject> backBs = [SELECT name, Client__c, SECTION__c,
                            BDOV__c, 
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
                        WHERE Client__c  IN :  clients
                        AND BDOV__c >=:StartDate];   
                        
            System.debug(backBs);
                        
            for(SObject backB : backBs){
                System.debug(backB.get('Client__c'));
                findGender(backB);
                System.debug(genIdentity);
                p.client  = String.valueOf(backB.get('Client__c'));
                p.genIdentity = genIdentity;
                System.debug(p);
               // 
            }
//            parsedList.add(p);
  //          System.debug(parsedList);
    //        System.debug(parsedList.size());
            System.debug(p);
            r.backBs = backBs;
            System.debug(r);
            return null;
    }
    
    public void DisplayRecords(){
    
    COCAPDates c = new COCAPDates();
        
        System.debug(StartDate);
        System.debug(EndDate);
            
        //start    
        if(StartDate!=null){
            Boolean sumbitDates = true;
            c.StartDate=StartDate;
        }        
        else{
            Boolean submitDates=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No start date'));
        }
        
        //end
        if(EndDate != null){    
            Boolean sumbitDates = true;
            c.EndDate= EndDate;
        }
        else{
            Boolean submitDates=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No end date'));
        }
        
        System.debug(c);
       // runQuery();
        //getBackground();
        
        COCAPParsed p = new COCAPParsed();
        System.debug(p);
        System.debug(backB);
        
    }
        
    public void findGender(SObject backB){
    
        genMale = FALSE;
        genFemale = FALSE;
        genTrans = FALSE;
        genOther = FALSE;
        genUnknown = FALSE;
        genMissing = FALSE;
       Integer genId = Integer.valueOf(backB.get('BIDENT__c'));
       //if null? use gender?
       
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
        System.debug(genIdentity);
    
    }
}