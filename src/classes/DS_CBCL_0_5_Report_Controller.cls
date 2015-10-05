/**
* The controller class for the CBCL young 1.5-5 analyst report
* 
**/

public with sharing class DS_CBCL_0_5_Report_Controller extends DS_BasicForm_Controller {
    
    public String cimi { get; set; }
    
    public Boolean printReport { get; set; }
    
    public Boolean displayHistory { get; set; }
    
    public Map<String, Visit> visits { get; set; }
    
    //Datetime currentVisitDate = null;
    
    public String currentVisitDate { get; set; }
    
    public String clinicalRange { get; set; }
    public String borderlineRange { get; set; }
    
    public class Visit {
        
        public Date  DOACY    { get; set; }    // Date of administration
        
        public Integer CBAPPCNY { get; set; } 
        
        public Double  CBIBTNY  { get; set; } // Internalizing Problems Score
        public String  CBIBPY   { get; set; } 
        public String  CBIBSY   { get; set; } 
        
        public Double  CBERTNY  { get; set; } // Emotionally Reactive
        public String  CBERPY   { get; set; }
        public String  CBERSY   { get; set; }
        
        public Double  CBADTNY  { get; set; } // Anxious/Depressed
        public String  CBADPY   { get; set; }
        public String  CBADSY   { get; set; }
        
        public Double  CBSCTNY  { get; set; } // Somatic Complaints
        public String  CBSCPY   { get; set; }
        public String  CBSCSY   { get; set; }
        
        public Double  CBWTNY   { get; set; } // Withdrawn
        public String  CBWPY    { get; set; } 
        public String  CBWSY    { get; set; } 
        
        public Double  CBEBTNY  { get; set; } // Externalizing Problems Score
        public String  CBEBPY   { get; set; }
        public String  CBEBSY   { get; set; }
        
        public Double  CBSPTNY  { get; set; } // Sleep Problems
        public String  CBSPPY   { get; set; }
        public String  CBSPSY   { get; set; }
        
        public Double  CBAPTNY  { get; set; } // Attention Problems
        public String  CBAPPY   { get; set; }
        public String  CBAPSY   { get; set; }
        
        public Double  CBABTNY  { get; set; } // Aggressive Behavior
        public String  CBABPY   { get; set; }
        public String  CBABSY   { get; set; }
        
        public Double  CBTSTNY  { get; set; } // Total Problems Score
        public String  CBTSPY   { get; set; }
        public String  CBTSSY   { get; set; }
        
    }
    
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
    
    public DS_CBCL_0_5_Report_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        cimi = Apexpages.currentPage().getParameters().get('cimi');
        
        visits = new Map<String, Visit>();
        
        // Set the obj name 
        form.setObjName('DS_CBCL_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('CBCL_SCORES_YOUNG');
        
        bfVariableMap.put('DOACY',   form.BorF+'DOACY__c');
        
        //Date tempVisitDate = Date.valueOf(form.obj.get(form.BorF+'DOACY__c'));
        
        //currentVisitDate = (form.BorF == 'F') ? Datetime.newInstance(tempVisitDate, time.newInstance(0,0,0,0)) : null;
        
        getAssesmentHistory();
        
        // Display history
        displayHistory = (visits.size() > 1) ? true : false;
        
        List<String> clinicalRangeList = new List<String>();
        List<String> borderlineRangeList = new List<String>();
        
        Map<String, String> category = new Map<String, String>();
        
        category.put('CBIBSY', 'Internalizing Problems');
        category.put('CBERSY', 'Emotionally Reactive');
        category.put('CBADSY', 'Anxious/Depressed');
        category.put('CBSCSY', 'Somatic Complaints');
        category.put('CBWSY',  'Withdrawn');
        category.put('CBEBSY', 'Externalizing Problems');
        category.put('CBSPSY', 'Sleep Problems');
        category.put('CBAPSY', 'Attention Problems');
        category.put('CBABSY', 'Aggressive Behavior');
        category.put('CBTSSY', 'Total Problems');
        
        for(String ca : category.keySet()) {
            String range = String.valueOf(form.obj.get(form.BorF+ca+'__c'));
            if(range == 'Clinical')
                clinicalRangeList.add(category.get(ca));
            else if(range == 'Borderline') 
                borderlineRangeList.add(category.get(ca));  
        }
        
        clinicalRange = String.join(clinicalRangeList, ', ');
        borderlineRange = String.join(borderlineRangeList, ', ');
        
        currentVisitDate = String.valueOf(Date.valueOf(form.obj.get(form.BorF+'DOACY__c'))) + '-' + form.summary.SECTION__c;

        
    }
    
    public void getAssesmentHistory() {
        
        List<SObject> baseline = 
            Database.query('SELECT ' + form.ut.getFields('DS_CBCL_B__c') +   
                           '  FROM DS_CBCL_B__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'');
        
        System.debug('SELECT ' + form.ut.getFields('DS_CBCL_B__c') +   
                           '  FROM DS_CBCL_B__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'');
        
        addVisit(baseline, 'B');
        
        List<SObject> followup = 
            Database.query('SELECT ' + form.ut.getFields('DS_CBCL_F__c') +   
                           '  FROM DS_CBCL_F__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'' +
                           //'   AND FDOAPTSD__c <= ' + currentVisitDate.format('yyyy-MM-dd') +  
                           ' ORDER BY FDOACY__c, SECTION__c');
        
        if(followup.size() > 0) addVisit(followup, 'F');
        
    }
    
    public void addVisit(List<SObject> cbcl, String BorF) {
        
        for(Sobject cb : cbcl) {
            
            Visit visit = new visit();
            
            visit.DOACY   = Date.valueOf(cb.get(BorF+'DOACY__c'));   
            
            visit.CBAPPCNY = Integer.valueOf(cb.get(BorF+'CBAPPCNY__c'));
            
            visit.CBIBTNY  = Double.valueOf(cb.get(BorF+'CBIBTNY__c'));
            visit.CBIBPY   = String.valueOf(cb.get(BorF+'CBIBPY__c'));
            visit.CBIBSY   = String.valueOf(cb.get(BorF+'CBIBSY__c'));
            
            visit.CBERTNY  = Double.valueOf(cb.get(BorF+'CBERTNY__c'));
            visit.CBERPY   = String.valueOf(cb.get(BorF+'CBERPY__c'));
            visit.CBERSY   = String.valueOf(cb.get(BorF+'CBERSY__c'));
            
            visit.CBADTNY  = Double.valueOf(cb.get(BorF+'CBADTNY__c'));
            visit.CBADPY   = String.valueOf(cb.get(BorF+'CBADPY__c'));
            visit.CBADSY   = String.valueOf(cb.get(BorF+'CBADSY__c'));
            
            visit.CBSCTNY  = Double.valueOf(cb.get(BorF+'CBSCTNY__c'));
            visit.CBSCPY   = String.valueOf(cb.get(BorF+'CBSCPY__c'));
            visit.CBSCSY   = String.valueOf(cb.get(BorF+'CBSCSY__c'));
            
            visit.CBEBTNY  = Double.valueOf(cb.get(BorF+'CBEBTNY__c'));
            visit.CBEBPY   = String.valueOf(cb.get(BorF+'CBEBPY__c'));
            visit.CBEBSY   = String.valueOf(cb.get(BorF+'CBEBSY__c'));
            
            visit.CBWTNY   = Double.valueOf(cb.get(BorF+'CBWTNY__c'));
            visit.CBWPY    = String.valueOf(cb.get(BorF+'CBWPY__c'));
            visit.CBWSY    = String.valueOf(cb.get(BorF+'CBWSY__c'));
            
            visit.CBSPTNY  = Double.valueOf(cb.get(BorF+'CBSPTNY__c'));
            visit.CBSPPY   = String.valueOf(cb.get(BorF+'CBSPPY__c'));
            visit.CBSPSY   = String.valueOf(cb.get(BorF+'CBSPSY__c'));
            
            visit.CBAPTNY  = Double.valueOf(cb.get(BorF+'CBAPTNY__c'));
            visit.CBAPPY   = String.valueOf(cb.get(BorF+'CBAPPY__c'));
            visit.CBAPSY   = String.valueOf(cb.get(BorF+'CBAPSY__c'));
            
            visit.CBABTNY  = Double.valueOf(cb.get(BorF+'CBABTNY__c'));
            visit.CBABPY   = String.valueOf(cb.get(BorF+'CBABPY__c'));
            visit.CBABSY   = String.valueOf(cb.get(BorF+'CBABSY__c'));
            
            visit.CBTSTNY  = Double.valueOf(cb.get(BorF+'CBTSTNY__c'));
            visit.CBTSPY   = String.valueOf(cb.get(BorF+'CBTSPY__c'));
            visit.CBTSSY   = String.valueOf(cb.get(BorF+'CBTSSY__c'));
            
            visits.put(String.valueOf(Date.valueOf(cb.get(BorF+'DOACY__c')))+'-'+String.valueOf(cb.get('section__c')), visit);

            
        }
        
    }
    
    public PageReference editRecord() {
        
        PageReference nextPage = new PageReference('/apex/DS_CBCL_0_5?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        nextPage.setRedirect(true);
        
        return nextPage;
        
    }
    
}