/****
*@description Controller for TSCYC Report Page
* 
*@date 2/18/16
*@modified date
*@author KW
*Purpose: Remove validity scores from clinical/normal/borderline range lists
*update validity to use 'Invalid' instead of 'Clinical'
*
*@date 2/25-26/16
*@modified date
*@author KW
*Purpose: Condense logic
*
*@date 3/4/16
*@modified date
*@author KW
*Purpose: fix ranges
*
*@group Assessment
*@group-content /ApexDocContent/Assessment/DS_TSCYC_Report_Controller.htm
****/
public with sharing class DS_TSCYC_Report_Controller extends DS_BasicForm_Controller {
    
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
    
    //public alias scoretype strings                    
    public String Str_RL {get;set;}             
    public String Str_ATR {get;set;}  
    
    public class Visit {
        
        public String SECTION { get; set; }
        public String currentVisit { get; set; } 
        public Date DOATSCYC {get;set;}   
        public String BorF {get;set;}
        public Integer ANX_T{get;set;}
        public Integer DEP_T{get;set;}
        public Integer DIS_T{get;set;}
        public Integer ANG_T{get;set;}
        public Integer SC_T{get;set;}
        public Integer PTSI_T{get;set;}
        public Integer PTSAV_T{get;set;}
        public Integer PTSAR_T{get;set;}
        public Integer PTSTOT_T{get;set;}
        public Integer RL_T{get;set;}
        public Integer ATR_T{get;set;}
        
        //alias score types                           
        public String RL{get;set;}            
        public String ATR{get;set;} 
    
        public visit() {
            this.currentVisit = null;
        }
        
    }
     
    //print report button
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
    
    public DS_TSCYC_Report_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        cimi = Apexpages.currentPage().getParameters().get('cimi');

        visits = new List<Visit>();
        
        // Set the obj name 
        form.setObjName('DS_TSCC_TSCYC_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('TSCYC');
        bfVariableMap.put('DOATSCYC',   form.BorF+'DOATSCYC__c');
        
        Date tempVisitDate = Date.valueOf(form.obj.get(form.BorF+'DOATSCYC__c'));
        
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
        C_Scale_Text.put('PTSTOT','Posttraumatic Stress-Total');
        C_Scale_Text.put('ANX','Anxiety');
        C_Scale_Text.put('DEP','Depression');
        C_Scale_Text.put('ANG','Anger');
        C_Scale_Text.put('SC','Sexual Concerns');
        C_Scale_Text.put('DIS','Dissociation');
        C_Scale_Text.put('PTSI','Posttraumatic Stress-Intrusion');
        C_Scale_Text.put('PTSAV','Posttraumatic Stress-Avoidance');
        C_Scale_Text.put('PTSAR','Posttraumatic Stress-Arousal');
    
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
            C_Value =Integer.valueOf(form.obj.get(form.BorF+t+'_T__c'));

            //set text
            C_Text = String.valueOf(C_Scale_Text.get(t));
            
            //assign text to range lists
            if(C_Value <= 64){
                normalList.add(C_Text);
            }
            else if(C_Value >=70){
                clinicalList.add(C_Text);
            }
            else{
                borderlineList.add(C_Text);
            }                      
        }
        
        //rejoin the lists
        clinicalRange = String.join(clinicalList, ', ');
        borderlineRange= String.join(borderlineList, ', ');
        normalRange= String.join(normalList, ', ');
        
        //Validity scores are set to strings, not lists
            //negligable LOC difference b/w iterative and mapped
                    
        //Response Level (RL)           
        if(Integer.valueOf(form.obj.get(form.BorF+'RL_T__c')) <= 64){
            Str_RL = 'Normal';
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'RL_T__c')) >=70){
            Str_RL = 'Invalid';
        }
        else{
            Str_RL = 'Borderline';
        }       
        
        //Atypical Response (ATR)           
        if(Integer.valueOf(form.obj.get(form.BorF+'ATR_T__c')) <= 69){
            Str_ATR = 'Normal';
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'ATR_T__c')) >=90){
            Str_ATR = 'Invalid';
        }
        else{
            Str_ATR = 'Borderline';
        }               
    
        return obj;
    }
    
    public void getAssesmentHistory() {
                
        //query baseline
        List<SObject> baseline = 
            Database.query('SELECT ' + form.ut.getFields('DS_TSCC_TSCYC_B__c') +   
                           '  FROM DS_TSCC_TSCYC_B__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'');
        
        addVisit(baseline, 'B',Str_RL,Str_ATR);
        
        //query follow-ups  
        List<SObject> followup= 
            Database.query('SELECT ' + form.ut.getFields('DS_TSCC_TSCYC_F__c') +   
                           '  FROM DS_TSCC_TSCYC_F__c' +                            
                           ' WHERE Client__c = \''+ form.cID + '\''+
                           'ORDER BY FDOATSCYC__c, SECTION__c');
                
        if(followup.size() > 0){
            addVisit(followup, 'F',Str_RL,Str_ATR);
        }
    }
    
    public void addVisit(List<SObject> tscyc, String BorF, String Str_RL, String Str_ATR) {
        
        for(Sobject t : tscyc) {
            
            Visit visit = new visit();
            
            visit.BorF         = BorF;
            visit.SECTION      = String.valueOf(t.get('SECTION__c'));
            visit.DOATSCYC     = Date.valueOf(t.get(BorF+'DOATSCYC__c'));
            visit.ANX_T        = Integer.valueOf(t.get(BorF+'ANX_T__c'));
            visit.DEP_T        = Integer.valueOf(t.get(BorF+'DEP_T__c'));
            visit.DIS_T        = Integer.valueOf(t.get(BorF+'DIS_T__c'));
            visit.ANG_T        = Integer.valueOf(t.get(BorF+'ANG_T__c'));
            visit.SC_T         = Integer.valueOf(t.get(BorF+'SC_T__c'));
            visit.PTSI_T       = Integer.valueOf(t.get(BorF+'PTSI_T__c'));
            visit.PTSAV_T      = Integer.valueOf(t.get(BorF+'PTSAV_T__c'));
            visit.PTSAR_T      = Integer.valueOf(t.get(BorF+'PTSAR_T__c'));
            visit.PTSTOT_T     = Integer.valueOf(t.get(BorF+'PTSTOT_T__c'));
            
            visit.RL_T         = Integer.valueOf(t.get(BorF+'RL_T__c'));
            visit.ATR_T        = Integer.valueOf(t.get(BorF+'ATR_T__c'));
            
            //alias score types
            visit.RL        = Str_RL;
            visit.ATR       = Str_ATR;
            
                if(visit.DOATSCYC != null){
                    visits.add(visit);        
                }
            }
     }  
     
    //edit button function
    public PageReference editRecord() {
        
        PageReference tscycPage = new PageReference('/apex/DS_TSCYC?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        tscycPage.setRedirect(true);
        
        return tscycPage;
        
    }
}