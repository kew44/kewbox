/****
*@description Controller for PSI Report Page
* 
*@date 2/18/16
*@modified date
*@author KW
*Purpose: Remove validity scores from clinical/normal/borderline range lists
*update validity to use 'Invalid' instead of 'Clinical'
*
*@date 2/26/16
*@modified date
*@author KW
*Purpose: Condense logic
*found potential issue w/ borderline classification
*
*@date 2/29/16
*@modified date
*@author KW
*Purpose: Exclude scores below 15 from significance
*
*@date 3/3/16
*@modified date
*@author KW
*Purpose: Clinical range is inclusive (>=85)
*
*@date 3/4/16
*@modified date
*@author KW
*Purpose: fix ranges
*
*@modified    4/22/16    KW    999 condition
*
*@modified    4/28/16    KW    validity range string
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
    public String Str_DR{get;set;}    
    
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
        public Integer PSIDR_PTLE {get;set;}//dr %ile
        
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
        cimi = Apexpages.currentPage().getParameters().get('cimi');

        visits = new List<Visit>();
        
        // Set the obj name 
        form.setObjName('DS_SDQ_PSI_CDI_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();        
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('PSI');
        bfVariableMap.put('DOAPSI',   form.BorF+'DOAPSI__c');
        
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
            
        //Map types and text
        Map<String, String> C_Scale_Text = new Map<String,String>();
        
        //map text
        C_Scale_Text.put('TS','Total Stress');
        C_Scale_Text.put('PD','Parental Distress');
        C_Scale_Text.put('PCDI','Parent-Child Dysfunctional Interaction');
        C_Scale_Text.put('DC','Difficult Child');
    
        //list alerts for types of scoretypes   
        List<String> clinicalList = new List<String>();
        List<String> borderlineList = new List<String>();
        List<String> normalList = new List<String>(); 
        
        //init var for scores
        Integer C_Value; 
        
        //init var for text
        String C_Text;         
        
        for(String t : C_Scale_Text.keySet()){
                            
            //set value
            C_Value =Integer.valueOf(form.obj.get(form.BorF+'PSI'+t+'_PTLE__c'));

            //set text
            C_Text = String.valueOf(C_Scale_Text.get(t));
            
            if(C_Value >= 15){
                //assign text to range lists
                if(C_Value <= 80){
                    normalList.add(C_Text);             
                }
                else if(C_Value >=85){
                    if(C_Value != 999){
                        clinicalList.add(C_Text);
                    }
                }
                else{
                    borderlineList.add(C_Text);
                }
            }
            /*else if((1 < C_Value) && (C_Value < 15)){
                below "Normal" range, do not add to any list
            }*/
        }
        
        //rejoin the lists
        clinicalRange = String.join(clinicalList, ', ');
        borderlineRange= String.join(borderlineList, ', ');
        normalRange= String.join(normalList, ', ');
        
        //Validity score set to string, not lists
        //Defensive Responding    (DR)     
         if( Integer.valueOf(form.obj.get(form.BorF+'PSIDR__c')) == 999){
             Str_DR = 'Not Available';
         }
         else if( Integer.valueOf(form.obj.get(form.BorF+'PSIDR__c')) <= 10){
             Str_DR = 'Clinically Significant';
         }
         else{
            Str_DR = 'Normal';
         }
                 
        return obj;
    }
    
    public void getAssesmentHistory() {
        
        //query baseline
        List<SObject> baseline = 
            Database.query('SELECT ' + form.ut.getFields('DS_SDQ_PSI_CDI_B__c') +   
                           '  FROM DS_SDQ_PSI_CDI_B__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'');
        
        addVisit(baseline, 'B',Str_DR);
              
        //query follow-ups             
        List<SObject> followup = 
            Database.query('SELECT ' + form.ut.getFields('DS_SDQ_PSI_CDI_F__c') +   
                           '  FROM DS_SDQ_PSI_CDI_F__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'' +
                           ' ORDER BY FDOAPSI__c, SECTION__c');
        
        if(followup.size() > 0){
            addVisit(followup, 'F',Str_DR);
        }
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
            
                if(visit.DOAPSI != null){
                    visits.add(visit);        
                }
            }
     }       
            
    //edit button function
    public PageReference editRecord() {
        
        PageReference psiPage = new PageReference('/apex/DS_PSI?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        psiPage.setRedirect(true);
        
        return psiPage;
        
    }
}