trigger DS_TRDETAIL1_Trigger on DS_TRDETAIL1__c (before insert, before update, after insert, after update) {
   
  Utility ut = new Utility(); 
  
  if(Trigger.isAfter) { 

	  ut.updateSummaryStatusForMergedObject(Trigger.new);

  	AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
  
  	if(Trigger.isInsert) { audit.generateLog(Trigger.new, Trigger.old); }
  	if(Trigger.isUpdate) { audit.generateLog(Trigger.new, Trigger.old); }

  }
    
}