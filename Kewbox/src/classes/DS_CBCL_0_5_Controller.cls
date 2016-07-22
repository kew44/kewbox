public with sharing class DS_CBCL_0_5_Controller extends DS_BasicForm_Controller {
    
    public List<Item> items { get; set; }
        
    Final String warningMessageContent = 'Please note that if eight or more items are missing the score will not be provided. Click Save or Save & View report if you wish to proceed without completing all questions.';
    
    public class Item {
        
        public String num { get; set; }
        public String question { get; set; }
        public String questionField { get; set; }
        public String symptom { get; set; }
        public String describeField { get; set; }
        public Boolean section { get; set; }
        
        public Item(String num, String question, String questionField, 
                    String symptom, String describeField, Boolean section) {
                        
                        this.num = num;
                        this.question = question;
                        this.questionField = questionField;
                        this.symptom = symptom;
                        this.describeField = describeField;
                        this.section = section;
                        
                    }
        
    }
    
    public DS_CBCL_0_5_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        List<DS_DATA__c> formInfo = 
            Database.query('SELECT ' + form.ut.getFields('DS_DATA__c') +   
                           '  FROM DS_DATA__c ' +
                           ' WHERE Type__c = \'1.5_5\'' +
                           '   AND Data_Type__c = \'DS_CBCL_Form_Info\'' +
                           ' ORDER BY Number__c');
        
        items = new List<Item>();
        
        for(DS_DATA__c info : formInfo) {
            
            String describeField = (info.Describe_Field__c == '' || info.Describe_Field__c == null) ? 
                form.BorF+'CBY1__c' : form.BorF+info.Describe_Field__c+'__c';
            
            String itemNumber = string.valueof(integer.valueof(info.Number__c));
            
            items.add(new Item(itemNumber, info.Content__c, 
                               form.BorF+info.Question_Field__c+'__c', info.Symptom__c,  
                               describeField, info.Section__c));  
            
        }
        
        // Set the obj name 
        form.setObjName('DS_CBCL_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('CBCL_0_5');
        
    }     
    
    public List<SelectOption> getNSVItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','0 = Not True')); 
        options.add(new SelectOption('1','1 = Somewhat or Sometimes True')); 
        options.add(new SelectOption('2','2 = Very True or Often True')); 
        
        return options; 
        
    }
    
    public Integer countBlankAnswer() {
        
        Integer blankCount = 0; 
                    
        Set<String> excludeForBlank = new Set<String> {'100', '101', '102'};
        
        for(Item info : items) {
            
            if(excludeForBlank.contains(info.num)) continue;
            
            if(info.section == false && form.obj.get(info.questionField) == null) 
                blankCount++;
            
        }
        
        System.debug(blankCount);
        
        return blankCount;
        
    }
    
    public Boolean showWarningMessageForBlank(Integer blankCount, String warningMessageContent) {
        
        if(blankCount >= 1 && displayWarningMessage == false) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, warningMessageContent));
            displayWarningMessage = true;
            return true;
        }
        
        return false;
        
    }
    
    public PageReference saveview() {  
        
        return (showWarningMessageForBlank(countBlankAnswer(), warningMessageContent)) ? null : save('/apex/DS_CBCL_0_5_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));    
        
    } 
    
    public override PageReference save() {
        
        PageReference nextPage;
        
        // If there is some blank answers and we need to display the warning message
        if(!showWarningMessageForBlank(countBlankAnswer(), warningMessageContent)) {
            
            if(form.saveObjRecord()) {
                nextPage = new PageReference(skip.formRedirct(form.cID, form.summary.SECTION__c, form.forceRedirect));
                nextPage.setRedirect(true);
            }
            else { nextPage = null; }
            
        }
        
        return nextPage;  
        
    }
    
}