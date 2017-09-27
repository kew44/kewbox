/****
*@description An apex page controller for TSCYC assessment
* 
*@date 12/11/15
*@modified date
*@author KW
*
*@group Assessment
*@group-content /ApexDocContent/Assessment/DS_TSCYC_Controller.htm
****/
public with sharing class DS_TSCYC_Controller  extends DS_BasicForm_Controller {

    public DS_TSCYC_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        // Set the obj name 
        form.setObjName('DS_TSCC_TSCYC_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('TSCYC');
                
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(skip.skipList);
        
        bfVariableMap.put('DOATSCYC',   form.BorF+'DOATSCYC__c');
        //anx
        bfVariableMap.put('ANX_R',form.BorF+'ANX_R__c');
        bfVariableMap.put('ANX_T',form.BorF+'ANX_T__c');        
            bfVariableMap.put('ANX_R2',form.BorF+'ANX_R2__c');
            bfVariableMap.put('ANX_T2',form.BorF+'ANX_T2__c');
        //dep
        bfVariableMap.put('DEP_R',form.BorF+'DEP_R__c');
        bfVariableMap.put('DEP_T',form.BorF+'DEP_T__c');
            bfVariableMap.put('DEP_R2',form.BorF+'DEP_R2__c');
            bfVariableMap.put('DEP_T2',form.BorF+'DEP_T2__c');
        //ang
        bfVariableMap.put('ANG_R',form.BorF+'ANG_R__c');
        bfVariableMap.put('ANG_T',form.BorF+'ANG_T__c');
            bfVariableMap.put('ANG_R2',form.BorF+'ANG_R2__c');
            bfVariableMap.put('ANG_T2',form.BorF+'ANG_T2__c');
        //sc
        bfVariableMap.put('SC_R',form.BorF+'SC_R__c');
        bfVariableMap.put('SC_T',form.BorF+'SC_T__c');
            bfVariableMap.put('SC_R2',form.BorF+'SC_R2__c');
            bfVariableMap.put('SC_T2',form.BorF+'SC_T2__c');
        //dis
        bfVariableMap.put('DIS_R',form.BorF+'DIS_R__c');
        bfVariableMap.put('DIS_T',form.BorF+'DIS_T__c');
            bfVariableMap.put('DIS_R2',form.BorF+'DIS_R2__c');
            bfVariableMap.put('DIS_T2',form.BorF+'DIS_T2__c');
        //int
        bfVariableMap.put('PTSI_R',form.BorF+'PTSI_R__c');
        bfVariableMap.put('PTSI_T',form.BorF+'PTSI_T__c');
            bfVariableMap.put('PTSI_R2',form.BorF+'PTSI_R2__c');
            bfVariableMap.put('PTSI_T2',form.BorF+'PTSI_T2__c');
        //av
        bfVariableMap.put('PTSAV_R',form.BorF+'PTSAV_R__c');
        bfVariableMap.put('PTSAV_T',form.BorF+'PTSAV_T__c');
            bfVariableMap.put('PTSAV_R2',form.BorF+'PTSAV_R2__c');
            bfVariableMap.put('PTSAV_T2',form.BorF+'PTSAV_T2__c');
        //ar
        bfVariableMap.put('PTSAR_R',form.BorF+'PTSAR_R__c');
        bfVariableMap.put('PTSAR_T',form.BorF+'PTSAR_T__c');
            bfVariableMap.put('PTSAR_R2',form.BorF+'PTSAR_R2__c');
            bfVariableMap.put('PTSAR_T2',form.BorF+'PTSAR_T2__c');
        //tot
        bfVariableMap.put('PTSTOT_R',form.BorF+'PTSTOT_R__c');
        bfVariableMap.put('PTSTOT_T',form.BorF+'PTSTOT_T__c');
            bfVariableMap.put('PTSTOT_R2',form.BorF+'PTSTOT_R2__c');
            bfVariableMap.put('PTSTOT_T2',form.BorF+'PTSTOT_T2__c');
        //rl
        bfVariableMap.put('RL_R',form.BorF+'RL_R__c');
        bfVariableMap.put('RL_T',form.BorF+'RL_T__c');
            bfVariableMap.put('RL_R2',form.BorF+'RL_R2__c');
            bfVariableMap.put('RL_T2',form.BorF+'RL_T2__c');
        //atr
        bfVariableMap.put('ATR_R',form.BorF+'ATR_R__c');
        bfVariableMap.put('ATR_T',form.BorF+'ATR_T__c');
            bfVariableMap.put('ATR_R2',form.BorF+'ATR_R2__c');
            bfVariableMap.put('ATR_T2',form.BorF+'ATR_T2__c');
    }
  
  public PageReference saveview() {
  
    return save('/apex/DS_TSCYC_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
              
  } 

}