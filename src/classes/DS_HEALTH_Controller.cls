/**
* The controller class for Health Module 
* 
**/

public with sharing class DS_HEALTH_Controller extends DS_BasicForm_Controller {
    
    public DS_HEALTH_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
          
        // Skip logic library
        skip.skipLibrary('TRT', 'show', '1', new Map<String, String>{'TRTOMED'=>'checkbox', 'TRTINJ'=>'checkbox',
                                                                     'TRTPL'  =>'checkbox', 'TRTPD' =>'checkbox',
                                                                     'TRTOTHR'=>'checkbox', 'TRTUK' =>'checkbox'});
        
        skip.skipLibrary('TRTOTHR', 'show', 'true', new Map<String, String>{'TRTOTSP'=>'text'});
        
        skip.skipLibrary('HSR', 'show', '1', new Map<String, String>{'HSRHOS'=>'checkbox', 'HSRED'=>'checkbox',
                                                                     'HSRSUR'=>'checkbox', 'HSRUC'=>'checkbox',
                                                                     'HSROT' =>'checkbox', 'HSRUK'=>'checkbox'});
       
        
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Set the obj name 
        form.setObjName('DS_Background_Family_Info_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(form.skip.skipList); 
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('HEALTH');
        
    }
    
}