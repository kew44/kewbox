/**
* The controller class for the CBCL old 6-18 analyst report
* 
**/

public with sharing class DS_CBCL_6_18_Report_Controller extends DS_BasicForm_Controller {
    
    public String cimi { get; set; }
    
    public Boolean printReport { get; set; }
    
    public Boolean displayHistory { get; set; }
    
    public Map<String, Visit> visits { get; set; }
    
    public String currentVisitDate { get; set; }
    
    public String clinicalRange { get; set; }
    
    public String borderlineRange { get; set; }
    
    public class Visit {
        
        public Date  DOACO   { get; set; }    // Date of administration
        
        public Integer CBAPPCN { get; set; } 
        
        public Double  CBIBTN  { get; set; } // Internalizing Problems Score
        public String  CBIBP   { get; set; } 
        public String  CBIBS   { get; set; } 
        
        public Double  CBADTN  { get; set; } // Anxious/Depressed
        public String  CBADP   { get; set; }
        public String  CBADS   { get; set; }
        
        public Double  CBWDTN  { get; set; } // Withdrawn/Depressed
        public String  CBWDP   { get; set; }
        public String  CBWDS   { get; set; }
        
        public Double  CBSCTN  { get; set; } // Somatic Complaints
        public String  CBSCP   { get; set; }
        public String  CBSCS   { get; set; }
        
        public Double  CBEBTN  { get; set; } // Externalizing Problems Score
        public String  CBEBP   { get; set; }
        public String  CBEBS   { get; set; }
        
        public Double  CBRBTN  { get; set; } // Rule Braking Behavior
        public String  CBRBP   { get; set; }
        public String  CBRBS   { get; set; } 
        
        public Double  CBABTN  { get; set; } // Aggressive Behavior
        public String  CBABP   { get; set; }
        public String  CBABS   { get; set; }
        
        public Double  CBSOTN  { get; set; } // Social Problems
        public String  CBSOP   { get; set; }
        public String  CBSOS   { get; set; }
        
        public Double  CBTPTN  { get; set; } // Thought Problems
        public String  CBTPP   { get; set; }
        public String  CBTPS   { get; set; }
        
        public Double  CBAPTN  { get; set; } // Attention Problems
        public String  CBAPP   { get; set; }
        public String  CBAPS   { get; set; }
        
        public Double  CBTSTN  { get; set; } // Total Problems Score
        public String  CBTSP   { get; set; }
        public String  CBTSS   { get; set; }
        
    }
    
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
    
    public DS_CBCL_6_18_Report_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        cimi = Apexpages.currentPage().getParameters().get('cimi');
        
        visits = new Map<String, Visit>();
        
        // Set the obj name 
        form.setObjName('DS_CBCL_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('CBCL_SCORES_OLD');
        
        // Get history record
        getAssesmentHistory();
        
        // Display history
        displayHistory = (visits.size() > 1) ? true : false;
        
        List<String> clinicalRangeList = new List<String>();
        List<String> borderlineRangeList = new List<String>();
        
        Map<String, String> category = new Map<String, String>();
        
        category.put('CBIBS', 'Internalizing Problems');
        category.put('CBADS', 'Anxious/Depressed');
        category.put('CBWDS', 'Withdrawn/Depressed');
        category.put('CBSCS', 'Somatic Complaints');
        category.put('CBEBS', 'Externalizing Problems');
        category.put('CBRBS', 'Rule Breaking Behavior');
        category.put('CBABS', 'Aggressive Behavior');
        category.put('CBSOS', 'Social Problems');
        category.put('CBTPS', 'Thought Problems');
        category.put('CBAPS', 'Attention Problems');
        category.put('CBTSS', 'Total Problems');
        
        for(String ca : category.keySet()) {
            String range = String.valueOf(form.obj.get(form.BorF+ca+'__c'));
            if(range == 'Clinical')
                clinicalRangeList.add(category.get(ca));
            else if(range == 'Borderline') 
                borderlineRangeList.add(category.get(ca));  
        }
        
        clinicalRange = String.join(clinicalRangeList, ', ');
        borderlineRange = String.join(borderlineRangeList, ', ');
                
        currentVisitDate = String.valueOf(Date.valueOf(form.obj.get(form.BorF+'DOACO__c'))) + '-' + form.summary.SECTION__c;
    }
    
    public void getAssesmentHistory() {
        
        List<SObject> baseline = 
            Database.query('SELECT ' + form.ut.getFields('DS_CBCL_B__c') +   
                           '  FROM DS_CBCL_B__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'' +
                           '   AND STATUS_CBCL_6_18__c != null');
        
        addVisit(baseline, 'B');
        
        List<SObject> followup = 
            Database.query('SELECT ' + form.ut.getFields('DS_CBCL_F__c') +   
                           '  FROM DS_CBCL_F__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'' +
                           //'   AND FDOAPTSD__c <= ' + currentVisitDate.format('yyyy-MM-dd') +  
                           '   AND STATUS_CBCL_6_18__c != null' + 
                           ' ORDER BY FDOACO__c, SECTION__c');
        
        if(followup.size() > 0) addVisit(followup, 'F');
        
    }
    
    public void addVisit(List<SObject> cbcl, String BorF) {
        
        for(Sobject obj : cbcl) {
            
            System.debug(Date.valueOf(obj.get(BorF+'DOACO__c')));
            System.debug(obj.get('id'));
            System.debug(obj.get(BorF+'CBIBTN__c'));
            System.debug(obj.get(BorF+'CBIBS__c'));
            
            Visit visit = new visit();
            
            visit.DOACO   = Date.valueOf(obj.get(BorF+'DOACO__c'));
            
            visit.CBAPPCN = Integer.valueOf(obj.get(BorF+'CBAPPCN__c'));
            
            visit.CBIBTN  = Double.valueOf(obj.get(BorF+'CBIBTN__c'));
            visit.CBIBP   = String.valueOf(obj.get(BorF+'CBIBP__c'));
            visit.CBIBS   = String.valueOf(obj.get(BorF+'CBIBS__c'));
            
            visit.CBADTN  = Double.valueOf(obj.get(BorF+'CBADTN__c'));
            visit.CBADP   = String.valueOf(obj.get(BorF+'CBADP__c'));
            visit.CBADS   = String.valueOf(obj.get(BorF+'CBADS__c'));
            
            visit.CBWDTN  = Double.valueOf(obj.get(BorF+'CBWDTN__c'));
            visit.CBWDP   = String.valueOf(obj.get(BorF+'CBWDP__c'));
            visit.CBWDS   = String.valueOf(obj.get(BorF+'CBWDS__c'));
            
            visit.CBSCTN  = Double.valueOf(obj.get(BorF+'CBSCTN__c'));
            visit.CBSCP   = String.valueOf(obj.get(BorF+'CBSCP__c'));
            visit.CBSCS   = String.valueOf(obj.get(BorF+'CBSCS__c'));
            
            visit.CBEBTN  = Double.valueOf(obj.get(BorF+'CBEBTN__c'));
            visit.CBEBP   = String.valueOf(obj.get(BorF+'CBEBP__c'));
            visit.CBEBS   = String.valueOf(obj.get(BorF+'CBEBS__c'));
            
            visit.CBRBTN  = Double.valueOf(obj.get(BorF+'CBRBTN__c'));
            visit.CBRBP   = String.valueOf(obj.get(BorF+'CBRBP__c'));
            visit.CBRBS   = String.valueOf(obj.get(BorF+'CBRBS__c'));
            
            visit.CBABTN  = Double.valueOf(obj.get(BorF+'CBABTN__c'));
            visit.CBABP   = String.valueOf(obj.get(BorF+'CBABP__c'));
            visit.CBABS   = String.valueOf(obj.get(BorF+'CBABS__c'));
            
            visit.CBSOTN  = Double.valueOf(obj.get(BorF+'CBSOTN__c'));
            visit.CBSOP   = String.valueOf(obj.get(BorF+'CBSOP__c'));
            visit.CBSOS   = String.valueOf(obj.get(BorF+'CBSOS__c'));
            
            visit.CBTPTN  = Double.valueOf(obj.get(BorF+'CBTPTN__c'));
            visit.CBTPP   = String.valueOf(obj.get(BorF+'CBTPP__c'));
            visit.CBTPS   = String.valueOf(obj.get(BorF+'CBTPS__c'));
            
            visit.CBAPTN  = Double.valueOf(obj.get(BorF+'CBAPTN__c'));
            visit.CBAPP   = String.valueOf(obj.get(BorF+'CBAPP__c'));
            visit.CBAPS   = String.valueOf(obj.get(BorF+'CBAPS__c'));
            
            visit.CBTSTN  = Double.valueOf(obj.get(BorF+'CBTSTN__c'));
            visit.CBTSP   = String.valueOf(obj.get(BorF+'CBTSP__c'));
            visit.CBTSS   = String.valueOf(obj.get(BorF+'CBTSS__c'));
            
            visits.put(String.valueOf(Date.valueOf(obj.get(BorF+'DOACO__c')))+'-'+String.valueOf(obj.get('section__c')), visit);
            
        }
        
    }
    
    
    public PageReference editRecord() {
        
        PageReference nextPage = new PageReference('/apex/DS_CBCL_6_18?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        nextPage.setRedirect(true);
        
        return nextPage;
        
    }
    
}