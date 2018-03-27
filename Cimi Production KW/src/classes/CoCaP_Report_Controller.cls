/****
*@description CoCaP Report controller
*
*@date    3/29/17
*@author    KW
*
*@modified  4/6/17  KW  Change demographics calculations to use 'open' clients/currently receiving treatment, not assessments 
*@modified  4/13/17 KW  Added retrievedRecords() and hasRecords boolean for easier rerendering display
*@modified  4/26-7/17 KW add date validation/error message on input dates-> combine errorChecker() & retrievedRecords
*@modified  4/27/17    KW    Force date format conversion->no?
*@modified  6/8-22/17    KW    debug/revise after data team feedback 
*@modified  6/26,28/17 KW      move compile time to controller instead of page, clean
*@modified  7/5/17  KW  Data team feedback pt2-> "new" definition, receiving?
*@modified  7/6/17  KW  Data team feedback pt2-> military, inactive status, future refinements
*@modified  7/10-14/17  KW  logic revise
*@modified  7/17/17     KW  clean unused logic stubs, un-globalize structures
*@modified  7/19/17 KW  move logic for closed/completed client count up
*@modified  8/2/2017    KW  PTSD dates were missing in assessment method: followups, parent versions
*@modified  8/10/17 KW  Military count off, add sex var if gender missing, CoCaP case
*@modified    8/16/17    KW    change wording of "completed" to "ended" and lowercase "completed AS PLANNED"
*
*@group CoCaP
*@group-content /ApexDocContent/CoCaP_Report_Controller.htm
****/
public with sharing class CoCaP_Report_Controller {
    
    /****
    * @description Initilization for print button 
    * @return null
    ****/
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
    public Boolean printReport { get; set; }

    //display boolean values
    public Boolean isError{get;set;}    
    public Boolean hasRecords{get;set;}
    public Boolean isValidData{get;set;}
            
    //init start and end dates
    public Date StartDate{get;set;}
    public Date EndDate{get;set;}
    
    //compile date/time string
    public String compileTime{get;set;}
                
    /****
    * @description generic class for mapping display
    * @return null
    ****/
    public class totalRec{
        public String recLabel{get;set;}
        public Integer recValue{get;set;}
        public totalRec(){
            this.recLabel = null;
        }
    }
    
    /****
    * @description main controller class, initially loaded values
    * @return null
    ****/
    public CoCaP_Report_Controller(ApexPages.StandardController controller) {
        //there should not be anything pre-loaded
        hasRecords = false;
        isError = false;
        isValidData= false;
        StartDate = null;
        EndDate = null;
        compileTime = '';
        assignedClients = false;
    }

    /****
    * @description define class to gather visit-specific information
    * @return null
    ****/
    public class visit{     
        public String clientId{get;set;}
        public String clientInit{get;set;}
        public Date clientDob{get;set;}
        public String genderRaw{get;set;}
        public String birthSex{get;set;}
        public String ethnicRaw{get;set;}
        public String racialGroup{get;set;}
        public String genderId{get;set;}
        public String ethnicGroup{get;set;}
                
        //visit-specific info           
        public Date visitDate{get;set;}
        public String visitSection{get;set;}
        public String visitType{get;set;}
        public String visitMilVal{get;set;}
                                                        
        public visit(){
            this.clientId = null;
        }
    }
    
    /****
    * @description define class to contain high-level information for each client
    * @return null
    ****/
    public class clientOverview{
        //client object
        //id
        public String clientId{get;set;}
        //initials
        public String clientInit{get;set;}
        
        //determined at baseline
        //age
        public Integer clientAgeRun{get;set;}
        //gender
        public String clientGender{get;set;}
        public String clientSex{get;set;}
        public String clientGenSexLabel{get;set;}
        //ethnicity
        public String clientEthnicity{get;set;}
        //race
        public String clientRace{get;set;}
        
        //cumulative
        //military
        public String militaryStatus{get;set;}
        
        //most recent visit
        //treatment status
        public String treatmentStatus{get;set;}
                
        public clientOverview(){
            this.clientId = null;
        }
    }
                
    //init integers for totals
    public Integer receivingTotal{get;set;} 
    public Integer assessmentTotal{get;set;}
    public Integer newTotal{get;set;}
    public Integer militaryTotal{get;set;}
    public Integer closedTotal{get;set;}
    public Integer txCompleteTotal{get;set;}
    
    //init integers for clients assigned sex instead of identifying gender
    public Integer assignedMale{get;set;}
    public Integer assignedFemale{get;set;}
    public Integer assignedUnknown{get;set;}
    public Boolean assignedClients{get;set;}
    
    //map demographics 
    public List<totalRec> treatmentRecords{get;set;}
    public List<totalRec> milRecords{get;set;}
    public List<totalRec> ageRecords{get;set;}
    public List<totalRec> genderRecords{get;set;}
    public List<totalRec> ethnicRecords{get;set;}
    public List<totalRec> raceRecords{get;set;}
        
    /****
    * @description function to run on click
    * @return null
    ****/
    public void getData(){       
        //query all baseline records
        List<DS_Background_Family_Info_B__c> baselineList = getBaselineRecords();
                
        //query all followup records
        List<DS_Background_Family_Info_F__c> followupList = getFollowupRecords();
                        
        //check validity of data in order to display
        hasRecords = retrievedRecords(baselineList);
        isError = errorChecker(StartDate, EndDate);
        isValidData = checkValidity(hasRecords, isError);
        
        //initialize sets
        Set<String> closedClients = new Set<String>();
        Set<String> txCompletedClients = new Set<String>();
                                 
        assignedMale = 0;
        assignedFemale = 0;
        assignedUnknown = 0;       
        
        //populate demographics and treatment status for ALL clients, pass through initialized sets
        List<clientOverview> allClientInfo = getClientOverview(isValidData, baselineList, followupList,closedClients, txCompletedClients);
        
        //only clients receiving services (not future or inactive)
        List<clientOverview> clientsReceiving = getReceivingClients(allClientInfo);
        
        //clients with assessments
        Set<String> assessmentClients= getAssessmentClients(clientsReceiving);
        
        //get totals for key domains based on the size of lists
        receivingTotal = clientsReceiving.size();
        assessmentTotal = assessmentClients.size();
        closedTotal = closedClients.size();
        txCompleteTotal =txCompletedClients.size();
        
        //use assessments list for determining military and demographic values
        Map<String, Integer> milMap= getMilMap(clientsReceiving);
        Map<String, Integer> ageMap= getAgeMap(clientsReceiving);
        Map<String, Integer> genMap= getGenMap(clientsReceiving);
        Map<String, Integer> ethMap= getEthMap(clientsReceiving);
        Map<String, Integer> raceMap= getRaceMap(clientsReceiving);     
        
        //add totals of direct services to map
        Map<String, Integer> treatmentMap = new Map<String,Integer>();
            treatmentMap.put('1. Number of Clients receiving direct clinical services: ', receivingTotal);
            treatmentMap.put('2. Number of Clients with a clinical assessment: ', assessmentTotal);
            treatmentMap.put('3. Number of new Clients: ', newTotal);
            treatmentMap.put('4. Number of Clients who ended treatment: ', closedTotal);
            treatmentMap.put('4a. Number of Clients who completed treatment as planned: ', txCompleteTotal);
                                                
        //lists of records
        treatmentRecords = new List<totalRec>();
        milRecords = new List<totalRec>();
        ageRecords = new List<totalRec>();
        genderRecords = new List<totalRec>();
        ethnicRecords = new List<totalRec>();
        raceRecords = new List<totalRec>();
        
        //parse maps into totalRec lisis records for display 
        //treatment
        for(String t:treatmentMap.keySet()){
            totalRec tr = new totalRec();
            tr.recLabel = t;
            tr.recValue = treatmentMap.get(t);
            treatmentRecords.add(tr);
        }
        //military
        for(String m:milMap.keySet()){
            totalRec mr = new totalRec();
            mr.recLabel = m;
            mr.recValue = milMap.get(m);
            milRecords.add(mr);
        }
        //age
        for(String a:ageMap.keySet()){
            totalRec ar = new totalRec();
            ar.recLabel = a;
            ar.recValue = ageMap.get(a);
            ageRecords.add(ar);
        }
        //gender
        for(String g:genMap.keySet()){
            totalRec gr = new totalRec();
            gr.recLabel = g;
            gr.recValue = genMap.get(g);
            genderRecords.add(gr);
        }
        //ethnicity
        for(String e:ethMap.keySet()){
            totalRec er = new totalRec();
            er.recLabel = e;
            er.recValue = ethMap.get(e);
            ethnicRecords.add(er);
        }
        //race
        for(String r:raceMap.keySet()){
            totalRec rr = new totalRec();
            rr.recLabel = r;
            rr.recValue = raceMap.get(r);
            raceRecords.add(rr);
        }
        
        //string of time report was compiled
        compileTime = getTime();
        
    }
    
    /****
    * @description get all clients who have ever had a baseline record 
    * called from getData()
    * @param none
    * @return List<DS_Background_Family_Info_B__c> baselineList
    ****/
    public List<DS_Background_Family_Info_B__c> getBaselineRecords(){
        List<DS_Background_Family_Info_B__c>  baselineList = [SELECT Client__c, Client__r.id, Client__r.INIT__c, SECTION__c,BDOV__c, Client__r.CURRENT_AGE__c,Client__r.DOB1__c, Client__r.GENDER__c,
                                                                        BMILFAMILY__c, BMILSELF__c,//military
                                                                        BIDENT__c, //gender
                                                                        ETHNIC__c,//ethnicity 
                                                                        RINDIAN__c, RAKNTV__c,RASIANIN__c, RCHINESE__c, RFILIPINO__c, RJAPANESE__c, RKOREAN__c, 
                                                                            RVIETNAMESE__c, ROASIAN__c, RBLACK__c, RHAWAN__c, RGUAM__c, RSAMOA__c, 
                                                                            ROPI__c, RWHITE__c, RREF__c, RUNK__c  //races
                                                                        FROM DS_Background_Family_Info_B__c]; 
        return baselineList;                                                                                                                    
    }
        
    /****
    * @description get followups ever using list of ids of clients w/ baseline data
    * called from getData()
    * @param Set<String> BaselineIds
    * @return List<DS_Background_Family_Info_F__c> followupList
    ****/
    public List<DS_Background_Family_Info_F__c> getFollowupRecords(){
        List<DS_Background_Family_Info_F__c> followupList = [SELECT Client__r.id, Client__r.INIT__c, SECTION__c, Client__r.DOB1__c,
                                                            FMSTAT__c, //military
                                                            FDOV__c, FETSTAT__c, FUTYPE__c//visit info
                                                            FROM DS_Background_Family_Info_F__c];
        return followupList;
    }              
    
    /****
    * @indicates if the records have been processed successfully, non-null
    * called from getData()
    * @param List<DS_Background_Family_Info_B__c> baselineList
    * @return boolean hasRecords
    ****/
    public Boolean retrievedRecords(List<DS_Background_Family_Info_B__c> baselineList){
        
        if(baselineList.size() >0){
            hasRecords = true;
        }
        else if(baselineList == null){
            hasRecords = false;
        }        
        return hasRecords;
    }

    /****
    * @description checks that both dates are present and in thr correct order
    * adds page-level error message if incorrect
    * called from getData()
    * @param Date StartDate
    * @param Date EndDate
    * @return boolean isError
    ****/
    public Boolean errorChecker(Date StartDate, Date EndDate){
                
        ApexPages.Message  startMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a Start Date');
        ApexPages.Message  endMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter an End Date');
        
        //catch null first
        if(StartDate == null){
            ApexPages.addMessage(startMessage);
            isError = true;
        }
        if(EndDate == null){
            ApexPages.addMessage(endMessage);
            isError = true;
        }
        //catch dates out of order
        else if((StartDate != null)&&(EndDate != null)){
            //cast dates to String
            String StartDateString = StartDate.format();
            string EndDateString = EndDate.format();
            
            ApexPages.Message  orderMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date ('+StartDateString+') must be earlier than End Date ('+EndDateString+')');
            
            //dates need to be in correct order
            if(StartDate > EndDate){
                ApexPages.addMessage(orderMessage);
                isError = true;
            }        
            else{
                isError = false;
            }
        }
        return isError;
    }
            
    /****
    * @description checks that data is present and valid
    * called from getData()
    * @param Boolean hasRecords
    * @param Boolean isError
    * @return Boolean isValidData
    ****/
    public Boolean checkValidity(Boolean hasRecords, Boolean isError){
        
        if((hasRecords == true)&&(isError == false)){
            isValidData= true;
        }
        else{
            isValidData= false;
        }        
        return isValidData;
    }
    
    /****
    * @description categorized visit data, gets demographics for all clients
    * called from getData()
    * @param Boolean isValidData
    * @param List<DS_Background_Family_Info_B__c> baselineList
    * @param List<DS_Background_Family_Info_F__c> followupList
    * @return List<visit> allVisits
    ****/
    public List<clientOverview> getClientOverview(Boolean isValidData, List<DS_Background_Family_Info_B__c> baselineList, List<DS_Background_Family_Info_F__c> followupList, Set<String> closedClients, Set<String> txCompletedClients){   
    
        List<clientOverview> allClientInfo = new List<clientOverview>();
        if(isValidData == true){
            
            List<visit> baselineVisits= new List<visit>();
            List<visit> allVisits = new List<visit>();
            Map<String, visit> baselineMap = new Map<String,visit>();
            Set<String> baselineClients= new Set<String>();
            
            //get baseline level information for all clients
            for(DS_Background_Family_Info_B__c b:baselineList){
                //get client id first
                String cId = String.valueOf(b.get('Client__c'));
                //check for uniqueness          
                if(!baselineClients.contains(cId)){
                    //make new visit
                    visit bvis = new Visit();
                    
                    //assign client info    
                    bvis.clientId= cId;     
                    bvis.clientInit =String.valueOf(b.Client__r.INIT__c);
                    bvis.clientDob=Date.valueOf(b.Client__r.DOB1__c);
                    
                    //assign raw values
                    bvis.genderRaw = String.valueOf(b.BIDENT__c);   
                    bvis.birthSex = String.valueOf(b.Client__r.GENDER__c);
                    bvis.ethnicRaw   = String.valueOf(b.ETHNIC__c);  
                    
                    //process race and assign
                    bvis.racialGroup = getRacialGroup(b);
                    
                    //assign visit information
                    bvis.visitDate= Date.valueOf(b.BDOV__c);
                    bvis.visitSection = b.SECTION__c;
                    
                    //process treatment type and assign
                    bvis.visitType = getVisitType(bvis.visitDate, 'B','');
                    
                    //process military vars
                    String family = String.valueOf(b.BMILFAMILY__c);
                    String self = String.valueOf(b.BMILSELF__c);
                    
                    //call method to determine military status
                    bvis.visitMilVal = getMilitary(family, self);
                    
                    //check if future
                    if(bvis.visitType != 'Future'){
                        //add client to set
                        baselineVisits.add(bvis);
                        //map client to visit
                        baselineMap.put(cId, bvis);
                    }
                }
            }
            
            //count new visits before processing followup
            newTotal = getNewTotal(baselineVisits);
            
            //for clients in map
            for(String c: baselineMap.keySet()){
                //alias baseline visit
                visit v = baselineMap.get(c);
                
                //alias overview vars
                //use baseline information
                String initials = String.valueOf(v.clientInit);
                Integer age = getAgeRun(v);
               // String gender = getGenderLabel(v.genderRaw, v.birthSex);
                String gender = v.genderRaw;
                String sex = v.birthSex;
                String ethnicity = getEthnicGroup(v.ethnicRaw);
                Date dob = Date.valueOf(v.clientDob);
                String race = v.racialGroup;
                String military = String.valueOf(v.visitMilVal);
                System.debug(initials+ ' = '+military);
                //initialize status to whatever baseline is
                String status = String.valueOf(v.visitType);
                
                //makew new overview
                clientOverview o = new clientOverview();
                
                //check 0-21
                if((age>=0)&&(age<=21)){
                
                    //initialize followup visit list for each client
                    List<visit> followupVisits = new List<visit>();
                                    
                    //for followups
                    for(DS_Background_Family_Info_F__c f: followupList){
                        String cId = String.valueOf(f.get('Client__c'));
                        //check that client ids match
                        if(c ==cId){        
                            //make new visit
                            visit fvis = new Visit();
                            fvis.clientId = cId;
                            fvis.clientInit = initials;
                            fvis.clientDob = dob;
                            fvis.genderRaw =v.genderRaw;
                            fvis.birthSex =v.birthSex;
                            fvis.ethnicRaw =v.ethnicRaw;
                            fvis.racialGroup =v.racialGroup;
                            
                            fvis.visitDate = Date.valueOf(f.FDOV__c);
                            fvis.visitSection = String.valueOf(f.SECTION__c);
                            fvis.visitMilVal = String.valueOf(f.FMSTAT__c);
                            
                            String futype = String.valueOf(f.FUTYPE__c);
                            String txstat = String.valueOf(f.FETSTAT__c);
                            fvis.visitType = getVisitType(fvis.visitDate, futype,txstat);
                            
                            //disregard future visits
                            if(fvis.visitType != 'Future'){
                                //add to list
                                followupVisits.add(fvis);
                            }            
                        }
                    }
                    
                    Integer followupVisitNum =followupVisits.size();
                                                            
                    for(visit f:followupVisits){
                        //find military status for followups (cumulative)
                        military = getMilitary(military, f.visitMilVal);
                            
                        //check how many followup visits there were                 
                        if(followupVisitNum > 0){
                            //check to see if any of the clients' visits were closed within range, regardless of most recent 
                            closedClients=getClosedClients(f,closedClients,txCompletedClients);
                            
                            //keep the status of the most recent
                            status = getRecentStatus(followupVisits);
                        }                       
                    }
                    //no followups = baseline only. keep status from baseline
                }
            
                //assign to overview 
                o.clientId = c;
                o.clientInit = initials;
                o.clientAgeRun = age;
                o.clientGender = gender;
                o.clientSex = sex;
                o.clientEthnicity = ethnicity;
                o.clientRace = race;
                o.militaryStatus = military;
                o.treatmentStatus = status;
                                    
                allClientInfo.add(o);
            }
        }      
        return allClientInfo;
    }
    
    /****
    * @description a list client information for only clients "currently" receiving services
    * called from getData()
    * @param List<clientOverview> allClientInfo
    * @return List<clientOverview> clientsReceiving
    ****/
    public List<clientOverview> getReceivingClients(List<clientOverview> allClientInfo){
        List<clientOverview> clientsReceiving = new List<clientOverview> ();  
            for(clientOverview c:allClientInfo){
                String status = c.treatmentStatus;
                
                //filter out inactive clients
                if((status!='Inactive')&&(status!='Future')){
                    String genId = c.clientGender;
                    String bSex = c.clientSex;
                    c.clientGenSexLabel= getGenderLabel(genId, bSex);
                    clientsReceiving.add(c);
                    System.debug(c.clientId+' , '+c.clientInit+' = '+genId+ ' '+bSex+ ' = '+c.clientGenSexLabel);                   
                }
                
            }
        return clientsReceiving;
    }       
             
    /****
    * @description of the clients receiving services, determine which have had any assessment within range
    * called from getData()
    * @param List<clientOverview> clientsReceiving
    * @return Set<String> assessmentClients
    ****/   
    public Set<String> getAssessmentClients(List<clientOverview> clientsReceiving){
        
        //set enforces unique values
        Set<String> assessmentClients = new Set<String>();
        
            Set<String> cbclBClients = getCbclBClients();
            Set<String> cbclFClients = getCbclFClients();
            Set<String> ptsdBClients = getPtsdBClients();
            Set<String> ptsdFClients = getPtsdFClients();
            Set<String> sdqpsiBClients = getSdqPsiBClients();
            Set<String> sdqpsiFClients = getSdqPsiFClients();
            Set<String> tsccaycBClients = getTsccAYcBClients();
            Set<String> tsccaycFClients = getTsccAYcFClients();
            
            //loop through all clients receiving services
            for(clientOverview o: clientsReceiving){
                //get client id
                String c = o.clientId;
                //check the status
                String status = o.treatmentStatus;
                
                //count bdov w/i range and fdov w/i range
                if((status == 'New')||(status =='Ongoing')||(status=='TxCompleted')||(status=='Closed')){
                    //NOT counting: 'Previous'(b or f), 'Future', 'Inactive'
                    assessmentClients.add(c);
                }
                
                if(cbclBClients.contains(c)){
                    assessmentClients.add(c);
                }
                if(cbclFClients.contains(c)){
                    assessmentClients.add(c);
                }
                if(ptsdBClients.contains(c)){
                    assessmentClients.add(c);
                }
                if(ptsdFClients.contains(c)){
                    assessmentClients.add(c);
                }
                if(sdqpsiBClients.contains(c)){
                    assessmentClients.add(c);
                }
                if(sdqpsiFClients.contains(c)){
                    assessmentClients.add(c);
                }
                if(tsccaycBClients.contains(c)){
                    assessmentClients.add(c);
                }
                if(tsccaycFClients.contains(c)){
                    assessmentClients.add(c);
                }
            }
        return assessmentClients;
    }       
    
    /****
    * @description get the military status of ALL CLIENTS receiving services
    * called from getData()
    * @param List<clientOverview> clientsReceiving
    * @return Map<String, Integer> milMap
    ****/   
    public Map<String, Integer> getMilMap(List<clientOverview> clientsReceiving){
        
        //map possible responses for military to the corresponding subtotal
        Map<String, Integer> milMap =  new Map<String, Integer>();   
        Integer countMilYes = 0;
        Integer countMilNo = 0;
        Integer countMilMissing = 0;
        
        //for each client, get all values for military from visits before end date
        for(clientOverview c: clientsReceiving){
            String milValue = c.militaryStatus;
            
            //any positive response w/i range
            if(milValue =='Yes'){
                countMilYes = countMilYes +1;
            }
            //negative response
            else if(milValue=='No'){
                countMilNo = countMilNo + 1;
            }
            //only not answered
            else if(milValue=='Missing'){
                countMilMissing = countMilMissing +1;
            }
        }
                
        //call method to make countMilYes value publically accessible for page display      
        militaryTotal=countMilYes;//getMilitaryTotal(countMilYes);
        milMap.put('Military Connected ', countMilYes);
        milMap.put('Not Military Connected ', countMilNo);
        milMap.put('Military Connection is Missing, Unknown, or Not Provided ', countMilMissing);
                
        return milMap;          
    }
        
    /****
    * @description get the age range of ALL CLIENTS receiving services
    * called from getData()
    * @param List<clientOverview> clientsReceiving
    * @return Map<String, Integer> ageMap
    ****/   
    public Map<String,Integer> getAgeMap(List<clientOverview> clientsReceiving){
            
        Map<String, Integer> ageMap =  new Map<String, Integer>();           
                
        Integer countAge0_4 = 0;
        Integer countAge5_9 = 0;
        Integer countAge10_12 = 0;
        Integer countAge13_17 = 0;
        Integer countAge18_21 = 0;
        Integer countAge_NA = 0;      
        
        for(clientOverview c: clientsReceiving){
                        
            Integer ageRun = c.clientAgeRun;
            
            if((ageRun >=0) &&(ageRun <=4)){
                countAge0_4 = countAge0_4+1;
            }
            else if((ageRun >=5) &&(ageRun <=9)){
                countAge5_9 = countAge5_9+1;
            }
            else if((ageRun >=10) &&(ageRun <=12)){
                countAge10_12 = countAge10_12+1;
            }
            else if((ageRun >=13) &&(ageRun <=17)){
                countAge13_17 = countAge13_17+1;
            }
            else if((ageRun >=18) &&(ageRun <=21)){
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
                
        return ageMap;
    }
        
    /****
    * @description get the gender of ALL CLIENTS receiving services
    * called from getData()
    * @param List<clientOverview> clientsReceiving
    * @return Map<String, Integer> genMap
    ****/   
    public Map<String,Integer> getGenMap(List<clientOverview> clientsReceiving){
            
        Map<String, Integer> genMap =  new Map<String, Integer>();  
        Integer maleCount = 0;
        Integer femCount = 0;
        Integer transCount = 0;
        Integer otherCount = 0;
        Integer refunkCount = 0;
        Integer missingCount = 0;
        
        for(clientOverview c :clientsReceiving){
            String genLabel = c.clientGenSexLabel;
            
            if(genLabel == 'Male'){
                maleCount=maleCount+1;
            }
            else if(genLabel == 'Female'){
                femCount = femCount+1;
            }
            else if(genLabel == 'Transgender'){
                transCount=transCount+1;
            }
            else if(genLabel == 'Other Gender Identity'){
                otherCount=otherCount+1;
            }
            else if(genLabel == 'Unknown/declined to provide Gender Identity'){
                refunkCount=refunkCount+1;
            }
        }
        
        genMap.put('Male',maleCount);
        genMap.put('Female',femCount);
        genMap.put('Transgender',transCount);
        genMap.put('Other Gender Identity',otherCount);
        genMap.put('Unknown/declined to provide Gender Identity',refunkCount);
        
        return genMap;
    }
    
    /****
    * @description get the ethnicity of ALL CLIENTS receiving services
    * called from getData()
    * @param List<clientOverview> clientsReceiving
    * @return Map<String, Integer> ethMap
    ****/   
    public Map<String,Integer> getEthMap(List<clientOverview> clientsReceiving){
            
        Map<String, Integer> ethMap =  new Map<String, Integer>();  
        Integer hispanicCount = 0;
        Integer nonhispCount = 0;
        Integer refunkCount = 0;
        Integer missingCount = 0;
        
        for(clientOverview c :clientsReceiving){
            String ethLabel = c.clientEthnicity;
            
            if(ethLabel =='Hispanic/Latino'){
                hispanicCount=hispanicCount+1;
            }
            else if(ethLabel =='Not Hispanic/Latino'){
                nonhispCount=nonhispCount+1;
            }
            else if(ethLabel =='Ethnicity Unknown or Not Reported'){
                refunkCount=refunkCount+1;
            }
            else if(ethLabel =='Ethnicity is Missing'){
                missingCount=missingCount+1;
            }               
        }
        
        ethMap.put('Hispanic/Latino',hispanicCount);
        ethMap.put('Not Hispanic/Latino',nonhispCount);
        ethMap.put('Ethnicity Unknown or Not Reported',refunkCount);
        ethMap.put('Ethnicity is Missing',missingCount);
                
        return ethMap;
    }
        
    /****
    * @description get the race of ALL CLIENTS receiving services
    * called from getData()
    * @param List<clientOverview> clientsReceiving
    * @return Map<String, Integer> raceMap
    ****/   
    public Map<String,Integer> getRaceMap(List<clientOverview> clientsReceiving){
        Map<String, Integer> raceMap =  new Map<String, Integer>();   
        Integer countRaceAm_Native = 0;
        Integer countRaceAsian = 0;
        Integer countRaceBlack = 0;
        Integer countRaceIsland = 0;
        Integer countRaceWhite = 0; 
        Integer countRaceRef_Unk = 0;
        Integer countRaceMulti = 0;
        
        //count occurrence of each racial group
        for(clientOverview c :clientsReceiving){
            String raceLabel = c.clientRace;
            
            if(raceLabel == 'American Indian/Native Alaskan'){
                countRaceAm_Native=countRaceAm_Native+1;
            }
            else if(raceLabel == 'Asian'){
                countRaceAsian=countRaceAsian+1;
            }
            else if(raceLabel == 'Black/African American'){
                countRaceBlack=countRaceBlack+1;
            }
            else if(raceLabel == 'Native Hawaiian/Other Pacific Islander'){
                countRaceIsland=countRaceIsland+1;
            }
            else if(raceLabel == 'White'){
                countRaceWhite=countRaceWhite+1;
            }
            else if(raceLabel == 'Race Unknown or Not Reported'){
                countRaceRef_Unk=countRaceRef_Unk+1;
            }
            else if(raceLabel == 'Multiracial'){
                countRaceMulti=countRaceMulti+1;
            }
        }
        
        raceMap.put('American Indian/Native Alaskan',countRaceAm_Native );
        raceMap.put('Asian',countRaceAsian );
        raceMap.put('Black/African American',countRaceBlack );
        raceMap.put('Native Hawaiian/Other Pacific Islander',countRaceIsland );
        raceMap.put('White',countRaceWhite );
        raceMap.put('Race Unknown or Not Reported',countRaceRef_Unk );
        raceMap.put('Multiracial',countRaceMulti );
        return raceMap;          
    }
    
    /****
    * @description gets the time of compilation into desired format
    * called from getData()
    * @param none
    * @return String compileTime
    ****/
    public String getTime(){
        String compileTime= String.valueOf(DateTime.now().format('EEEE, MM/dd/yyyy\' at\' hh:mm a z', 'GMT'));
        return compileTime;
    }
        
    /****
    * @description get racial group for EACH CLIENT
    * called from getClientOverview()
    * @param DS_Background_Family_Info_B__c b
    * @return String racialGroup    
    ****/
    public String getRacialGroup(DS_Background_Family_Info_B__c b){   
        
        Integer countRaces=0;   
        String tmpRace ='';
        List<String> clientRaceList = new List<String>();    
        String racialGroup = '';

        //Native American/Alaskan
        if((b.RINDIAN__c == true) ||(b.RAKNTV__c == true)){ 
            tmpRace = 'American Indian/Native Alaskan';
            clientRaceList.add(tmpRace);
        }       
        //Asian
        if((b.RASIANIN__c == true)|| (b.RCHINESE__c == true)||
            (b.RFILIPINO__c == true)|| (b.RJAPANESE__c == true)||
            (b.RKOREAN__c == true)|| (b.RVIETNAMESE__c == true)||
            (b.ROASIAN__c == true)){                        
            tmpRace = 'Asian';
            clientRaceList.add(tmpRace);
        }       
        //black
        if(b.RBLACK__c== true){ 
            tmpRace = 'Black/African American';
            clientRaceList.add(tmpRace);
        }       
        //Hawaiian/Pacific Islander
        if((b.RHAWAN__c == true)|| (b.RGUAM__c == true)||
            (b.RSAMOA__c == true)|| (b.ROPI__c == true)){                  
            tmpRace = 'Native Hawaiian/Other Pacific Islander';
            clientRaceList.add(tmpRace);
        }       
        //white
        if(b.RWHITE__c == true){ 
            tmpRace = 'White';
            clientRaceList.add(tmpRace);
        }       
        //unknown/not reported
        if((b.RREF__c == true)||(b.RUNK__c == true)){
            tmpRace = 'Race Unknown or Not Reported';
            clientRaceList.add(tmpRace);
        }
        
        //#races per client
        countRaces = Integer.valueOf(clientRaceList.size());
                        
        if(countRaces  >1){
            racialGroup = 'Multiracial';
        }
        else{
            racialGroup = tmpRace;
        }             
        
        return racialGroup;
    }       
    
    /****
    * @description get the category for EACH VISIT
    * called from getClientOverview()
        * possible values: Future,  Inactive, New, Previous, Closed, TxCompleted, Ongoing
        * these values reflect not only the type of visit, but also when it occurred in the client's treatment 
        * Future = This visit was after the End Date
        * Inactive = The visit was before the Start Date and FUTYPE__c = 2 (end of treatment)
        * New = Baseline DOV is within the range
        * Previous = This visit was before the Start Date, but was not an end of treatment
        * Closed = The visit was within the date range, FUTYPE__c = 2
        * TxCompleted = visit within range, FUTYPE__c = 2, AND FETSTAT__c = 1 (completed as planned)
        * Ongoing = A visit within range that is not new, closed, or completed
    * @param Date dov -> can be used w/ B or F
    * @param String Futype -> 'B' will be passed for Baseline visits, otherwise FUTYPE__c
    * @param String Txstat -> '' for Baseline, FETSTAT__c for followup
    * @return String visitType
    ****/
    public String getVisitType(Date dov, String Futype, String Txstat){
        String visitType='';
        
        //do not include future
        if(dov>EndDate){
            visitType = 'Future';
        }
        //if before end date
        else{
            //baseline
            if(Futype =='B'){
                //new
                if(dov>=StartDate){
                    visitType = 'New';
                }
                //previous baseline
                else{
                    visitType = 'Previous';
                }
            }
            //closed followup
            else if(Futype == '2'){
                //if before start
                if(dov<StartDate){
                    visitType ='Inactive';
                }
                //during range
                else{
                    if(Txstat =='1'){
                        visitType = 'TxCompleted';
                    }
                    else{
                        visitType = 'Closed';
                    }
                }
            }
            //ongoing or re-opened followup
            else{
                //before range
                if(dov<StartDate){
                    visitType ='Previous';
                }
                else{
                    visitType = 'Ongoing';
                }
            }
        }
        return visitType;
    }
      
    /****
    * @description get the cumulative military status for EACH CLIENT
    * for baseline visits, uses the value for family and for self
    * for followup visits, uses the previously calculated value and the value for the visit
    * called from getClientOverview()
    * @param String Mil1
    * @param String Mil2
    * @return String MilValue
    ****/   
    public String getMilitary(String Mil1, String Mil2){
        String MilValue;
        String tmpVal;
        
        //check military family or previous val
        //missing or null
        if((Mil1 == null)||(Mil1 == 'null')||(Mil1 == '96')||(Mil1 == '99')||(Mil1 =='Missing')){
            tmpVal = 'Missing';
        }
        //positive
        else if(((Mil1 =='1')||(Mil1 =='2'))||(Mil1 == 'Yes')){
            tmpVal = 'Yes';
        }
        //negative
        else if((Mil1 =='0')||(Mil1 =='No')){
            tmpVal = 'No';
        }
        
        //both missing or null
        if(((Mil2 == null)||(Mil2 == 'null')||(Mil2 == '96')||(Mil2 == '99')) && (tmpVal =='Missing')){
            MilValue = 'Missing';
        }
        //any positive
        else if((Mil2 =='1')||(tmpVal == 'Yes')){
            MilValue = 'Yes';
        }
        //definately not military
        else{
            MilValue = 'No';
        }
        
        //return overall value at this visit
        return MilValue;
    }
     
    /****
    * @description get public integer value of TOTAL new clients 
    * called from getClientOverview()
    * @param List<visit> baselineVisits
    * @return Integer newTotal
    ****/
    public Integer getNewTotal( List<visit> baselineVisits){
        newTotal = 0;
        for(visit v : baselineVisits){
            if(v.visitType =='New'){
                newTotal = newTotal +1;
            }
        }
        return newTotal;
    }
           
    /****
    * @description get EACH CLIENT's age at the end of the reporting period
    * called from getClientOverview()
    * @param visit b
    * @return Integer clientAgeRun
    ****/
    public Integer getAgeRun(visit b){      
        Date bday = Date.valueOf(b.clientDob);
        Date endday = Date.valueOf(EndDate);
        String yrs = String.valueOf(bday.monthsBetween(endday) / 12);
        Integer clientAgeRun = Integer.valueOf(yrs);
        
        return clientAgeRun;
    }
         
    /****
    * @description get the gender identity/sex label for EACH CLIENT
    * called from getReceivingClients()
    * @param String genId
    * @param String bSex
    * @return String genderId
    ****/   
    public String getGenderLabel(String genId, String bSex){
          
        String genderId = '';
    
            if(genId == '1'){
                genderId = 'Male';
            }
            else if(genId == '2'){
                genderId = 'Female';
            }
            else if((genId == '3') || (genId == '4')){
                genderId = 'Transgender';
            }
            else if(genId == '98'){
                genderId = 'Other Gender Identity';
            }
            else if((genId == '96') || (genId == '99')){
                genderId = 'Unknown/declined to provide Gender Identity';
            }
            //use sex at birth instead of grouping as missing
            else{
                //genderId = 'Gender Identity is Missing';
                if(bSex =='Male'){
                    genderId = 'Male';
                    assignedMale = assignedMale+1;
                }
                else if(bSex == 'Female'){
                    genderId = 'Female';
                    assignedFemale = assignedFemale+1;
                }
                else{
                    genderId = 'Unknown/declined to provide Gender Identity';
                    assignedUnknown = assignedUnknown+1;
                }
                assignedClients = true;
            }            
        return genderId;
    }
    
    /****
    * @description get ethnic group for EACH CLIENT
    * called from getClientOverview()
    * @param String ethnic
    * @return String ethnicGroup    
    ****/
    public String getEthnicGroup(String ethnic){   
    
        //required field
        String ethnicGroup = '';
        
        if(ethnic == '1'){
            ethnicGroup ='Hispanic/Latino';
        }
        else if(ethnic == '2'){
            ethnicGroup ='Not Hispanic/Latino';
        }       
        else if((ethnic == '96') || (ethnic == '99')){
            ethnicGroup ='Ethnicity Unknown or Not Reported';
        }
        else{
            ethnicGroup ='Ethnicity is Missing';
        }               
        return ethnicGroup;
    }
      
    /****
    * @description get the status of the most recent visit for EACH CLIENT
    * called from getClientOverview()
    * @param List<visit> fVisits
    * @return String status
    ****/
    public String getRecentStatus(List<visit> fVisits){
        Date latest;
        String status;
        String vNum;
        
        for(visit f:fVisits){
            Date tdate = f.visitDate;
            String type = f.visitType;
            String section = f.visitSection;
            
            //a visit has been processed before this one
            if(latest!= null){
                //set the visit as most recent
                if(tdate>latest){
                    latest = tdate;
                    status = type;
                    vNum = section;
                }
                //if two or more visits on the same day
                else if(tdate == latest){
                    //take the visit with the highest section
                    if(section > vNum){
                        latest = tdate;
                        status = type;
                        vNum = section;                     
                    }
                }
                //do nothing for the 'losing' visit
            }
            //first visit processed, set as most recent
            else{
                latest = tdate;
                status = type;
                vNum = section;
            }
        }
        return status;
    }
     
    /****
    * @description populates sets for closed or completed clients
    * called from getClientOverview()
    * @param visit v -> followup visits of a client
    * @param Set<String> closedClients -> this is passed through getClientOverview and gets updated on each pass
    * @param Set<String> txCompletedClients -> this is passed through getClientOverview and gets updated on each pass
    * @return Set<String> closedClients
    ****/
    public Set<String> getClosedClients(visit v, Set<String> closedClients, Set<String> txCompletedClients){
        if((v.visitType =='Closed')||(v.visitType =='TxCompleted')){
            if(v.visitType =='TxCompleted'){
                txCompletedClients.add(v.clientId);
            }
            closedClients.add(v.clientId);
        }
        return closedClients;
    }
    
    /****
    * @description get the client ids of cbcl bs in range
    * called from getAssessmentClients()
    * @param none
    * @return Set<String> cbclBClients
    ****/
    public Set<String> getCbclBClients(){
        Set<String> cbclBClients = new Set<String>();
        List<DS_CBCL_B__c>  cbclBList = [SELECT Client__c,BDOACO__c, BDOACY__c
                                        FROM DS_CBCL_B__c
                                        ];
                                                                        
        for(DS_CBCL_B__c cb:cbclBList){
            String client = String.valueOf(cb.Client__c);
            Date old = Date.valueOf(cb.BDOACO__c);
            Date young = Date.valueOf(cb.BDOACY__c);
            
            if((old >= StartDate) &&(old <= EndDate)){
                cbclBClients.add(client);
            }
            else if((young >= StartDate) &&(young <= EndDate)){
                cbclBClients.add(client);
            }
        }                       
        return cbclBClients;
    }
    
    /****
    * @description get the client ids of cbcl fs in range
    * called from getAssessmentClients()
    * @param none
    * @return Set<String> cbclFClients
    ****/
    public Set<String> getCbclFClients(){
        Set<String> cbclFClients = new Set<String>();
            
        List<DS_CBCL_F__c>  cbclFList = [SELECT Client__c, SECTION__c, FDOACO__c, FDOACY__c
                                        FROM DS_CBCL_F__c];
                                                                            
        for(DS_CBCL_F__c cf:cbclFList){
            String client = String.valueOf(cf.Client__c);
            Date old = Date.valueOf(cf.FDOACO__c);
            Date young = Date.valueOf(cf.FDOACY__c);
            
            if((old >= StartDate) &&(old <= EndDate)){
                cbclFClients.add(client);
            }
            if((young >= StartDate) &&(young <= EndDate)){
                cbclFClients.add(client);
            }
        }                       
        return cbclFClients;
    }
    
    /****
    * @description get the client ids of ptsd bs in range
    * called from getAssessmentClients()
    * @param none
    * @return Set<String> ptsdBClients
    ****/
    public Set<String> getPtsdBClients(){
        Set<String> ptsdBClients = new Set<String>();
        List<DS_PTSD_CA_B__c>  ptsdBList = [SELECT Client__c,BDOAPTSD__c, BDOAPTSDP__c
                                            FROM DS_PTSD_CA_B__c];
                                                                                    
        for(DS_PTSD_CA_B__c pb : ptsdBList){
            String client = String.valueOf(pb.Client__c);
            Date cDoa = Date.valueOf(pb.BDOAPTSD__c);
            Date pDoa  = Date.valueOf(pb.BDOAPTSDP__c);
            
            if((cDoa >= StartDate) &&(cDoa <= EndDate)){
                ptsdBClients.add(client);
            }
            if((pDoa >= StartDate) &&(pDoa <= EndDate)){
                ptsdBClients.add(client);
            }
        }
        
        return ptsdBClients;
    }
    
    /****
    * @description get the client ids of ptsd fs in range
    * called from getAssessmentClients()
    * @param none
    * @return Set<String> ptsdFClients
    ****/
    public Set<String> getPtsdFClients(){
        Set<String> ptsdFClients = new Set<String>();
        List<DS_PTSD_CA_F__c>  ptsdFList = [SELECT Client__c, SECTION__c, FDOAPTSD__c, FDOAPTSDP__c
                                            FROM DS_PTSD_CA_F__c];
            
        for(DS_PTSD_CA_F__c pf : ptsdFList){
                String client = String.valueOf(pf.Client__c);
                Date cDoa = Date.valueOf(pf.FDOAPTSD__c);
                Date pDoa = Date.valueOf(pf.FDOAPTSDP__c);
            
            if((cDoa >= StartDate) &&(cDoa <= EndDate)){
                ptsdFClients.add(client);
            }
            if((pDoa >= StartDate) &&(pDoa <= EndDate)){
                ptsdFClients.add(client);
            }
        }
        
        return ptsdFClients;
    }
    
    /****
    * @description get the client ids of sdqpsi bs in range
    * called from getAssessmentClients()
    * @param none
    * @return Set<String> sdqpsiBClients
    ****/
    public Set<String> getSdqPsiBClients(){
        
        Set<String> sdqpsiBClients = new Set<String>();
        List<DS_SDQ_PSI_CDI_B__c>  sdqBList = [SELECT  Client__c,BDOAPSI__c, BDOASDYP__c,BDOASDOP__c,BDOASDOS__c
                                                FROM DS_SDQ_PSI_CDI_B__c];
                                                                                
        for(DS_SDQ_PSI_CDI_B__c sb : sdqBList){
            String client = String.valueOf(sb.Client__c);
            Date psi = Date.valueOf(sb.BDOAPSI__c);
            Date youngP = Date.valueOf(sb.BDOASDYP__c);
            Date oldP = Date.valueOf(sb.BDOASDOP__c);
            Date oldS = Date.valueOf(sb.BDOASDOS__c);
            
            if((youngP >= StartDate) &&(youngP <= EndDate)){
                sdqpsiBClients.add(client);
            }
            if((oldP >= StartDate) &&( oldP<= EndDate)){
                sdqpsiBClients.add(client);
            }
            if((oldS >= StartDate) &&(oldS <= EndDate)){
                sdqpsiBClients.add(client);
            }
            if((psi >= StartDate) &&(psi <= EndDate)){
                sdqpsiBClients.add(client);
            }
        }
        return sdqpsiBClients;
    }
    
    /****
    * @description get the client ids of sdqpsi fs in range
    * called from getAssessmentClients()
    * @param none
    * @return Set<String> sdqpsiFClients
    ****/
    public Set<String> getSdqPsiFClients(){
        Set<String> sdqpsiFClients = new Set<String>();
        List<DS_SDQ_PSI_CDI_F__c>  sdqFList = [SELECT  Client__c,FDOAPSI__c, FDOASDYP__c,FDOASDOP__c,FDOASDOS__c
                                                FROM DS_SDQ_PSI_CDI_F__c];
                                                                                
        for(DS_SDQ_PSI_CDI_F__c sf : sdqFList){
            String client = String.valueOf(sf.Client__c);
            Date psi = Date.valueOf(sf.FDOAPSI__c);
            Date youngP = Date.valueOf(sf.FDOASDYP__c);
            Date oldP = Date.valueOf(sf.FDOASDOP__c);
            Date oldS = Date.valueOf(sf.FDOASDOS__c);
            
            if((youngP >= StartDate) &&(youngP <= EndDate)){
                sdqpsiFClients.add(client);
            }
            if((oldP >= StartDate) &&( oldP<= EndDate)){
                sdqpsiFClients.add(client);
            }
            if((oldS >= StartDate) &&(oldS <= EndDate)){
                sdqpsiFClients.add(client);
            }
            if((psi >= StartDate) &&(psi <= EndDate)){
                sdqpsiFClients.add(client);
            }
        }
        return sdqpsiFClients;
    }
    
    /****
    * @description get the client ids of tscc bs in range
    * called from getAssessmentClients()
    * @param none
    * @return Set<String> tsccaycBClients
    ****/
    public Set<String> getTsccAYcBClients(){
        Set<String> tsccaycBClients = new Set<String>();
        List<DS_TSCC_TSCYC_B__c>  tsccBList = [SELECT Client__c,BDOATSCC__c, BDOATSCYC__c
                                            FROM DS_TSCC_TSCYC_B__c];
                                    
        for(DS_TSCC_TSCYC_B__c tb : tsccBList){
            String client = String.valueOf(tb.Client__c);
            Date old = Date.valueOf(tb.BDOATSCC__c);
            Date young = Date.valueOf(tb.BDOATSCYC__c);
            
            if((old >= StartDate) &&(old <= EndDate)){
                tsccaycBClients.add(client);
            }
            if((young >= StartDate) &&( young<= EndDate)){
                tsccaycBClients.add(client);
            }
        }
        return tsccaycBClients;
    }
    
    /****
    * @description get the client ids of tscc/yc fs in range
    * called from getAssessmentClients()
    * @param none
    * @return Set<String> tsccaycBClients
    ****/
    public Set<String> getTsccAYcFClients(){
        Set<String> tsccaycFClients = new Set<String>();
        List<DS_TSCC_TSCYC_F__c>  tsccFList = [SELECT Client__c,FDOATSCC__c, FDOATSCYC__c
                                                FROM DS_TSCC_TSCYC_F__c];
                                        
        for(DS_TSCC_TSCYC_F__c tf : tsccFList){
            String client = String.valueOf(tf.Client__c);
            Date old = Date.valueOf(tf.FDOATSCC__c);
            Date young = Date.valueOf(tf.FDOATSCYC__c);
            
            if((old >= StartDate) &&(old <= EndDate)){
                tsccaycFClients.add(client);
            }
            if((young >= StartDate) &&( young<= EndDate)){
                tsccaycFClients.add(client);
            }
        }
        return tsccaycFClients;
    }
    
}