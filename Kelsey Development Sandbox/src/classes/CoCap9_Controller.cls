/****
*@description another cocap mockup
*
*@date    3/22/17
*@author    KW
*
*@modified  3/23/17 KW  refine lists, add assessments
*@modified  3/27/17 KW  demographics, print
*
*@group cocap
*@group-content /ApexDocContent/Cocap9_Controller.htm
****/
public with sharing class CoCap9_Controller {
    
    //init start and end dates
    public Date StartDate{get;set;}
    public Date EndDate{get;set;}
    
    //init lists of custom class client records
    public List<ClientInfo> BaselineClients{get;set;}
    public List<ClientInfo> FullClients{get;set;}
    public List<ClientInfo> NewClients{get;set;}
    public List<ClientInfo> ClosedClients{get;set;}
    public List<ClientInfo> TxCompleteClients{get;set;}
    public List<ClientInfo> OpenClients{get;set;}
    public List<ClientInfo> AssessmentsClients{get;set;}
        
    //init integers for totals
    public Integer newTotal{get;set;}
    public Integer openTotal{get;set;}
    public Integer closedTotal{get;set;}
    public Integer txCompleteTotal{get;set;}
    public Integer assessmentTotal{get;set;}
    
    //map demographics and military to display subtotals?/don't need Integers?      
    public List<totalRec> treatmentRecords{get;set;}
    public List<totalRec> milRecords{get;set;}
    public List<totalRec> ageRecords{get;set;}
    public List<totalRec> genderRecords{get;set;}
    public List<totalRec> ethnicRecords{get;set;}
    public List<totalRec> raceRecords{get;set;}
    
    public Boolean printReport { get; set; }
    
    /****
    * @description Initilization for print button 
    * @return null
    */
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
    
    //initially loaded values
    public Cocap9_Controller(ApexPages.StandardController controller){
        //there should not be anything pre-loaded
    }
    
    //define custom class for client info
    public class ClientInfo{
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
        public String activeStatus{get;set;}//open/closed
        
        //dates
        public Date bdov{get;set;}
        public Date fdov{get;set;}  
        
        public ClientInfo(){
            this.clientID= null;
        }
    }
    
    //generic class for mapping display
    public class totalRec{
        public String recLabel{get;set;}
        public Integer recValue{get;set;}
        public totalRec(){
            this.recLabel = null;
        }
    }
    
    //function to run on click
    public void getData(){
        //get all clients who have a baseline record ever
        //try Map<id,clientinfo>?
        List<ClientInfo> BaselineClients = getBaseClients();
        //get info from most recent followup per client(if ever)
        List<ClientInfo> FullClients = getFullClients(BaselineClients);
        //get new records       
        List<ClientInfo> NewClients = getNewClients(FullClients );
        //get closed records
        List<ClientInfo> ClosedClients = getClosedClients(FullClients );
        //get tx completed
        List<ClientInfo> TxCompleteClients = getTxCompletedClients(ClosedClients);
        //get open records
        List<ClientInfo> OpenClients = getOpenClients(FullClients );
        //map most recent date to client id for each assessment object
        Map<String, Date> cbclBClientDate = getCbclBs(FullClients);
        Map<String, Date> cbclFClientDate = getCbclFs(FullClients);
        Map<String, Date> ptsdBClientDate = getPtsdBs(FullClients);
        Map<String, Date> ptsdFClientDate = getPtsdFs(FullClients);
        Map<String, Date> sdq_cdi_BClientDate = getSdqBs(FullClients);
        Map<String, Date> sdq_cdi_FClientDate = getSdqFs(FullClients);
        Map<String, Date> tscBClientDate = getTsccBs(FullClients);
        Map<String, Date> tscFClientDate = getTsccFs(FullClients);
        //get assessments list
        List<ClientInfo> AssessmentClients = getAssessmentClients(FullClients, cbclBClientDate, cbclFClientDate, ptsdBClientDate, ptsdFClientDate, sdq_cdi_BClientDate, sdq_cdi_FClientDate, tscBClientDate, tscFClientDate);      
        
        //get the counts for each question about treatment
        newTotal= Integer.valueOf(NewClients.size());
        openTotal= Integer.valueOf(OpenClients.size());
        assessmentTotal= Integer.valueOf(AssessmentClients.size());
        closedTotal= Integer.valueOf(ClosedClients.size());
        txCompleteTotal= Integer.valueOf(TxCompleteClients.size());
        
        //map the treatment questions to the size
        Map<String, Integer> treatmentsMap=new Map<String, Integer>();          
            treatmentsMap.put('1. Number of new Clients within date range: ', newTotal);
            treatmentsMap.put('2. Number of Clients currently receiving services: ', openTotal);
            treatmentsMap.put('3. Number of Clients with a Clinical Assessment within date range: ', assessmentTotal);
            treatmentsMap.put('4. Number of Clients where treatment was completed: ', closedTotal);
                treatmentsMap.put('4a. Number of Clients where treatment was completed AS PLANNED: ', txCompleteTotal);
                
        //use assessments list for determining military and demographic values
        Map<String, Integer> milMap= getMilMap(AssessmentClients);
        Map<String, Integer> ageMap= getAgeMap(AssessmentClients);
        Map<String, Integer> genMap= getGenMap(AssessmentClients);
        Map<String, Integer> ethMap= getEthMap(AssessmentClients);
        Map<String, Integer> raceMap= getRaceMap(AssessmentClients);
                
        //lists of records
        treatmentRecords = new List<totalRec>();
        milRecords = new List<totalRec>();
        genderRecords = new List<totalRec>();
        ageRecords = new List<totalRec>();
        ethnicRecords = new List<totalRec>();
        raceRecords = new List<totalRec>();
        
        //treatment
        for(String t:treatmentsMap.keySet()){
            totalRec tr = new totalRec();
            tr.recLabel = t;
            tr.recValue = treatmentsMap.get(t);
            System.debug(tr);
            treatmentRecords.add(tr);
        }
        //military
        for(String m:milMap.keySet()){
            totalRec mr = new totalRec();
            mr.recLabel = m;
            mr.recValue = milMap.get(m);
            System.debug(mr);
            milRecords.add(mr);
        }
        //gender
        for(String g:genMap.keySet()){
            totalRec gr = new totalRec();
            gr.recLabel = g;
            gr.recValue = genMap.get(g);
            System.debug(gr);
            genderRecords.add(gr);
        }
        //age
        for(String a:ageMap.keySet()){
            totalRec ar = new totalRec();
            ar.recLabel = a;
            ar.recValue = ageMap.get(a);
            System.debug(ar);
            ageRecords.add(ar);
        }
        //ethnicity
        for(String e:ethMap.keySet()){
            totalRec er = new totalRec();
            er.recLabel = e;
            er.recValue = ethMap.get(e);
            System.debug(er);
            ethnicRecords.add(er);
        }
        //race
        for(String r:raceMap.keySet()){
            totalRec rr = new totalRec();
            rr.recLabel = r;
            rr.recValue = raceMap.get(r);
            System.debug(rr);
            raceRecords.add(rr);
        }
    
        System.debug(treatmentRecords);
        System.debug(milRecords);
        System.debug(genderRecords);
        System.debug(ageRecords);
        System.debug(ethnicRecords);
        System.debug(raceRecords);
    }
    
    //get all clients who have a baseline record ever
    public List<ClientInfo> getBaseClients(){
    
        //initialize list
        List<ClientInfo> BaselineClients = new List<ClientInfo>();        
        
        //query baseline information
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
        
        //loop through the baseline records
        for(DS_Background_Family_Info_B__c b:baselineInfo){
            
            //initialize client information class record
            ClientInfo cb = new ClientInfo();
            
            //assign values
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
            cb.activeStatus = 'Open';
            //dates 
            cb.bdov = b.BDOV__c;
            //cb.fdov   = null;     
            
            //add to list of client info records
            BaselineClients.add(cb);
        }
        
        //return list of client info records with baseline data
        return BaselineClients;
    }
    
    //get all clients with at least one followup ever
    public List<ClientInfo> getFullClients(List<ClientInfo> BaselineClients){
        
        //initialize lists for client info records
        List<ClientInfo> FullClients = new List<ClientInfo>();
        List<ClientInfo> tmpListClients = new List<ClientInfo>();
        
        //initialize date list
        List<Date> clientdateList= new List<Date>();
        //init client id list
        List<Id> cliIds = new List<Id>();
        //init the most recent date per client
        Date mostRecent;
                       
        //add the client ids from baseline clients to list
        for(ClientInfo o:BaselineClients){
            cliIds.add(o.clientID);
        }
        
        //query followup information
        List<DS_Background_Family_Info_F__c> followupInfo = [SELECT Client__r.id, SECTION__c, 
                                                            FMSTAT__c, 
                                                            FDOV__c, FETSTAT__c, FUTYPE__c
                                                            FROM DS_Background_Family_Info_F__c
                                                            WHERE Client__r.id IN: cliIds 
                                                            ORDER BY FDOV__c DESC 
                                                            ];                
                 
        //loop through the querried records
        for(DS_Background_Family_Info_F__c f: followupInfo){
            
            //initialize client information class record
            ClientInfo cb = new ClientInfo();
            
            //create a client info record
            cb.clientID = f.Client__r.id;
            cb.milStatusF = String.valueOf(f.FMSTAT__c);
            cb.followupType = String.valueOf(f.FUTYPE__c);
            cb.followupCompletion = String.valueOf(f.FETSTAT__c);
            cb.fdov = f.FDOV__c;
            
            //add record to temporary list
            tmpListClients.add(cb);
        }
                
        //loop through the baseline list    
        for(ClientInfo b:BaselineClients){
            //loop through temporary list to compare
            for(ClientInfo t:tmpListClients){
                //find the most recent fdov
                clientdateList.add(t.fdov);
                //match any followup records to baseline via client id              
                if(b.clientID == t.clientID){
                    //update the baseline record to include followup info
                    b.milStatusF = t.milStatusF;
                    b.followupType = t.followupType;
                    b.followupCompletion = t.followupCompletion;
                    b.fdov = getMostRecent(clientdateList);
                }
            }
            FullClients.add(b);
        }               
        return FullClients;
    }
    
    //get new records 
    public List<ClientInfo> getNewClients(List<ClientInfo> FullClients){
        List<ClientInfo> NewClients = new List<ClientInfo>();
        
        //filter bdov in range
        for(ClientInfo c:FullClients){
            if((c.bdov >= StartDate) &&(c.bdov <= EndDate)){
                NewClients.add(c);
            }
        }
        return NewClients;
    }
    
    //get closed records
    public List<ClientInfo> getClosedClients(List<ClientInfo> FullClients){
        List<ClientInfo> ClosedClients = new List<ClientInfo>();
        
        for(ClientInfo c:FullClients){
            if((c.followupType =='2') && ((c.fdov >= StartDate) &&(c.fdov<= EndDate)) ){
                c.activeStatus = 'Closed';
                ClosedClients.add(c);
            }
        }
        return ClosedClients;
    }
            
    //get tx completed
    public List<ClientInfo> getTxCompletedClients(List<ClientInfo> ClosedClients){
        List<ClientInfo> TxCompleteClients = new List<ClientInfo>();
        
        for(ClientInfo c:ClosedClients){
            if(c.followupCompletion =='1'){
                TxCompleteClients.add(c);
            }
        }
        return TxCompleteClients;
    }
    
    //get open records
    public List<ClientInfo> getOpenClients(List<ClientInfo> FullClients){
        
        List<ClientInfo> OpenClients = new List<ClientInfo>();
                
        for(ClientInfo f:FullClients){
          if(f.activeStatus == 'Open'){
                OpenClients.add(f);
            }
        }
        return OpenClients;
    }
    
    //most recent date method
    public Date getMostRecent(List<Date> dateList){
        Date MostRecentDate;
        for(Date d : dateList){
            if(d != null){
                if(MostRecentDate == null){
                    MostRecentDate = d;
                }
                else if(MostRecentDate < d){
                    d= MostRecentDate;
                }
                else{
                    MostRecentDate = MostRecentDate;
                }
            }
        }
        return MostRecentDate;
    }
    
    //get all cbcl b
    public Map<String, Date> getCbclBs(List<ClientInfo> FullClients){
        
        //initialize date list
        List<Date> cbclBdateList= new List<Date>();
        //init client id list
        List<Id> cliIds = new List<Id>();
        ///init map of client id string and date
        Map<String, Date> cbclBClientDate = new Map<String, Date>();
        //init the most recent date per client
        Date mostRecent;
        
        //add the client ids from followup clients to list
        for(ClientInfo o:FullClients){
            cliIds.add(o.clientID);
        }
        
        //query only the clients that are part of the followup clients
        List<DS_CBCL_B__c>  cbclBList = [SELECT Client__c,BDOACO__c, BDOACY__c
                                    FROM DS_CBCL_B__c
                                    WHERE Client__c IN: cliIds 
                                    ];                     
         
        //loop through the querried records
        for(DS_CBCL_B__c c : cbclBList){
            //parse id to string (could use id?)
            String cliId = String.valueOf(c.Client__c);
            //add dates to the date list
            cbclBdateList.add(c.BDOACO__c);
            cbclBdateList.add(c.BDOACY__c);
            //find the most recent date
            mostRecent= getMostRecent(cbclBdateList);
            //add client id and date to map
            cbclBClientDate.put(cliId, mostRecent);
        }           
        //return a list of clients and their most recent date for the object
        return(cbclBClientDate);
    }
    
    //get all cbcl f
    public Map<String, Date> getCbclFs(List<ClientInfo> FullClients){
        
        List<Date> cbclFdateList= new List<Date>();
        List<Id> cliIds = new List<Id>();
        Map<String, Date> cbclFClientDate = new Map<String, Date>();
        Date mostRecent;
        
        for(ClientInfo o:FullClients){
            cliIds.add(o.clientID);
        }
        
        List<DS_CBCL_F__c>  cbclFList = [SELECT Client__c, SECTION__c, FDOACO__c, FDOACY__c
                                        FROM DS_CBCL_F__c
                                        WHERE Client__c IN: cliIds 
                                        ];
                                    
        for(DS_CBCL_F__c c : cbclFList){
            String cliId = String.valueOf(c.Client__c);
            cbclFdateList.add(c.FDOACO__c);
            cbclFdateList.add(c.FDOACY__c);
            mostRecent= getMostRecent(cbclFdateList);
            cbclFClientDate.put(cliId, mostRecent);
        }           
        return(cbclFClientDate);
    }
    
    //get all ptsd b
    public Map<String, Date> getPtsdBs(List<ClientInfo> FullClients){
        
        List<Date> ptsdBdateList= new List<Date>();
        List<Id> cliIds = new List<Id>();
        Map<String, Date> ptsdBClientDate = new Map<String, Date>();
        Date mostRecent;
        
        for(ClientInfo o:FullClients){
            cliIds.add(o.clientID);
        }
                
        List<DS_PTSD_CA_B__c>  ptsdBList = [SELECT Client__c,BDOAPTSD__c
                                            FROM DS_PTSD_CA_B__c
                                            WHERE Client__c IN: cliIds 
                                            ];
                                    
        for(DS_PTSD_CA_B__c p : ptsdBList){
            String cliId = String.valueOf(p.Client__c);
            ptsdBdateList.add(p.BDOAPTSD__c);
            mostRecent= getMostRecent(ptsdBdateList);
            ptsdBClientDate.put(cliId, mostRecent);
        }           
        System.debug(ptsdBClientDate);
        System.debug(ptsdBClientDate.size());
        return(ptsdBClientDate);
    }
    
    //get all ptsd f
    public Map<String, Date> getPtsdFs(List<ClientInfo> FullClients){
        
        List<Date> ptsdFdateList= new List<Date>();
        List<Id> cliIds = new List<Id>();
        Map<String, Date> ptsdFClientDate = new Map<String, Date>();
        Date mostRecent;
        
        for(ClientInfo o:FullClients){
            cliIds.add(o.clientID);
        }
        
        List<DS_PTSD_CA_F__c>  ptsdFList = [SELECT Client__c, SECTION__c, FDOAPTSD__c
                                            FROM DS_PTSD_CA_F__c
                                            WHERE Client__c IN: cliIds 
                                            ];
                                    
        for(DS_PTSD_CA_F__c p : ptsdFList){
            String cliId = String.valueOf(p.Client__c);
            ptsdFdateList.add(p.FDOAPTSD__c);
            mostRecent= getMostRecent(ptsdFdateList);
            ptsdFClientDate.put(cliId, mostRecent);
        }
        System.debug(ptsdFClientDate);
        System.debug(ptsdFClientDate.size());
        return(ptsdFClientDate);
    }
    
    //get all sdq (cdi) b
    public Map<String, Date> getSdqBs(List<ClientInfo> FullClients){
        
        List<Date> sdqBdateList= new List<Date>();
        List<Id> cliIds = new List<Id>();
        Map<String, Date> sdq_cdi_BClientDate = new Map<String, Date>();
        Date mostRecent;
        
        for(ClientInfo o:FullClients){
            cliIds.add(o.clientID);
        }
        
        List<DS_SDQ_PSI_CDI_B__c>  sdqBList = [SELECT  Client__c,BDOAPSI__c
                                            FROM DS_SDQ_PSI_CDI_B__c
                                            WHERE Client__c IN: cliIds 
                                            ];
                                            
        for(DS_SDQ_PSI_CDI_B__c s : sdqBList){
            String cliId = String.valueOf(s.Client__c);
            sdqBdateList.add(s.BDOAPSI__c);
            mostRecent= getMostRecent(sdqBdateList);
            sdq_cdi_BClientDate.put(cliId, mostRecent);
        }           
        System.debug(sdq_cdi_BClientDate);
        System.debug(sdq_cdi_BClientDate.size());
        return(sdq_cdi_BClientDate);
    }
    
    //get all sdq (cdi) f
    public Map<String, Date> getSdqFs(List<ClientInfo> FullClients){
        
        List<Date> sdqFdateList= new List<Date>();
        List<Id> cliIds = new List<Id>();
        Map<String, Date> sdq_cdi_FClientDate = new Map<String, Date>();
        Date mostRecent;
        
        for(ClientInfo o:FullClients){
            cliIds.add(o.clientID);
        }
                
        List<DS_SDQ_PSI_CDI_F__c>  sdqFList = [SELECT Client__c,SECTION__c ,FDOAPSI__c
                                            FROM DS_SDQ_PSI_CDI_F__c
                                            WHERE Client__c IN: cliIds 
                                            ];
                                            
        for(DS_SDQ_PSI_CDI_F__c s : sdqFList){
            String cliId = String.valueOf(s.Client__c);
            sdqFdateList.add(s.FDOAPSI__c);
            mostRecent= getMostRecent(sdqFdateList);
            sdq_cdi_FClientDate.put(cliId, mostRecent);
        }
        System.debug(sdq_cdi_FClientDate);
        System.debug(sdq_cdi_FClientDate.size());
        return(sdq_cdi_FClientDate);
    }
    
    //get all tscc/yc b
    public Map<String, Date>  getTsccBs(List<ClientInfo> FullClients){
        
        List<Date> tsccBdateList= new List<Date>();
        List<Id> cliIds = new List<Id>();
        Map<String, Date> tscBClientDate = new Map<String, Date>();
        Date mostRecent;
        
        for(ClientInfo o:FullClients){
            cliIds.add(o.clientID);
        }
        
        List<DS_TSCC_TSCYC_B__c>  tsccBList = [SELECT Client__c,BDOATSCC__c, BDOATSCYC__c
                                            FROM DS_TSCC_TSCYC_B__c    
                                            WHERE Client__c IN: cliIds      
                                            ];
                                            
        for(DS_TSCC_TSCYC_B__c t : tsccBList){
            String cliId = String.valueOf(t.Client__c);
            tsccBdateList.add(t.BDOATSCC__c);
            tsccBdateList.add(t.BDOATSCYC__c);
            mostRecent= getMostRecent(tsccBdateList);
            tscBClientDate.put(cliId, mostRecent);
        }           
        System.debug(tscBClientDate);
        System.debug(tscBClientDate.size());
        return(tscBClientDate);
    }
    
    //get all tscc/yc f
    public Map<String, Date> getTsccFs(List<ClientInfo> FullClients){
        
        List<Date> tsccFdateList= new List<Date>();
        List<Id> cliIds = new List<Id>();
        Map<String, Date> tscFClientDate = new Map<String, Date>();
        Date mostRecent;                
        
        for(ClientInfo o:FullClients){
            cliIds.add(o.clientID);
        }
        
        List<DS_TSCC_TSCYC_F__c>  tsccFList = [SELECT Client__c,FDOATSCC__c, FDOATSCYC__c
                                            FROM DS_TSCC_TSCYC_F__c   
                                            WHERE Client__c IN: cliIds       
                                            ];
                                            
        for(DS_TSCC_TSCYC_F__c t : tsccFList){
            String cliId = String.valueOf(t.Client__c);
                tsccFdateList.add(t.FDOATSCC__c);               
                tsccFdateList.add(t.FDOATSCYC__c);
                mostRecent= getMostRecent(tsccFdateList);
            tscFClientDate.put(cliId, mostRecent);
        }
        System.debug(tscFClientDate);
        System.debug(tscFClientDate.size());
        return(tscFClientDate);
    }   
    
    //get assessments list
    public List<ClientInfo> getAssessmentClients(List<ClientInfo> FullClients,
                                                Map<String, Date> cbclBClientDate, Map<String, Date> cbclFClientDate, 
                                                Map<String, Date> ptsdBClientDate, Map<String, Date> ptsdFClientDate,
                                                Map<String, Date> sdq_cdi_BClientDate, Map<String, Date> sdq_cdi_FClientDate,
                                                Map<String, Date> tscBClientDate, Map<String, Date> tscFClientDate
                                                ){
        List<ClientInfo> AssessmentClients = new List<ClientInfo>();
        
        for(ClientInfo c:FullClients){
            
            //if the bdov or fdov is within the range, add to the list
            if(((c.bdov >=StartDate)&&(c.bdov <= EndDate)) ||((c.fdov >=StartDate)&&(c.fdov <= EndDate))){
                AssessmentClients.add(c);
            }
            //not, check to see if any assessments
            else{
                if(
                    (cbclBClientDate.containsKey(c.clientId))||(cbclFClientDate.containsKey(c.clientId))||
                    (ptsdBClientDate.containsKey(c.clientId))||(ptsdFClientDate.containsKey(c.clientId))||
                    (sdq_cdi_BClientDate.containsKey(c.clientId))||(sdq_cdi_FClientDate.containsKey(c.clientId))||
                    (tscBClientDate.containsKey(c.clientId))||(tscFClientDate.containsKey(c.clientId))
                    ){
                    AssessmentClients.add(c);     
                }
            }
        }
        System.debug(AssessmentClients);
        System.debug(AssessmentClients.size());
        return AssessmentClients;
    }
                    
    //get map military
    public Map<String, Integer> getMilMap(List<ClientInfo> AssessmentClients){
        
        Map<String, Integer> milMap =  new Map<String, Integer>();   
        Integer countMilYes = 0;
        Integer countMilNo = 0;
        Integer countMilMissing = 0;
        
        for(ClientInfo m: AssessmentClients){
            if((m.milFamilyB == '1')||(m.milFamilyB == '2')||(m.milSelfB =='1')||(m.milStatusF == '1')){
                countMilYes = countMilYes+1;
            }
            else if((m.milFamilyB == null)&&(m.milSelfB == null)&&(m.milStatusF == null)){
                countMilMissing = countMilMissing+1;
            }
            else{
                countMilNo = countMilNo +1;
            }
        }
        milMap.put('Military Associated ', countMilYes);
        milMap.put('Not Military Associated ', countMilNo);
        milMap.put('Military Missing ', countMilMissing);
        System.debug(milMap);
        return milMap;
    }
    
    //get map age
    public Map<String, Integer> getAgeMap(List<ClientInfo> AssessmentClients){
        
        Map<String, Integer> ageMap =  new Map<String, Integer>();                                          
        Integer countAge0_4 = 0;
        Integer countAge5_9 = 0;
        Integer countAge10_12 = 0;
        Integer countAge13_17 = 0;
        Integer countAge18_21 = 0;
        Integer countAge_NA = 0;      
        
        for(ClientInfo a:AssessmentClients){
        
            if((a.currentAge >=0) &&(a.currentAge <=4)){
                countAge0_4 = countAge0_4+1;
            }
            else if((a.currentAge >=5) &&(a.currentAge <=9)){
                countAge5_9 = countAge5_9+1;
            }
            else if((a.currentAge >=10) &&(a.currentAge <=12)){
                countAge10_12 = countAge10_12+1;
            }
            else if((a.currentAge >=13) &&(a.currentAge <=17)){
                countAge13_17 = countAge13_17+1;
            }
            else if((a.currentAge >=18) &&(a.currentAge <=21)){
                countAge18_21 = countAge18_21+1;
            }
            else {
                countAge_NA = countAge_NA+1;
            }
        }
        ageMap.put('Aged 0-4',countAge0_4);
        ageMap.put('Aged 5-9',countAge5_9);
        ageMap.put('Aged 10-12',countAge10_12);
        ageMap.put('Aged 13-17',countAge13_17);
        ageMap.put('Aged 18-21',countAge18_21);
        ageMap.put('No Applicable Age Group',countAge_NA);
        System.debug(ageMap);
        return ageMap;
    }
    
    //get map gender
    public Map<String, Integer> getGenMap(List<ClientInfo> AssessmentClients){
        
        Map<String, Integer> genMap =  new Map<String, Integer>();   
        Integer countGenMale=0;
        Integer countGenFemale=0;
        Integer countGenTrans=0;
        Integer countGenOther=0;
        Integer countGenRef_Unk=0;
        Integer countGenMissing=0;   
        
        for(ClientInfo g:AssessmentClients){
            if(g.genderId == '1'){
                countGenMale = countGenMale +1;
            }
            else if(g.genderId == '2'){
                countGenFemale = countGenFemale +1;
            }
            else if((g.genderId == '3') || (g.genderId == '4')){
                countGenTrans = countGenTrans+1;
            }
            else if(g.genderId == '98'){
                countGenOther = countGenOther+1;
            }
            else if((g.genderId == '96') || (g.genderId == '99')){
                countGenRef_Unk=countGenRef_Unk+1;
            }
            else{
                countGenMissing = countGenMissing+1;
            }
        }
        genMap.put('Male',countGenMale);
        genMap.put('Female',countGenFemale );
        genMap.put('Transgender',countGenTrans);
        genMap.put('Other Gender Identity',countGenOther);
        genMap.put('Unknown/declined to provide Gender Identity',countGenRef_Unk);
        genMap.put('Gender Identity is Missing',countGenMissing);
        System.debug(genMap);
        return genMap;
    }
    
    //get map ethnicity
    public Map<String, Integer> getEthMap(List<ClientInfo> AssessmentClients){
        
        Map<String, Integer> ethMap =  new Map<String, Integer>();   
        Integer countEthHispanic=0;
        Integer countEthNonHispanic=0;
        Integer countEthRef_Unk=0;
        Integer countEthMissing = 0;
        
        for(ClientInfo e:AssessmentClients){
            if(e.ethnic == '1'){
                countEthHispanic = countEthHispanic+1;
            }
            else if(e.ethnic == '2'){
                countEthNonHispanic = countEthNonHispanic+1;
            }       
            else if((e.ethnic == '96') || (e.ethnic == '99')){
                countEthRef_Unk = countEthRef_Unk +1;
            }
            else{
                countEthMissing = countEthMissing+1;
            }
        }
        ethMap.put('Hispanic/Latino',countEthHispanic);
        ethMap.put('Not Hispanic/Latino',countEthNonHispanic);
        ethMap.put('Ethnicity Unknown or Not Reported',countEthRef_Unk);
        ethMap.put('Ethnicity is Missing',countEthMissing);
        return ethMap;
    }
    
    //get map race
    public Map<String, Integer> getRaceMap(List<ClientInfo> AssessmentClients){
        
        Map<String, Integer> raceMap =  new Map<String, Integer>();   
        Integer countRaceAm_Native = 0;
        Integer countRaceAsian = 0;
        Integer countRaceBlack = 0;
        Integer countRaceIsland = 0;
        Integer countRaceWhite = 0; 
        Integer countRaceRef_Unk = 0;
        Integer countRaceMulti = 0;
        
        
        for(ClientInfo r:AssessmentClients){
            
            //reset for every clirnt
            //Map<Id,List<String>> clientRaces = new Map<Id, List<String>>();
            Integer countRaces=0;   
            List<String> clientRaceList = new List<String>();
            
                //Native American/Alaskan
                if((r.raceNtvAmerican == 'true') ||(r.raceAlaskanNtv == 'true')){                    
                    countRaceAm_Native=countRaceAm_Native+1;
                    clientRaceList.add('Native');
                }
                
                //Asian
                if((r.raceIndian == 'true')|| (r.raceChinese == 'true')||
                    (r.raceFilipino == 'true')|| (r.raceJapanese == 'true')||
                    (r.raceKorean == 'true')|| (r.raceVietnamese == 'true')||
                    (r.raceOAsian == 'true')){
                        
                    countRaceAsian  = countRaceAsian +1;
                    clientRaceList.add('Asian');
                }
                
                //black
                if(r.raceBlack== 'true'){                
                    countRaceBlack=countRaceBlack+1;
                    clientRaceList.add('Black');
                }
                
                //Hawaiian/Pacific Islander
                if((r.raceHawaiian == 'true')|| (r.raceGuam == 'true')||
                    (r.raceSamoan == 'true')|| (r.raceOPIslander == 'true')
                    ){                        
                    countRaceIsland=countRaceIsland+1;
                    clientRaceList.add('Island');
                }
                
                //white
                if(r.raceWhite == 'true'){
                    
                    countRaceWhite=countRaceWhite+1;
                    clientRaceList.add('White');
                }
                
                //unknown/not reported
                if((r.raceRef == 'true')||(r.raceUnk == 'true')){
                    
                    countRaceRef_Unk=countRaceRef_Unk+1;
                    clientRaceList.add('Unknown');
                }
                
                //#races per client
                countRaces = Integer.valueOf(clientRaceList.size());
                
                if(countRaces  >1){
                
                    //one per client
                    countRaceMulti = countRaceMulti +1;
                    
                    //for each race
                    for (String c:clientRaceList){
                        
                        if(c =='Native'){
                            countRaceAm_Native = countRaceAm_Native-1;
                        }
                        else if(c =='Asian'){
                            countRaceAsian = countRaceAsian -1;
                        }
                        else if(c =='Black'){
                            countRaceBlack = countRaceBlack -1;
                        }
                        else if(c =='Island'){
                            countRaceIsland = countRaceIsland -1;
                        }
                        else if(c =='White'){
                            countRaceWhite =  countRaceWhite -1;
                        }
                        else if(c =='Unknown'){
                            countRaceRef_Unk =  countRaceRef_Unk-1;
                        }
                    }                    
                }
            }
        raceMap.put('American Indian/Native Alaskan',countRaceAm_Native );
        raceMap.put('Asian',countRaceAsian );
        raceMap.put('Black/African American',countRaceBlack );
        raceMap.put('Native Hawaiian/Other Pacific Islander',countRaceIsland );
        raceMap.put('White',countRaceWhite );
        raceMap.put('Race Unknown or Not Reported',countRaceRef_Unk );
        raceMap.put('Multiracial',countRaceMulti );
        System.debug(raceMap);
        return raceMap;           
    }
}