trigger DS_SDQ_PSI_CDI_F_Trigger on DS_SDQ_PSI_CDI_F__c (before insert, before update, after insert, after update) {
    
    Utility ut = new Utility();
    ReportBuilder rb = new ReportBuilder();
    
    if(Trigger.isBefore) {
        
        // Get the Background_Family_Info data
        Map<String, SObject> backgroundObj = ut.getObjectRecordWithClient(Trigger.new, 'DS_Background_Family_Info_F__c', null);
        
        DS_SDQ_Scoring score = new DS_SDQ_Scoring();
        DS_PSI_Scoring psi = new DS_PSI_Scoring();           
        
        for(DS_SDQ_PSI_CDI_F__c obj: Trigger.new) {
            obj = (DS_SDQ_PSI_CDI_F__c) score.scoreAnalyzer(obj);
            
            if(obj.STATUS_PSI__c != null){
                obj = (DS_SDQ_PSI_CDI_F__c) psi.delta_PSI(obj);
            }
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