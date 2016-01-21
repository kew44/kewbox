public class DS_PTSD_Scoring {
    
    //private List<DS_DATA__c> formInfo;
    private Map<String, List<DS_DATA__c>> formInfo = new Map<String, List<DS_DATA__c>>();
    
    private Utility ut = new Utility();
    
    private Map<String, String> resetFieldsCA = new Map<String, String>();
    private Map<String, String> resetFieldsPA = new Map<String, String>();
    
    public DS_PTSD_Scoring() {
        
        List<DS_DATA__c> ptsdData = [Select Symptom__c, Section__c, Number__c, Field__c, Type__c 
                                       From DS_DATA__c  
                                      WHERE Data_Type__c = 'DS_PTSD_Form_Info'  
                                        AND isDeleted = false
                                        AND Section__c = false];
        
        List<DS_DATA__c> formInfoChildren = new List<DS_DATA__c>();
        List<DS_DATA__c> formInfoParent = new List<DS_DATA__c>();
        
        for(DS_DATA__c f : ptsdData) {
            if(f.Type__c == 'Children / Adolescents') formInfoChildren.add(f);
            else formInfoParent.add(f);
        }
        
        formInfo.put('Children', formInfoChildren);
        formInfo.put('Parent', formInfoParent);
        
        // Get the fields that need to be reset before the score calculation
        resetFieldsCA = ut.getFieldsFromDD('PTSD_SCORES');
        
        resetFieldsCA.put('PTSFHC', 'PTSFHC__c');
        resetFieldsCA.put('PTSFSC', 'PTSFSC__c');
        resetFieldsCA.put('PTSFRC', 'PTSFRC__c');
        resetFieldsCA.put('PTSFPC', 'PTSFPC__c');
        resetFieldsCA.put('PTSDC', 'PTSDC__c');
        resetFieldsCA.put('PTSFC', 'PTSFC__c');
        resetFieldsCA.put('PTSVDSN', 'PTSVDSN__c');
        resetFieldsPA.put('PTSVDA1', 'PTSVDA1__c');
        resetFieldsPA.put('PTSVDA2', 'PTSVDA2__c');
        
        resetFieldsPA = ut.getFieldsFromDD('PTSD_SCORES_PA');
        
        resetFieldsPA.put('PTSFHCP', 'PTSFHCP__c');
        resetFieldsPA.put('PTSFSCP', 'PTSFSCP__c');
        resetFieldsPA.put('PTSFRCP', 'PTSFRCP__c');
        resetFieldsPA.put('PTSFPCP', 'PTSFPCP__c');
        resetFieldsPA.put('PTSDCP', 'PTSDCP__c');
        resetFieldsPA.put('PTSFCP', 'PTSFCP__c');
        resetFieldsPA.put('PTSVDSNP', 'PTSVDSNP__c');
        resetFieldsPA.put('PTSVDA1P', 'PTSVDA1P__c');
        resetFieldsPA.put('PTSVDA2P', 'PTSVDA2P__c');
        
    }
    
    public SObject scoreAnalyzer(SObject obj) {
                
        String BorF = (String.valueOf(obj.getsObjectType()) == 'DS_PTSD_CA_B__c') ? 'B' : 'F';
        
        if(String.valueOf(obj.get('STATUS_PTSD_CA__c')) != null) {
        
            // Reset the scoring fields for children version
            obj = ut.resetFieldsValue(obj, BorF, resetFieldsCA);
            
            obj = scoreCalculator(obj, BorF, 'Children');
            
        }
        
        if(String.valueOf(obj.get('STATUS_PTSD_PA__c')) != null) {
        
            // Reset the scoring fields for parent version
            obj = ut.resetFieldsValue(obj, BorF, resetFieldsPA);
          
            obj = scoreCalculator(obj, BorF, 'Parent');
            
        }
        
        return obj;
        
    }
    
    public SObject scoreCalculator(SObject obj, String BorF, String version) {
        
        // Map<Symptom__c, Map<Number__c, Value>>
        Map<String, Map<Integer, Integer>> Analysis = new Map<String, Map<Integer, Integer>>();
        
        String CorP = (version == 'Children') ? '' : 'P';
        
        Map<Integer, String> blankFields = new Map<Integer, String>();
        Integer questionNumForAvg = 0;
        Integer valueTotal = 0;
        
        obj.put(BorF+'PTSAPPCN'+CorP+'__c', 1);
        
        for(DS_DATA__c info : formInfo.get(version)) {
            
            Map<Integer, Integer> score = new Map<Integer, Integer>();
            
            Integer num = Integer.valueof(info.Number__c);
            
            if(Analysis.containsKey(info.Symptom__c)) 
                score = Analysis.get(info.Symptom__c); 
            
            Integer value = Integer.valueof(obj.get(BorF+info.Field__c + '__c'));
            
            score.put(num, value);
            Analysis.put(info.Symptom__c, score);                
            
            if(value == null || value == 99) {   // Blank answer
                blankFields.put(num, info.Symptom__c);
            }
            else {
                questionNumForAvg++; 
                valueTotal += value; 
            }
            
            if(blankFields.size() == 3) break;
            
        }
        
        // If there are more than 2 blank answers, this record is not applicable. 
        if(blankFields.size() > 2) {
            obj.put(BorF+'PTSAPPCN'+CorP+'__c', 0);
        }
        // If there are less than 2 blank, take the avg and put it to the 2 blank answers.
        else if(blankFields.size() <= 2 && blankFields.size() > 0) {
            
            Integer avg = Math.round(valueTotal/questionNumForAvg);
            
            for(Integer blankNumber : blankFields.keySet()) {
                obj.put(BorF+'PTSV' + blankNumber + CorP + '__c', String.valueOf(avg));
                Analysis.get(blankFields.get(blankNumber)).put(blankNumber, avg);
            }
            
        }
        
        if(obj.get(BorF+'PTSAPPCN'+CorP+'__c') == 1) {
            
            Map<String, Integer> cutofflist = new Map<String, Integer>();
            
            cutofflist.put(BorF+'PTSVDACN'+CorP+'__c', 0);
            cutofflist.put(BorF+'PTSBCN'+CorP+'__c', 0);
            cutofflist.put(BorF+'PTSCCN'+CorP+'__c', 0);
            cutofflist.put(BorF+'PTSDCN'+CorP+'__c', 0);
            cutofflist.put(BorF+'PTSECN'+CorP+'__c', 0);
            
            for(String key : Analysis.keySet()) {
                
                Integer max = 0;
                String cutoff = '';
                
                for(Integer subKey : Analysis.get(key).keySet()) {
                    Integer value = Analysis.get(key).get(subKey);
                    max = (value < max) ? max : value;
                }
                
                String symptom = key.substring(0, 1);
                
                if(symptom != 'A') 
                    obj.put(BorF+'PTSA' + key + CorP + '__c', max);
                else 
                    obj.put(BorF+'PTSVD' + key + CorP + '__c', max);
                
                if(max >= 3) {
                    if(symptom != 'A')
                        cutoff = BorF+'PTS' + symptom + 'CN' + CorP + '__c';
                    else
                        cutoff = BorF+'PTSVDACN' + CorP + '__c';
                    Integer cutoffn = cutofflist.get(cutoff);
                    cutofflist.put(cutoff, ++cutoffn);
                }
                
            }
            
            if(Integer.valueof(obj.get(BorF+'PTSV4'+CorP+'__c')) >= 2) 
                cutofflist.put(BorF+'PTSECN'+CorP+'__c', cutofflist.get(BorF+'PTSECN'+CorP+'__c') + 1);
            
            if(Integer.valueof(obj.get(BorF+'PTSV10'+CorP+'__c')) >= 2) 
                cutofflist.put(BorF+'PTSBCN'+CorP+'__c', cutofflist.get(BorF+'PTSBCN'+CorP+'__c') + 1);
            
            if(Integer.valueof(obj.get(BorF+'PTSV26'+CorP+'__c')) >= 2 && Integer.valueof(obj.get(BorF+'PTSV20'+CorP+'__c')) < 3) 
                cutofflist.put(BorF+'PTSECN'+CorP+'__c', cutofflist.get(BorF+'PTSECN'+CorP+'__c') + 1);
            
            for(String key : cutofflist.keySet()) 
                obj.put(key, cutofflist.get(key));
            
        }
        
        
        return obj;
    }
}