/**
* The controller class for FAPGAR.  
* 
**/

public with sharing class DS_FAPGAR_Controller extends DS_BasicForm_Controller {
    
    // Variable for tracking the warning message for FFAPGARRAW
    private Boolean displayWarningMessageFFAPGARRAW = false;
    
    Final String warningMessageContent = 'Please note that if one or more items are missing the score will not be provided.  Click Save if you wish to proceed without completing all questions.';
    
    public DS_FAPGAR_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        // Set the obj name 
        form.setObjName('DS_Functioning_Forms_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('FAPGAR');
        
    }
    
    public List<SelectOption> getNSVUItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        //options.add(new SelectOption('','')); 
        options.add(new SelectOption('0','Hardly ever')); 
        options.add(new SelectOption('1','Some of the time')); 
        options.add(new SelectOption('2','Almost always')); 
        options.add(new SelectOption('99','Unknown'));
        
        return options; 
        
    }
    
    public Integer countBlankAnswer() {
        
        Integer blankCount = 0;       
        
        for(Integer i = 1; i <= 5; i++) {
            
            if(form.obj.get(bfVariableMap.get('FAPGAR'+String.valueOf(i))) == null) 
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

    
    /*public override PageReference save() {
        
        Boolean warningMessage = false;
                
        if(checkBlankAnswer() == true && displayWarningMessageFFAPGARRAW == false) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please note that if one or more items are missing the score will not be provided.  Click Save if you wish to proceed without completing all questions.'));
            displayWarningMessageFFAPGARRAW = true;
            warningMessage = true;
        }
        
        
        PageReference nextPage;
        
        if(form.saveObjRecord()) {
            nextPage = new PageReference(skip.formRedirct(form.cID, form.summary.SECTION__c, form.forceRedirect));
            nextPage.setRedirect(true);
        }
        else { nextPage = null; }
        
        return (warningMessage == false) ? nextPage : null;
        
    }*/
    
    
}