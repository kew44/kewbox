/****
*@description Controller for temp report page
*
*@date 5/10/16
*@author KW
*
*@modified    5/11/16    KW     Purpose:Add standard report elements
*
*@modified    5/12/16    KW     Purpose:Add visits
*
****/
public with sharing class DS_TEMP_REPORT_CONTROLLER extends DS_BasicForm_Controller  {

    //use a string variable to display warning if there are missing scores (on SDQ)
    public String missingRange{ get; set; }
    
    //score ranges
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
    public String Str_chk {get;set;}     
    
    //information on each visit
    public class Visit {
        public String SECTION { get; set; }
        public String currentVisit { get; set; }  
        public String BorF {get;set;}
        public Date dateTEMP{get;set;}
        public Integer num1 {get;set;}
        public Integer num2 {get;set;}
        public Integer num3 {get;set;}
        public Integer num3dbl {get;set;}
        public Integer num4 {get;set;}
        public Integer num4dbl {get;set;}
        
        //alias for scores' significance (only using double entries)
        public String chk{get;set;}
        
        public visit() {
            this.currentVisit = null;
        }            
    }
        
    //print report button
    public void init() {
        printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
    }
    
    public DS_TEMP_REPORT_CONTROLLER(ApexPages.StandardController controller) {

        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));        
        cimi = Apexpages.currentPage().getParameters().get('cimi');
        
        //list of visits
        visits = new List<Visit>();
                
        // Set the obj name 
        form.setObjName('DS_Background_Family_Info_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('TEMP');     
        
        //add stray variables to map
        bfVariableMap.put('DOV_TEMP',   form.BorF+'DOV_TEMP__c');
        
        //calls function to get other records of this assessment
        getAssesmentHistory();
        
        // Display history
        displayHistory = (visits.size() > 1) ? true : false;
        
        //determine the scoretype range of each score and add to corresponding list
        getScoreType(form.obj);  
        
        SectionNum = Integer.valueOf(form.obj.get('SECTION__c'));
    }

    public SObject getScoreType(SObject obj){//modeled on tscc,yc,psi
            
        //Map types and text
        Map<String, String> C_Scale_Text = new Map<String,String>();
        
        //map text
        C_Scale_Text.put('1','Subscore1');
        C_Scale_Text.put('2','Sub-scale2');
        C_Scale_Text.put('3','3');
        C_Scale_Text.put('4','Four');
        C_Scale_Text.put('5','Etc.');
        C_Scale_Text.put('6','TheLastOne');
                
        //list alerts for types of scoretypes  
        List<String> clinicalList = new List<String>();
        List<String> borderlineList = new List<String>();
        List<String> normalList = new List<String>();  
        
        //init var for scores 
        Integer C_Value; 
        
        //init var for text
        String C_Text;       
        
        for(String s : C_Scale_Text.keySet()){
                    
            //set value
            C_Value =Integer.valueOf(form.obj.get(form.BorF+'NUM'+s+'_TEMP__c'));
            
            //set text
            C_Text = String.valueOf(C_Scale_Text.get(s));
            
            //criteria for different ranges(assuming similar value ranges, if not, use another map/loop)
            if(C_Value>=6){
                clinicalList.add(C_Text);
            }
            else if(C_Value>=4){
                borderlineList.add(C_Text);
            }
            else{
                normalList.add(C_Text);
            }
        }
        
        //for variables w/ different criteria OR to assign to local string
        if(form.obj.get(form.BorF+'CHECK1_TEMP__c') == TRUE){
            Str_chk = 'Checkbox is True';
        }
        else if(form.obj.get(form.BorF+'CHECK1_TEMP__c') != TRUE){
            Str_chk = 'Checkbox is True';
        }
        else{
            Str_chk = 'Not Available';
        }
         
        //rejoin the lists
        clinicalRange = String.join(clinicalList, ', ');
        borderlineRange= String.join(borderlineList, ', ');
        normalRange= String.join(normalList, ', ');
        
        return obj;
    }
    //historical scores function
    public void getAssesmentHistory() {
                
        //query baseline
        List<SObject> baseline = 
            Database.query('SELECT ' + form.ut.getFields('DS_Background_Family_Info_B__c') +   
                           '  FROM DS_Background_Family_Info_B__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'');
        
        addVisit(baseline, 'B',Str_chk);
                
        //query follow-ups             
        List<SObject> followup = 
            Database.query('SELECT ' + form.ut.getFields('DS_Background_Family_Info_F__c') +   
                           '  FROM DS_Background_Family_Info_F__c' +                           
                           ' WHERE Client__c = \''+ form.cID + '\'' +
                           ' ORDER BY FDOV_TEMP__c, SECTION__c');
        
        if(followup.size() > 0){
            addVisit(followup, 'F',Str_chk);
        }
    }
    
    //values for visits
    public void addVisit(List<SObject> temp, String BorF, String Str_chk) {
        
        for(Sobject t : temp) {
            
            Visit visit = new visit();
            
            visit.BorF        = BorF;
            visit.SECTION     = String.valueOf(t.get('SECTION__c'));
            visit.dateTEMP    = Date.valueOf(t.get(BorF+'DOV_TEMP__c'));
            visit.num1        = Integer.valueOf(t.get(BorF+'NUM1_TEMP__c'));
            visit.num2        = Integer.valueOf(t.get(BorF+'NUM2_TEMP__c'));
            visit.num3        = Integer.valueOf(t.get(BorF+'NUM3_TEMP__c'));
            visit.num3dbl     = Integer.valueOf(t.get(BorF+'NUM3_DBL_TEMP__c'));
            visit.num4        = Integer.valueOf(t.get(BorF+'NUM4_TEMP__c'));
            visit.num4dbl     = Integer.valueOf(t.get(BorF+'NUM4_DBL_TEMP__c'));
        
            //alias score types
            visit.chk      = Str_chk;
            
                if(visit.dateTEMP != null){
                    visits.add(visit);        
                }
            }
     }  
    
    //edit button function
    public PageReference editRecord() {
        
        PageReference nextPage = new PageReference('/apex/DS_TEMP?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        nextPage.setRedirect(true);
        
        return nextPage;
        
    }

}