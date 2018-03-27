/****
*@description Controller for TSCC-A Report Page
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
*@date 3/11/16
*@author KW
*Purpose: add subscale scores to map of clinical scores
*
*@modified    6/23/16    KW    999 condition
*
*@modified    6/27/16    KW    validity string comparison values (999->0)
*
*@modified    5/16-18/17    KW    null values issue; user cannot access page if missing values for any record
*
*@group Assessment
*@group-content /ApexDocContent/Assessment/DS_TSCC_A_Report_Controller.htm
****/
public with sharing class DS_TSCC_A_Report_Controller extends DS_BasicForm_Controller {
    
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
    public String Str_UND{get;set;}            
    public String Str_HYP{get;set;}   
    
    public class Visit {
        
        public String SECTION { get; set; }
        public String currentVisit { get; set; } 
        public Date DOATSCC{get;set;}   
        public String BorF {get;set;}
        public Integer TSCAXTN {get;set;}
        public Integer TSCDPTN {get;set;}
        public Integer TSCAGTN {get;set;}
        public Integer TSCPTTN {get;set;}
        public Integer TSCDSTN {get;set;}
        public Integer TSCODTN {get;set;}
        public Integer TSCFNTN {get;set;}
        public Integer TSCNTN {get;set;}
        public Integer TSCHYTN {get;set;}
                             
        //alias score types 
        public String UND {get;set;}                
        public String HYP {get;set;}
        
        public visit() {
            this.currentVisit = null;
        }
        
    }
     
    //print report button
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
    
    public DS_TSCC_A_Report_Controller(ApexPages.StandardController controller) {
            
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));        
        cimi = Apexpages.currentPage().getParameters().get('cimi');

        visits = new List<Visit>();
		System.debug(visits);
        
        // Set the obj name 
        form.setObjName('DS_TSCC_TSCYC_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('TSCC_A');
        bfVariableMap.put('DOATSCC',   form.BorF+'DOATSCC__c');
        
        Date tempVisitDate = Date.valueOf(form.obj.get(form.BorF+'DOATSCC__c'));
        
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
		
		System.debug(obj);
		            
        //Map types and text
        Map<String, String> C_Scale_Text = new Map<String,String>();
        
        //map text
        C_Scale_Text.put('AX','Anxiety');
        C_Scale_Text.put('DP','Depression');
        C_Scale_Text.put('AG','Anger');
        C_Scale_Text.put('PT','Post-Traumatic Stress');
        C_Scale_Text.put('DS','Dissociation');
        C_Scale_Text.put('OD','Overt Dissociation');
        C_Scale_Text.put('FN','Fantasy');
                
        //list alerts for types of scoretypes   
        List<String> clinicalList = new List<String>();
        List<String> borderlineList = new List<String>();
        List<String> normalList = new List<String>();  
        
        //init var for scores
        Integer C_Value; 
        
        //init var for text
        String C_Text;         
        
        for(String t : C_Scale_Text.keySet()){
            
            System.debug(form.obj.get(form.BorF+'TSC'+t+'TN__c'));
                        
            //set value
            C_Value =Integer.valueOf(form.obj.get(form.BorF+'TSC'+t+'TN__c'));
            
            //set text
            C_Text = String.valueOf(C_Scale_Text.get(t));
            
            //assign text to range lists
            if(C_Value <= 59){
                normalList.add(C_Text);
            }
            else if(C_Value >= 65){
                clinicalList.add(C_Text);
            }
            else{
                borderlineList.add(C_Text);
            }        
			System.debug(C_Value);
            System.debug(form.obj.get(form.BorF+'TSC'+t+'TN__c'));              
        }
        
        //rejoin the lists
        clinicalRange = String.join(clinicalList, ', ');
        borderlineRange= String.join(borderlineList, ', ');
        normalRange= String.join(normalList, ', ');
        
        //Validity scores have unique ranges and are set to strings, not lists
            //negligable LOC difference b/w iterative and mapped
        
        System.debug((form.obj.get(form.BorF+'TSCNTN__c')));

        //Underresponse (UND)           
        if(Integer.valueOf(form.obj.get(form.BorF+'TSCNTN__c')) == 0){
            Str_UND = 'Not Available';
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCNTN__c')) <= 64){
            Str_UND = 'Normal';
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCNTN__c')) >= 70){
            Str_UND = 'Invalid';
        }
        else{
            Str_UND = 'Borderline';
        }
		
        //Hyperresponse (HYP)        
        if( Integer.valueOf(form.obj.get(form.BorF+'TSCHYTN__c')) == 0){
            Str_HYP = 'Not Available';
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCHYTN__c')) <= 64){
            Str_HYP = 'Normal';
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCHYTN__c')) >=90){
            Str_HYP = 'Invalid';
        }
        else{
            Str_HYP = 'Borderline';
        }
		
		System.debug(obj);
            
        return obj;
    }
      
    public void getAssesmentHistory() {
                
        //query baseline
        List<SObject> baseline = 
            Database.query('SELECT ' + form.ut.getFields('DS_TSCC_TSCYC_B__c') +   
                           '  FROM DS_TSCC_TSCYC_B__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'');
        System.debug(baseline);
		
        addVisit(baseline, 'B', Str_UND, Str_HYP);
        
        //query follow-ups  
        List<SObject> followup= 
            Database.query('SELECT ' + form.ut.getFields('DS_TSCC_TSCYC_F__c') +   
                           '  FROM DS_TSCC_TSCYC_F__c' +                            
                           ' WHERE Client__c = \''+ form.cID + '\''+
                           'ORDER BY FDOATSCC__c, SECTION__c');
         
		System.debug(followup);
				
        if(followup.size() > 0){
            addVisit(followup, 'F', Str_UND, Str_HYP);
        }
    }
    
    public void addVisit(List<SObject> tscc, String BorF, String Str_UND, String Str_HYP) {
                
        for(Sobject t : tscc) {
			
			System.debug(t);
            
            Visit visit = new visit();
            
            System.debug(visit);
            visit.BorF          = BorF;
            visit.SECTION       = String.valueOf(t.get('SECTION__c'));
            visit.DOATSCC       = Date.valueOf(t.get(BorF+'DOATSCC__c'));
			//there should be no nulls in visit values
			//map?
            visit.TSCAXTN       = (t.get(BorF+'TSCAXTN__c')) != null? Integer.valueOf(t.get(BorF+'TSCAXTN__c')): 0;
            visit.TSCDPTN       = (t.get(BorF+'TSCDPTN__c')) != null? Integer.valueOf(t.get(BorF+'TSCDPTN__c')): 0;
            visit.TSCAGTN       = (t.get(BorF+'TSCAGTN__c')) != null? Integer.valueOf(t.get(BorF+'TSCAGTN__c')): 0;
            visit.TSCPTTN       = (t.get(BorF+'TSCPTTN__c')) != null? Integer.valueOf(t.get(BorF+'TSCPTTN__c')): 0;
            visit.TSCDSTN       = (t.get(BorF+'TSCDSTN__c')) != null? Integer.valueOf(t.get(BorF+'TSCDSTN__c')): 0;
            visit.TSCODTN       = (t.get(BorF+'TSCODTN__c')) != null? Integer.valueOf(t.get(BorF+'TSCODTN__c')): 0;
            visit.TSCFNTN       = (t.get(BorF+'TSCFNTN__c')) != null? Integer.valueOf(t.get(BorF+'TSCFNTN__c')): 0;
            visit.TSCNTN        = (t.get(BorF+'TSCNTN__c'))  != null? Integer.valueOf(t.get(BorF+'TSCNTN__c')) : 0;
            visit.TSCHYTN       = (t.get(BorF+'TSCHYTN__c')) != null? Integer.valueOf(t.get(BorF+'TSCHYTN__c')): 0;
                    
            //alias score types                              
            visit.UND   = Str_UND;              
            visit.HYP   = Str_HYP;
            
			System.debug(visit);
			
                if(visit.DOATSCC != null){
                    visits.add(visit);        
                }
				
				System.debug(t);
            }        
     }       

    //edit button function
    public PageReference editRecord() {
        
        PageReference tsccPage = new PageReference('/apex/DS_TSCC_A?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        tsccPage.setRedirect(true);
        
        return tsccPage;
        
    }
}