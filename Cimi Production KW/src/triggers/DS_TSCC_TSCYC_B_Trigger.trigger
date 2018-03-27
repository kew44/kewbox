trigger DS_TSCC_TSCYC_B_Trigger on DS_TSCC_TSCYC_B__c (before insert, before update, after insert, after update) {
    
    Utility ut = new Utility();
    
    if(Trigger.isBefore) {
        
        // Get the Background_Family_Info data        
        Map<String, SObject> backgroundObj = ut.getObjectRecordWithClient(Trigger.new, 'DS_Background_Family_Info_B__c', null);
        
        DS_TSCC_TSCYC_Scoring tsccayc = new DS_TSCC_TSCYC_Scoring(); 
		
        for(DS_TSCC_TSCYC_B__c obj: Trigger.new) {
            
            if(obj.STATUS_TSCC_A__c != null){
                obj = (DS_TSCC_TSCYC_B__c) tsccayc.delta_TSCC(obj);
            }
            if(obj.STATUS_TSCYC__c != null){
                obj = (DS_TSCC_TSCYC_B__c) tsccayc.delta_TSCYC(obj);
            }
			
            // Background id
            if(backgroundObj.containsKey(obj.Client__c+'-'+obj.SECTION__c))
                obj.Background_ID__c = String.valueOf(backgroundObj.get(obj.Client__c+'-'+obj.SECTION__c).get('id'));
        }
        
    } 
    
    if(Trigger.isAfter) { 
        ut.updateSummaryStatusForMergedObject(Trigger.new);
        
        AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
        if(Trigger.isInsert) { audit.generateLog(); }
        if(Trigger.isUpdate) { audit.generateLog(); } 
    }
}