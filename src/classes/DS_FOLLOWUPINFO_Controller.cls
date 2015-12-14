public with sharing class DS_FOLLOWUPINFO_Controller extends DS_BasicForm_Controller {
    
    public String TypeModuleStatus { get; set; }       
    public String HealthModuleStatus { get; set; }
    public String MilitaryModuleStatus { get; set; }
    public String NewTraumaModuleStatus { get; set; }
    public String OldTraumaModuleStatus { get; set; }    
    //public String TimeModuleStatus { get; set; }
    
    public DS_FOLLOWUPINFO_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        // Skip logic library
        //#3, ongoing, other amount of time
        skip.skipLibrary('UTIME', 'show', '98', new Map<String, String>{'UTIMESP'=>'text'});    

        //#3, end of treatment, other amount of time
        skip.skipLibrary('ETSTAT', 'show', '98', new Map<String, String>{'ETSTATSP'=>'text'});  
        
        //#7
        skip.skipLibrary('INFOTHR', 'show', 'true', new Map<String, String>{'INFOSP'=>'text'}); 
        
        //#8
        skip.skipLibrary('GUARD', 'show', '98', new Map<String, String>{'GUARDSP'=>'text'});     
        
        //#9
        skip.skipLibrary('PCHG','show','1', 
                          new Map<String, String>{'PCHGPL'=>'checkbox',
                                                  'PCHGCG'=>'checkbox',
                                                  'PCHGLG'=>'checkbox',
                                                  'PCHGOTHR'=>'checkbox'
                                                  });                                                                         
        
        //#9 sp
        skip.skipLibrary('PCHGOTHR','show','true', new Map<String, String>{'PCHGSP'=>'text'});           
        
        //#13
        skip.skipLibrary('RSTAT','show','1', new Map<String, String>{'RSTATNONE'=>'checkbox',
                                                                    'RSTATREF'=>'checkbox',
                                                                    'RSTATASY'=>'checkbox',
                                                                    'RSTATIMM'=>'checkbox',
                                                                    'RSTATUNK'=>'checkbox'
                                                                    });          
                
        // Set the skip object to form object
        form.setSkipLogic(skip);       
        
        // Set the obj name 
        form.setObjName('DS_Background_Family_Info_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(form.skip.skipList); 
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('FOLLOWUPINFO');
                
        //type module
        TypeModuleStatus = String.valueOf(form.obj.get(bfVariableMap.get('UTYPE')));
        
        //health module
        HealthModuleStatus = String.valueOf(form.obj.get(bfVariableMap.get('HOVERALL')));
        
        //military module
        MilitaryModuleStatus = String.valueOf(form.obj.get(bfVariableMap.get('MSTAT')));
        
        //trauma module     
        NewTraumaModuleStatus = String.valueOf(form.obj.get(bfVariableMap.get('NEWTR')));
        OldTraumaModuleStatus = String.valueOf(form.obj.get(bfVariableMap.get('PRETR')));

    }
    
    public List<SelectOption> getTypeOption() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('1','Follow-up for ongoing treatment')); 
        options.add(new SelectOption('2','End of treatment')); 
        options.add(new SelectOption('3','Re-opening case for new episode of care'));
        options.add(new SelectOption('4','Post-treatment evaluation'));
        options.add(new SelectOption('98','Other'));
        
        return options;
    }
    
    public List<SelectOption> getTimeOption() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','0-3 month')); 
        options.add(new SelectOption('1','3-month')); 
        options.add(new SelectOption('2','6-month')); 
        options.add(new SelectOption('3','9-month'));
        options.add(new SelectOption('4','12-month'));
        options.add(new SelectOption('5','15-month')); 
        options.add(new SelectOption('6','18-month')); 
        options.add(new SelectOption('7','21-month')); 
        options.add(new SelectOption('8','24-month')); 
        options.add(new SelectOption('98','Other'));
        
        return options;
    }
    
    public List<SelectOption> getStatusOption() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('1','Treatment is completed as planned')); 
        options.add(new SelectOption('2','Case was transferred to another clinic or program'));
        options.add(new SelectOption('3','Child dropped out prior to end of planned treatment (for any reason)'));
        options.add(new SelectOption('4','Case is lost, no follow-up assessments performed'));
        options.add(new SelectOption('98','Other')); 
        
        return options;
    }
    
    public List<SelectOption> getGuardianOption() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('1','Parent'));
        options.add(new SelectOption('2','Other adult relative'));
        options.add(new SelectOption('3','State'));
        options.add(new SelectOption('4','Emancipated minor (self)'));
        options.add(new SelectOption('99','Unknown'));
        options.add(new SelectOption('98','Other'));
        
        return options;
    }
    
    public List<SelectOption> getHealthOption() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('1','Excellent'));
        options.add(new SelectOption('2','Very Good'));
        options.add(new SelectOption('3','Good'));
        options.add(new SelectOption('4','Fair'));
        options.add(new SelectOption('5','Poor'));
        options.add(new SelectOption('96','Refused'));
        options.add(new SelectOption('99','Unknown'));
        
        return options;
    }
    
}