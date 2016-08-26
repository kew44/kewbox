public with sharing class Custom_Report_Controller {

    //object record
    public Custom_Reporting__c cocap {get;set;}

    //client record info
    public Client__c client { get; set; }
    public Id cId{get;set;}
    public List<Client__c> clients {get;set;}
    
    //background object records
    public SObject backB {get;set;}
    public SObject backF {get;set;}
    
    //cbcl object records
    public SObject cbclB{ get; set; }
    public SObject cbclF{ get; set; }   
    
    //ptsd object records
    public SObject ptsdB{ get; set; }
    public SObject ptsdF{ get; set; }
    
    //sdq/psi object records
    public SObject sdqB{ get; set; }
    public SObject sdqF{ get; set; }
    
    //tscc object records
    public SObject tsccB{ get; set; }
    public SObject tsccF{ get; set; }
        
    //overall date list
    public List<Date> dateList{get;set;}
    
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
    
    //most recent and earliest dates
    public Date mostRecent{get;set;}
    public Date dateEarliest{get;set;}
    
    //age
    public Map<String, Integer> AgeMap{get;set;}
    public Integer cAge {get;set;}
    public String AgeGroup {get;set;}
    public Boolean age0_4{get;set;}
    public Boolean age5_9{get;set;}
    public Boolean age10_12{get;set;}
    public Boolean age13_17{get;set;}
    public Boolean age18_21{get;set;}
    
    //race
    public String  raceGroup{get;set;}
    public Boolean raceBlack {get;set;}
    public Boolean raceWhite {get;set;}
    public Boolean raceAINAK {get;set;}
    public Boolean raceAsian {get;set;}
    public Boolean raceHIOPI {get;set;}
    public Boolean raceUnkNR {get;set;}
    public Boolean raceMulti {get;set;}
    
    //ethnicity
    public String ethnicGroup{get;set;}
    public Boolean ethnicHispanic{get;set;}
    public Boolean ethnicNonHispanic{get;set;}
    public Boolean ethnicUnknown{get;set;}
    
    //gender
    public String genIdentity{get;set;}
    public Boolean genMale{get;set;}
    public Boolean genFemale{get;set;}
    public Boolean genTrans{get;set;}
    public Boolean genOther{get;set;}
    public Boolean genUnknown{get;set;}
    
    //military
    public Boolean milAssociated{get;set;}
    
    //treatment
    public Boolean treatCompleted{get;set;}
    public Boolean treatAsPlanned{get;set;}
    
    public void getRaw(Client__c client){
    
        //get list of clients
    /*    clients = [SELECT id, Clinician__c, Center__c, Age__c, CURRENT_AGE__c, INIT__c
                                    FROM Client__c];
            
        //get list of client ids only
     /*   List<String> cids = new List<String>(); 
        String cid;
    
        for (Client__c c : clients){
            cid = String.valueOf(c.get('id'));
            cids.add(cid);
            cAge = Integer.valueOf(c.CURRENT_AGE__c);
            System.debug(cid);
            System.debug(c.id);
//            System.debug(c.get(0));
            System.debug(c.get('id'));
        }    */
        cid = String.valueOf(client.id);
        
        List<SObject> backBs = [SELECT Client__c,
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
                                WHERE Client__c =: cid];
        
        List<SObject> backFs = [SELECT FDOV__c, FUTYPE__c, FETSTAT__c, FMSTAT__c
                                FROM DS_Background_Family_Info_F__c
                                WHERE client__c =: cid
                               ORDER BY SECTION__c DESC];
        
        List<SObject> cbclBs = [SELECT BDOACO__c, BDOACY__c
                                FROM DS_CBCL_B__c
                                WHERE client__c =: cid];
        
        List<SObject> cbclFs = [SELECT FDOACO__c, FDOACY__c
                                FROM DS_CBCL_F__c
                                WHERE client__c =: cid
                               ORDER BY SECTION__c DESC];
        
        List<SObject> ptsdBs = [SELECT BDOAPTSD__c
                                FROM DS_PTSD_CA_B__c
                                WHERE client__c =: cid];
        
        List<SObject> ptsdFs = [SELECT FDOAPTSD__c
                                FROM DS_PTSD_CA_F__c
                                WHERE client__c =: cid
                               ORDER BY SECTION__c DESC];
        
        //using sdq for object name even though psi values are querried now
        List<SObject> sdqBs = [SELECT BDOAPSI__c
                               FROM DS_SDQ_PSI_CDI_B__c
                               WHERE client__c  =: cid];
        
        List<SObject> sdqFs = [SELECT FDOAPSI__c
                               FROM DS_SDQ_PSI_CDI_F__c
                               WHERE client__c  =: cid
                               ORDER BY SECTION__c DESC];
        
        List<Sobject> tsccBs = [SELECT BDOATSCC__c, BDOATSCYC__c
                                FROM DS_TSCC_TSCYC_B__c         
                                WHERE Client__c   =: cid];
        
        List<Sobject> tsccFs = [SELECT FDOATSCC__c, FDOATSCYC__c
                                FROM DS_TSCC_TSCYC_F__c         
                                WHERE Client__c  =: cid
                               ORDER BY SECTION__c DESC];
                               
                               
         
        
        //if not null, get baseline values        
            //for followups, order by section descending, then get 0. this presumes that sections are in date order
        
        if (backBs.size()>0){
            backB = backBs.get(0);
            bbDate = date.valueOf(backB.get('BDOV__c'));
        }
        if (backFs.size()>0){
            backF = backFs.get(0);
            bfDate = date.valueOf(backF.get('FDOV__c'));
        }
        if (cbclBs.size()>0){
            cbclB = cbclBs.get(0);
            cObDate = date.valueOf(cbclB.get('BDOACO__c'));
            cYbDate = date.valueOf(cbclB.get('BDOACY__c'));
        }
        if (cbclFs.size()>0){
            cbclF = cbclFs.get(0);
            cOfDate = date.valueOf(cbclF.get('FDOACO__c'));
            cYfDate = date.valueOf(cbclF.get('FDOACY__c'));
        }
        if (ptsdBs.size()>0){
            ptsdB = ptsdBs.get(0);
            pbDate = date.valueOf(ptsdB.get('BDOAPTSD__c'));
        }
        if (ptsdFs.size()>0){
            ptsdF = ptsdFs.get(0);
            pfDate = date.valueOf(ptsdF.get('FDOAPTSD__c'));
        }
        if (sdqBs.size()>0){
            sdqB = sdqBs.get(0);
            sbDate = date.valueOf(sdqB.get('BDOAPSI__c'));
        }
        if (sdqFs.size()>0){
            sdqF = sdqFs.get(0);
            sfDate = date.valueOf(sdqF.get('FDOAPSI__c'));
        }
        if (tsccBs.size()>0){
            tsccB = tsccBs.get(0);
            tAbDate = date.valueOf(tsccB.get('BDOATSCC__c'));
            tObDate = date.valueOf(tsccB.get('BDOATSCYC__c'));
        }
        if (tsccFs.size()>0){
            tsccF = tsccFs.get(0);
            tAfDate = date.valueOf(tsccF.get('FDOATSCC__c'));
            tOfDate = date.valueOf(tsccF.get('FDOATSCYC__c'));
        }
                
    }
    public void findDate(){ 
    
        //list all date variables
        List<Date> dateList = new List<Date>();                           
            dateList.add(bbDate);
            dateList.add(bfDate);
            dateList.add(cObDate);
            dateList.add(cOfDate);
            dateList.add(cYbDate);
            dateList.add(cYfDate);
            dateList.add(pbDate);
            dateList.add(pfDate);
            dateList.add(sbDate);
            dateList.add(sfDate);
            dateList.add(tAbDate);
            dateList.add(tObDate);
            dateList.add(tAfDate);
            dateList.add(tOfDate);
        
        //highest date temp var
        Date maxDate;
        
        //map to index alias
        Map<Integer, Date> dateOrder = new Map<Integer, Date>();            
        Integer indexI =0;
        
        //sorts ascending
        dateList.sort();
        
        //gets the last (highest) date value in list
        maxDate = dateList.get(dateList.size()-1);
        
        for(Date d : dateList){
        
            //nonnull dates only
            if(d != null){
                
                //adds order number and date value to map
                dateOrder.put(indexI, d);
                
                //simple increment
                indexI = indexI +1;
            }
        }
        
        //earlist date (nulls excluded)
        dateEarliest = dateOrder.get(0);
        //we can redefing length of care parameters
        
        //if there is only one date, maxdate is earliest
        if(maxDate == null){
            maxDate = dateEarliest;
        }
        
        //out: earliset and most recent dates, quarter # most recent
    }           
    public void findRace(){//String cid){
        //map race categories to the variable names
        Map<String, String> raceMap= new Map<String, String>();
            //race variable, race group
            raceMap.put('RINDIAN__c', 'American Indian/Native Alaskan' );
            raceMap.put('RAKNTV__c', 'American Indian/Native Alaskan');
            raceMap.put('RASIANIN__c', 'Asian' );
            raceMap.put('RCHINESE__c', 'Asian');
            raceMap.put('RFILIPINO__c', 'Asian' );
            raceMap.put('RJAPANESE__c', 'Asian');
            raceMap.put('RKOREAN__c', 'Asian' );
            raceMap.put('RVIETNAMESE__c', 'Asian');
            raceMap.put('ROASIAN__c', 'Asian' );
            raceMap.put('RBLACK__c', 'Black/African American');
            raceMap.put('RHAWAN__c', 'Native Hawaiian/Other Pacific Islander' );
            raceMap.put('RGUAM__c', 'Native Hawaiian/Other Pacific Islander' );
            raceMap.put('RSAMOA__c', 'Native Hawaiian/Other Pacific Islander' );
            raceMap.put('ROPI__c', 'Native Hawaiian/Other Pacific Islander' );
            raceMap.put('RWHITE__c', 'White' );
            raceMap.put('RREF__c', 'Unknown or Not Reported' );
            raceMap.put('RUNK__c', 'Unknown or Not Reported' );

        //list of races for an individual client
        List<String> raceList = new List<String>();
        
        //count nubmer of races indicated
        Integer raceCount = 0;
        
        //set races to false
        raceBlack = FALSE;
        raceWhite = FALSE; 
        raceAINAK  = FALSE;
        raceAsian  = FALSE;
        raceHIOPI  = FALSE;
        raceUnkNR  = FALSE;
        raceMulti  = FALSE;
        
        System.debug(backB);
        String valString;
        
        //loop through the race variables
        for (String r: raceMap.keySet()){
            
            //variable value
            valString = String.valueOf(backB.get(r));
            System.debug(valString);
            
            //race category
            raceGroup= String.valueOf(raceMap.get(r));
            System.debug(raceGroup);

            //any race field that's true
            if(valString == 'true'){
                raceList.add(raceGroup);
            }
            
            //more than one race indicated for client
            if(raceList.size() >1){
              //  raceGroup = 'Multiracial';
                raceMulti  = TRUE; 
            }
            else if(raceList.size() == 1){
                if(raceGroup== 'Unknown or Not Reported'){
                    raceUnkNR = TRUE; 
                }
                else if(raceGroup=='White'){
                    raceWhite = TRUE; 
                }
                else if(raceGroup=='Native Hawaiian/Other Pacific Islander'){
                    raceHIOPI = TRUE; 
                }
                else if(raceGroup=='Black/African American'){
                    raceBlack = TRUE; 
                }
                else if(raceGroup=='Asian'){
                    raceAsian = TRUE; 
                }
                else if(raceGroup=='American Indian/Native Alaskan'){
                    raceAINAK = TRUE; 
                }
               System.debug(raceGroup); 
            }
           System.debug(raceGroup); 
        }
       System.debug(raceGroup);     
    }
    public void findGender(){
    
        genMale = FALSE;
        genFemale = FALSE;
        genTrans = FALSE;
        genOther = FALSE;
        genUnknown = FALSE;
    
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
        
    }
    public void findAge(){
        //in:Integer cAge, AgeMap,AgeGroup
        
        age0_4 = FALSE;
        age5_9 = FALSE;
        age10_12 = FALSE;
        age13_17 = FALSE;
        age18_21 = FALSE;
        
        if((cAge >=0) &&(cAge<=4)){
            AgeGroup = 'AgeGroup_0_4';
            age0_4 = TRUE;
        }
        else if((cAge >=5) &&(cAge<=9)){
            AgeGroup = 'AgeGroup_5_9';
            age5_9 = TRUE;
        }
        else if((cAge >=10) &&(cAge<=12)){
            AgeGroup = 'AgeGroup_10_12';
            age10_12 = TRUE;
        }
        else if((cAge >=13) &&(cAge<=17)){
            AgeGroup = 'AgeGroup_13_17';
            age13_17 = TRUE;
        }
        else if((cAge >=18) &&(cAge<=21)){
            AgeGroup = 'AgeGroup_18_21';
            age18_21 = TRUE;
        }
        else {
            AgeGroup = 'Not Applicable';
        }
        
      //  AgeMap.put(AgeGroup, cAge);
        //out:age group String, integer
    }
    public void findMilitary(String cid){
        
        milAssociated = FALSE;
        
        //in:bmilfamily, bmilself, fmstat
        Integer bFam = Integer.valueOf(backB.get('BMILFAMILY__c'));
        Integer bSelf = Integer.valueOf(backB.get('BMILSELF__c'));
        Integer fMil; 
        if(backF != null){
            fMil = Integer.valueOf(backF.get('FMSTAT__c'));
        }
        else{
            fMil = 0;
        }
        
        if(
           ((bFam == 1) || (bFam ==2)) 
           || (bSelf == 1)
           || (fMil == 1)
           )
        {
            milAssociated = TRUE;
        }
        //out:
    }
    public void findServices(){
        treatCompleted = FALSE;
        treatAsPlanned = FALSE;
        if(backF != null){
            if((backF.get('FUTYPE__c') == 2)){
                treatCompleted = TRUE;
                if((backF.get('FETSTAT__c') == 1)){
                    treatAsPlanned = TRUE;
                }
            }
        }
        //in:backF- futype fetstat
        //out:
    }
    public void findEthnic(){
    
        //get value entered
        Integer ethVal = Integer.valueOf(backB.get('ETHNIC__c'));
        
        //set to false
        ethnicNonHispanic = FALSE;
        ethnicHispanic = FALSE;
        ethnicUnknown = FALSE;
        
        if(ethVal == 2){
            ethnicGroup = 'Not Hispanic/Latino';
            ethnicNonHispanic = TRUE;
        }
        
        else if(ethVal == 1){
            ethnicGroup = 'Hispanic/Latino';
            ethnicHispanic = TRUE;
        }
        else if((ethVal == 96) || (ethVal == 99)){
            ethnicGroup = 'Ethnicity Unknown or Not Reported';
            ethnicUnknown = TRUE;
        }
        //in:ethnic number entry
        //out:string, 3 booleans
    }
    
    public Custom_Report_Controller(ApexPages.StandardController controller) {
    //client = [SELECT id  FROM Client__c WHERE id = 'a0255000004BIyHAAW']; //test client id hardcoded
                
        //get list of clients
        clients = [SELECT id, Clinician__c, Center__c, Age__c, CURRENT_AGE__c, INIT__c
                                    FROM Client__c];
                                    
       cocap = new Custom_Reporting__c();
   client = clients.get(0);
   System.debug(client);
        getRaw(client);
        System.debug(backB);
        System.debug(backF);
       // for(Client__c c :clients){
            cid = String.valueOf(client.id);
            cAge = Integer.valueOf(client.CURRENT_AGE__c);
            
            findDate();
            findAge();
            findRace();//cid);//c);
            findEthnic();
            findGender();
            findMilitary(cid);
            findServices();            
            
            System.debug(client.INIT__c);
            System.debug(cAge);
            
            cocap.AgeGroup__c = AgeGroup;
            System.debug(cocap.AgeGroup__c);
            
            System.debug(mostRecent);
            System.debug(dateEarliest);
            System.debug(AgeGroup);
            System.debug(age0_4);
            System.debug(age5_9);
            System.debug(age10_12);
            System.debug(age13_17);
            System.debug(age18_21);
            System.debug(raceGroup);
            System.debug(raceBlack);
            System.debug(raceWhite);
            System.debug(raceAINAK);
            System.debug(raceAsian);
            System.debug(raceHIOPI);
            System.debug(raceUnkNR);
            System.debug(raceMulti);
            System.debug(ethnicGroup);
            System.debug(ethnicHispanic);
            System.debug(ethnicNonHispanic);
            System.debug(ethnicUnknown);
            System.debug(genIdentity);
            System.debug(genMale);
            System.debug(genFemale);
            System.debug(genTrans);
            System.debug(genOther);
            System.debug(genUnknown);
            System.debug(milAssociated);
            System.debug(treatCompleted);
            System.debug(treatAsPlanned);
            
            //create new reporting record
       // }
    }

}