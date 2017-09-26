/**
* @author Kelsey Willett
* @date 12/1/16
*
* @group Report Builder
* @group-content /ApexDocContent/ReportBuilder.htm
*
* @description An apex class to set framework for custom reports object records
*/
public class ReportBuilder {
/*
    public static Strategic_Reports__c makeNewReport(
														//client info
														String clientId,
														//age info
														//Integer cAge, 
														String  ageGroup,
														Boolean age0_4, Boolean age5_9, Boolean age10_12, Boolean age13_17, Boolean age18_21,
														//gender info
														String  genIdentity,  
														Boolean genMale, Boolean genFemale, Boolean genTrans, Boolean genOther,  Boolean genUnknown,  Boolean genMissing,
														//ethnicity info
														String  ethnicGroup,  
														Boolean ethnicHispanic, Boolean ethnicNonHispanic,  Boolean ethnicUnknown,  Boolean ethnicMissing, 
														//race info
														String  raceGroup,  
														Boolean raceBlack,  Boolean raceWhite,  Boolean raceAINAK, Boolean raceAsian,  Boolean raceHIOPI,  Boolean raceUnkNR,  Boolean raceMulti,  
														//military info
														Boolean milAssociated, 
														//services info
														Boolean treatMissing,  Boolean treatEnded, Boolean treatAsPlanned
													){
													
			Strategic_Reports__c makeNewReport = 
							new Strategic_Reports__c(
														//client info
														Client__c =  clientId,
														//age info
														//Age_Current_Age__c = cAge, 
														Age_Group__c = ageGroup,
														Age_Group_0_4__c = age0_4, Age_Group_5_9__c = age5_9, Age_Group_10_12__c = age10_12, Age_Group_13_17__c = age13_17, Age_Group_18_21__c = age18_21,
														//gender info
														Gender_Identity__c = genIdentity,
														Gender_Female__c = genFemale, Gender_Male__c = genMale, Gender_Missing__c = genMissing, Gender_Other__c = genOther, Gender_Refused_or_Unknown__c = genUnknown, Gender_Transgender__c = genTrans,
														//ethnicity info
														Ethnic_Group__c = ethnicGroup,
														Ethnicity_Hispanic_or_Latino__c = ethnicHispanic, Ethnicity_Missing__c = ethnicMissing, Ethnicity_Non_Hispanic__c = ethnicNonHispanic, Ethnicity_Refused_or_Unknown__c = ethnicUnknown,
														//race info
														Race__c = raceGroup,
														Race_American_Indian_or_Alaskan_Native__c = raceAINAK, Race_Asian__c = raceAsian, Race_Black_African_American__c = raceBlack, Race_Multiracial__c = raceMulti, Race_Native_Hawaiian_or_Pacific_Islander__c = raceHIOPI, Race_Refused_or_Unknown__c = raceUnkNR, Race_White__c = raceWhite,
														//military info
														Military_Associated__c = milAssociated, 
														//services info
														Treatment_Completed_as_Planned__c = treatAsPlanned, Treatment_Ended__c = treatEnded, Treatment_Missing__c = treatMissing 
													);
													//Age_Enrolled__c = eAge,Treatment_Clinical_Assessment__c = treatClinical, Military_Missing__c = milMissing,Treatment_of_a_New_Client__c = treatNew, Treatment_Receiving_Services__c = treatServices									
            
			return makeNewReport;
    }
    
    //client record info
    public SObject client { get; set; }
    public String cId{get;set;}
    public Id clientId{get;set;}
    public List<SObject> clients {get;set;}
    
    //background object records
    public List<SObject> backBs {get;set;}
    public List<SObject>  backFs {get;set;}
    public SObject backB {get;set;}
    public SObject backF {get;set;}
    
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
    public List<Date> dateMinMax{get;set;}
    
    //age
    public Map<String, Integer> AgeMap{get;set;}
    public Integer cAge {get;set;}
	public Integer eAge {get;set;}
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
    public Boolean ethnicMissing{get;set;}
    
    //gender
    public String genIdentity{get;set;}
    public Boolean genMale{get;set;}
    public Boolean genFemale{get;set;}
    public Boolean genTrans{get;set;}
    public Boolean genOther{get;set;}
    public Boolean genUnknown{get;set;}
    public Boolean genMissing{get;set;}
    
    //military
    public Boolean milAssociated{get;set;}
    public Boolean milMissing{get;set;}
    
    //treatment
	public Boolean treatEnded{get;set;}
	public Boolean treatClinical{get;set;}
	public Boolean treatNew{get;set;}
	public Boolean treatServices{get;set;}
    public Boolean treatAsPlanned{get;set;}
    public Boolean treatMissing{get;set;}
    
    //custom report records
    public Strategic_Reports__c existing {get;set;}
    public Strategic_Reports__c newCustomReport {get;set;}
    
    //duplicates
    public Boolean hasExisting{get;set;}
                
    public void cocap(List<SObject> obj){
        
       // List <Id> cids;
        List <String> objIds = new List<String>();
        String clientObjId;
        
        for(Sobject o: obj){
            System.debug(o.get('Client__c'));
            clientObjId=String.valueOf(o.get('Client__c'));
            System.debug(clientObjId);
            objIds.add(clientObjId);
        }
        System.debug(objIds);
        
        //clients info
        List<SObject> clients = [SELECT id, Clinician__c, Center__c, Age__c, CURRENT_AGE__c, INIT__c
                                    FROM Client__c
                                    WHERE id IN : objIds];
                                    
        System.debug(clients);
        
        //list of cocap records
        List<Strategic_Reports__c> custReports = new List<Strategic_Reports__c>();
                   
        client = clients.get(0);
        clientId = client.id;
        System.debug(clientId);
      //  cId = String.valueOf(clientId);
       // System.debug(cId);
        System.debug(clients.size());
        System.debug(Client);        
                
        //declare date list
        List<Date> dateList = new List<Date>();
        
        //lists for all object records
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
                                WHERE Client__c  =: clientId]; 
                                
        System.debug(backBs);
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
                    dateList.add(bbDate);
                }               
            }
        }
        System.debug(backB);
                                
        List<SObject> backFs = [SELECT Client__c,FDOV__c, FUTYPE__c, FETSTAT__c, FMSTAT__c
                                FROM DS_Background_Family_Info_F__c
                                WHERE Client__c  =: clientId
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
                    dateList.add(bfDate);
                }
            }
        }
        
        List<SObject> cbclBs = [SELECT Client__c,BDOACO__c, BDOACY__c
                                FROM DS_CBCL_B__c
                                WHERE Client__c  =: clientId];
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
                    dateList.add(cObDate);
                }
                if(cYbDate != null){
                    dateList.add(cYbDate);
                }
            }
        }
        
        List<SObject> cbclFs = [SELECT Client__c,FDOACO__c, FDOACY__c
                                FROM DS_CBCL_F__c
                                WHERE Client__c  =: clientId
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
                    dateList.add(cOfDate);
                }
                if(cYfDate != null){
                    dateList.add(cYfDate);
                }
            }
        }
        
        List<SObject> ptsdBs = [SELECT Client__c,BDOAPTSD__c
                                FROM DS_PTSD_CA_B__c
                                WHERE Client__c  =: clientId];
        //test that list of this object is not empty
        if((ptsdBs.size()>0)){
            
            //for the list
            for(SObject pb : ptsdBs){
                ptsdB = ptsdBs.get(0);              
                //get the date(s)
                pbDate = date.valueOf(pb.get('BDOAPTSD__c'));
                
                //add to date list
                if(pbDate != null){
                    dateList.add(pbDate);
                }

            }
        }
        
        List<SObject> ptsdFs = [SELECT Client__c,FDOAPTSD__c
                                FROM DS_PTSD_CA_F__c
                                WHERE Client__c  =: clientId
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
                    dateList.add(pfDate);
                }

            }
        }
        
        List<SObject> sdqBs = [SELECT Client__c,BDOAPSI__c
                               FROM DS_SDQ_PSI_CDI_B__c
                               WHERE Client__c  =: clientId];
        //test that list of this object is not empty
        if((sdqBs.size()>0)){
            sdqB = sdqBs.get(0);
            //for the list
            for(SObject sb : sdqBs){                
                //get the date(s)
                sbDate = date.valueOf(sb.get('BDOAPSI__c'));
                
                //add to date list
                if(sbDate != null){
                    dateList.add(sbDate);
                }       

            }
        }
        
        List<SObject> sdqFs = [SELECT Client__c,FDOAPSI__c
                               FROM DS_SDQ_PSI_CDI_F__c
                               WHERE Client__c  =: clientId
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
                    dateList.add(sfDate);
                }
            }
        }
        
        List<Sobject> tsccBs = [SELECT Client__c,BDOATSCC__c, BDOATSCYC__c
                                FROM DS_TSCC_TSCYC_B__c         
                                WHERE Client__c  =: clientId];
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
                    dateList.add(tAbDate);
                }
                if(tObDate != null){
                    dateList.add(tObDate);
                }

            }
        }
        
        List<Sobject> tsccFs = [SELECT Client__c,FDOATSCC__c, FDOATSCYC__c
                                FROM DS_TSCC_TSCYC_F__c         
                                WHERE Client__c  =: clientId
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
                    dateList.add(tAfDate);
                }
                if(tOfDate != null){
                    dateList.add(tOfDate);
                }                   
            }
        }   
        
        System.debug(backB);
        System.debug(client);
        System.debug(dateList);
        System.debug(backF);
        
        findDuplicate(client);
        System.debug(hasExisting);
        
        System.debug(dateList);
        findDate(dateList);
        
        findGender(backB);
        System.debug(genIdentity);
        findAge(client);
        System.debug(AgeGroup);
        
        System.debug(dateEarliest);
        System.debug(mostRecent);
        findRace(backB);
        System.debug(raceGroup);
        findEthnic(backB);
        System.debug(ethnicGroup);
        System.debug(ethnicMissing);
        findMilitary(backB, backF);
        System.debug(milAssociated);
        System.debug(client);
        findServices(backF);
        
            System.debug(clientId);
            System.debug(client);
            //age
            System.debug(cAge);
            System.debug(AgeGroup);
            System.debug(age0_4);
            System.debug(age5_9);
            System.debug(age10_12);
            System.debug(age13_17);
            System.debug(age18_21);
            //date
            System.debug(mostRecent);
            System.debug(dateEarliest);
            //ethnic
            System.debug(ethnicGroup);
            System.debug(ethnicHispanic);
            System.debug(ethnicNonHispanic);
            System.debug(ethnicUnknown);
            //gender
            System.debug(genIdentity);
            System.debug(genMale);
            System.debug(genFemale);
            System.debug(genTrans);
            System.debug(genOther);
            System.debug(genUnknown);
            //military
            System.debug(milAssociated);
            //race
            System.debug(raceGroup);
            System.debug(raceBlack);
            System.debug(raceWhite);
            System.debug(raceAINAK);
            System.debug(raceAsian);
            System.debug(raceHIOPI);
            System.debug(raceUnkNR);
            System.debug(raceMulti);
            //treatment
            System.debug(treatEnded);
            System.debug(treatAsPlanned);
            
            Id id;
			String cid = String.valueOf(clientId);
			
        
        //build new report record
        newCustomReport = makeNewReport(
											//client info
											cid,
											//age info
											//cAge, 
											ageGroup,
											age0_4, age5_9, age10_12, age13_17, age18_21,
											//gender info
											genIdentity,
											genFemale, genMale, genMissing, genOther, genUnknown, genTrans,
											//ethnicity info
											ethnicGroup,
											ethnicHispanic, ethnicMissing, ethnicNonHispanic, ethnicUnknown,
											//race info
											raceGroup,
											raceAINAK, raceAsian, raceBlack, raceMulti, raceHIOPI, raceUnkNR, raceWhite,
											//military info
											milAssociated, 
											//services info
											treatAsPlanned, treatEnded, treatMissing
										);		
            
        //if there is an existing report
        if (existing != null){
            newCustomReport.id= existing.Id;
        }
        //get the id of the existing record
        //add the id to the new report
        //add updated value to the list
        //update list
        System.debug(newCustomReport);
        
        System.debug(genMissing);
        System.debug(milMissing);
        System.debug(treatMissing);
        
        //add client to record
        newCustomReport.put('Client__c', cId);
        
        
        newCustomReport.put('Gender_Missing__c', genMissing);
        newCustomReport.put('Military_Missing__c', milMissing);
        newCustomReport.put('Treatment_Missing__c', treatMissing);
        System.debug(newCustomReport);
        
        custReports.add(newCustomReport);
        System.debug(custReports);
        
        System.debug(existing);
        
        
        if (existing != null){
            System.debug('Update');
            System.debug(custReports);
            update custReports;
        }
        else{
            System.debug('Insert');
            System.debug(custReports);
            insert custReports;
        }
        
    }
    
    //duplicate method
    public void findDuplicate(SObject client){
        hasExisting = FALSE;
        cId = String.valueOf(client.id);
        
        //check for duplicates per client
        List<Strategic_Reports__c> existingReports = [SELECT Id,		
														//client info
														Client__c,
														//age info
														//Age_Current_Age__c,
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
                                                    FROM Strategic_Reports__c
                                                    WHERE Client__c =: cId];
        //check if exists
        //makeNewReport
        if(existingReports.size() >0) {
            hasExisting = TRUE;
            existing = existingReports.get(0);
        }
      //  return hasExisting;
    }
   
   //find earliest and latest dates for client using dateList
    public void findDate(List<Date> dateList){
        System.debug(dateList);
        
        //sort ascending
        dateList.sort();
        
        //local dates
        Date dateMin;
        Date dateMax;
        List<Date> dateMinMax = new List<Date>();
        
        //more than one date
        if(dateList.size()>1){
            dateMin = dateList.get(dateList.size()-1);
            dateMax = dateList.get(0);
        }
        //only one date in list
        else if(dateList.size() ==1){
            //min and max same
            dateMin = dateList.get(0);
            dateMax = dateList.get(0);
        }
        
        //add locals to list
        dateMinMax.add(dateMin);
        dateMinMax.add(dateMax);
        
        //should only be 2
        mostRecent= dateMax;
        dateEarliest = dateMin;
        
        System.debug('Treatment from '+dateEarliest +'to '+mostRecent);
        
    }
    public void findAge(SObject client){
        cAge = Integer.valueOf(client.get('CURRENT_AGE__c'));
		eAge = Integer.valueOf(client.get('Age__c'));
        
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
        System.debug(AgeGroup);
    }
    //find race using baseline background info record
    public void findRace(SObject backB){
        
        //set races to false
        raceBlack = FALSE;
        raceWhite = FALSE; 
        raceAINAK  = FALSE;
        raceAsian  = FALSE;
        raceHIOPI  = FALSE;
        raceUnkNR  = FALSE;
        raceMulti  = FALSE;
        
        //count nubmer of races indicated
        Integer raceCount = 0;
        
        //Native American/Alaskan
        if( (backB.get('RINDIAN__c') ==TRUE) || (backB.get('RAKNTV__c') == TRUE)){
            raceGroup = 'American Indian/Native Alaskan';
            raceAINAK = TRUE; 
            raceCount = raceCount +1;
        }
        //Asian
        if( (backB.get('RASIANIN__c') ==TRUE) || (backB.get('RCHINESE__c') == TRUE) || (backB.get('RFILIPINO__c') == TRUE) || (backB.get('RJAPANESE__c') == TRUE) || (backB.get('RKOREAN__c') == TRUE) || (backB.get('RVIETNAMESE__c') == TRUE) || (backB.get('ROASIAN__c') == TRUE)){
            raceGroup = 'Asian';
            raceAsian = TRUE; 
            raceCount = raceCount +1;
        }
        //black
        if( backB.get('RBLACK__c') ==TRUE){
            raceGroup = 'Black/African American';
            raceBlack = TRUE; 
            raceCount = raceCount +1;
        }
        //Hawaiian/Pacific Islander
        if( (backB.get('RHAWAN__c') ==TRUE) || (backB.get('RGUAM__c') == TRUE) || (backB.get('RSAMOA__c') == TRUE) || (backB.get('ROPI__c') == TRUE)){
            raceGroup = 'Native Hawaiian/Other Pacific Islander';
            raceHIOPI = TRUE; 
            raceCount = raceCount +1;
        }
        //white
        if( backB.get('RWHITE__c') ==TRUE){
            raceGroup = 'White';
            raceWhite = TRUE; 
            raceCount = raceCount +1;
        }
        //unknown/not reported
        if( (backB.get('RREF__c') ==TRUE) || (backB.get('RUNK__c') == TRUE)){
            raceGroup = 'Unknown or Not Reported';
            raceUnkNR = TRUE; 
            raceCount = raceCount +1;
        }
        //multi
        if( raceCount > 1){
            raceGroup = 'Multiracial';
            raceMulti  = TRUE; 
            
            //reset races
            raceBlack = FALSE;
            raceWhite = FALSE; 
            raceAINAK  = FALSE;
            raceAsian  = FALSE;
            raceHIOPI  = FALSE;
            raceUnkNR  = FALSE;
        }
        
       System.debug(backB);
       System.debug(raceCount);        
       System.debug(raceCount);        
       System.debug(raceGroup);
       System.debug(raceGroup);     
    }
    public void findEthnic(SObject backB){
    
        //get value entered
        Integer ethVal = Integer.valueOf(backB.get('ETHNIC__c'));
        
        //set to false
        ethnicNonHispanic = FALSE;
        ethnicHispanic = FALSE;
        ethnicUnknown = FALSE;
        ethnicMissing = FALSE;
        
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
        else{
            ethnicGroup = 'Ethnicity is Missing';
            ethnicMissing = TRUE;
        }
        
        System.debug(ethnicMissing);
        System.debug(ethnicGroup);
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
    public void findMilitary(SObject backB, SObject backF){
        System.debug(backB);
        System.debug(backF);
        milAssociated = FALSE;
        milMissing = FALSE;
        
        //in:bmilfamily, bmilself, fmstat
        Integer bFam = Integer.valueOf(backB.get('BMILFAMILY__c'));
        Integer bSelf = Integer.valueOf(backB.get('BMILSELF__c'));
        Integer fMil; 
        if(backF != null){
            fMil = Integer.valueOf(backF.get('FMSTAT__c'));
        }
        if(
           ((bFam == 1) || (bFam ==2)) 
           || (bSelf == 1)
           || (fMil == 1)
           ){
            milAssociated = TRUE;
        }
        else if((bFam == null) || (bSelf ==null) || (fMil == null)){
            milMissing = TRUE;
        }
        
        System.debug(milMissing);
        System.debug(milAssociated);
    }
    public void findServices(SObject backF){
        treatEnded = FALSE;
        treatAsPlanned = FALSE;
        treatMissing = FALSE;
        if(backF != null){
            if((backF.get('FUTYPE__c') == 2)){
                treatEnded = TRUE;
                if((backF.get('FETSTAT__c') == 1)){
                    treatAsPlanned = TRUE;
                    System.debug('Treatment completed as planned.');
                }
            }
        }
        else{
            treatMissing = TRUE;
        }        
    }  */      
}