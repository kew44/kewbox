/**
* The controller class for PTSD Reaction Index for Parent/Caregiver.  
* 
**/

public with sharing class DS_PTSD_PA_Controller extends DS_BasicForm_Controller {
	
    public List<Item> items { get; set; }
    
    Final String warningMessageContent = 'Please note that if three or more items are missing the score will not be provided. Click Save or Save & View report if you wish to proceed without completing all questions.';
    
    public class Item {
        
        public String num {get;set;}
        public String content {get;set;}
        public String field {get;set;}
        public String symptom {get;set;}
        public Boolean section { get;set; }
        
        public Item(String num, String symptom, String field, Boolean section, String content) {
            this.num = num;
            this.content = content;
            this.field = field;
            this.symptom = symptom;
            this.section = section;
        }
        
    }
    
    public DS_PTSD_PA_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        List<DS_DATA__c> formInfo = 
            Database.query('SELECT ' + form.ut.getFields('DS_DATA__c') +   
                           '  FROM DS_DATA__c ' +
                           ' WHERE Data_Type__c = \'DS_PTSD_Form_Info\'' +
                           '   AND Type__c = \'Parent / Caregiver\'' + 
                           ' ORDER BY Number__c');
        
        items = new List<Item>();
        
        for(DS_DATA__c info : formInfo) {
            items.add(new Item(string.valueof(integer.valueof(info.Number__c)), info.Symptom__c, form.BorF+info.Field__c+'__c', info.Section__c, info.Content__c));
        }
        
        // Set the obj name 
        form.setObjName('DS_PTSD_CA_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('PTSD_PA');
        
    }
    
    public List<SelectOption> getRadioItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','0 = None')); 
        options.add(new SelectOption('1','1 = Little')); 
        options.add(new SelectOption('2','2 = Some')); 
        options.add(new SelectOption('3','3 = Much')); 
        options.add(new SelectOption('4','4 = Most')); 
        options.add(new SelectOption('99','99 = Don\'t Know')); 
        
        return options; 
        
    }
    
    public List<SelectOption> getRadioYesNo() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('1','Yes')); 
        options.add(new SelectOption('0','No')); 
        
        return options; 
        
    }
    
    public Integer countBlankAnswer() {
        
        Integer blankCount = 0; 
        
        for(Item info : items) {
            if(info.section == false && form.obj.get(info.field) == null) 
                blankCount++;
        }
        
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
        
        return (showWarningMessageForBlank(countBlankAnswer(), warningMessageContent)) ? null : save('/apex/DS_PTSD_PA_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));    
        
    } 
    
    public override PageReference save() {
        
        PageReference nextPage;
        
        // If there are some blank answers and this is the first time they click the save button
        // , it would display the warning message
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