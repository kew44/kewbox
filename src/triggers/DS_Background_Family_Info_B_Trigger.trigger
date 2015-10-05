trigger DS_Background_Family_Info_B_Trigger on DS_Background_Family_Info_B__c (before insert, after insert, after delete, after update) {

  Utility ut = new Utility();

  if(Trigger.isAfter) { 

    ut.updateSummaryStatusForMergedObject(Trigger.new);
  
    //FormBuilder.MilitaryRefugeHealthDisplayLogic(Trigger.new);
   // FormBuilder.ResponseDisplayLogic(Trigger.new);
    
    //FormBuilder.AgeDisplayLogic(Trigger.new);
    FormBuilder.FormDisplayLogic(Trigger.new);

  }
  
}