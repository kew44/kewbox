trigger DS_Background_Family_Info_B_Trigger on DS_Background_Family_Info_B__c (before insert, after insert, after delete, after update) {

  Utility ut = new Utility();

  /*if(Trigger.isInsert && Trigger.isBefore){
      MyObjectClass process = new MyObjectClass(Trigger.new, Trigger.old, triggerAction.beforeInsert);
  }
  if( Trigger.isAfter && Trigger.isInsert ){
      MyObjectClass process = new MyObjectClass(Trigger.new, Trigger.old, triggerAction.afterInsert);
  }
  if(Trigger.isUpdate && Trigger.isBefore){
      MyObjectClass process = new MyObjectClass(Trigger.new, Trigger.old, triggerAction.beforeUpdate);
  }
  if( Trigger.isAfter && Trigger.isUpdate ){
      MyObjectClass process = new MyObjectClass(Trigger.new, Trigger.old, triggerAction.afterUpdate);
  }*/     

  if(Trigger.isAfter) { 

    ut.updateSummaryStatusForMergedObject(Trigger.new);
  
    FormBuilder.MilitaryRefugeHealthDisplayLogic(Trigger.new);

    /*AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
  
    if(Trigger.isInsert) { audit.generateLog(Trigger.new, Trigger.old); }
    if(Trigger.isUpdate) { audit.generateLog(Trigger.new, Trigger.old); }*/

  }
  
}