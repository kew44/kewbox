/****
*@description An apex page controller for PSI assessment
* 
*@date 12/11/15
*@modified date
*@author KW
*
*@modified    4/22/16    KW    if r=999: p= 0, keysets,strings added
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
        
        ////
        Map<String,String> prefixMap = new Map<String, String>();
            prefixMap.put('DR',  'Defensive Responding');
            prefixMap.put('TS',  'Total Stress');
            prefixMap.put('PD',  'Parental Distress');
            prefixMap.put('PCDI','Parent-Child Dysfunctional Interaction');
            prefixMap.put('DC',  'Difficult Child');
                
        for(String pm : prefixMap.keySet()){
            
            //temp strings for each type of variable
            String raw1 = String.valueOf(form.BorF+'PSI'+pm+'__c');      
            Integer rVal1 =Integer.valueOf(form.obj.get(raw1));
                  
            String p1 = String.valueOf(form.BorF+'PSI'+pm+'_PTLE__c');
            String p2 = String.valueOf(form.BorF+'PSI'+pm+'_PTLE2__c');
            
            if(rVal1 == 999){
                System.debug(form.obj.get(p1));
                form.obj.put(p1, 0);
                form.obj.put(p2, 0);
            }
            
         System.debug(form.obj.get(p1));            
        }                 
    }
  
  public PageReference saveview() {
  
    return save('/apex/DS_PSI_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
              
  } 
}