/****
*@description another cocap mockup
*
*@date    2/15/17
*@author    KW
*
*@modified  2/16/17 KW  list/class structure, age parsing
*@modified  2/17/17 KW  race, start services
*@modified  2/21-3/17 KW  date tweaking, start mil
*@modified  2/24/17 KW  removed approaches to date/assessment, refine mil b/f w/o dupe, genericize class
*
*@group cocap
*@group-content /ApexDocContent/Cocap6_Controller.htm
****/
public with sharing class Cocap6_Controller{

    //start and end dates
    public Date StartDate{get;set;}
    public Date EndDate{get;set;}
    public List<Date> dateRange{get;set;}
    
    //querries
    public List<Client__c> clients{get;set;}
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
            
    //init lists    
    public List<targetRec> genderRecords{get;set;}
    public List<targetRec> ageRecords{get;set;}
    public List<targetRec> ethnicRecords{get;set;}
    public List<targetRec> raceRecords{get;set;}
    public List<targetRec> milRecords{get;set;}
    public List<targetRec> newRecords{get;set;}
    //
    //
    public List<targetRec> completedRecords{get;set;}
    public List<targetRec> plannedRecords{get;set;}
        
    //generic class
    public class targetRec{
        public String recLabel{get;set;}
        public Integer recValue{get;set;}
        public targetRec(){
            this.recLabel = null;
        }
    }
    
    //initially loaded values
    public Cocap6_Controller(ApexPages.StandardController controller){
                
        System.debug(genderRecords);
        System.debug(ageRecords);
        System.debug(ethnicRecords);
        System.debug(raceRecords);
        System.debug(milRecords);
        System.debug(newRecords);//q#1
        //q#2
        //q#3
        System.debug(completedRecords);//q#4
        System.debug(plannedRecords);   //q#4a
    }
        
    //function run on click
    public void getData(){
    
        //initialize queries
        List<Client__c> clients = getClients();
        
        //date range
        List<Date> dateRange = getDateRange();
        System.debug(dateRange);
        
        //get all background records, regardless of date
        List<DS_Background_Family_Info_B__c> backgroundBs = getBackBs(clients);
        List<DS_Background_Family_Info_F__c> backgroundFs = getBackFs(clients);
        List<DS_CBCL_B__c> cbclBs = getCbclBs(clients);
        List<DS_CBCL_F__c> cbclFs = getCbclFs(clients);
        List<DS_PTSD_CA_B__c> ptsdBs = getPtsdBs(clients);
        List<DS_PTSD_CA_F__c> ptsdFs = getPtsdFs(clients);
        List<DS_SDQ_PSI_CDI_B__c> sdqBs = getSdqBs(clients);
        List<DS_SDQ_PSI_CDI_F__c> sdqFs = getSdqFs(clients);
        List<DS_TSCC_TSCYC_B__c> tsccBs = getTsccBs(clients);
        List<DS_TSCC_TSCYC_F__c> tsccFs = getTsccFs(clients);
        
        //maps
        Map<String, Integer> genderMap= getGender(backgroundBs);
        Map<String, Integer> ageMap= getAge(clients );
        Map<String, Integer> ethnicMap= getEthnic(backgroundBs);
        Map<String, Integer> raceMap= getRace(backgroundBs);
        Map<Id, String> bMil= getMilB(backgroundBs);
        Map<Id, String> fMil= getMilF(backgroundFs);
        Map<String, Integer> milMap= getMil(bMil,FMil);
        Map<String, Integer> newClientMap = getNewClients(backgroundBs);
        Map<String, Integer> completedMap = getCompleted(backgroundFs);
                
        //lists of records
        genderRecords = new List<targetRec>();
        ageRecords = new List<targetRec>();
        ethnicRecords = new List<targetRec>();
        raceRecords = new List<targetRec>();
        milRecords = new List<targetRec>();
        newRecords = new List<targetRec>();
        completedRecords = new List<targetRec>();
        plannedRecords = new List<targetRec>();
        
        System.debug(genderMap);
        System.debug(ageMap);
        System.debug(ethnicMap);
        System.debug(raceMap);
        System.debug(bMil);
        System.debug(fMil);
        System.debug(milMap);
        System.debug(newClientMap);
        System.debug(completedMap);
        
        //gender
        for(String g:genderMap.keySet()){
            targetRec  gr = new targetRec();
           // GenderRec  gr = new GenderRec();
            gr.recLabel= g;
            gr.recValue= genderMap.get(g);
            System.debug(gr);
            genderRecords.add(gr);
        }
        
        //age
        for(String a:ageMap.keySet()){
            targetRec ar = new targetRec();
            ar.recLabel = a;
            ar.recValue = ageMap.get(a);
            System.debug(ar);
            ageRecords.add(ar);
        }
        
        //ethnicity
        for(String e:ethnicMap.keySet()){
            targetRec er = new targetRec();
            er.recLabel= e;
            er.recValue = ethnicMap.get(e);
            System.debug(er);
            ethnicRecords.add(er);
        }
        
        //race
        for(String r:raceMap.keySet()){
            targetRec rr = new targetRec();
            rr.recLabel= r;
            rr.recValue = raceMap.get(r);
            System.debug(rr);
            raceRecords.add(rr);
        }
        
        //military
        for(String m:milMap.keySet()){
            targetRec mr = new targetRec();
            mr.recLabel = m;
            mr.recValue = milMap.get(m);
            System.debug(mr);
            milRecords.add(mr);
        }
        
        //new client
        for(String c:newClientMap.keySet()){
            targetRec nc = new targetRec();
            nc.recLabel = c;
            nc.recValue = newClientMap.get(c);
            System.debug(nc);
            newRecords.add(nc);
        }
        
        //completed treatment
        for(String t:completedMap.keySet()){
            //treatment completed
            targetRec ct = new targetRec();
            //as planned
            targetRec ap = new targetRec();
            if(t == 'Clients with completed treatment'){
                ct.recLabel = t;
                ct.recValue = completedMap.get(t);
            }
            else if(t == 'Treatment completed as planned'){
                ap.recLabel = t;
                ap.recValue = completedMap.get(t);
            }
            System.debug(ct);
            System.debug(ap);
            completedRecords.add(ct);
            plannedRecords.add(ap);
        }
        System.debug(genderRecords);
        System.debug(genderMap);
        System.debug(ageRecords);
        System.debug(ageMap);    
        System.debug(ethnicRecords);
        System.debug(ethnicMap);    
        System.debug(raceRecords);
        System.debug(raceMap); 
        System.debug(milRecords);
        System.debug(bMil); 
        System.debug(fMil); 
        System.debug(milMap); 
        System.debug(newRecords);
        System.debug(newClientMap);
        System.debug(completedRecords);
        System.debug(plannedRecords);
        System.debug(completedMap);
    }
    
    //date range
    public List<Date> getDateRange(){
        System.debug(StartDate);
        System.debug(EndDate);
        List<Date> dateRange = new List<Date>();
        dateRange.add(StartDate);
        dateRange.add(EndDate);
        return dateRange;
    }
    
    //objects
    //client query
    public List<Client__c> getClients(){
        List<Client__c> clients = [SELECT id, Clinician__c, Center__c, Age__c, CURRENT_AGE__c, INIT__c
                                    FROM Client__c];
        System.debug(clients);
        return clients;
    }
    
    //get all background b records with client
    public List<DS_Background_Family_Info_B__c> getBackBs(List<Client__c> clients){
        
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
                                                            ];
        System.debug(backgroundBs);
        System.debug(backgroundBs.size());
        return(backgroundBs);
    }
    
    //get all background f
    public List<DS_Background_Family_Info_F__c> getBackFs(List<Client__c> clients){
        
        List<DS_Background_Family_Info_F__c>  backgroundFs = [SELECT Client__c, SECTION__c, FDOV__c, FUTYPE__c, FETSTAT__c, FMSTAT__c
                                                            FROM DS_Background_Family_Info_F__c
                                                            ];
        System.debug(backgroundFs);
        System.debug(backgroundFs.size());
        return(backgroundFs);
    }
    
    //get all cbcl b
    public List<DS_CBCL_B__c> getCbclBs(List<Client__c> clients){
        
        List<DS_CBCL_B__c>  cbclBs = [SELECT Client__c,BDOACO__c, BDOACY__c
                                    FROM DS_CBCL_B__c
                                    ];
        System.debug(cbclBs);
        System.debug(cbclBs.size());
        return(cbclBs);
    }
    
    //get all cbcl f
    public List<DS_CBCL_F__c> getCbclFs(List<Client__c> clients){
        
        List<DS_CBCL_F__c>  cbclFs = [SELECT Client__c, SECTION__c, FDOACO__c, FDOACY__c
                                    FROM DS_CBCL_F__c
                                    ];
        System.debug(cbclFs);
        System.debug(cbclFs.size());
        return(cbclFs);
    }
    
    //get all ptsd b
    public List<DS_PTSD_CA_B__c> getPtsdBs(List<Client__c> clients){
        
        List<DS_PTSD_CA_B__c>  ptsdBs = [SELECT Client__c,BDOAPTSD__c
                                        FROM DS_PTSD_CA_B__c
                                        ];
        System.debug(ptsdBs);
        System.debug(ptsdBs.size());
        return(ptsdBs);
    }
    
    //get all ptsd f
    public List<DS_PTSD_CA_F__c> getPtsdFs(List<Client__c> clients){
        
        List<DS_PTSD_CA_F__c>  ptsdFs = [SELECT Client__c, SECTION__c, FDOAPTSD__c
                                        FROM DS_PTSD_CA_F__c
                                        ];
        System.debug(ptsdFs);
        System.debug(ptsdFs.size());
        return(ptsdFs);
    }
    
    //get all sdq (cdi) b
    public List<DS_SDQ_PSI_CDI_B__c> getSdqBs(List<Client__c> clients){
        
        List<DS_SDQ_PSI_CDI_B__c>  sdqBs = [SELECT  Client__c,BDOAPSI__c
                                            FROM DS_SDQ_PSI_CDI_B__c
                                            ];
        System.debug(sdqBs);
        System.debug(sdqBs.size());
        return(sdqBs);
    }
    
    //get all sdq (cdi) f
    public List<DS_SDQ_PSI_CDI_F__c> getSdqFs(List<Client__c> clients){
        
        List<DS_SDQ_PSI_CDI_F__c>  sdqFs = [SELECT Client__c,SECTION__c ,FDOAPSI__c
                                            FROM DS_SDQ_PSI_CDI_F__c
                                            ];
        System.debug(sdqFs);
        System.debug(sdqFs.size());
        return(sdqFs);
    }
    
    //get all tscc/yc b
    public List<DS_TSCC_TSCYC_B__c> getTsccBs(List<Client__c> clients){
        
        List<DS_TSCC_TSCYC_B__c>  tsccBs = [SELECT Client__c,BDOATSCC__c, BDOATSCYC__c
                                            FROM DS_TSCC_TSCYC_B__c         
                                            ];
        System.debug(tsccBs);
        System.debug(tsccBs.size());
        return(tsccBs);
    }
    
    //get all tscc/yc f
    public List<DS_TSCC_TSCYC_F__c> getTsccFs(List<Client__c> clients){
        
        List<DS_TSCC_TSCYC_F__c>  tsccFs = [SELECT Client__c,FDOATSCC__c, FDOATSCYC__c
                                            FROM DS_TSCC_TSCYC_F__c         
                                            ];
        System.debug(tsccFs);
        System.debug(tsccFs.size());
        return(tsccFs);
    }   
    
    //demographics
    //populate gender map
    public Map<String, Integer> getGender(List<DS_Background_Family_Info_B__c> backgroundBs ){
        
        //initialize counts to 0
        Integer countGenMale=0;
        Integer countGenFemale=0;
        Integer countGenTrans=0;
        Integer countGenOther=0;
        Integer countGenRef_Unk=0;
        Integer countGenMissing=0;   
        
        Map<String, Integer> genderCounts = new Map<String, Integer>();
        
        for(DS_Background_Family_Info_B__c b: backgroundBs ){
            //if((b.BDOV__c >= StartDate) && (b.BDOV__c <= EndDate)){  
            
                //genderParsing
                Integer genId = Integer.valueOf(b.get('BIDENT__c'));
                
                if(genId == 1){
                    countGenMale = countGenMale +1;
                }
                else if(genId == 2){
                    countGenFemale = countGenFemale +1;
                }
                else if((genId == 3) || (genId == 4)){
                    countGenTrans = countGenTrans+1;
                }
                else if(genId == 98){
                    countGenOther = countGenOther+1;
                }
                else if((genId == 96) || (genId == 99)){
                    countGenRef_Unk=countGenRef_Unk+1;
                }
                else{
                    countGenMissing = countGenMissing+1;
                }
                //end gender
                
           // }
        }
        genderCounts.put('Male',countGenMale);
        genderCounts.put('Female',countGenFemale );
        genderCounts.put('Transgender',countGenTrans);
        genderCounts.put('Other',countGenOther);
        genderCounts.put('Unknown or declined to provide',countGenRef_Unk);
        genderCounts.put('Gender Identity is Missing',countGenMissing);
        System.debug(genderCounts);
        return genderCounts;
    }
    
    //populate age map
    public Map<String, Integer> getage(List<Client__c>clients  ){
                                
        Integer countAge0_4 = 0;
        Integer countAge5_9 = 0;
        Integer countAge10_12 = 0;
        Integer countAge13_17 = 0;
        Integer countAge18_21 = 0;
        Integer countAge_NA = 0;
        
        Integer cAge;
        
        Map<String, Integer> ageCounts = new Map<String, Integer>();
        
        for(Client__c c: clients){
            cAge = Integer.valueOf(c.get('CURRENT_AGE__c'));
    
                if((cAge >=0) &&(cAge <=4)){
                    countAge0_4 = countAge0_4+1;
                }
                else if((cAge >=5) &&(cAge <=9)){
                    countAge5_9 = countAge5_9+1;
                }
                else if((cAge >=10) &&(cAge <=12)){
                    countAge10_12 = countAge10_12+1;
                }
                else if((cAge >=13) &&(cAge <=17)){
                    countAge13_17 = countAge13_17+1;
                }
                else if((cAge >=18) &&(cAge <=21)){
                    countAge18_21 = countAge18_21+1;
                }
                else {
                    countAge_NA = countAge_NA+1;
                }
                //end age
        }
        ageCounts.put('AgeGroup_0_4',countAge0_4);
        ageCounts.put('AgeGroup_5_9',countAge5_9);
        ageCounts.put('AgeGroup_10_12',countAge10_12);
        ageCounts.put('AgeGroup_13_17',countAge13_17);
        ageCounts.put('AgeGroup_18_21',countAge18_21);
        ageCounts.put('Not Applicable',countAge_NA);
        return ageCounts;
    }
    
    //populate ethnicity map
    public Map<String, Integer> getEthnic(List<DS_Background_Family_Info_B__c> backgroundBs ){
        
        //initialize counts to 0
        Integer countEthHispanic=0;
        Integer countEthNonHispanic=0;
        Integer countEthRef_Unk=0;
        Integer countEthMissing = 0;
        
        Map<String, Integer> ethnicCounts = new Map<String, Integer>();
        
        for(DS_Background_Family_Info_B__c b: backgroundBs ){
            if((b.BDOV__c >= StartDate) && (b.BDOV__c <= EndDate)){  
            
                //ethnic Parsing
                Integer ethVal = Integer.valueOf(b.get('ETHNIC__c'));
                
                if(ethVal == 1){
                    countEthHispanic = countEthHispanic+1;
                }
                else if(ethVal == 2){
                    countEthNonHispanic = countEthNonHispanic+1;
                }       
                else if((ethVal == 96) || (ethVal == 99)){
                    countEthRef_Unk = countEthRef_Unk +1;
                }
                else{
                    countEthMissing = countEthMissing+1;
                }
                //end ethnic            
            }
        }
        ethnicCounts.put('Hispanic/Latino',countEthHispanic);
        ethnicCounts.put('Not Hispanic/Latino',countEthNonHispanic);
        ethnicCounts.put('Ethnicity Unknown or Not Reported',countEthRef_Unk);
        ethnicCounts.put('Ethnicity is Missing',countEthMissing);
        return ethnicCounts;
    }

    //populate race map
    public Map<String, Integer> getRace(List<DS_Background_Family_Info_B__c> backgroundBs ){
        
        //initialize counts to 0
        Integer countRaceAm_Native = 0;
        Integer countRaceAsian = 0;
        Integer countRaceBlack = 0;
        Integer countRaceIsland = 0;
        Integer countRaceWhite = 0; 
        Integer countRaceRef_Unk = 0;
        Integer countRaceMulti = 0;
        
        Integer countRaces=0;      
                
        Map<String, Integer> raceCounts = new Map<String, Integer>();       
        List<String> clientRaceList;
        
        for(DS_Background_Family_Info_B__c b: backgroundBs ){
                
            if((b.BDOV__c >= StartDate) && (b.BDOV__c <= EndDate)){  
            
                clientRaceList = new List<String>();  
            
                //Native American/Alaskan
                if( (b.get('RINDIAN__c') ==TRUE) || (b.get('RAKNTV__c') == TRUE)){
                    
                    countRaceAm_Native=countRaceAm_Native+1;
                    clientRaceList.add('Native');
                }
                
                //Asian
                if( (b.get('RASIANIN__c') ==TRUE) 
                    || (b.get('RCHINESE__c') == TRUE) 
                    || (b.get('RFILIPINO__c') == TRUE) 
                    || (b.get('RJAPANESE__c') == TRUE) 
                    || (b.get('RKOREAN__c') == TRUE) 
                    || (b.get('RVIETNAMESE__c') == TRUE) 
                    || (b.get('ROASIAN__c') == TRUE)){
                        
                    countRaceAsian  = countRaceAsian +1;
                    clientRaceList.add('Asian');
                }
                
                //black
                if( b.get('RBLACK__c') ==TRUE){
                
                    countRaceBlack=countRaceBlack+1;
                    clientRaceList.add('Black');
                }
                
                //Hawaiian/Pacific Islander
                if( (b.get('RHAWAN__c') ==TRUE) 
                    || (b.get('RGUAM__c') == TRUE) 
                    || (b.get('RSAMOA__c') == TRUE) 
                    || (b.get('ROPI__c') == TRUE)){
                        
                    countRaceIsland=countRaceIsland+1;
                    clientRaceList.add('Island');
                }
                
                //white
                if( b.get('RWHITE__c') ==TRUE){
                    
                    countRaceWhite=countRaceWhite+1;
                    clientRaceList.add('White');
                }
                
                //unknown/not reported
                if( (b.get('RREF__c') ==TRUE) || (b.get('RUNK__c') == TRUE)){
                    
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
                        //if contains x, pop countX
                    }
                    
                }
            }
        }   
                
        raceCounts.put('American Indian/Native Alaskan',countRaceAm_Native );
        raceCounts.put('Asian',countRaceAsian );
        raceCounts.put('Black/African American',countRaceBlack );
        raceCounts.put('Native Hawaiian/Other Pacific Islander',countRaceIsland );
        raceCounts.put('White',countRaceWhite );
        raceCounts.put('Unknown or Not Reported',countRaceRef_Unk );
        raceCounts.put('Multiracial',countRaceMulti );
        return raceCounts;
    }    

    //populate baseline military map
    public Map<Id, String> getMilB(List<DS_Background_Family_Info_B__c> backgroundBs){
                
        Map<Id, String> bMil = new Map<Id, String>();   
        
        for(DS_Background_Family_Info_B__c b: backgroundBs ){
            Id client = b.Client__c;
            Integer milFam = Integer.valueOf(b.get('BMILFAMILY__c'));
            Integer milSelf = Integer.valueOf(b.get('BMILSELF__c'));
            String bCliIndicator;
            
            System.debug(b.get('BMILFAMILY__c'));
            System.debug(b.get('BMILSELF__c'));
            System.debug(milFam );
            System.debug(milSelf );
            
            if( (milFam ==1)||
                (milFam ==2)||
                (milSelf ==1)){
                    bCliIndicator ='Yes';
            }
            else if( (milFam ==null)&&
                    (milSelf )==null){
                    bCliIndicator ='Missing';
            }
            else{
                    bCliIndicator ='No';
            }
            System.debug(bCliIndicator);
            bMil.put(client,  bCliIndicator); 
        }   
        System.debug(bMil);        
        return bMil;
    }    
 
    //populate followup military map
    public Map<Id, String> getMilF(List<DS_Background_Family_Info_F__c> backgroundFs){
        
        Map<Id, String> fMil = new Map<Id, String>(); 
        
        for(DS_Background_Family_Info_F__c f: backgroundFs ){
            Id client = f.Client__c;
            Integer milStat = Integer.valueOf(f.get('FMSTAT__c'));
            String fCliIndicator;
            
            System.debug(f.get('FMSTAT__c'));
            System.debug(milStat); 
            
            if(milStat==1){
                    fCliIndicator ='Yes';
            }
            else if(milStat==null){
                    fCliIndicator ='Missing';
            }
            else{
                    fCliIndicator ='No';
            }            
            System.debug(fCliIndicator);
            fMil.put(client,  fCliIndicator); 
        }
        System.debug(fMil);
        return fMil;
    }
 
    //populate overall military map
    public Map<String,Integer>getMil(Map<Id, String> bMil, Map<Id, String> fMil){    
        
        //initialize counts to 0
        String bString;
        String fString;
        Integer countMilYes=0;
        Integer countMilNo=0;
        Integer countMilMissing=0;
        
        Map<String, Integer> milMap=new Map<String, Integer>();
        
        System.debug(bMil);
        System.debug(fMil); 
        
        for(Id b: bMil.keySet()){
            System.debug(b);//client
            System.debug(bMil.get(b));
            System.debug(fMil.get(b));
            
            bString = bMil.get(b);
            fString = fMil.get(b);
            
            
            System.debug('Client '+b+' '+ bMil.get(b) + ' baseline and ' + (fMil.get(b)) + 'followup');
            
            if(fMil.containsKey(b)){  
                    System.debug(b + ' = ' + bMil.get(b));
            }
        }        
                   
        Integer bMilVal = 0;
        Integer fMilVal = 0;
        
        //loop through baseline; there shouldn't be a followup w/o a baseline
     /*   for(Id f:fMil.keySet()){
            
            Integer CliIndicator;
            
            System.debug(f);
            if(bMil.containsKey(f)){   
                System.debug(f);
                
                Integer bVal = Integer.ValueOf(fMil.get(f));
                Integer fVal = Integer.ValueOf(fMil.get(f));
                
                System.debug(bMil.get(f));
                System.debug(fMil.get(f));
                if((bVal  == 1) || (fVal  == 1)){
                    System.debug(f + ' = ' + bMil.get(f));
                    System.debug(f + ' = ' + fMil.get(f));
                } 
            }
            System.debug(bMil.get(f));
            System.debug(fMil.get(f));
            
            System.debug(bMilVal);
            System.debug(fMilVal);
        }*/
        
        //loop through baseline; there shouldn't be a followup w/o a baseline
    /*    for(Id b:fMil.keySet()){
    
            bMilVal = Integer.valueOf(bMil.get(b));
            fMilVal = Integer.valueOf(fMil.get(b));
            
            //if the client is the same, look at both values to determine overall
            if(fMil.containsKey(b)){                          
                
                //if yes is indicated on any visit
                if(bMilVal==1 || fMilVal ==1){
                    countMilYes = countMilYes +1;
                    System.debug(bMilVal+' baseline, '+fMilVal+' followup');
                }
                else if(bMilVal !=1 && fMilVal !=1){
                    System.debug(bMilVal+' baseline, '+fMilVal+' followup');
                    
                    //both values are missing
                    if(bMilVal ==99 && fMilVal == 99){
                        countMilMissing = countMilMissing +1;
                    }
                    //if one is missing/both are no?
                    else{
                        countMilNo = countMilNo +1;
                    }
                }
            System.debug(countMilYes); 
            System.debug(countMilNo); 
            System.debug(countMilMissing); 
            }
            
            //the clients with only baseline
            else{
                System.debug(bMilVal+' baseline, '+fMilVal+' followup');
                if(bMilVal == 1){
                    countMilYes = countMilYes +1;
                }
                else if(bMilVal ==0){
                    countMilNo = countMilNo +1;
                }
                else if(bMilVal ==99){
                    countMilMissing = countMilMissing +1;
                }
            }
            System.debug(countMilYes); 
            System.debug(countMilNo); 
            System.debug(countMilMissing); */
            
            milMap.put('Military Associated', countMilYes);
            milMap.put('Not Military Associated', countMilNo);
            milMap.put('Military Missing', countMilMissing);
   //     }
        System.debug(milMap);
        return milMap;
    }
    
    //service questions
    //populate new clients
    public Map<String, Integer>  getNewClients(List<DS_Background_Family_Info_B__c> backgroundBs){
        
        Map<String, Integer> newClientMap =  new Map<String, Integer>();   
        Integer newClientCount = 0;
        
        for(DS_Background_Family_Info_B__c b :backgroundBs){
            if((b.BDOV__c >= StartDate) && (b.BDOV__c <= EndDate)){  
                newClientCount = newClientCount+1;
            }
        }
        newClientMap.put('New Clients',newClientCount);
        
        return newClientMap;
    }
    
    //populate completed treatments
    public Map<String, Integer>  getCompleted(List<DS_Background_Family_Info_F__c> backgroundFs){
        
        Map<String, Integer> completedMap =  new Map<String, Integer>();   
      //  Map<String, Integer> asPlannedMap =  new Map<String, Integer>();   
        Integer completedCount = 0;
        Integer plannedCount = 0;
        
        for(DS_Background_Family_Info_F__c f :backgroundFs){
            if((f.FDOV__c >= StartDate) && (f.FDOV__c <= EndDate) && (f.FUTYPE__c =='2')){                
                completedCount = completedCount+1;
                if(f.FETSTAT__c == '1'){
                    plannedCount = plannedCount +1;
                }
            }
        }
        completedMap.put('Clients with completed treatment',completedCount);
        completedMap.put('Treatment completed as planned',plannedCount);
        
        return completedMap;
    }
}