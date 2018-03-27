public with sharing class DS_SDQ_S_11_17_Report_Controller extends DS_BasicForm_Controller {
    
    public String clinicalRange{ get; set; }
    public String borderlineRange{ get; set; }
    public String missingRange{ get; set; }
    
    //variables for displaying historical scores
    public String cimi { get; set; }  
    
    public Boolean printReport { get; set; }    
    
    public Boolean displayHistory { get; set; }    
    
    public List<Visit> visits { get; set; }    
    
   // Datetime currentVisitDate = null;    
    
    public class Visit {
        
        public String SECTION { get; set; }
        public String currentVisit { get; set; }  
        public String BorF {get;set;}
        public Date DOASDOS {get;set;}
        
        //scores and types
        //total
        public Integer SDSTOT { get; set; }
        public String SDSTYP { get; set; }
        //emotional
        public Integer SDSEMO { get; set; }
        public String SDSETYP { get; set; }
        //behavioral
        public Integer SDSBEH { get; set; }
        public String SDSBTYP { get; set; }
        //hyperactivity
        public Integer SDSHYP { get; set; }
        public String SDSHTYP { get; set; }
        //peer
        public Integer SDSOTC { get; set; }
        public String SDSOTYP { get; set; }
        //prosocial
        public Integer SDSKHB { get; set; }
        public String SDSKTYP { get; set; }
        //impact
        public Integer SDSDCL { get; set; }
        public String SDSITYP { get; set; }
        
        public visit() {
            this.currentVisit = null;
        }
        
    }
    
    //print report button
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
    
    public DS_SDQ_S_11_17_Report_Controller(ApexPages.StandardController controller) {
        
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
        bfVariableMap = form.getVariable('SDQ_S_11_17');     
        
        //add stray variables to map
        bfVariableMap.put('DOASDOS',   form.BorF+'DOASDOS__c');  //there is no young version of self
        bfVariableMap.put('SDSTYP',   form.BorF+'SDSTYP__c');  
        bfVariableMap.put('SDSETYP',   form.BorF+'SDSETYP__c');  
        bfVariableMap.put('SDSBTYP',   form.BorF+'SDSBTYP__c');  
        bfVariableMap.put('SDSHTYP',   form.BorF+'SDSHTYP__c');
        bfVariableMap.put('SDSOTYP',   form.BorF+'SDSOTYP__c');  
        bfVariableMap.put('SDSKTYP',   form.BorF+'SDSKTYP__c'); 
        bfVariableMap.put('SDSITYP',   form.BorF+'SDSITYP__c');
        
        //Date tempVisitDate
        Date tempVisitDate = Date.valueOf(form.obj.get(form.BorF+'DOASDOS__c'));
        
        //currentVisitDate         
       // currentVisitDate = (form.BorF == 'F') ? Datetime.newInstance(tempVisitDate, time.newInstance(0,0,0,0)) : null;
        
        getAssesmentHistory();
        
        // Display history
        displayHistory = (visits.size() > 1) ? true : false;
        
        //Lists display above chart and are used in conditional formatting
        //list alerts for types of scoretypes   
        List<String> clinicalRangeList = new List<String>();
        List<String> borderlineList = new List<String>();
        List<String> missingList = new List<String>();       
        
        //strings of scoretypes
        String OverAll = String.valueOf(form.obj.get(form.BorF+'SDSTYP__c'));
        String EmoSym = String.valueOf(form.obj.get(form.BorF+'SDSETYP__c'));
        String BehDif = String.valueOf(form.obj.get(form.BorF+'SDSBTYP__c'));
        String Adhd = String.valueOf(form.obj.get(form.BorF+'SDSHTYP__c'));
        String DiffChld = String.valueOf(form.obj.get(form.BorF+'SDSOTYP__c'));
        String KindBeh = String.valueOf(form.obj.get(form.BorF+'SDSKTYP__c'));
        String ImpLife = String.valueOf(form.obj.get(form.BorF+'SDSITYP__c'));
        
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
            clinicalRangeList.add('Hyperactivity-Inattention');
        else if (Adhd == 'Borderline')
            borderlineList.add('Hyperactivity-Inattention'); 
        else if (Adhd == 'Missing/Incomplete')
            missingList.add('Hyperactivity-Inattention'); 
        
        //Peer Problems
        if (DiffChld == 'Clinical')
            clinicalRangeList.add('Peer Problems');
        else if (DiffChld == 'Borderline')
            borderlineList.add('Peer Problems'); 
        else if (DiffChld == 'Missing/Incomplete')
            missingList.add('Peer Problems'); 
        
        //Prosocial (formerly kind & helpful behaviors)
        if (KindBeh == 'Clinical')
            clinicalRangeList.add('Prosocial Behavior');
        else if (KindBeh == 'Borderline')
            borderlineList.add('Prosocial Behavior'); 
        
        //Impact on life
        if (ImpLife == 'Clinical')
            clinicalRangeList.add('Impact of Difficulties');
        else if (ImpLife == 'Borderline')
            borderlineList.add('Impact of Difficulties'); 
        else if (ImpLife == 'Missing/Incomplete')
            missingList.add('Impact of Difficulties'); 
        
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
                           'ORDER BY FDOASDOS__c, SECTION__c');
        
        if(followup.size() > 0) addVisit(followup, 'F');
        
    }
    
    //add visit function
    public void addVisit(List<SObject> sdq, String BorF) {
        
        for(SObject s :sdq){
            
            Visit visit = new visit();
            
            //ignore any previous visits where the child did not have a self eval
            if(Date.valueOf(s.get(BorF+'DOASDOS__c')) != null){
            
                visit.BorF    = BorF;
                visit.SECTION = String.valueOf(s.get('SECTION__c'));
                visit.DOASDOS= Date.valueOf(s.get(BorF+'DOASDOS__c'));//there is no young version of self
                
                visit.SDSTOT = Integer.valueOf(s.get(BorF+'SDSTOT__c'));
                visit.SDSTYP = String.valueOf(s.get(BorF+'SDSTYP__c'));
                visit.SDSEMO = Integer.valueOf(s.get(BorF+'SDSEMO__c'));
                visit.SDSETYP = String.valueOf(s.get(BorF+'SDSETYP__c'));
                visit.SDSBEH = Integer.valueOf(s.get(BorF+'SDSBEH__c'));
                visit.SDSBTYP = String.valueOf(s.get(BorF+'SDSBTYP__c'));
                visit.SDSHYP = Integer.valueOf(s.get(BorF+'SDSHYP__c'));
                visit.SDSHTYP = String.valueOf(s.get(BorF+'SDSHTYP__c'));
                visit.SDSOTC = Integer.valueOf(s.get(BorF+'SDSOTC__c'));
                visit.SDSOTYP = String.valueOf(s.get(BorF+'SDSOTYP__c'));
                visit.SDSKHB = Integer.valueOf(s.get(BorF+'SDSKHB__c'));
                visit.SDSKTYP = String.valueOf(s.get(BorF+'SDSKTYP__c'));
                visit.SDSDCL = Integer.valueOf(s.get(BorF+'SDSDCL__c'));
                visit.SDSITYP = String.valueOf(s.get(BorF+'SDSITYP__c'));
                
                visits.add(visit);
            }
        }
        //add all to visit
    }
    
    //edit button function
    public PageReference editRecord() {
        
        PageReference nextPage = new PageReference('/apex/DS_SDQ_S_11_17?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        nextPage.setRedirect(true);
        
        return nextPage;
        
    }
}