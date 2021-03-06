trigger DS_PTSD_CA_B_Trigger on DS_PTSD_CA_B__c (before insert, before update, after insert, after update) {
    
    Utility ut = new Utility();
    
    if(Trigger.isBefore) {
        
        // Get the Background_Family_Info data        
        Map<String, SObject> backgroundObj = ut.getObjectRecordWithClient(Trigger.new, 'DS_Background_Family_Info_B__c', null);
        
        DS_PTSD_Scoring score = new DS_PTSD_Scoring();
        
        for(DS_PTSD_CA_B__c obj : Trigger.new) {
            obj = (DS_PTSD_CA_B__c) score.scoreAnalyzer(obj);
            
            // Background id
            if(backgroundObj.containsKey(obj.Client__c+'-'+obj.SECTION__c))
                obj.background_id__c = String.valueof(backgroundObj.get(obj.Client__c+'-'+obj.SECTION__c).get('id'));
        }
        
    } 
    
    
    if(Trigger.isAfter) { 
        
        ut.updateSummaryStatusForMergedObject(Trigger.new);
        
        AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
        if(Trigger.isInsert) { audit.generateLog(); }
        if(Trigger.isUpdate) { audit.generateLog(); } 
        
    }
    
}