trigger DS_Functioning_Forms_B_Trigger on DS_Functioning_Forms_B__c  (before insert, before update, after insert, after delete, after update) {
    
    Utility ut = new Utility();
        
    if(Trigger.isBefore) {
        
        // Get the Background_Family_Info data        
        Map<String, SObject> backgroundObj = ut.getObjectRecordWithClient(Trigger.new, 'DS_Background_Family_Info_B__c', null);
        
        DS_FAPGAR_Scoring FAPGARScore = new DS_FAPGAR_Scoring();
                        
        for(DS_Functioning_Forms_B__c obj: Trigger.new){
            
            // FAPGAR scoring only runs when the FAPGAR is filled out. 
            if(obj.STATUS_FAPGAR__c != null) {
                obj = (DS_Functioning_Forms_B__c) FAPGARScore.scoreAnalyzer(obj);
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