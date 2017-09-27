/**
* The controller class for Brief Intervention Services Information.  
* 
**/

public with sharing class DS_BIS_Controller extends DS_BasicForm_Controller {
    
    public String dateModuleStatus{get;set;}
    
    public DS_BIS_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        skip.skipLibrary('CBISRECV', 'show', '1', 
                         new Map<String,String>{'CBISCREE'=>'checkbox', //if Q1 yes, show Q2 checkboxes
                             'CBISASSM'=>'checkbox',
                             'CBISCONS'=>'checkbox',
                             'CBISMANA'=>'checkbox',
                             'CBISCFTS'=>'checkbox',
                             'CBISPFA' =>'checkbox',
                             'CBISSPR' =>'checkbox',
                             'CBISCRIM'=>'checkbox',
                             'CBISRFSE'=>'checkbox',
                             'CBISPSYE'=>'checkbox',
                             'CBISSFTP'=>'checkbox',
                             'CBISINDT'=>'checkbox',
                             'CBISFAMT'=>'checkbox',
                             'CBISGRPT'=>'checkbox',
                             'CBISSUPG'=>'checkbox',
                             'CBISOTHE'=>'checkbox',
                             ////Q3 date
                             'CBISTCDT'=>'text',
                             ////Q4 radiobuttons   
                             'CBISCOMP'=>'radio'});
        
        skip.skipLibrary('CBISOTHE','show','true', new Map<String, String>{'CBISOTHS'=>'text'});//#2, other
        
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Set the obj name 
        form.setObjName('DS_Functioning_Forms_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(form.skip.skipList); 
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('BIS');
        
        dateModuleStatus= String.valueOf(form.obj.get(bfVariableMap.get('CBISCOMP')));
        
    }
    
    public List<SelectOption> getYNCompletedIems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('0','No, left treatment before completing ')); 
        options.add(new SelectOption('1','Yes, completed treatment ')); 
        return options; 
    }
    
}