public with sharing class DS_SDQ_S_11_17_Controller extends DS_BasicForm_Controller {
    
    public String difficultModuleStatus { get; set; }
    
    public String thisFORM{get;set;}
    
    public DS_SDQ_S_11_17_Controller(ApexPages.StandardController controller) {    
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Set the obj name 
        form.setObjName('DS_SDQ_PSI_CDI_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('SDQ_S_11_17');
        
        thisFORM ='SDQ_S_11_17';//String.valueOf(form.title);
        
        if (form.BorF == 'B'){
            difficultModuleStatus = String.valueOf(form.obj.get(form.BorF+'SDSEBCD__c'));        
        }
        else if (form.BorF == 'F'){
            difficultModuleStatus = String.valueOf(form.obj.get(form.BorF+'SDSEBDD__c'));     
        }       
        
        // Get field name from DS_DATA (variable)
        //bfVariableMap.put('STATUS', 'STATUS_SDQ_S_11_17__c');   
        
        form.obj.put(form.BorF+'FORM__c',thisForm);
        
        bfVariableMap.put('FORM',  form.BorF+'FORM__c');  
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(skip.skipList);
        
        bfVariableMap.put('SDSPROB',   form.BorF+'SDSPROB__c');
        bfVariableMap.put('SDSHELPFL',   form.BorF+'SDSHELPFL__c');
        bfVariableMap.put('METSDOS',   form.BorF+'METSDOS__c');
        bfVariableMap.put('DOASDOS',   form.BorF+'DOASDOS__c');
        //     bfVariableMap.put('SDSDCL',   form.BorF+'SDSDCL__c');
        
    }
    
    public List<SelectOption> getOverallItems() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0','No')); 
        options.add(new SelectOption('1','Yes- minor difficulties')); 
        options.add(new SelectOption('2','Yes- definite difficulties')); 
        options.add(new SelectOption('3','Yes- severe difficulties'));
        
        return options; 
        
    }
    
    public List<SelectOption> getHowLongItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','Less than a month')); 
        options.add(new SelectOption('1','1-5 months')); 
        options.add(new SelectOption('2','6-12 months')); 
        options.add(new SelectOption('3','Over a year'));
        
        return options;
        
    }      
    
    public List<SelectOption> getImprovementItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','Much worse ')); 
        options.add(new SelectOption('1','A bit worse ')); 
        options.add(new SelectOption('2','About the same ')); 
        options.add(new SelectOption('3','A bit better ')); 
        options.add(new SelectOption('4','Much better ')); 
        
        return options; 
        
    }
    
    public List<SelectOption> getDegreeItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','Not at all')); 
        options.add(new SelectOption('1','Only a little')); 
        options.add(new SelectOption('2','A medium amount')); 
        options.add(new SelectOption('3','A great deal')); 
        
        return options; 
        
    }
    
    public PageReference saveview() {
        
        return save('/apex/DS_SDQ_S_11_17_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
        
    } 
    
}