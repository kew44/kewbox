trigger DS_Background_Family_Info_F_Trigger on DS_Background_Family_Info_F__c (before insert, before update, after insert, after delete, after update) {
    
    Utility ut = new Utility();    
    
    if(Trigger.isBefore) {
        
        //get DS_Background_Family_Info_B__c.id    
        Map<String, SObject> baselineObj = ut.getObjectRecordWithClient(Trigger.new, 'DS_Background_Family_Info_B__c', new List<String>{'\'0\''});
        
        //for new trigger
        for(DS_Background_Family_Info_F__c obj: Trigger.new){
            
            if(baselineObj.containsKey(obj.Client__c+'-0')){
                
                //assign Baseline_ID__c
                obj.Baseline_ID__c = String.valueOf(baselineObj.get(obj.Client__c+'-0').get('id'));               
                
            }
        }
    }    
    
    
    if(Trigger.isAfter) { 
        
        FormBuilder.FormDisplayLogic(Trigger.new);
        
        ut.updateSummaryStatusForMergedObject(Trigger.new);

        
        
        AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
        if(Trigger.isInsert) { audit.generateLog(); }
        if(Trigger.isUpdate) { audit.generateLog(); }
        
    }
    
}