trigger DS_CBCL_B_Trigger on DS_CBCL_B__c (before insert, before update, after insert, after update) {
    
    Utility ut = new Utility();
    
    List<String> clientIDs = new List<String>();
    
    if(Trigger.isBefore) {
        
        // Get the Background_Family_Info data        
        Map<String, SObject> backgroundObj = ut.getObjectRecordWithClient(Trigger.new, 'DS_Background_Family_Info_B__c', null);
        
        DS_CBCL_Scoring score = new DS_CBCL_Scoring();
        
        for(DS_CBCL_B__c cbcl : Trigger.new) { clientIDs.add(cbcl.Client__c); }
        
        Map<Id, Client__c> clients = 
            new Map<Id, Client__c>([SELECT id, Gender__c, AGE__c, 
                                    DOB1__c, CURRENT_AGE__c
                                    FROM Client__c
                                    WHERE id IN : clientIDs]);
        
        for(DS_CBCL_B__c obj : Trigger.new) {
            obj = (DS_CBCL_B__c) score.scoreAnalyzer(obj, clients);
            
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