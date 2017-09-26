/****
*@description mockup of cocap reporting page
*
*@date    1/23/17
*@author    KW
*
*@modified    1/24    KW    query across main objects, date input
*@modified  1/25    KW  ditto
*@modified  1/30    KW  refining
*@modified  1/31    KW  more->v3
****/
public with sharing class CoCap_Report_Filter_Controller {
    
    //button
    public Boolean submitRequested{get;set;}

    //client record info
    public SObject client { get; set; }
    public String cId{get;set;}
    public Id clientId{get;set;}
    public List<SObject> clients {get;set;}
    
    public Date DateStart{get;set;}
    public Date StartDate{get;set;}
    public Date DateEnd;
    public Strategic_Reports__c cocapObj{get;set;}
    public List<Strategic_Reports__c> listCocap{get;set;}
    public List<CocapInfo> cocapInfoList{get;set;}
    
    //other objects    
    //background object records
    public List<SObject> backBs {get;set;}
    public List<SObject>  backFs {get;set;}
    public SObject backB {get;set;}
    public SObject backF {get;set;}
    
    public List<SObject> backgroundList{get;set;}
    //no list, map instead?
    public Map<String, List<SObject>> rawMap{get;set;}
    
    //cbcl object records
    public List<SObject> cbclBs{ get; set; }
    public List<SObject>  cbclFs{ get; set; }   
    public SObject cbclB{ get; set; }
    public SObject cbclF{ get; set; }   
    
    //ptsd object records
    public List<SObject>  ptsdBs{ get; set; }
    public List<SObject>  ptsdFs{ get; set; }
    public SObject ptsdB{ get; set; }
    public SObject ptsdF{ get; set; }
    
    //sdq/psi object records
    public List<SObject>  sdqBs{ get; set; }
    public List<SObject>  sdqFs{ get; set; }
    public SObject sdqB{ get; set; }
    public SObject sdqF{ get; set; }
    
    //tscc object records
    public List<SObject>  tsccBs{ get; set; }
    public List<SObject>  tsccFs{ get; set; }
    public SObject tsccB{ get; set; }
    public SObject tsccF{ get; set; }
        
    //most recent date per object (order by section)
    public Date bbDate{get;set;}
    public Date bfDate{get;set;}
    public Date cObDate{get;set;}
    public Date cOfDate{get;set;}
    public Date cYbDate{get;set;}
    public Date cYfDate{get;set;}
    public Date pbDate{get;set;}
    public Date pfDate{get;set;}
    public Date sbDate{get;set;}
    public Date sfDate{get;set;}
    public Date tAbDate{get;set;}
    public Date tObDate{get;set;}
    public Date tAfDate{get;set;}
    public Date tOfDate{get;set;}
    
    //overall date list
    public List<Date> dateList{get;set;}
    
    //map client to list of raw field values?
    //public Map<String, List<String>> cliMap{get;set;}
    //maybe make maps of each SObject record instead?
        //Client,backb.section,backb.bdov.....
    public List<SObject> tobjlst{get;set;}
    //cocap class
    public class CocapInfo{

        public String cocaprecord{get;set;}
        
        public String Client{get;set;}
        public String Center{get;set;}
        
        //age
        public Integer cAge {get;set;}
        public Integer eAge {get;set;}
        public String ageGroup{get;set;}
        public Boolean age0_4{get;set;}
        public Boolean age5_9{get;set;}
        public Boolean age10_12{get;set;}
        public Boolean age13_17{get;set;}
        public Boolean age18_21{get;set;}
        
        //gender
        public String genIdentity{get;set;}
        public Boolean genFemale{get;set;}
        public Boolean genMale{get;set;}
        public Boolean genMissing{get;set;}
        public Boolean genOther{get;set;}
        public Boolean genUnknown{get;set;}
        public Boolean genTrans{get;set;}
        
        //ethnicity
        public String ethnicGroup{get;set;}
        public Boolean ethnicHispanic{get;set;}
        public Boolean ethnicMissing{get;set;}
        public Boolean ethnicNonHispanic{get;set;}
        public Boolean ethnicUnknown{get;set;}
        
        //race
        public String raceGroup{get;set;}
        public Boolean raceAINAK{get;set;}
        public Boolean raceAsian{get;set;}
        public Boolean raceBlack{get;set;}
        public Boolean raceHIOPI{get;set;}
        public Boolean raceWhite{get;set;}
        public Boolean raceUnkNR{get;set;}
        public Boolean raceMulti{get;set;}
        
        //military
        public Boolean milAssociated{get;set;}
        public Boolean milMissing{get;set;}
        
        //treatment
        public Boolean treatNew{get;set;}
        public Boolean treatClinical{get;set;}
        public Boolean treatServices{get;set;}
        public Boolean treatEnded{get;set;}
        public Boolean treatAsPlanned{get;set;}
        public Boolean treatMissing{get;set;}
            
        //dates 
        public Date RangeStartDate{get;set;}
        public Date RangeEndDate{get;set;}
        
        //overall date list
        public List<Date> dateList{get;set;}
        
        public CocapInfo(){
            this.cocaprecord = null;
        }
    }
    
    //main controller
    public CoCap_Report_Filter_Controller(ApexPages.StandardController controller) {
    
        cocapInfoList = new List<CocapInfo>();  
        
        //from reportbuilder.cls, query all objs
                
       // List <Id> cids;
        List <String> objIds = new List<String>();
        String clientObjId;
                        
        //clients info
        List<SObject> clients = [SELECT id, Clinician__c, Center__c, Age__c, CURRENT_AGE__c, INIT__c
                                    FROM Client__c
                                    ];//where allowed by role
                                    
        System.debug(clients); 
        System.debug(clients.size()); 
        
        //lists for all object records
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
                                WHERE Client__c  IN :  clients]; 
          
        //test that list of this object is not empty
        if((backBs.size()>0)){
            //for the list
            for(SObject b : backBs){
                
                backB = backBs.get(0);
                //get the date(s)
                bbDate = date.valueOf(b.get('BDOV__c'));
                System.debug(bbDate);
                
                //add to date list
                if(bbDate != null){
                //    dateList.add(bbDate);
                }             
            //    backgroundList.add(backB);
            }            
            System.debug(backBs);
          //  backgroundList=backBs;
        }
                                
        List<SObject> backFs = [SELECT name, Client__c,FDOV__c, FUTYPE__c, FETSTAT__c, FMSTAT__c, SECTION__c
                                FROM DS_Background_Family_Info_F__c
                                WHERE Client__c  IN :  clients
                               ORDER BY SECTION__c DESC];
                               
        //test that list of this object is not empty
        if((backFs.size()>0)){
            //for the list
            for(SObject f : backFs){
                
                backF = backFs.get(0);
                //get the date(s)
                bfDate = date.valueOf(f.get('FDOV__c'));
                System.debug(bfDate);
                
                //add to date list
                if(bfDate != null){
               //     dateList.add(bfDate);
                }
             //   backgroundList.add(f);
            }
        }
        
        List<SObject> cbclBs = [SELECT Client__c,BDOACO__c, BDOACY__c, SECTION__c
                                FROM DS_CBCL_B__c
                                WHERE Client__c  IN :  clients];
        //test that list of this object is not empty
        if((cbclBs.size()>0)){
            //for the list
            for(SObject cb : cbclBs){
                
                cbclB = cbclBs.get(0);
                //get the date(s)
                cObDate = date.valueOf(cb.get('BDOACO__c'));
                cYbDate = date.valueOf(cb.get('BDOACY__c'));
                
                //add to date list
                if(cObDate != null){
                   // dateList.add(cObDate);
                }
                if(cYbDate != null){
                 //   dateList.add(cYbDate);
                }
            }
        }
        
        List<SObject> cbclFs = [SELECT Client__c,FDOACO__c, FDOACY__c, SECTION__c
                                FROM DS_CBCL_F__c
                                WHERE Client__c  IN :  clients
                               ORDER BY SECTION__c DESC];
        //test that list of this object is not empty
        if((cbclFs.size()>0)){
            //for the list
            for(SObject cf : cbclFs){
                cbclF = cbclFs.get(0);
                //get the date(s)
                cOfDate = date.valueOf(cf.get('FDOACO__c'));
                cYfDate = date.valueOf(cf.get('FDOACY__c'));
                
                //add to date list
                if(cOfDate != null){
                 //   dateList.add(cOfDate);
                }
                if(cYfDate != null){
                 //   dateList.add(cYfDate);
                }
            }
        }
        
        List<SObject> ptsdBs = [SELECT Client__c,BDOAPTSD__c, SECTION__c
                                FROM DS_PTSD_CA_B__c
                                WHERE Client__c  IN :  clients];
        //test that list of this object is not empty
        if((ptsdBs.size()>0)){
            
            //for the list
            for(SObject pb : ptsdBs){
                ptsdB = ptsdBs.get(0);              
                //get the date(s)
                pbDate = date.valueOf(pb.get('BDOAPTSD__c'));
                
                //add to date list
                if(pbDate != null){
               //     dateList.add(pbDate);
                }

            }
        }
        
        List<SObject> ptsdFs = [SELECT Client__c,FDOAPTSD__c, SECTION__c
                                FROM DS_PTSD_CA_F__c
                                WHERE Client__c  IN :  clients
                               ORDER BY SECTION__c DESC];
        //test that list of this object is not empty
        if((ptsdFs.size()>0)){
            //for the list
            for(SObject pf : ptsdFs){
                ptsdF = ptsdFs.get(0);              
                //get the date(s)
                pfDate = date.valueOf(pf.get('FDOAPTSD__c'));
                
                //add to date list
                if(pfDate != null){
                //    dateList.add(pfDate);
                }

            }
        }
        
        List<SObject> sdqBs = [SELECT Client__c,BDOAPSI__c, SECTION__c
                               FROM DS_SDQ_PSI_CDI_B__c
                               WHERE Client__c  IN :  clients];
        //test that list of this object is not empty
        if((sdqBs.size()>0)){
            sdqB = sdqBs.get(0);
            //for the list
            for(SObject sb : sdqBs){                
                //get the date(s)
                sbDate = date.valueOf(sb.get('BDOAPSI__c'));
                
                //add to date list
                if(sbDate != null){
               //     dateList.add(sbDate);
                }       

            }
        }
        
        List<SObject> sdqFs = [SELECT Client__c,FDOAPSI__c, SECTION__c
                               FROM DS_SDQ_PSI_CDI_F__c
                               WHERE Client__c  IN :  clients
                               ORDER BY SECTION__c DESC];
        //test that list of this object is not empty
        if((sdqFs.size()>0)){
            sdqF = sdqFs.get(0);
            
            //for the list
            for(SObject sf : sdqFs){                
                //get the date(s)
                sfDate = date.valueOf(sf.get('FDOAPSI__c'));
                
                //add to date list
                if(sfDate != null){
              //      dateList.add(sfDate);
                }
            }
        }
        
        List<Sobject> tsccBs = [SELECT Client__c,BDOATSCC__c, BDOATSCYC__c, SECTION__c
                                FROM DS_TSCC_TSCYC_B__c         
                                WHERE Client__c  IN :  clients];
        //test that list of this object is not empty
        if((tsccBs.size()>0)){
            
            //for the list
            for(SObject tb : tsccBs){
                tsccB = tsccBs.get(0);              
                //get the date(s)
                tAbDate = date.valueOf(tb.get('BDOATSCC__c'));
                tObDate = date.valueOf(tb.get('BDOATSCYC__c'));
                
                //add to date list
                if(tAbDate != null){
              //      dateList.add(tAbDate);
                }
                if(tObDate != null){
               //     dateList.add(tObDate);
                }

            }
        }
        
        List<Sobject> tsccFs = [SELECT Client__c,FDOATSCC__c, FDOATSCYC__c, SECTION__c
                                FROM DS_TSCC_TSCYC_F__c         
                                WHERE Client__c  IN :  clients
                               ORDER BY SECTION__c DESC];
        //test that list of this object is not empty
        if((tsccFs.size()>0)){
            
            //for the list
            for(SObject tf : tsccFs){
                tsccF = tsccFs.get(0);
    
                //get the date(s)
                tAfDate = date.valueOf(tf.get('FDOATSCC__c'));
                tOfDate = date.valueOf(tf.get('FDOATSCYC__c'));
                
                //add to date list
                if(tAfDate != null){
             //       dateList.add(tAfDate);
                }
                if(tOfDate != null){
              //      dateList.add(tOfDate);
                }                   
            }
        }  
        
        Map<String, List<SObject>> rawMap = new Map<String, List<SObject>>();
        rawMap.put('BackB', backBs);
        rawMap.put('BackF', backFs);
        rawMap.put('CbclB', cbclBs);
        rawMap.put('CbclF', cbclFs);
        rawMap.put('PtsdB', ptsdBs);
        rawMap.put('PtsdF', ptsdFs);
        rawMap.put('SdqB', sdqBs);
        rawMap.put('SdqF', sdqFs);
        rawMap.put('TsccB', tsccBs);
        rawMap.put('TsccF', tsccFs);
        
        System.debug(rawMap);
        System.debug(rawMap.size());
        
        //call makeCoCap function
//        makeCoCap(rawMap);
        
     /*   for(String oName : rawMap.keyset()){
            List<SObject> tobjlst = new List<SObject>();
            tobjlst=rawMap.get(oName);
            SObject tmpObj = tobjlst.get(0);
            List<Integer> sectionList = new List<Integer>();
            System.debug(tobjlst.get(0));
            System.debug(tmpObj);
            System.debug(tmpObj.get('SECTION__c'));
            System.debug(tobjlst);
            System.debug(rawMap.get(oName));
        }*/
        System.debug(tobjlst);
    
        //get existing cocap records
        getCocapRecords();
        getCocaps(clients, backBs, backFs, cbclBs, cbclFs, ptsdBs, ptsdFs, sdqBs, sdqFs, tsccBs, tsccFs);
        StartDate();
        System.debug(backBs);
        System.debug(backBs.size());
        System.debug(backFs);
        System.debug(backFs.size());
        System.debug(cbclBs);
        System.debug(cbclBs.size());
        System.debug(cbclFs);
        System.debug(cbclFs.size());
        System.debug(ptsdBs);
        System.debug(ptsdBs.size());
        System.debug(ptsdFs);
        System.debug(ptsdFs.size());
        System.debug(sdqBs);
        System.debug(sdqBs.size());
        System.debug(sdqFs);
        System.debug(sdqFs.size());
        System.debug(tsccBs);
        System.debug(tsccBs.size());
        System.debug(tsccFs);
        System.debug(tsccFs.size());
     //   System.debug(backgroundList);
  //      System.debug(backgroundList.size());
        System.debug(cocapInfoList);
       // System.debug(listCocap);
                    
    }
    public void getCocaps(List<SObject> clients, 
                            List<SObject> backBs, List<SObject> backFs, 
                            List<SObject> cbclBs, List<SObject> cbclFs, 
                            List<SObject> ptsdBs, List<SObject> ptsdFs, 
                            List<SObject> sdqBs, List<SObject> sdqFs, 
                            List<SObject> tsccBs, List<SObject> tsccFs 
                         ){      
        //List<SObject> backgroundList = new List<SObject>();
        System.debug(clients);
        System.debug(clients.size());
        System.debug(backBs.size());
        System.debug(backBs);
        
        for(SObject c : clients){
//            backB = backBs.get('Client__c');
            System.debug(c.get('id'));
            System.debug(c.get('INIT__c'));
            System.debug(backBs);
            //get background b
            //get others
            //map? <client, list, list, list>()
                //for map, call funcitons
        }
        
        //add to query user role info?   
     //   makeCoCap(backBs);
      //  makeCoCap(backFs);
    }
               
    //function to query cocap records
    public void getCocapRecords(){
        
        //cocap as a seperate object
        List<SObject> listCocap = [SELECT 
                                        Client__c,
                                        Center__c,
                                        //age info
                                        Age_Current_Age__c,
                                        Age_Group__c,
                                        Age_Group_0_4__c, Age_Group_5_9__c, Age_Group_10_12__c, Age_Group_13_17__c, Age_Group_18_21__c,
                                        //gender info
                                        Gender_Identity__c,
                                        Gender_Female__c, Gender_Male__c, Gender_Missing__c, Gender_Other__c, Gender_Refused_or_Unknown__c, Gender_Transgender__c,
                                        //ethnicity info
                                        Ethnic_Group__c,
                                        Ethnicity_Hispanic_or_Latino__c, Ethnicity_Missing__c, Ethnicity_Non_Hispanic__c, Ethnicity_Refused_or_Unknown__c,
                                        //race info
                                        Race__c,
                                        Race_American_Indian_or_Alaskan_Native__c, Race_Asian__c, Race_Black_African_American__c, Race_Multiracial__c, Race_Native_Hawaiian_or_Pacific_Islander__c, Race_Refused_or_Unknown__c, Race_White__c,
                                        //military info
                                        Military_Associated__c, 
                                        //services info
                                        Treatment_Completed_as_Planned__c, Treatment_Ended__c, Treatment_Missing__c 
                                    FROM Strategic_Reports__c];
        System.debug(listCocap);
        System.debug(listCocap.size());
        
            //individual objects
                                                
        addCocapRecord(listCocap);
        
        //alternatively, call methods for all objects
        
    }        
    
    //input button onclick
