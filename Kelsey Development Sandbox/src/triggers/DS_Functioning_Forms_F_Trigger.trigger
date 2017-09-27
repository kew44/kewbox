/****
*@description trigger for Functioning_Forms_F object
*
*@modified    11/30/16    KW    remove unhandled 'after delete' clause
****/
trigger DS_Functioning_Forms_F_Trigger on DS_Functioning_Forms_F__c (before insert, before update, after insert, after update) {
    
    Utility ut = new Utility();
    
    if(Trigger.isBefore) {
        
        // Get the Background_Family_Info data
        Map<String, SObject> backgroundObj = ut.getObjectRecordWithClient(Trigger.new, 'DS_Background_Family_Info_F__c', null);
        
        DS_FAPGAR_Scoring FAPGARScore = new DS_FAPGAR_Scoring();
        
        for(DS_Functioning_Forms_F__c obj: Trigger.new){
            
            // FAPGAR scoring only runs when the FAPGAR is filled out. 
            if(obj.STATUS_FAPGAR__c != null) {
                obj = (DS_Functioning_Forms_F__c) FAPGARScore.scoreAnalyzer(obj);
            }
            
            // Background id
            if(backgroundObj.containsKey(obj.Client__c+'-'+obj.SECTION__c))
                obj.Background_ID__c = String.valueof(backgroundObj.get(obj.Client__c+'-'+obj.SECTION__c).get('id'));
            
        }               
        
    }
    
    if(Trigger.isAfter) { 
        
        ut.updateSummaryStatusForMergedObject(Trigger.new);
        
        AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
        if(Trigger.isInsert) { audit.generateLog(); }
        if(Trigger.isUpdate) { audit.generateLog(); } 
        
    }
}