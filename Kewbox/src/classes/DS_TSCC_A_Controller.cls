/****
*@description An apex page controller for TSCC-A assessment
* 
*@date 12/10/15
*@modified date
*@author KW
*
*@group Assessment
*@group-content /ApexDocContent/Assessment/DS_TSCC_A_Controller.htm
****/
public with sharing class DS_TSCC_A_Controller extends DS_BasicForm_Controller {

    public DS_TSCC_A_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        // Set the obj name 
        form.setObjName('DS_TSCC_TSCYC_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('TSCC_A');
                
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(skip.skipList);
        
        bfVariableMap.put('DOATSCC',   form.BorF+'DOATSCC__c');
        //anx
        bfVariableMap.put('TSCAXN',form.BorF+'TSCAXN__c');
        bfVariableMap.put('TSCAXTN',form.BorF+'TSCAXTN__c'); 
            bfVariableMap.put('TSCAXN2',form.BorF+'TSCAXN2__c');
            bfVariableMap.put('TSCAXTN2',form.BorF+'TSCAXTN2__c');  
        //dep
        bfVariableMap.put('TSCDPN',form.BorF+'TSCDPN__c');
        bfVariableMap.put('TSCDPTN',form.BorF+'TSCDPTN__c'); 
            bfVariableMap.put('TSCDPN2',form.BorF+'TSCDPN2__c');
            bfVariableMap.put('TSCDPTN2',form.BorF+'TSCDPTN2__c');
        //ang
        bfVariableMap.put('TSCAGG',form.BorF+'TSCAGG__c');
        bfVariableMap.put('TSCAGTN',form.BorF+'TSCAGTN__c');  
            bfVariableMap.put('TSCAGG2',form.BorF+'TSCAGG2__c');
            bfVariableMap.put('TSCAGTN2',form.BorF+'TSCAGTN2__c'); 
        //pts
        bfVariableMap.put('TSCPTN',form.BorF+'TSCPTN__c');
        bfVariableMap.put('TSCPTTN',form.BorF+'TSCPTTN__c');  
            bfVariableMap.put('TSCPTN2',form.BorF+'TSCPTN2__c');
            bfVariableMap.put('TSCPTTN2',form.BorF+'TSCPTTN2__c'); 
        //dis
        bfVariableMap.put('TSCDSN',form.BorF+'TSCDSN__c');
        bfVariableMap.put('TSCDSTN',form.BorF+'TSCDSTN__c');  
            bfVariableMap.put('TSCDSN2',form.BorF+'TSCDSN2__c');
            bfVariableMap.put('TSCDSTN2',form.BorF+'TSCDSTN2__c'); 
        //diso
        bfVariableMap.put('TSCODN',form.BorF+'TSCODN__c');
        bfVariableMap.put('TSCODTN',form.BorF+'TSCODTN__c');   
            bfVariableMap.put('TSCODN2',form.BorF+'TSCODN2__c');
            bfVariableMap.put('TSCODTN2',form.BorF+'TSCODTN2__c');   
        //disf
        bfVariableMap.put('TSCFNN',form.BorF+'TSCFNN__c');
        bfVariableMap.put('TSCFNTN',form.BorF+'TSCFNTN__c');  
            bfVariableMap.put('TSCFNN2',form.BorF+'TSCFNN2__c');
            bfVariableMap.put('TSCFNTN2',form.BorF+'TSCFNTN2__c');     
        //und
        bfVariableMap.put('TSCUNN',form.BorF+'TSCUNN__c');
        bfVariableMap.put('TSCNTN',form.BorF+'TSCNTN__c');   
            bfVariableMap.put('TSCUNN2',form.BorF+'TSCUNN2__c');
            bfVariableMap.put('TSCNTN2',form.BorF+'TSCNTN2__c'); 
        //hyp
        bfVariableMap.put('TSCHYN',form.BorF+'TSCHYN__c');
        bfVariableMap.put('TSCHYTN',form.BorF+'TSCHYTN__c');   
            bfVariableMap.put('TSCHYN2',form.BorF+'TSCHYN2__c');
            bfVariableMap.put('TSCHYTN2',form.BorF+'TSCHYTN2__c');  

    }

  
  public PageReference saveview() {
  
    return save('/apex/DS_TSCC_A_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
              
  } 
}