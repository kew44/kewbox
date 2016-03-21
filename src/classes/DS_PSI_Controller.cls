/****
*@description An apex page controller for PSI assessment
* 
*@date 12/11/15
*@modified date
*@author KW
*
*@group Assessment
*@group-content /ApexDocContent/Assessment/DS_PSI_Controller.htm
****/
public with sharing class DS_PSI_Controller extends DS_BasicForm_Controller  {

    public DS_PSI_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        // Set the obj name 
        form.setObjName('DS_SDQ_PSI_CDI_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('PSI');

        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(skip.skipList);
        
        bfVariableMap.put('DOAPSI',   form.BorF+'DOAPSI__c');
        //pd
        bfVariableMap.put('PSIPD',   form.BorF+'PSIPD__c');
        bfVariableMap.put('PSIPD_PTLE',   form.BorF+'PSIPD_PTLE__c');
            bfVariableMap.put('PSIPD2',   form.BorF+'PSIPD2__c');
            bfVariableMap.put('PSIPD_PTLE2',   form.BorF+'PSIPD_PTLE2__c');
        //pcdi
        bfVariableMap.put('PSIPCDI',   form.BorF+'PSIPCDI__c');
        bfVariableMap.put('PSIPCDI_PTLE',   form.BorF+'PSIPCDI_PTLE__c');
            bfVariableMap.put('PSIPCDI2',   form.BorF+'PSIPCDI2__c');
            bfVariableMap.put('PSIPCDI_PTLE2',   form.BorF+'PSIPCDI_PTLE2__c');
        //dc
        bfVariableMap.put('PSIDC',   form.BorF+'PSIDC__c');
        bfVariableMap.put('PSIDC_PTLE',   form.BorF+'PSIDC_PTLE__c');
            bfVariableMap.put('PSIDC2',   form.BorF+'PSIDC2__c');
            bfVariableMap.put('PSIDC_PTLE2',   form.BorF+'PSIDC_PTLE2__c');
        //ts
        bfVariableMap.put('PSITS',   form.BorF+'PSITS__c');
        bfVariableMap.put('PSITS_PTLE',   form.BorF+'PSITS_PTLE__c');
            bfVariableMap.put('PSITS2',   form.BorF+'PSITS2__c');
            bfVariableMap.put('PSITS_PTLE2',   form.BorF+'PSITS_PTLE2__c');
        //dr
        bfVariableMap.put('PSIDR',   form.BorF+'PSIDR__c');
        bfVariableMap.put('PSIDR_PTLE',   form.BorF+'PSIDR_PTLE__c');
            bfVariableMap.put('PSIDR2',   form.BorF+'PSIDR2__c');
            bfVariableMap.put('PSIDR_PTLE2',   form.BorF+'PSIDR_PTLE2__c');
    }

  
  public PageReference saveview() {
  
    return save('/apex/DS_PSI_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
              
  } 
}