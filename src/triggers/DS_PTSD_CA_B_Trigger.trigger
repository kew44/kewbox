trigger DS_PTSD_CA_B_Trigger on DS_PTSD_CA_B__c (before insert, before update, after insert, after update) {
 
  Utility ut = new Utility();

  if(Trigger.isBefore) {
        
    List<DS_DATA__c> pInfo = [Select Symptom__c, Section__c, Number__c, Field__c 
                                From DS_DATA__c  
                               WHERE Data_Type__c = 'DS_PTSD_Form_Info'  
                                 AND isDeleted = false
                                 AND Section__c = false];
            
    Map<String, Map<Integer, Integer>> Analysis = new Map<String, Map<Integer, Integer>>();
        
    for(DS_PTSD_CA_B__c ptsd : Trigger.new) {

      Integer countBlank = 0;
      List<Integer> blankFields = new List<Integer>();
      Integer questionNumForAvg = 0;
      Integer valueTotal = 0;
      
      ptsd.BPTSAPPCN__c = 1;

      for(DS_DATA__c info : pInfo) {
          
        Map<Integer, Integer> score = new Map<Integer, Integer>();
        
        Integer num = Integer.valueof(info.Number__c);
                        
        if(Analysis.containsKey(info.Symptom__c)) 
          score = Analysis.get(info.Symptom__c); 

        Integer value = Integer.valueof(ptsd.get('B'+info.Field__c + '__c'));

        score.put(num, value);
        Analysis.put(info.Symptom__c, score);                

        if(value == null) {   // Blank answer
          countBlank++;
          blankFields.add(num);
        }
        else {
          questionNumForAvg++; 
          valueTotal += value; 
        }

        if(countBlank == 3) break;

      }
      
      if(countBlank > 2) {
        ptsd.BPTSAPPCN__c = 0;
      }
      else if(countBlank <= 2 && countBlank > 0) {

        Integer avg = Math.round(valueTotal/questionNumForAvg);

        for(Integer blank : blankFields) 
          ptsd.put('BPTSV' + blank + '__c', String.valueOf(avg));

      }

      if(ptsd.BPTSAPPCN__c == 1) {

        Map<String, Integer> cutofflist = new Map<String, Integer>();
        
        cutofflist.put('BPTSVDACN__c', 0);
        cutofflist.put('BPTSBCN__c', 0);
        cutofflist.put('BPTSCCN__c', 0);
        cutofflist.put('BPTSDCN__c', 0);
        cutofflist.put('BPTSECN__c', 0);
                    
        for(String key : Analysis.keySet()) {
            
          Integer max = 0;
          String cutoff = '';
          
          for(Integer subKey : Analysis.get(key).keySet()) {
            Integer value = Analysis.get(key).get(subKey);
            max = (value < max) ? max : value;
          }
          
          String symptom = key.substring(0, 1);
          
          if(symptom != 'A') 
            ptsd.put('BPTSA' + key + '__c', max);
          else 
            ptsd.put('BPTSVD' + key + '__c', max);
                              
          if(max >= 3) {
            if(symptom != 'A')
              cutoff = 'BPTS' + symptom + 'CN__c';
            else
              cutoff = 'BPTSVDACN__c';
            Integer cutoffn = cutofflist.get(cutoff);
            cutofflist.put(cutoff, ++cutoffn);

          }
          
        }

        if(Integer.valueof(ptsd.BPTSV4__c) >= 2) 
            cutofflist.put('BPTSECN__c', cutofflist.get('BPTSECN__c') + 1);

        if(Integer.valueof(ptsd.BPTSV10__c) >= 2) 
          cutofflist.put('BPTSBCN__c', cutofflist.get('BPTSBCN__c') + 1);
        
        if(Integer.valueof(ptsd.BPTSV26__c) >= 2 && Integer.valueof(ptsd.BPTSV20__c) < 3) 
          cutofflist.put('BPTSECN__c', cutofflist.get('BPTSECN__c') + 1);

        for(String key : cutofflist.keySet()) 
          ptsd.put(key, cutofflist.get(key));

      }

    }  

  } 
  
  
  if(Trigger.isAfter) { 

    ut.updateSummaryStatusForMergedObject(Trigger.new);

    AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
  
    if(Trigger.isInsert) { audit.generateLog(Trigger.new, Trigger.old); }
    if(Trigger.isUpdate) { audit.generateLog(Trigger.new, Trigger.old); }

  }
}