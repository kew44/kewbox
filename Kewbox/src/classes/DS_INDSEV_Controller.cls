/*
Controller for Indicators of Severity (6+)
 */

public with sharing class DS_INDSEV_Controller extends DS_BasicForm_Controller {
 
  public String suicideModuleStatus { get; set; }
  public String criminalModuleStatus { get; set; }

  public DS_INDSEV_Controller(ApexPages.StandardController controller) {

    // Initilize the DS_BasicForm_Controller
    super(Apexpages.currentPage().getParameters().get('cimi'));

    // Set the obj name 
    form.setObjName('DS_Functioning_Forms_'+form.BorF+'__c');
    
    // Get the object record into form.obj
    form.getObjRecord();
    
    // Get field name from DS_DATA (variable)
    bfVariableMap = form.getVariable('INDSEV');
        
    suicideModuleStatus = String.valueOf(form.obj.get(bfVariableMap.get('ISPSUIC')));    
    criminalModuleStatus = String.valueOf(form.obj.get(bfVariableMap.get('ISPCRIM')));
    
    //16
    skip.skipLibrary('SUITALK', 'show', '1', new Map<String, String>{'SUTAMO'=>'text'}); 
    //17
    skip.skipLibrary('SUIATT', 'show', '1', new Map<String, String>{'SUATMO'=>'text'});
    //18
    skip.skipLibrary('ISPCRRU', 'show', '', new Map<String, String>{'ISPCRSP'=>'text'}); 
    
    // Set the skip object to form object
    form.setSkipLogic(skip);

    // Get field name from DS_DATA (variable)
    bfVariableMap.put('STATUS', 'STATUS_INDSEV__c');    

    // Serialize the skip library to JSON format
    skipElementToJson = JSON.serialize(skip.skipList);
          
  }

  public List<SelectOption> getNSVUItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','Not a problem')); 
    options.add(new SelectOption('1','Somewhat/sometimes a problem')); 
    options.add(new SelectOption('2','Very much/often a problem')); 
    options.add(new SelectOption('99','Unknown'));
    
    return options; 
        
  }
  
  public List<SelectOption> getRefUnkItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 

    options.add(new SelectOption('96','Refused'));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

}