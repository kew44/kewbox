/*Page Description:
*  Controller for VisualForce page DS_REFIMM
*/
public with sharing class DS_REFIMM_Controller extends DS_BasicForm_Controller {
    
    public DS_REFIMM_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        // Set the obj name 
        form.setObjName('DS_Background_Family_Info_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable
        bfVariableMap = form.getVariable('REFIMM');
        
        skip.skipLibrary('MOMUS', 'show', '0', new Map<String,String>{'MOMCTY'=>'text',
                                                                      'METHORG'=>'text'});  
                                                                      
        skip.skipLibrary('DADUS', 'show', '0', new Map<String,String>{'DADCTY'=>'text',
                                                                      'DETHORG'=>'text'});   
        
        skip.skipLibrary('REFCAMP', 'show', '1', new Map<String,String>{'CAMPMO'=>'text',
                                                                        'CAMPYR'=>'text'});  
        
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(skip.skipList);
        
    }
    
    public List<SelectOption> getEngWellItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','Speaks little or no English ')); 
        options.add(new SelectOption('1','Speaks some English ')); 
        options.add(new SelectOption('2','Speaks English well ')); 
        options.add(new SelectOption('99','Unknown'));
        
        return options; 
    }
    
    public List<SelectOption> getCTDECT() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        List<DS_DATA__c> countries = [SELECT CODE__c, LONGLABEL__c 
                                      FROM DS_DATA__c 
                                      WHERE DATA_TYPE__c = 'DS_CODELIST'
                                      AND CODELIST__C = 'CTDECT'
                                      ORDER BY LONGLABEL__c];
        
        options.add(new SelectOption('',''));
        
        for(DS_DATA__c c : countries) {
            options.add(new SelectOption(c.CODE__c, c.LONGLABEL__c));
        }
        
        return options; 
    }   
}