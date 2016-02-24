/****
*@description Controller for TSCC-A Report Page
* 
*@date 2/18/16
*@modified date
*@author KW
*Purpose: Remove validity scores from clinical/normal/borderline range lists
*update validity to use 'Invalid' instead of 'Clinical'
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
        
        //redundant cimi?
        cimi = Apexpages.currentPage().getParameters().get('cimi');

        visits = new List<Visit>();
        
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
            
        //list alerts for types of scoretypes   
        List<String> clinicalList = new List<String>();
        List<String> borderlineList = new List<String>();
        List<String> normalList = new List<String>(); 
                                  
        //Anxiety (ANX)            
        if(Integer.valueOf(form.obj.get(form.BorF+'TSCAXTN__c')) <= 59){
            normalList.add('Anxiety');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCAXTN__c')) >65){
            clinicalList.add('Anxiety');
        }
        else{
            borderlineList.add('Anxiety');
        }
        
        //Depression (DEP)            
        if(Integer.valueOf(form.obj.get(form.BorF+'TSCDPTN__c'))<= 59){
            normalList.add('Depression');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCDPTN__c')) >65){
            clinicalList.add('Depression');
        }
        else{
            borderlineList.add('Depression');
        }   

        //Anger (ANG)               
        if(Integer.valueOf(form.obj.get(form.BorF+'TSCAGTN__c'))<= 59){
            normalList.add('Anger');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCAGTN__c')) >65){
            clinicalList.add('Anger');
        }
        else{
            borderlineList.add('Anger');
        }

        //Posttraumatic Stress (PTS)     
        if(Integer.valueOf(form.obj.get(form.BorF+'TSCPTTN__c'))<= 59){
            normalList.add('Posttraumatic Stress');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCPTTN__c')) >65){
            clinicalList.add('Posttraumatic Stress');
        }
        else{
            borderlineList.add('Posttraumatic Stress');
        }
        
        //Dissociation (DIS)            
        if(Integer.valueOf(form.obj.get(form.BorF+'TSCDSTN__c'))<= 59){
            normalList.add('Dissociation');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCDSTN__c')) >65){
            clinicalList.add('Dissociation');
        }
        else{
            borderlineList.add('Dissociation');
        }  

        //Overt Dissociation (DIS-O)    
        if(Integer.valueOf(form.obj.get(form.BorF+'TSCODTN__c'))<= 59){
            normalList.add('Overt Dissociation');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCODTN__c')) >65){
            clinicalList.add('Overt Dissociation');
        }
        else{
            borderlineList.add('Overt Dissociation');
        }

        //Fantasy (DIS-F)             
       if(Integer.valueOf(form.obj.get(form.BorF+'TSCFNTN__c')) <= 59){
            normalList.add('Fantasy');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCFNTN__c')) >65){
            clinicalList.add('Fantasy');
        }
        else{
            borderlineList.add('Fantasy');
        }

        //Underresponse (UND)           
        if(Integer.valueOf(form.obj.get(form.BorF+'TSCNTN__c')) <= 64){
            Str_UND = 'Normal';
           // normalList.add('Underresponse');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCNTN__c')) >70){
            Str_UND = 'Invalid';
           // clinicalList.add('Underresponse');
        }
        else{
            Str_UND = 'Borderline';
           // borderlineList.add('Underresponse');
        }

        //Hyperresponse (HYP)           
        if(Integer.valueOf(form.obj.get(form.BorF+'TSCHYTN__c')) <= 88){
            Str_HYP = 'Normal';
           // normalList.add('Hyperresponse');
        }
        else if(Integer.valueOf(form.obj.get(form.BorF+'TSCHYTN__c')) >90){
            Str_HYP = 'Invalid';
           // clinicalList.add('Hyperresponse');
        }
        else{
            Str_HYP = 'Borderline';
          //  borderlineList.add('Hyperresponse');
        }
    
        //rejoin the lists
        clinicalRange = String.join(clinicalList, ', ');
        borderlineRange= String.join(borderlineList, ', ');
        normalRange= String.join(normalList, ', ');
        
        return obj;
    }
      
    public void getAssesmentHistory() {
                
        //query baseline
        List<SObject> baseline = 
            Database.query('SELECT ' + form.ut.getFields('DS_TSCC_TSCYC_B__c') +   
                           '  FROM DS_TSCC_TSCYC_B__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'');
        
        addVisit(baseline, 'B', Str_UND, Str_HYP);
           
        //query follow-ups  
        List<SObject> followup= 
            Database.query('SELECT ' + form.ut.getFields('DS_TSCC_TSCYC_F__c') +   
                           '  FROM DS_TSCC_TSCYC_F__c' +                            
                           ' WHERE Client__c = \''+ form.cID + '\''+
                           'ORDER BY FDOATSCC__c, SECTION__c');
                
        if(followup.size() > 0) addVisit(followup, 'F', Str_UND, Str_HYP);
           
    }
    
    public void addVisit(List<SObject> tscc, String BorF, String Str_UND, String Str_HYP) {
                
        for(Sobject t : tscc) {
            
            Visit visit = new visit();
            
            visit.BorF          = BorF;
            visit.SECTION       = String.valueOf(t.get('SECTION__c'));
            visit.DOATSCC       = Date.valueOf(t.get(BorF+'DOATSCC__c'));
            visit.TSCAXTN       = Integer.valueOf(t.get(BorF+'TSCAXTN__c'));
            visit.TSCDPTN       = Integer.valueOf(t.get(BorF+'TSCDPTN__c'));
            visit.TSCAGTN       = Integer.valueOf(t.get(BorF+'TSCAGTN__c'));
            visit.TSCPTTN       = Integer.valueOf(t.get(BorF+'TSCPTTN__c'));
            visit.TSCDSTN       = Integer.valueOf(t.get(BorF+'TSCDSTN__c'));
            visit.TSCODTN       = Integer.valueOf(t.get(BorF+'TSCODTN__c'));
            visit.TSCFNTN       = Integer.valueOf(t.get(BorF+'TSCFNTN__c'));
            visit.TSCNTN        = Integer.valueOf(t.get(BorF+'TSCNTN__c'));
            visit.TSCHYTN       = Integer.valueOf(t.get(BorF+'TSCHYTN__c'));
                    
            //alias score types                              
            visit.UND   = Str_UND;              
            visit.HYP   = Str_HYP;
            
            visits.add(visit);            
            }            
     }       

    //edit button function
    public PageReference editRecord() {
        
        PageReference tsccPage = new PageReference('/apex/DS_TSCC_A?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        tsccPage.setRedirect(true);
        
        return tsccPage;
        
    }
}