public with sharing virtual class DS_BasicForm_Controller {
    
    public Form form { get; set; }
    
    // Object for skiplgic
    public SkipLogic skip { get; set; }
    
    // Variable for JSON format skiplogic library
    public String skipElementToJson { get; set; } 
    
    public Boolean displayWarningMessage { get; set; }
        
    // Variable list
    public Map<String, String> bfVariableMap { get; set; }
    
    public DS_BasicForm_Controller(String cimi) {
        form = new Form(cimi);
        skip = new SkipLogic();
        bfVariableMap = new Map<String, String>();
        skipElementToJson = '';
        displayWarningMessage = false;
    }
    
    public virtual PageReference cancel() {
        
        PageReference summaryPage = new PageReference('/apex/ClientSummary?s='+form.summary.SECTION__c+'&id=' + form.cID);
        summaryPage.setRedirect(true);
        
        return summaryPage;
        
    }
    
    public virtual PageReference save() {
        
        PageReference nextPage;
        
        if(form.saveObjRecord()) {
            nextPage = new PageReference(skip.formRedirct(form.cID, form.summary.SECTION__c, form.forceRedirect));
            nextPage.setRedirect(true);
        }
        else { nextPage = null; }
        
        return nextPage;
        
    }

    public virtual PageReference save(String url) {

        PageReference nextPage;
        
        if(form.saveObjRecord()) {
            nextPage = new PageReference(url);
            nextPage.setRedirect(true);
        }
        else { nextPage = null; }
        
        return nextPage;

    }
    
    public List<SelectOption> getNYOptionWithBlank() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('','')); 
        options.add(new SelectOption('0','No')); 
        options.add(new SelectOption('1','Yes')); 
        
        return options; 
        
    }
    
    public List<SelectOption> getNYOption() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No')); 
        options.add(new SelectOption('1','Yes')); 
        
        return options; 
        
    }
    
    public List<SelectOption> getNYUOptionWithBlank() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('','')); 
        options.add(new SelectOption('0','No')); 
        options.add(new SelectOption('1','Yes')); 
        options.add(new SelectOption('99','Unknown')); 
        
        return options; 
        
    }
    
    public List<SelectOption> getNYUOption() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No')); 
        options.add(new SelectOption('1','Yes')); 
        options.add(new SelectOption('99','Unknown')); 
        
        return options; 
        
    }
    
    public List<SelectOption> getBMETOption() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('','')); 
        options.add(new SelectOption('0','Pen and paper only')); 
        options.add(new SelectOption('1','Electronic only')); 
        
        return options; 
        
    }
    
    
    
}