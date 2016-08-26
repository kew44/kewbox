trigger DS_Background_Family_Info_B_Trigger on DS_Background_Family_Info_B__c (before insert, before update, after insert, after delete, after update) {

  Utility ut = new Utility();
  ReportBuilder rb = new ReportBuilder();

  if(Trigger.isAfter) {       
      
    FormBuilder.FormDisplayLogic(Trigger.new);
    rb.cocap(Trigger.new);
    

    ut.updateSummaryStatusForMergedObject(Trigger.new);
      
    AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
    if(Trigger.isInsert) { audit.generateLog(); }
    if(Trigger.isUpdate) { audit.generateLog(); }  
      
  }
  
}