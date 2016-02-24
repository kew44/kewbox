/****
*@description Controller for PSI Report Page
* 
*@date 2/18/16
*@modified date
*@author KW
*Purpose: Remove validity scores from clinical/normal/borderline range lists
*update validity to use 'Invalid' instead of 'Clinical'
*
*@group Assessment
*@group-content /ApexDocContent/Assessment/DS_PSI_Report_Controller.htm
****/
public with sharing class DS_PSI_Report_Controller extends DS_BasicForm_Controller {
    
    public String clinicalRange{get; set; }
    public String borderlineRange{get; set; }
    public String normalRange{get; set; }
    
    //variables for displaying historical scores
    public String cimi { get; set; }  
    
    public Boolean printReport { get; set; }    
    
    public Boolean displayHistory { get; set; }   
    
    public List<Visit> visits { get; set; } 
    
    public Integer SectionNum {get;set;}
    
    Datetime currentVisitDate = null;
    
    //public alias scoretype string                    
    public String Str_DR {get;set;}       
    
    public class Visit {
        
        public String SECTION { get; set; }
        public String currentVisit { get; set; }  
        public Date DOAPSI {get;set;}
        public String BorF {get;set;}
        public Integer PSIPD {get;set;}
        public Integer PSIPD_PTLE {get;set;}
        public Integer PSIPCDI {get;set;}
        public Integer PSIPCDI_PTLE {get;set;}
        public Integer PSIDC {get;set;}
        public Integer PSIDC_PTLE {get;set;}
        public Integer PSITS {get;set;}
        public Integer PSITS_PTLE {get;set;}
        public Integer PSIDR {get;set;}
        public Integer PSIDR_PTLE {get;set;}
        
        //alias score type    
        public String DR{get;set;}
        
        public visit() {
            this.currentVisit = null;
        }
        
    }
     
    //print report button
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
    
    public DS_PSI_Report_Controller(ApexPages.StandardController controller) {
    
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
        bfVariableMap = form.getVariable('PSI');
        
        Date tempVisitDate = Date.valueOf(form.obj.get(form.BorF+'DOAPSI__c'));
        
        currentVisitDate = (form.BorF == 'F') ? Datetime.newInstance(tempVisitDate, time.newInstance(0,0,0,0)) : null;
        
        //getAssessmentHistory must be called before displayHistory to enable charts
        getAssesmentHistory();
        
        // Display history
        displayHistory = (visits.size() > 1) ? true : false;
        
        //determine the scoretype range of each score and add to corresponding list
        getScoreType(form.obj);      
                
        SectionNum = Integer.valueOf(form.obj.get('SECTION__c'));
        
    }
    
    public SObject getScoreType(SObject obj){
    
        //list alerts for types of scoretypes   
        List<String> clinicalList = new List<String>();
        List<String> borderlineList = new List<String>();
        List<String> normalList = new List<String>(); 
        
        //Total Stress    (TS)
        if( (15 <= Integer.valueOf(form.obj.get(form.BorF+'PSITS_PTLE__c'))) && (Integer.valueOf(form.obj.get(form.BorF+'PSITS_PTLE__c')) <=80 ) ){
            normalList.add('Total Stress');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'PSITS_PTLE__c')) >85){
            clinicalList.add('Total Stress');
        }
        else{
            borderlineList.add('Total Stress');
        }
        
        //Parental Distress (PD)     
        if( (15 <= Integer.valueOf(form.obj.get(form.BorF+'PSIPD_PTLE__c'))) && (Integer.valueOf(form.obj.get(form.BorF+'PSIPD_PTLE__c')) <=80 ) ){
            normalList.add('Parental Distress');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'PSIPD_PTLE__c')) >85){
            clinicalList.add('Parental Distress');
        }
        else{
            borderlineList.add('Parental Distress');
        }
        
        //Parent-Child Dysfunctional Interaction (P-CDI)       
        if( (15 <= Integer.valueOf(form.obj.get(form.BorF+'PSIPCDI_PTLE__c'))) && (Integer.valueOf(form.obj.get(form.BorF+'PSIPCDI_PTLE__c')) <=80 )) {
            normalList.add('Parent-Child Dysfunctional Interaction');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'PSIPD_PTLE__c')) >85){
            clinicalList.add('Parent-Child Dysfunctional Interaction');
        }
        else{
            borderlineList.add('Parent-Child Dysfunctional Interaction');
        }
        
        //Difficult Child (DC)         
        if( (15 <= Integer.valueOf(form.obj.get(form.BorF+'PSIDC_PTLE__c'))) && (Integer.valueOf(form.obj.get(form.BorF+'PSIDC_PTLE__c')) <=80 )) {
            normalList.add('Difficult Child');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'PSIDC_PTLE__c')) >85){
            clinicalList.add('Difficult Child');
        }
        else{
            borderlineList.add('Difficult Child');
        }
        
        //Defensive Responding    (DR)      
        if( (15 <= Integer.valueOf(form.obj.get(form.BorF+'PSIDR_PTLE__c'))) && (Integer.valueOf(form.obj.get(form.BorF+'PSIDR_PTLE__c')) <=80 )) {
            Str_DR = 'Normal';
         //   normalList.add('Defensive Responding');
        } 
        else if(Integer.valueOf(form.obj.get(form.BorF+'PSIDR_PTLE__c')) >85){
            Str_DR = 'Invalid';
         //   clinicalList.add('Defensive Responding');
        }
        else{
            Str_DR = 'Borderline';
         //   borderlineList.add('Defensive Responding');
        }    
        
        //rejoin the lists
        clinicalRange = String.join(clinicalList, ', ');
        borderlineRange= String.join(borderlineList, ', ');
        normalRange= String.join(normalList, ', ');
        
        return obj;
    }
    
    public void getAssesmentHistory() {
        
        List<SObject> baseline = 
            Database.query('SELECT ' + form.ut.getFields('DS_SDQ_PSI_CDI_B__c') +   
                           '  FROM DS_SDQ_PSI_CDI_B__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'');
        
        addVisit(baseline, 'B',Str_DR);
                         
        List<SObject> followup = 
            Database.query('SELECT ' + form.ut.getFields('DS_SDQ_PSI_CDI_F__c') +   
                           '  FROM DS_SDQ_PSI_CDI_F__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'' +
                           ' ORDER BY FDOAPSI__c, SECTION__c');
        
        if(followup.size() > 0) addVisit(followup, 'F',Str_DR);
        
    }
    
    public void addVisit(List<SObject> psi, String BorF, String Str_DR) {
        
        for(Sobject p : psi) {
            
            Visit visit = new visit();
            
            visit.SECTION      = String.valueOf(p.get('SECTION__c'));
            visit.DOAPSI       = Date.valueOf(p.get(BorF+'DOAPSI__c'));
            visit.BorF         = BorF;
            visit.PSIPD        = Integer.valueOf(p.get(BorF+'PSIPD__c'));
            visit.PSIPD_PTLE   = Integer.valueOf(p.get(BorF+'PSIPD_PTLE__c'));
            visit.PSIPCDI      = Integer.valueOf(p.get(BorF+'PSIPCDI__c'));
            visit.PSIPCDI_PTLE = Integer.valueOf(p.get(BorF+'PSIPCDI_PTLE__c'));             
            visit.PSIDC        = Integer.valueOf(p.get(BorF+'PSIDC__c'));
            visit.PSIDC_PTLE   = Integer.valueOf(p.get(BorF+'PSIDC_PTLE__c'));
            visit.PSITS        = Integer.valueOf(p.get(BorF+'PSITS__c'));
            visit.PSITS_PTLE   = Integer.valueOf(p.get(BorF+'PSITS_PTLE__c'));
            visit.PSIDR        = Integer.valueOf(p.get(BorF+'PSIDR__c'));
            visit.PSIDR_PTLE   = Integer.valueOf(p.get(BorF+'PSIDR_PTLE__c'));
            
            //alias score type
            visit.DR    =Str_DR;
            
            visits.add(visit);
            
            }
     }       
            
    //edit button function
    public PageReference editRecord() {
        
        PageReference psiPage = new PageReference('/apex/DS_PSI?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        psiPage.setRedirect(true);
        
        return psiPage;
        
    }
}