//turn dates into String> pagerefernce
public PageReference StartDate(){
    StartDate =  DateStart;
    System.debug(StartDate);
    System.debug(DateStart);
    return null;
}
        
    //function of add a record to the list of cocap records
    public void addCocapRecord(List<SObject> listCocap){//with singular objects, this definition may have to change
        for(SObject cocapObj: listCocap){
        
            //declare new
            CocapInfo info = new CocapInfo();
            
            //assign values     
            info.Center = String.valueOf(cocapObj.get('Center__c')); 
            info.Client = String.valueOf(cocapObj.get('Client__c'));
            info.ageGroup = String.valueOf(cocapObj.get('Age_Group__c'));
            info.ethnicGroup = String.valueOf(cocapObj.get('Ethnic_Group__c'));
            info.genIdentity = String.valueOf(cocapObj.get('Gender_Identity__c'));
            info.raceGroup = String.valueOf(cocapObj.get('Race__c'));
            
            //add to list
            cocapInfoList.add(info);
        }
    }    
    
    public PageReference cocapDisplay(){
        DateStart = cocapObj.DateStart__c;
        DateEnd = cocapObj.DateEnd__c;
        listCocap = [SELECT name, id, Client__c,
                        Date_Earliest__c, Date_Latest__c, 
                        Age_Group__c, Ethnic_Group__c, Gender_Identity__c,  Race__c
                    FROM Strategic_Reports__c
                   // WHERE cocapObj.Date_Earliest__c
                    //cocapObj.Date_Latest__c
                    ];
        return null;
    }

}