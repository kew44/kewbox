public class CustomReportBuilder {

	
	Utility ut = new Utility();
	String cId;
	
	public Client__c client { get; set; }
	
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
    	
	public List<Date> dateList{get;set;}
    
    public void getRaw(){
	
        //get list of clients
        List<Client__c> clients = [SELECT id, Clinician__c, Center__c, Age__c, CURRENT_AGE__c
                                    FROM Client__c];
    
        System.debug(clients);
        
        //get list of client ids only
        List<String> cids = new List<String>();	
        String cid;
        
        for (Client__c c : clients){
            cid = String.valueOf(c.id);
            cids.add(cid);
            //call here?
        }
        System.debug(cids);
        System.debug(cid);
	
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
                                WHERE Client__c IN : cids];
        
        List<SObject> backFs = [SELECT FUTYPE__c, FETSTAT__c, FMSTAT__c
                                FROM DS_Background_Family_Info_F__c
                                WHERE client__c IN : cids
                               ORDER BY SECTION__c DESC];
        
        List<SObject> cbclBs = [SELECT BDOACO__c, BDOACY__c
                                FROM DS_CBCL_B__c
                                WHERE client__c IN : cids];
        
        List<SObject> cbclFs = [SELECT FDOACO__c, FDOACY__c
                                FROM DS_CBCL_F__c
                                WHERE client__c IN : cids
                               ORDER BY SECTION__c DESC];
        
        List<SObject> ptsdBs = [SELECT BDOAPTSD__c
                                FROM DS_PTSD_CA_B__c
                                WHERE client__c IN : cids];
        
        List<SObject> ptsdFs = [SELECT FDOAPTSD__c
                                FROM DS_PTSD_CA_F__c
                                WHERE client__c IN : cids
                               ORDER BY SECTION__c DESC];
        
        //using sdq for object name even though psi values are querried now
        List<SObject> sdqBs = [SELECT BDOAPSI__c
                               FROM DS_SDQ_PSI_CDI_B__c
                               WHERE client__c IN : cids];
        
        List<SObject> sdqFs = [SELECT FDOAPSI__c
                               FROM DS_SDQ_PSI_CDI_F__c
                               WHERE client__c IN : cids
                               ORDER BY SECTION__c DESC];
        
        List<Sobject> tsccBs = [SELECT BDOATSCC__c, BDOATSCYC__c
                                FROM DS_TSCC_TSCYC_B__c			
                                WHERE Client__c  IN : cids];
        
        List<Sobject> tsccFs = [SELECT FDOATSCC__c, FDOATSCYC__c
                                FROM DS_TSCC_TSCYC_F__c			
                                WHERE Client__c  IN : cids
                               ORDER BY SECTION__c DESC];
        
        //if not null, get baseline values        
        	//for followups, order by section descending, then get 0. this presumes that sections are in date order
        
        if (backBs.size()>0){
            backB = backBs.get(0);
        }
        if (backFs.size()>0){
            backF = backFs.get(0);
        }
        if (cbclBs.size()>0){
            cbclB = cbclBs.get(0);
        }
        if (cbclFs.size()>0){
            cbclF = cbclFs.get(0);
        }
        if (ptsdBs.size()>0){
            ptsdB = ptsdBs.get(0);
        }
        if (ptsdFs.size()>0){
            ptsdF = ptsdFs.get(0);
        }
        if (sdqBs.size()>0){
            sdqB = sdqBs.get(0);
        }
        if (sdqFs.size()>0){
            sdqF = sdqFs.get(0);
        }
        if (tsccBs.size()>0){
            tsccB = tsccBs.get(0);
        }
        if (tsccFs.size()>0){
            tsccF = tsccFs.get(0);
        }
        
        System.debug(backB);
        System.debug(backF);
        System.debug(cbclB);
        System.debug(cbclF);
        System.debug(ptsdB);
        System.debug(ptsdF);
        System.debug(sdqB);
        System.debug(sdqF);
        System.debug(tsccB);
        System.debug(tsccF);
    }
    public void findDate(){        
        //in:
            //	takes a list of dates, sorts by most recent, maps to quarter number, returns
            //	? just most recent
        //out:
    }    		
    public void findRace(){
        //in:
        //out:
    }
    public void findGender(){
        //in:
        //out:
    }
    public void findAge(){
        //in:
        //out:
    }
    public void findMilitary(){
        //in:
        //out:
    }
    public void findServices(){
        //in:
        //out:
    }
    public void findEthnic(){
        //in:
        //out:
    }
    
    public Custom_Reporting__c createNew(Custom_Reporting__c report){

		//prevent duplicates-add client field to report object, but do not show in report
		/*	for c in clients
				run other methods*/
		return report;
	}
}