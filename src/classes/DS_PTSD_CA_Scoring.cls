public class DS_PTSD_CA_Scoring {
    
    private List<DS_DATA__c> formInfo;
    
    private Utility ut = new Utility();
    
    private Map<String, String> resetFields = new Map<String, String>();
    
    public DS_PTSD_CA_Scoring() {
        
        formInfo = [Select Symptom__c, Section__c, Number__c, Field__c 
                    From DS_DATA__c  
                    WHERE Data_Type__c = 'DS_PTSD_Form_Info'  
                    AND isDeleted = false
                    AND Section__c = false];
        
        // Get the fields that need to be reset before the score calculation
        resetFields = ut.getFieldsFromDD('PTSD_SCORES');
        
        resetFields.put('PTSFHC', 'PTSFHC__c');
        resetFields.put('PTSFSC', 'PTSFSC__c');
        resetFields.put('PTSFRC', 'PTSFRC__c');
        resetFields.put('PTSFPC', 'PTSFPC__c');
        resetFields.put('PTSDC', 'PTSDC__c');
        resetFields.put('PTSFC', 'PTSFC__c');
        resetFields.put('PTSVDSN', 'PTSVDSN__c');
        
    }
    
    public SObject scoreAnalyzer(SObject obj) {
                
        String BorF = (String.valueOf(obj.getsObjectType()) == 'DS_PTSD_CA_B__c') ? 'B' : 'F';
        
        // Reset the scoring fields
        obj = ut.resetFieldsValue(obj, BorF, resetFields);
        
        Map<String, Map<Integer, Integer>> Analysis = new Map<String, Map<Integer, Integer>>();
        
        Map<Integer, String> blankFields = new Map<Integer, String>();
        Integer questionNumForAvg = 0;
        Integer valueTotal = 0;
        
        obj.put(BorF+'PTSAPPCN__c', 1);
        
        for(DS_DATA__c info : formInfo) {
            
            Map<Integer, Integer> score = new Map<Integer, Integer>();
            
            Integer num = Integer.valueof(info.Number__c);
            
            if(Analysis.containsKey(info.Symptom__c)) 
                score = Analysis.get(info.Symptom__c); 
            
            Integer value = Integer.valueof(obj.get(BorF+info.Field__c + '__c'));
            
            score.put(num, value);
            Analysis.put(info.Symptom__c, score);                
            
            if(value == null) {   // Blank answer
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
            obj.put(BorF+'PTSAPPCN__c', 0);
        }
        // If there are less than 2 blank, take the avg and put it to the 2 blank answers.
        else if(blankFields.size() <= 2 && blankFields.size() > 0) {
            
            Integer avg = Math.round(valueTotal/questionNumForAvg);
            
            for(Integer blankNumber : blankFields.keySet()) {
                obj.put(BorF+'PTSV' + blankNumber + '__c', String.valueOf(avg));
                Analysis.get(blankFields.get(blankNumber)).put(blankNumber, avg);
            }
            
        }
        
        if(obj.get(BorF+'PTSAPPCN__c') == 1) {
            
            Map<String, Integer> cutofflist = new Map<String, Integer>();
            
            cutofflist.put(BorF+'PTSVDACN__c', 0);
            cutofflist.put(BorF+'PTSBCN__c', 0);
            cutofflist.put(BorF+'PTSCCN__c', 0);
            cutofflist.put(BorF+'PTSDCN__c', 0);
            cutofflist.put(BorF+'PTSECN__c', 0);
            
            for(String key : Analysis.keySet()) {
                
                Integer max = 0;
                String cutoff = '';
                
                for(Integer subKey : Analysis.get(key).keySet()) {
                    Integer value = Analysis.get(key).get(subKey);
                    max = (value < max) ? max : value;
                }
                
                String symptom = key.substring(0, 1);
                
                if(symptom != 'A') 
                    obj.put(BorF+'PTSA' + key + '__c', max);
                else 
                    obj.put(BorF+'PTSVD' + key + '__c', max);
                
                if(max >= 3) {
                    if(symptom != 'A')
                        cutoff = BorF+'PTS' + symptom + 'CN__c';
                    else
                        cutoff = BorF+'PTSVDACN__c';
                    Integer cutoffn = cutofflist.get(cutoff);
                    cutofflist.put(cutoff, ++cutoffn);
                }
                
            }
            
            if(Integer.valueof(obj.get(BorF+'PTSV4__c')) >= 2) 
                cutofflist.put(BorF+'PTSECN__c', cutofflist.get(BorF+'PTSECN__c') + 1);
            
            if(Integer.valueof(obj.get(BorF+'PTSV10__c')) >= 2) 
                cutofflist.put(BorF+'PTSBCN__c', cutofflist.get(BorF+'PTSBCN__c') + 1);
            
            if(Integer.valueof(obj.get(BorF+'PTSV26__c')) >= 2 && Integer.valueof(obj.get(BorF+'PTSV20__c')) < 3) 
                cutofflist.put(BorF+'PTSECN__c', cutofflist.get(BorF+'PTSECN__c') + 1);
            
            for(String key : cutofflist.keySet()) 
                obj.put(key, cutofflist.get(key));
            
        }
        
        return obj;
        
    }
    
    
}