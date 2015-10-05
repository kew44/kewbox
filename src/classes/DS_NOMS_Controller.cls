/*Page Description:
*  Controller for VisualForce page DS_NOMS
*/
public with sharing class DS_NOMS_Controller extends DS_BasicForm_Controller {
    
    public DS_NOMS_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
                
        // Set the obj name 
        form.setObjName('DS_Functioning_Forms_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('NOMS');
        
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(skip.skipList);
    }  
    
    public List<SelectOption> getAdminItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        //options.add(new SelectOption('','')); 
        options.add(new SelectOption('1','Administrative staff ')); 
        options.add(new SelectOption('2','Care coordinator ')); 
        options.add(new SelectOption('3','Case manager ')); 
        options.add(new SelectOption('4','Clinician providing direct services '));
        options.add(new SelectOption('5','Clinician not providing services '));
        options.add(new SelectOption('6','Consumer peer'));
        options.add(new SelectOption('7','Data collector '));
        options.add(new SelectOption('8','Evaluator'));
        options.add(new SelectOption('9','Family advocate '));
        options.add(new SelectOption('10','Research assistant staff '));
        options.add(new SelectOption('11','Self-administered '));
        options.add(new SelectOption('98','Other '));
        
        return options; 
        
    }
    
}