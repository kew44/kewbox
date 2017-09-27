/****
*@description This test provides code coverage cocap reports
*
*@group Trigger
*@group-content /ApexDocContent/Trigger/DS_Background_Family_Info_F_Trigger.htm
*
*@modified  4/13/17 KW  Update Treatment Status
*@modified  4/18/17 KW  move Treatment Status to isAfter, remove isInsert clause
*@modified  4/19/17 KW  updateClientTxStatus, debug query limit issue (after delete, obj.section instead of 0)
*@modified  5/30/17 KW  noticed interference with this object's BDOV__c on or after 4/13, reverting obj.section
*
****/
trigger DS_Background_Family_Info_F_Trigger on DS_Background_Family_Info_F__c (before insert, before update, after insert,  after update) {
    
    Utility ut = new Utility();    
    
    if(Trigger.isBefore) {
            
        Map<String, SObject> baselineObj = ut.getObjectRecordWithClient(Trigger.new, 'DS_Background_Family_Info_B__c', new List<String>{'\'0\''});
        
        //for new trigger
        for(DS_Background_Family_Info_F__c obj: Trigger.new){
            
            if(baselineObj.containsKey(obj.Client__c+'-0')){
            //if(baselineObj.containsKey(obj.Client__c+'-'+obj.SECTION__c)){
                obj.Baseline_ID__c = String.valueOf(baselineObj.get(obj.Client__c+'-0').get('id'));   
               // obj.Baseline_ID__c = String.valueof(baselineObj.get(obj.Client__c+'-'+obj.SECTION__c).get('id'));       
                
            }            
        }
    }        
    
    if(Trigger.isAfter) { 
        
        FormBuilder.FormDisplayLogic(Trigger.new);
        
        ut.updateSummaryStatusForMergedObject(Trigger.new);
        
        ut.updateClientTxStatus(Trigger.new);        
        
        AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
        if(Trigger.isInsert) { audit.generateLog(); }
        if(Trigger.isUpdate) { audit.generateLog(); }
        
    }
    
}