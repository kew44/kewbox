/**
* The controller class for PTSD Reaction Index for Parent/Caregiver Report
* 
**/

public with sharing class DS_PTSD_PA_Report_Controller extends DS_BasicForm_Controller {
	
    public String cimi { get; set; }
    
    public Boolean printReport { get; set; }
    
    public Boolean displayHistory { get; set; }
    
    public List<Visit> visits { get; set; }
    
    Datetime currentVisitDate = null;
    
    public class Visit {
        
        public String SECTION { get; set; }
        public String currentVisit { get; set; }  
        public Date DOAPTSDP {get;set;}
        public String BorF {get;set;}
        public Integer PTSOCNP {get;set;}
        public Integer PTSORNP {get;set;}
        public Integer PTSBRNP { get;set; }
        public Integer PTSBMNP { get; set; }
        public Integer PTSCRNP { get;set; }
        public Integer PTSCMNP { get;set; }
        public Integer PTSDRNP { get;set; }
        public Integer PTSDMNP { get;set; }
        public Integer PTSERNP { get;set; }
        public Integer PTSEMNP { get;set; }
        public String PTSDURAP { get;set; }
        public Boolean PTSDCP { get;set; }
        public Boolean PTSFCP { get;set; }
        public Integer PTSVDSNP { get;set; }
        public Integer PTSAPPCNP { get; set; }
        
        // Symptom B Intrusion
        public Integer PTSAB1P { get; set; }
        public Integer PTSAB2P { get; set; }
        public Integer PTSAB3P { get; set; }
        public Integer PTSAB4P { get; set; }
        public Integer PTSAB5P { get; set; }
        
        // Symptom C Avoidance
        public Integer PTSAC1P { get; set; }
        public Integer PTSAC2P { get; set; }
        
        // Symptom D Negative Alterations in Cognitions/Mood
        public Integer PTSAD1P { get; set; }
        public Integer PTSAD2P { get; set; }
        public Integer PTSAD3P { get; set; }
        public Integer PTSAD4P { get; set; }
        public Integer PTSAD5P { get; set; }
        public Integer PTSAD6P { get; set; }
        public Integer PTSAD7P { get; set; }
        
        // Symptom E Alterations in Arousal/Reactivity
        public Integer PTSAE1P { get; set; }
        public Integer PTSAE2P { get; set; }
        public Integer PTSAE3P { get; set; }
        public Integer PTSAE4P { get; set; }
        public Integer PTSAE5P { get; set; }
        public Integer PTSAE6P { get; set; }
        
        // Clinician Assessment: Functional Impairment
        public Boolean PTSFHCP { get; set; }
        public Boolean PTSFSCP { get; set; }
        public Boolean PTSFRCP { get; set; }
        public Boolean PTSFPCP { get; set; }
        
        // Presence of one or more Dissociative Symtoms
        public Integer PTSVDA1P { get; set; }
        public Integer PTSVDA2P { get; set; }
        
        public visit() {
            this.currentVisit = null;
        }
        
    }
    
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
    
    public DS_PTSD_PA_Report_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        cimi = Apexpages.currentPage().getParameters().get('cimi');
        
        visits = new List<Visit>();
        
        // Set the obj name 
        form.setObjName('DS_PTSD_CA_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('PTSD_SCORES_PA');
        
        bfVariableMap.put('PTSFHCP',   form.BorF+'PTSFHCP__c');
        bfVariableMap.put('PTSFSCP',   form.BorF+'PTSFSCP__c');
        bfVariableMap.put('PTSFRCP',   form.BorF+'PTSFRCP__c');
        bfVariableMap.put('PTSFPCP',   form.BorF+'PTSFPCP__c');
        bfVariableMap.put('DOAPTSDP',  form.BorF+'DOAPTSDP__c');
        bfVariableMap.put('PTSDURAP',  form.BorF+'PTSDURAP__c');
        bfVariableMap.put('PTSDCP',    form.BorF+'PTSDCP__c');
        bfVariableMap.put('PTSFCP',    form.BorF+'PTSFCP__c');
        bfVariableMap.put('PTSVDSNP',  form.BorF+'PTSVDSNP__c');
        
        System.debug(form);
        
        Date tempVisitDate = Date.valueOf(form.obj.get(form.BorF+'DOAPTSDP__c'));
        
        System.debug(form);
        
        currentVisitDate = (form.BorF == 'F') ? Datetime.newInstance(tempVisitDate, time.newInstance(0,0,0,0)) : null;
        
        // Assessment history
        //historyExisted = (currentVisitDate != null) ? true : false;
        
        getAssesmentHistory();
        
        // Display history
        displayHistory = (visits.size() > 1) ? true : false;
        
    }
    
    public void getAssesmentHistory() {
        
        List<SObject> baseline = 
            Database.query('SELECT ' + form.ut.getFields('DS_PTSD_CA_B__c') +   
                           '  FROM DS_PTSD_CA_B__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'' +
                           '   AND STATUS_PTSD_PA__c != null');
        
        addVisit(baseline, 'B');
        
        List<SObject> followup = 
            Database.query('SELECT ' + form.ut.getFields('DS_PTSD_CA_F__c') +   
                           '  FROM DS_PTSD_CA_F__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'' +
                           '   AND STATUS_PTSD_PA__c != null' +
                           //'   AND FDOAPTSD__c <= ' + currentVisitDate.format('yyyy-MM-dd') +  
                           ' ORDER BY FDOAPTSDP__c, SECTION__c');
        
        if(followup.size() > 0) addVisit(followup, 'F');
        
    }
    
    public void addVisit(List<SObject> ptsd, String BorF) {
        
        for(Sobject p : ptsd) {
            
            Visit visit = new visit();
            
            visit.SECTION   = String.valueOf(p.get('SECTION__c'));
            visit.DOAPTSDP   = Date.valueOf(p.get(BorF+'DOAPTSDP__c'));
            visit.BorF      = BorF;
            visit.PTSOCNP    = Integer.valueOf(p.get(BorF+'PTSOCNP__c'));
            visit.PTSORNP    = Integer.valueOf(p.get(BorF+'PTSORNP__c'));
            visit.PTSBRNP    = Integer.valueOf(p.get(BorF+'PTSBRNP__c'));
            visit.PTSBMNP   = Integer.valueOf(p.get(BorF+'PTSBMNP__c'));
            visit.PTSCRNP    = Integer.valueOf(p.get(BorF+'PTSCRNP__c'));
            visit.PTSCMNP    = Integer.valueOf(p.get(BorF+'PTSCMNP__c'));
            visit.PTSDRNP    = Integer.valueOf(p.get(BorF+'PTSDRNP__c'));
            visit.PTSDMNP    = Integer.valueOf(p.get(BorF+'PTSDMNP__c'));
            visit.PTSERNP    = Integer.valueOf(p.get(BorF+'PTSERNP__c'));
            visit.PTSEMNP    = Integer.valueOf(p.get(BorF+'PTSEMNP__c'));
            visit.PTSDURAP   = String.valueOf(p.get(BorF+'PTSDURAP__c'));
            visit.PTSDCP     = Boolean.valueOf(p.get(BorF+'PTSDCP__c'));
            visit.PTSFCP     = Boolean.valueOf(p.get(BorF+'PTSFCP__c'));
            visit.PTSVDSNP   = Integer.valueOf(p.get(BorF+'PTSVDSNP__c'));
            visit.PTSAPPCNP  = Integer.valueOf(p.get(BorF+'PTSAPPCNP__c'));
            
            // Symptom B Intrusion
            visit.PTSAB1P = Integer.valueOf(p.get(BorF+'PTSAB1P__c'));
            visit.PTSAB2P = Integer.valueOf(p.get(BorF+'PTSAB2P__c'));
            visit.PTSAB3P = Integer.valueOf(p.get(BorF+'PTSAB3P__c'));
            visit.PTSAB4P = Integer.valueOf(p.get(BorF+'PTSAB4P__c'));
            visit.PTSAB5P = Integer.valueOf(p.get(BorF+'PTSAB5P__c'));
            
            // Symptom C Avoidance
            visit.PTSAC1P = Integer.valueOf(p.get(BorF+'PTSAC1P__c'));
            visit.PTSAC2P = Integer.valueOf(p.get(BorF+'PTSAC2P__c'));
            
            // Symptom D Negative Alterations in Cognitions/Mood
            visit.PTSAD1P = Integer.valueOf(p.get(BorF+'PTSAD1P__c'));
            visit.PTSAD2P = Integer.valueOf(p.get(BorF+'PTSAD2P__c'));
            visit.PTSAD3P = Integer.valueOf(p.get(BorF+'PTSAD3P__c'));
            visit.PTSAD4P = Integer.valueOf(p.get(BorF+'PTSAD4P__c'));
            visit.PTSAD5P = Integer.valueOf(p.get(BorF+'PTSAD5P__c'));
            visit.PTSAD6P = Integer.valueOf(p.get(BorF+'PTSAD6P__c'));
            visit.PTSAD7P = Integer.valueOf(p.get(BorF+'PTSAD7P__c'));
            
            // Symptom E Alterations in Arousal/Reactivity
            visit.PTSAE1P = Integer.valueOf(p.get(BorF+'PTSAE1P__c'));
            visit.PTSAE2P = Integer.valueOf(p.get(BorF+'PTSAE2P__c'));
            visit.PTSAE3P = Integer.valueOf(p.get(BorF+'PTSAE3P__c'));
            visit.PTSAE4P = Integer.valueOf(p.get(BorF+'PTSAE4P__c'));
            visit.PTSAE5P = Integer.valueOf(p.get(BorF+'PTSAE5P__c'));
            visit.PTSAE6P = Integer.valueOf(p.get(BorF+'PTSAE6P__c'));
            
            // Clinician Assessment: Functional Impairment
            visit.PTSFHCP = Boolean.valueOf(p.get(BorF+'PTSFHCP__c'));
            visit.PTSFSCP = Boolean.valueOf(p.get(BorF+'PTSFSCP__c'));
            visit.PTSFRCP = Boolean.valueOf(p.get(BorF+'PTSFRCP__c'));
            visit.PTSFPCP = Boolean.valueOf(p.get(BorF+'PTSFPCP__c'));
            
            // Presence of one or more Dissociative Symtoms
            visit.PTSVDA1P = Integer.valueOf(p.get(BorF+'PTSVDA1P__c'));
            visit.PTSVDA2P = Integer.valueOf(p.get(BorF+'PTSVDA2P__c'));
            
            visits.add(visit);
            
        }
        
    }
    
    public PageReference editRecord() {
        
        PageReference ptsdPage = new PageReference('/apex/DS_PTSD_PA?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        ptsdPage.setRedirect(true);
        
        return ptsdPage;
        
    }
    
}