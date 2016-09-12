trigger DS_PTSD_CA_F_Trigger on DS_PTSD_CA_F__c (before insert, before update, after insert, after update) {
    
    Utility ut = new Utility();
    ReportBuilder rb = new ReportBuilder();
    
    if(Trigger.isBefore) {
        
        // Get the Background_Family_Info data
        Map<String, SObject> backgroundObj = ut.getObjectRecordWithClient(Trigger.new, 'DS_Background_Family_Info_F__c', null);
        
        DS_PTSD_Scoring score = new DS_PTSD_Scoring();
        
        for(DS_PTSD_CA_F__c obj : Trigger.new) {
            obj = (DS_PTSD_CA_F__c) score.scoreAnalyzer(obj);
            
            // Background id
            if(backgroundObj.containsKey(obj.Client__c+'-'+obj.SECTION__c))
                obj.Background_ID__c = String.valueOf(backgroundObj.get(obj.Client__c+'-'+obj.SECTION__c).get('id'));
        }
        
    } 
    
    
    if(Trigger.isAfter) { 
        rb.cocap(Trigger.new);
        
        ut.updateSummaryStatusForMergedObject(Trigger.new);
        
        AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
        if(Trigger.isInsert) { audit.generateLog(); }
        if(Trigger.isUpdate) { audit.generateLog(); } 
        
    }
    
}