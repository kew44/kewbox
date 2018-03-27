/**
* @author Danny Fu
* @date 02/23/2016
* @modified date
*
* @group PTSD
* @group-content /ApexDocContent/PTSD/PTSD_children_report.htm
*
* @description An apex controller class for PTSD Reaction Index for Children/Adolescents Report.
* 
*/
public with sharing class DS_PTSD_CA_Report_Controller extends DS_BasicForm_Controller {
    
    public String cimi { get; set; }
    
    public Boolean printReport { get; set; }
    
    public Boolean displayHistory { get; set; }
    
    public List<Visit> visits { get; set; }
    
    Datetime currentVisitDate = null;
    
    public class Visit {
        
        public String SECTION { get; set; }
        public String currentVisit { get; set; }  
        public Date DOAPTSD {get;set;}
        public String BorF {get;set;}
        public Integer PTSOCN {get;set;}
        public Integer PTSORN {get;set;}
        public Integer PTSBRN { get;set; }
        public Integer PTSBMN { get; set; }
        public Integer PTSCRN { get;set; }
        public Integer PTSCMN { get;set; }
        public Integer PTSDRN { get;set; }
        public Integer PTSDMN { get;set; }
        public Integer PTSERN { get;set; }
        public Integer PTSEMN { get;set; }
        public String PTSDURA { get;set; }
        public Boolean PTSDC { get;set; }
        public Boolean PTSFC { get;set; }
        public Integer PTSVDSN { get;set; }
        public Integer PTSAPPCN { get; set; }
        
        // Symptom B Intrusion
        public Integer PTSAB1 { get; set; }
        public Integer PTSAB2 { get; set; }
        public Integer PTSAB3 { get; set; }
        public Integer PTSAB4 { get; set; }
        public Integer PTSAB5 { get; set; }
        
        // Symptom C Avoidance
        public Integer PTSAC1 { get; set; }
        public Integer PTSAC2 { get; set; }
        
        // Symptom D Negative Alterations in Cognitions/Mood
        public Integer PTSAD1 { get; set; }
        public Integer PTSAD2 { get; set; }
        public Integer PTSAD3 { get; set; }
        public Integer PTSAD4 { get; set; }
        public Integer PTSAD5 { get; set; }
        public Integer PTSAD6 { get; set; }
        public Integer PTSAD7 { get; set; }
        
        // Symptom E Alterations in Arousal/Reactivity
        public Integer PTSAE1 { get; set; }
        public Integer PTSAE2 { get; set; }
        public Integer PTSAE3 { get; set; }
        public Integer PTSAE4 { get; set; }
        public Integer PTSAE5 { get; set; }
        public Integer PTSAE6 { get; set; }
        
        // Clinician Assessment: Functional Impairment
        public Boolean PTSFHC { get; set; }
        public Boolean PTSFSC { get; set; }
        public Boolean PTSFRC { get; set; }
        public Boolean PTSFPC { get; set; }
        
        // Presence of one or more Dissociative Symtoms
        public Integer PTSVDA1 { get; set; }
        public Integer PTSVDA2 { get; set; }
        
        public visit() {
            this.currentVisit = null;
        }
        
    }
    
    /****
    * @description Initilization for print button 
    * @return null
    */
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
    
    /****
    * @description Constructor, gather form information, assessment history. 
    * @param controller ApexPages.StandardController
    * @return null
    */
    public DS_PTSD_CA_Report_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        cimi = Apexpages.currentPage().getParameters().get('cimi');
        
        visits = new List<Visit>();
        
        // Set the obj name 
        form.setObjName('DS_PTSD_CA_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('PTSD_SCORES');
        
        bfVariableMap.put('PTSFHC',   form.BorF+'PTSFHC__c');
        bfVariableMap.put('PTSFSC',   form.BorF+'PTSFSC__c');
        bfVariableMap.put('PTSFRC',   form.BorF+'PTSFRC__c');
        bfVariableMap.put('PTSFPC',   form.BorF+'PTSFPC__c');
        bfVariableMap.put('DOAPTSD',  form.BorF+'DOAPTSD__c');
        bfVariableMap.put('PTSDURA',  form.BorF+'PTSDURA__c');
        bfVariableMap.put('PTSDC',    form.BorF+'PTSDC__c');
        bfVariableMap.put('PTSFC',    form.BorF+'PTSFC__c');
        bfVariableMap.put('PTSVDSN',  form.BorF+'PTSVDSN__c');
        
        Date tempVisitDate = Date.valueOf(form.obj.get(form.BorF+'DOAPTSD__c'));
        
        currentVisitDate = (form.BorF == 'F') ? Datetime.newInstance(tempVisitDate, time.newInstance(0,0,0,0)) : null;
        
        // Assessment history       
        getAssesmentHistory();
        
        // Display history
        displayHistory = (visits.size() > 1) ? true : false;
        
    }
    
    /****
    * @description Get the baseline and follow-up assessment history. 
    * @return null
    */
    public void getAssesmentHistory() {
        
        List<SObject> baseline = 
            Database.query('SELECT ' + form.ut.getFields('DS_PTSD_CA_B__c') +   
                           '  FROM DS_PTSD_CA_B__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'' +
                           '   AND STATUS_PTSD_CA__c != null');
        
        addVisit(baseline, 'B');
        
        List<SObject> followup = 
            Database.query('SELECT ' + form.ut.getFields('DS_PTSD_CA_F__c') +   
                           '  FROM DS_PTSD_CA_F__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'' +
                           '   AND STATUS_PTSD_CA__c != null' +
                           //'   AND FDOAPTSD__c <= ' + currentVisitDate.format('yyyy-MM-dd') +  
                           ' ORDER BY FDOAPTSD__c, SECTION__c');
        
        if(followup.size() > 0) addVisit(followup, 'F');
        
    }
    
    /****
    * @description Add the visit data into the visits list. 
    * @param ptsd list of the ptsd SObject
    * @param BorF baseline of follow-up
    * @return null
    */
    public void addVisit(List<SObject> ptsd, String BorF) {
        
        for(Sobject p : ptsd) {
            
            Visit visit = new visit();
            
            visit.SECTION   = String.valueOf(p.get('SECTION__c'));
            visit.DOAPTSD   = Date.valueOf(p.get(BorF+'DOAPTSD__c'));
            visit.BorF      = BorF;
            visit.PTSOCN    = Integer.valueOf(p.get(BorF+'PTSOCN__c'));
            visit.PTSORN    = Integer.valueOf(p.get(BorF+'PTSORN__c'));
            visit.PTSBRN    = Integer.valueOf(p.get(BorF+'PTSBRN__c'));
            visit.PTSBMN    = Integer.valueOf(p.get(BorF+'PTSBMN__c'));
            visit.PTSCRN    = Integer.valueOf(p.get(BorF+'PTSCRN__c'));
            visit.PTSCMN    = Integer.valueOf(p.get(BorF+'PTSCMN__c'));
            visit.PTSDRN    = Integer.valueOf(p.get(BorF+'PTSDRN__c'));
            visit.PTSDMN    = Integer.valueOf(p.get(BorF+'PTSDMN__c'));
            visit.PTSERN    = Integer.valueOf(p.get(BorF+'PTSERN__c'));
            visit.PTSEMN    = Integer.valueOf(p.get(BorF+'PTSEMN__c'));
            visit.PTSDURA   = String.valueOf(p.get(BorF+'PTSDURA__c'));
            visit.PTSDC     = Boolean.valueOf(p.get(BorF+'PTSDC__c'));
            visit.PTSFC     = Boolean.valueOf(p.get(BorF+'PTSFC__c'));
            visit.PTSVDSN   = Integer.valueOf(p.get(BorF+'PTSVDSN__c'));
            visit.PTSAPPCN  = Integer.valueOf(p.get(BorF+'PTSAPPCN__c'));
            
            // Symptom B Intrusion
            visit.PTSAB1 = Integer.valueOf(p.get(BorF+'PTSAB1__c'));
            visit.PTSAB2 = Integer.valueOf(p.get(BorF+'PTSAB2__c'));
            visit.PTSAB3 = Integer.valueOf(p.get(BorF+'PTSAB3__c'));
            visit.PTSAB4 = Integer.valueOf(p.get(BorF+'PTSAB4__c'));
            visit.PTSAB5 = Integer.valueOf(p.get(BorF+'PTSAB5__c'));
            
            // Symptom C Avoidance
            visit.PTSAC1 = Integer.valueOf(p.get(BorF+'PTSAC1__c'));
            visit.PTSAC2 = Integer.valueOf(p.get(BorF+'PTSAC2__c'));
            
            // Symptom D Negative Alterations in Cognitions/Mood
            visit.PTSAD1 = Integer.valueOf(p.get(BorF+'PTSAD1__c'));
            visit.PTSAD2 = Integer.valueOf(p.get(BorF+'PTSAD2__c'));
            visit.PTSAD3 = Integer.valueOf(p.get(BorF+'PTSAD3__c'));
            visit.PTSAD4 = Integer.valueOf(p.get(BorF+'PTSAD4__c'));
            visit.PTSAD5 = Integer.valueOf(p.get(BorF+'PTSAD5__c'));
            visit.PTSAD6 = Integer.valueOf(p.get(BorF+'PTSAD6__c'));
            visit.PTSAD7 = Integer.valueOf(p.get(BorF+'PTSAD7__c'));
            
            // Symptom E Alterations in Arousal/Reactivity
            visit.PTSAE1 = Integer.valueOf(p.get(BorF+'PTSAE1__c'));
            visit.PTSAE2 = Integer.valueOf(p.get(BorF+'PTSAE2__c'));
            visit.PTSAE3 = Integer.valueOf(p.get(BorF+'PTSAE3__c'));
            visit.PTSAE4 = Integer.valueOf(p.get(BorF+'PTSAE4__c'));
            visit.PTSAE5 = Integer.valueOf(p.get(BorF+'PTSAE5__c'));
            visit.PTSAE6 = Integer.valueOf(p.get(BorF+'PTSAE6__c'));
            
            // Clinician Assessment: Functional Impairment
            visit.PTSFHC = Boolean.valueOf(p.get(BorF+'PTSFHC__c'));
            visit.PTSFSC = Boolean.valueOf(p.get(BorF+'PTSFSC__c'));
            visit.PTSFRC = Boolean.valueOf(p.get(BorF+'PTSFRC__c'));
            visit.PTSFPC = Boolean.valueOf(p.get(BorF+'PTSFPC__c'));
            
            // Presence of one or more Dissociative Symtoms
            visit.PTSVDA1 = Integer.valueOf(p.get(BorF+'PTSVDA1__c'));
            visit.PTSVDA2 = Integer.valueOf(p.get(BorF+'PTSVDA2__c'));
            
            visits.add(visit);
            
        }
        
    }
    
    /****
    * @description Redirect for the edit button 
    * @return PageReference
    */
    public PageReference editRecord() {
        
        PageReference ptsdPage = new PageReference('/apex/DS_PTSD_CA?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        ptsdPage.setRedirect(true);
        
        return ptsdPage;
        
    }
    
}