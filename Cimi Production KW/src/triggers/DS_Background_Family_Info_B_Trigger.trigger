/****
*@description trigger for Background_Family_Info_B object
*
*@modified    11/30/16    KW    remove unhandled 'after delete' clause, causing error in cleaning duplicate records 
****/
trigger DS_Background_Family_Info_B_Trigger on DS_Background_Family_Info_B__c (before insert, before update, after insert, after update) {

  Utility ut = new Utility();

  if(Trigger.isAfter) { 
      
    FormBuilder.FormDisplayLogic(Trigger.new);

    ut.updateSummaryStatusForMergedObject(Trigger.new);
      
    AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
    if(Trigger.isInsert) { audit.generateLog(); }
    if(Trigger.isUpdate) { audit.generateLog(); }  
      
  }
  
}