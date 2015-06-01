/**
 * The controller class for FAPGAR.  
 * 
 **/

public with sharing class DS_FAPGAR_Controller extends DS_BasicForm_Controller {
  public DS_FAPGAR_Controller(ApexPages.StandardController controller) {
    
    // Initilize the DS_BasicForm_Controller
    super(Apexpages.currentPage().getParameters().get('cimi'));
  
    // Set the obj name 
    form.setObjName('DS_Functioning_Forms_'+form.BorF+'__c');

    // Get the object record into form.obj
    form.getObjRecord();

    // Serialize the skip library to JSON format
  //  skipElementToJson = JSON.serialize(form.skip.skipList); 
    
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
}