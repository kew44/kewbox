trigger DS_TRDETAIL2_Trigger on DS_TRDETAIL2__c (before insert, before update, after insert, after update) {
   
  Utility ut = new Utility(); 

  if(Trigger.isAfter) { 

  	ut.updateSummaryStatusForMergedObject(Trigger.new);

  	AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
  
  	if(Trigger.isInsert) { audit.generateLog(Trigger.new, Trigger.old); }
  	if(Trigger.isUpdate) { audit.generateLog(Trigger.new, Trigger.old); }

  }
  
}