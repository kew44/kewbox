/****
*@description An apex page controller for PSI assessment
* 
*@date 12/11/15
*@modified date
*@author KW
*
*@modified    4/22/16    KW    if r=999: p= 0, keysets,strings added
*
*@modified    5/3/16    KW    deleted logic that is on the scoring class
*
*@group Assessment
*@group-content /ApexDocContent/Assessment/DS_PSI_Controller.htm
****/
public with sharing class DS_PSI_Controller extends DS_BasicForm_Controller  {

    public DS_PSI_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(skip.skipList);
        
        // Set the obj name 
        form.setObjName('DS_SDQ_PSI_CDI_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('PSI');      
                
        bfVariableMap.put('DOAPSI',   form.BorF+'DOAPSI__c');
                        
    }
  
  public PageReference saveview() {
  
    return save('/apex/DS_PSI_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
              
  } 
}