public with sharing class DS_SDQ_P_O_B_Report_Controller extends DS_BasicForm_Controller  {
   
  public String clinicalRange{get; set; }
  public String borderlineRange{get; set; }
  public String missingRange{get; set; }
  
    //variables for displaying historical scores
    public String cimi { get; set; }  
    
    public Boolean printReport { get; set; }    
    
    public Boolean displayHistory { get; set; }    
    
    public List<Visit> visits { get; set; }    
    
    Datetime currentVisitDate = null;    
    
    public class Visit {
        
        public String SECTION { get; set; }
        public String currentVisit { get; set; }  
        public String BorF {get;set;}
        public Date DOASDOP {get;set;}
        
        //scores and types
        //total
        public Integer SDPTOT { get; set; }
        public String SDPTYP { get; set; }
        //emotional
        public Integer SDPEMO { get; set; }
        public String SDPETYP { get; set; }
        //behavioral
        public Integer SDPBEH { get; set; }
        public String SDPBTYP { get; set; }
        //hyperactivity
        public Integer SDPHYP { get; set; }
        public String SDPHTYP { get; set; }
        //peer
        public Integer SDPOTC { get; set; }
        public String SDPOTYP { get; set; }
        //prosocial
        public Integer SDPKHB { get; set; }
        public String SDPKTYP { get; set; }
        //impact
        public Integer SDPDCL { get; set; }
        public String SDPITYP { get; set; }
            
        public visit() {
            this.currentVisit = null;
        }
        
    }
    
    //print report button
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
        
    public DS_SDQ_P_O_B_Report_Controller(ApexPages.StandardController controller) {

    // Initilize the DS_BasicForm_Controller
    super(Apexpages.currentPage().getParameters().get('cimi'));
        
    //redundant cimi?
    cimi = Apexpages.currentPage().getParameters().get('cimi');
        
    visits = new List<Visit>();
    
    // Set the obj name 
    form.setObjName('DS_SDQ_PSI_CDI_'+form.BorF+'__c');
    
    // Get the object record into form.obj
    form.getObjRecord();
    
    // Get field name from DS_DATA (variable)
    bfVariableMap = form.getVariable('SDQ_P_11_17');//SCORES_PARENT'); 
    
    //add stray variables to map
    bfVariableMap.put('DOASDOP',   form.BorF+'DOASDOP__c');  
    bfVariableMap.put('SDPTYP',   form.BorF+'SDPTYP__c');  
    bfVariableMap.put('SDPETYP',   form.BorF+'SDPETYP__c');  
    bfVariableMap.put('SDPBTYP',   form.BorF+'SDPBTYP__c');  
    bfVariableMap.put('SDPHTYP',   form.BorF+'SDPHTYP__c');
    bfVariableMap.put('SDPOTYP',   form.BorF+'SDPOTYP__c');  
    bfVariableMap.put('SDPKTYP',   form.BorF+'SDPKTYP__c'); 
    bfVariableMap.put('SDPITYP',   form.BorF+'SDPITYP__c');
                
        //Date tempVisitDate
        Date tempVisitDate = Date.valueOf(form.obj.get(form.BorF+'DOASDOP__c'));
        
        //currentVisitDate         
        currentVisitDate = (form.BorF == 'F') ? Datetime.newInstance(tempVisitDate, time.newInstance(0,0,0,0)) : null;
        
        getAssesmentHistory();
                
        // Display history
        displayHistory = (visits.size() > 1) ? true : false;
       
    //Lists display above chart and are used in conditional formatting
       //list alerts for types of scoretypes   
        List<String> clinicalRangeList = new List<String>();
        List<String> borderlineList = new List<String>();
        List<String> missingList = new List<String>();    

        //strings of scoretypes
        String OverAll = String.valueOf(form.obj.get(form.BorF+'SDPTYP__c'));
        String EmoSym = String.valueOf(form.obj.get(form.BorF+'SDPETYP__c'));
        String BehDif = String.valueOf(form.obj.get(form.BorF+'SDPBTYP__c'));
        String Adhd = String.valueOf(form.obj.get(form.BorF+'SDPHTYP__c'));
        String DiffChld = String.valueOf(form.obj.get(form.BorF+'SDPOTYP__c'));
        String KindBeh = String.valueOf(form.obj.get(form.BorF+'SDPKTYP__c'));
        String ImpLife = String.valueOf(form.obj.get(form.BorF+'SDPITYP__c'));
    
        //if scoretype = string value, add subtitle label to the correct list
    
        //Total
        if (OverAll  == 'Clinical')
        clinicalRangeList.add('Total Difficulties');
        else if (OverAll  == 'Borderline')
        borderlineList.add('Total Difficulties'); 
        else if (OverAll  == 'Missing/Incomplete')
        missingList.add('Total Difficulties'); 
    
        //Emotional
        if (EmoSym == 'Clinical')
        clinicalRangeList.add('Emotional Problems');
        else if (EmoSym == 'Borderline')
        borderlineList.add('Emotional Problems'); 
        else if (EmoSym == 'Missing/Incomplete')
        missingList.add('Emotional Problems'); 
    
        //Behavioral
        if (BehDif == 'Clinical')
        clinicalRangeList.add('Behavioral Difficulties');
        else if (BehDif == 'Borderline')
        borderlineList.add('Behavioral Difficulties'); 
        else if (BehDif == 'Missing/Incomplete')
        missingList.add('Behavioral Difficulties'); 
    
        //Hyperactivity
        if (Adhd == 'Clinical')
        clinicalRangeList.add('Hyperactivity');
        else if (Adhd == 'Borderline')
        borderlineList.add('Hyperactivity'); 
        else if (Adhd == 'Missing/Incomplete')
        missingList.add('Hyperactivity'); 
        
        //Peer Problems
        if (DiffChld == 'Clinical')
        clinicalRangeList.add('Peer Problems');
        else if (DiffChld == 'Borderline')
        borderlineList.add('Peer Problems'); 
        else if (DiffChld == 'Missing/Incomplete')
        missingList.add('Peer Problems'); 
        
        //Prosocial (formerly kind & helpful behaviors)
        if (KindBeh == 'Clinical')
        clinicalRangeList.add('Prosocial');
        else if (KindBeh == 'Borderline')
        borderlineList.add('Prosocial'); 
        
        //Impact on life
        if (ImpLife == 'Clinical')
        clinicalRangeList.add('Impact');
        else if (ImpLife == 'Borderline')
        borderlineList.add('Impact'); 
        else if (ImpLife == 'Missing/Incomplete')
        missingList.add('Impact'); 
    
        //rejoin the lists
        clinicalRange = String.join(clinicalRangeList, ', ');
        borderlineRange= String.join(borderlineList, ', ');
        missingRange= String.join(missingList, ', ');
        }
        
    //historical scores function
    public void getAssesmentHistory() {
   
        //query baseline
        List<SObject> baseline=
            Database.query('SELECT ' + form.ut.getFields('DS_SDQ_PSI_CDI_B__c') + 
                           '  FROM DS_SDQ_PSI_CDI_B__c' +                           
                           ' WHERE Client__c =\''+ form.cID + '\'');
        
        addVisit(baseline, 'B');
        
    //query follow-ups
        List<SObject> followup=
            Database.query('SELECT ' + form.ut.getFields('DS_SDQ_PSI_CDI_F__c') +   
                           '  FROM DS_SDQ_PSI_CDI_F__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\''+
                           'ORDER BY FDOASDOP__c, SECTION__c');
        
        if(followup.size() > 0) addVisit(followup, 'F');
        
    }
    
    //add visit function
    public void addVisit(List<SObject> sdq, String BorF) {
    
        for(SObject s :sdq){
            
            Visit visit = new visit();
            
            visit.BorF    = BorF;
            visit.SECTION = String.valueOf(s.get('SECTION__c'));
            visit.DOASDOP= Date.valueOf(s.get(BorF+'DOASDOP__c'));
            
            visit.SDPTOT = Integer.valueOf(s.get(BorF+'SDPTOT__c'));
            visit.SDPTYP = String.valueOf(s.get(BorF+'SDPTYP__c'));
            visit.SDPEMO = Integer.valueOf(s.get(BorF+'SDPEMO__c'));
            visit.SDPETYP = String.valueOf(s.get(BorF+'SDPETYP__c'));
            visit.SDPBEH = Integer.valueOf(s.get(BorF+'SDPBEH__c'));
            visit.SDPBTYP = String.valueOf(s.get(BorF+'SDPBTYP__c'));
            visit.SDPHYP = Integer.valueOf(s.get(BorF+'SDPHYP__c'));
            visit.SDPHTYP = String.valueOf(s.get(BorF+'SDPHTYP__c'));
            visit.SDPOTC = Integer.valueOf(s.get(BorF+'SDPOTC__c'));
            visit.SDPOTYP = String.valueOf(s.get(BorF+'SDPOTYP__c'));
            visit.SDPKHB = Integer.valueOf(s.get(BorF+'SDPKHB__c'));
            visit.SDPKTYP = String.valueOf(s.get(BorF+'SDPKTYP__c'));
            visit.SDPDCL = Integer.valueOf(s.get(BorF+'SDPDCL__c'));
            visit.SDPITYP = String.valueOf(s.get(BorF+'SDPITYP__c'));
            
            visits.add(visit);
        }
    //add all to visit
    }

//edit button function
    public PageReference editRecord() {
        
        PageReference sdqPage = new PageReference('/apex/DS_SDQ_P_11_17?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        sdqPage.setRedirect(true);
        
        return sdqPage;
        
    }
}