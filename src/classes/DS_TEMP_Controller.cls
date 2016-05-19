/****
*@description A page to develop a style guide template
*
*@date 5/4/16
*@author KW
*
*@modified    5/5/16    KW    map dummy variables
*
*@group Assessment
*@group-content /ApexDocContent/TEMP.htm
****/
public with sharing class DS_TEMP_Controller  extends DS_BasicForm_Controller {

    Final String warningMessageContent = 'Please note that if...';

    public DS_TEMP_Controller(ApexPages.StandardController controller) {
    
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        // Set the obj name 
        form.setObjName('DS_Background_Family_Info_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();     
        
        //variable(s) needed for js would go here
        
        //skip logic library 
        
        // Set the skip object to form object  
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(skip.skipList);
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('TEMP');                
        
        //add variables to BorF map
        bfVariableMap.put('DOV_TEMP',   form.BorF+'DOV_TEMP__c');
        bfVariableMap.put('MET_TEMP',   form.BorF+'MET_TEMP__c');
        bfVariableMap.put('RADIO_TEMP',   form.BorF+'RADIO_TEMP__c');
        bfVariableMap.put('NUM1_TEMP',   form.BorF+'NUM1_TEMP__c');
        bfVariableMap.put('NUM2_TEMP',   form.BorF+'NUM2_TEMP__c');
        bfVariableMap.put('NUM3_TEMP',   form.BorF+'NUM3_TEMP__c');
        bfVariableMap.put('NUM3_DBL_TEMP',   form.BorF+'NUM3_DBL_TEMP__c');
        bfVariableMap.put('NUM4_TEMP',   form.BorF+'NUM4_TEMP__c');
        bfVariableMap.put('NUM4_DBL_TEMP',   form.BorF+'NUM4_DBL_TEMP__c');
        bfVariableMap.put('NUM5_TEMP',   form.BorF+'NUM5_TEMP__c');
        bfVariableMap.put('NUM5_DBL_TEMP',   form.BorF+'NUM5_DBL_TEMP__c');
        bfVariableMap.put('NUM6_TEMP',   form.BorF+'NUM6_TEMP__c');
        bfVariableMap.put('NUM6_DBL_TEMP',   form.BorF+'NUM6_DBL_TEMP__c');
        bfVariableMap.put('UNK_CHECK_TEMP',   form.BorF+'UNK_CHECK_TEMP__c');
        bfVariableMap.put('UNK_CHECK2_TEMP',   form.BorF+'UNK_CHECK2_TEMP__c');
        bfVariableMap.put('CHECK1_TEMP',   form.BorF+'CHECK1_TEMP__c');
        bfVariableMap.put('CHECK2_TEMP',   form.BorF+'CHECK2_TEMP__c');
        bfVariableMap.put('CHECK3_TEMP',   form.BorF+'CHECK3_TEMP__c');
        bfVariableMap.put('CHECK4_TEMP',   form.BorF+'CHECK4_TEMP__c');
        bfVariableMap.put('CHECK5_TEMP',   form.BorF+'CHECK5_TEMP__c');
        bfVariableMap.put('CHECK6_TEMP',   form.BorF+'CHECK6_TEMP__c');

    }
    public list<SelectOption> getRadioTempItems() {
    
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','Thing 1')); 
    options.add(new SelectOption('1','Thing 2')); 
    options.add(new SelectOption('98','Other')); 
    
    return options; 
        
    }

    public Integer countBlankAnswer() {
        
        Integer blankCount = 0; 
                
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
        
        return (showWarningMessageForBlank(countBlankAnswer(), warningMessageContent)) ? null : save('/apex/DS_TEMP_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));    
        
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