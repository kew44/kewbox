public class DS_CBCL_Scoring {
    
    private Utility ut = new Utility();
    
    private Map<String, List<DS_DATA__c>> formInfo = new Map<String, List<DS_DATA__c>>();
    
    private List<String> scaleType = new List<String>{'','I','II','III','IV','V','VI','VII','VIII'};
        
        private Map<String, DS_DATA__c> scaleInfo = new Map<String, DS_DATA__c>();
    
    private Map<String, String> resetFieldsOld = new Map<String, String>();
    private Map<String, String> resetFieldsYoung = new Map<String, String>();
    
    
    public DS_CBCL_Scoring() {
        
        List<DS_DATA__c> cbclData = [Select Number__c, Question_Field__c, Type__c,
                                     Scale__c, Scale_Number__c, Data_Type__c
                                     FROM DS_DATA__c  
                                     WHERE Data_Type__c = 'DS_CBCL_Form_Info'
                                     AND isDeleted = false      
                                     AND Section__c = false];
        
        List<DS_DATA__c> cbclOld = new List<DS_DATA__c>();
        List<DS_DATA__c> cbclYoung = new List<DS_DATA__c>();
        
        for(DS_DATA__c cb : cbclData) {
            if(cb.Type__c == '6_18') cbclOld.add(cb);
            else cbclYoung.add(cb);
        }
        
        formInfo.put('6_18', cbclOld);
        formInfo.put('1.5_5', cbclYoung);
        
        List<DS_DATA__c> scaleData = [SELECT T_Score__c, Percentile__c, Scale__c, 
                                      Sig_Range__c, Age_Range__c, Scale_Number__c,
                                      Raw_Score__c, Gender__c
                                      FROM DS_DATA__c
                                      WHERE Data_Type__c = 'DS_CBCL_SCALES'];
        
        for(DS_DATA__c sc : scaleData) 
            scaleInfo.put(sc.Age_Range__c+'-'+sc.Scale_Number__c+'-'+ sc.Gender__c+'-'+sc.Raw_Score__c+'-'+sc.Scale__c, sc);
        
        // Get the fields that need to be reset before the score calculation for CBCL Old
        resetFieldsOld = ut.getFieldsFromDD('CBCL_SCORES_OLD');
        
        // Get the fields that need to be reset before the score calculation for CBCL Young
        resetFieldsYoung = ut.getFieldsFromDD('CBCL_SCORES_YOUNG');
        
    }
    
    public SObject scoreAnalyzer(SObject obj, Map<Id, Client__c> clients) { 
        
        Map<Integer, Integer> Analysis = new Map<Integer, Integer>();
        
        // Check the record is baseline or follow-up
        String BorF = (String.valueOf(obj.getsObjectType()) == 'DS_CBCL_B__c') ? 'B' : 'F';
        
        Client__c client = clients.get(String.valueOf(obj.get('Client__c')));
        
        String gender = (client.GENDER__c == 'Male') ? 'Boy' : 'Girl';
        
        String age = '';
        
        List<Integer> blankFields = new List<Integer>();
        Integer questionNumForAvg = 0;
        Integer valueTotal = 0;    
        
        if(String.valueOf(obj.get('STATUS_CBCL_6_18__c')) != null) {
            
            // Reset the scoring fields for CBCL Old
            obj = ut.resetFieldsValue(obj, BorF, resetFieldsOld);
            
            Integer countBlank = 0;
            
            Analysis = new Map<Integer, Integer>();
            
            List<String> scaleField = new List<String>{'AD', 'WD', 'SC', 'SO', 
                'TP', 'AP', 'RB', 'AB'};
                    
            obj.put(BorF+'CBAPPCN__c', 1);  // Record defalut to applicable. 
            
            Set<String> notCountForBlank = new Set<String> {'CBO56', 'CBO56H', 'CBO113', 'CBO114', 'CBO115'};
                
                for(DS_DATA__c info : formInfo.get('6_18')) {
                    
                    // Visit age
                    Date dob = Date.valueOf(client.DOB1__c);
                    Date visitDate = Date.valueOf(obj.get(BorF+'DOACO__c'));
                    Decimal visitAge = dob.daysBetween(visitDate)/365;
                    
                    if(Integer.valueOf(visitAge) > 11) age = '12_18';
                    else age = '6_11';
                    
                    Integer num = Integer.valueof(info.Number__c);
                    Integer scale = Integer.valueof(info.Scale_Number__c);
                    
                    Integer score = 0;
                    Integer value = 0;
                    
                    if(Analysis.containsKey(scale)) 
                        score = Analysis.get(scale); 
                    
                    if(obj.get(BorF+info.Question_Field__c + '__c') != null) {
                        value = Integer.valueof(obj.get(BorF+info.Question_Field__c + '__c'));
                    }
                    else {
                        
                        if(!notCountForBlank.contains(info.Question_Field__c)) countBlank++;   
                        
                        if(countBlank == 8) {
                            obj.put(BorF+'CBAPPCN__c', 0);
                            break;
                        }
                        
                    }
                    
                    score += value;
                    
                    Analysis.put(scale, score);
                    
                }
            
            
            if(Integer.valueOf(obj.get(BorF+'CBAPPCN__c')) == 0) return obj;
                        
            for(Integer i = 0; i < scaleField.size(); i++) {
                
                Integer index = i + 1;
                
                obj.put(BorF+'CB'+scaleField.get(i)+'R__c', String.valueof(Analysis.get(index)));
                obj.put(BorF+'CB'+scaleField.get(i)+'RN__c', Analysis.get(index));
                
                Integer rawScore = Analysis.get(index);
                                
                DS_DATA__c scale = scaleInfo.get(age+'-'+index+'-'+gender+'-'+rawScore+'-'+scaleType.get(index));               
                
                // T-Score
                obj.put(BorF+'CB'+scaleField.get(i)+'T__c', string.valueof(scale.T_Score__c));
                obj.put(BorF+'CB'+scaleField.get(i)+'TN__c', scale.T_Score__c);
                
                // Percentile
                obj.put(BorF+'CB'+scaleField.get(i)+'P__c', scale.Percentile__c);
                
                // Significance Range
                obj.put(BorF+'CB'+scaleField.get(i)+'S__c', scale.Sig_Range__c);
                
            }
            
            // Other Problems raw score
            List<String> otherProblems = 
                new List<String>{ '6', '7', '15', '24', '44', '53', '55', '56h', '74',
                    '77', '93', '98', '107', '108', '109', '110', '113',
                    '114', '115'};
                        
                        obj.put(BorF+'CBOTPN__c', 0);
            
            for(String o : otherProblems) {
                if(obj.get(BorF+'CBO'+o+'__c') != null) 
                    obj.put(BorF+'CBOTPN__c', Integer.valueOf(obj.get(BorF+'CBO'+o+'__c')) + Integer.valueOf(obj.get(BorF+'CBOTPN__c')) );
            }
            
            // Internal (a) raw score, T-score
            obj.put(BorF+'CBIBRN__c', Integer.valueOf(obj.get(BorF+'CBADRN__c')) + Integer.valueOf(obj.get(BorF+'CBWDRN__c')) + Integer.valueOf(obj.get(BorF+'CBSCRN__c')));
            obj.put(BorF+'CBIBR__c', string.valueof(obj.get(BorF+'CBIBRN__c')));
            
            DS_DATA__c internalizing = scaleInfo.get(age+'-null-'+gender+'-'+obj.get(BorF+'CBIBRN__c')+'-Internalizing');
            
            obj.put(BorF+'CBIBT__c', string.valueOf(internalizing.T_Score__c));
            obj.put(BorF+'CBIBTN__c', internalizing.T_Score__c);
            obj.put(BorF+'CBIBP__c', internalizing.Percentile__c);
            obj.put(BorF+'CBIBS__c', internalizing.Sig_Range__c);        
            
            // External (b) raw score
            obj.put(BorF+'CBEBRN__c', Integer.valueOf(obj.get(BorF+'CBRBRN__c')) + Integer.valueOf(obj.get(BorF+'CBABRN__c')));
            obj.put(BorF+'CBEBR__c', string.valueof(obj.get(BorF+'CBEBRN__c')));
            
            DS_DATA__c externalizing = scaleInfo.get(age+'-null-'+gender+'-'+obj.get(BorF+'CBEBRN__c')+'-Externalizing');
            
            obj.put(BorF+'CBEBT__c', string.valueOf(externalizing.T_Score__c));
            obj.put(BorF+'CBEBTN__c', externalizing.T_Score__c);
            obj.put(BorF+'CBEBP__c', externalizing.Percentile__c);
            obj.put(BorF+'CBEBS__c', externalizing.Sig_Range__c);
            
            // Total (a)+(b)+(c) raw score
            obj.put(BorF+'CBTSRN__c', Integer.valueOf(obj.get(BorF+'CBIBRN__c')) + Integer.valueOf(obj.get(BorF+'CBEBRN__c')) + 
                    Integer.valueOf(obj.get(BorF+'CBSORN__c')) + Integer.valueOf(obj.get(BorF+'CBTPRN__c')) + 
                    Integer.valueOf(obj.get(BorF+'CBAPRN__c')) + Integer.valueOf(obj.get(BorF+'CBOTPN__c')));
            
            obj.put(BorF+'CBTSR__c', string.valueof(obj.get(BorF+'CBTSRN__c')));
            
            DS_DATA__c total = scaleInfo.get(age+'-null-'+gender+'-'+obj.get(BorF+'CBTSRN__c')+'-Total');
            
            obj.put(BorF+'CBTST__c', string.valueOf(total.T_Score__c));
            obj.put(BorF+'CBTSTN__c', total.T_Score__c);
            obj.put(BorF+'CBTSP__c', total.Percentile__c);
            obj.put(BorF+'CBTSS__c', total.Sig_Range__c);
            
        }
        
        if(String.valueOf(obj.get('STATUS_CBCL_0_5__c')) != null) {
            
            // Reset the scoring fields for CBCL Young
            obj = ut.resetFieldsValue(obj, BorF, resetFieldsYoung);
            
            Integer countBlank = 0;
            
            Analysis = new Map<Integer, Integer>();
            
            age = '1.5_5';
            
            List<String> scaleField = new List<String>{'ER', 'AD', 'SC', 'W', 'SP', 'AP', 'AB'};
                
                obj.put(BorF+'CBAPPCNY__c', 1);  // Record defalut to applicable. 
            
            Set<String> notCountForBlank = new Set<String> {'CBY100', 'CBY101', 'CBY102'};
                
                for(DS_DATA__c info : formInfo.get('1.5_5')) {
                    
                    Integer num = Integer.valueof(info.Number__c);
                    Integer scale = Integer.valueof(info.Scale_Number__c);
                    
                    Integer score = 0;
                    Integer value = 0;
                    
                    if(Analysis.containsKey(scale)) 
                        score = Analysis.get(scale); 
                    
                    if(obj.get(BorF+info.Question_Field__c + '__c') != null) {
                        value = Integer.valueof(obj.get(BorF+info.Question_Field__c + '__c'));
                    }
                    else {
                        
                        if(!notCountForBlank.contains(info.Question_Field__c)) countBlank++;   
                        
                        if(countBlank == 8) {
                            obj.put(BorF+'CBAPPCNY__c', 0);
                            break;
                        }
                    }
                    
                    score += value;
                    
                    Analysis.put(scale, score);
                    
                }
            
            if(Integer.valueOf(obj.get(BorF+'CBAPPCNY__c')) == 0) return obj;
                        
            for(Integer i = 0; i < scaleField.size(); i++) {
                
                Integer index = i + 1;
                                
                obj.put(BorF+'CB'+scaleField.get(i)+'RY__c', String.valueof(Analysis.get(index)));
                obj.put(BorF+'CB'+scaleField.get(i)+'RNY__c', Analysis.get(index));
                
                Integer rawScore = Analysis.get(index);
                                
                DS_DATA__c scale = scaleInfo.get(age+'-'+index+'-'+gender+'-'+rawScore+'-'+scaleType.get(index));
                                
                // T-Score
                obj.put(BorF+'CB'+scaleField.get(i)+'TY__c', string.valueof(scale.T_Score__c));
                obj.put(BorF+'CB'+scaleField.get(i)+'TNY__c', scale.T_Score__c);
                
                // Percentile
                obj.put(BorF+'CB'+scaleField.get(i)+'PY__c', scale.Percentile__c);
                
                // Significance Range
                obj.put(BorF+'CB'+scaleField.get(i)+'SY__c', scale.Sig_Range__c);
                
            }
            
            // Other Problems raw score
            List<String> otherProblems = 
                new List<String>{ '3', '9', '11', '13', '14', '17', '25', '26', '28', '30', 
                    '31', '32', '34', '36', '41', '49', '50', '54', '55', '57', 
                    '60', '61', '63', '65', '72', '73', '75', '76', '77', 
                    '80', '89', '91', '100', '101', '102'};
                        
                        obj.put(BorF+'CBOTPNY__c', 0);
            
            for(String o : otherProblems) {
                if(obj.get(BorF+'CBY'+o+'__c') != null) 
                    obj.put(BorF+'CBOTPNY__c', Integer.valueOf(obj.get(BorF+'CBOTPNY__c')) + Integer.valueOf(obj.get(BorF+'CBY'+o+'__c')));
            }
            
            // Internal (a) raw score, T-score
            obj.put(BorF+'CBIBRNY__c', Integer.valueOf(obj.get(BorF+'CBERRNY__c')) + Integer.valueOf(obj.get(BorF+'CBADRNY__c')) + 
                    Integer.valueOf(obj.get(BorF+'CBSCRNY__c')) + Integer.valueOf(obj.get(BorF+'CBWRNY__c')));
            obj.put(BorF+'CBIBRY__c', string.valueof(obj.get(BorF+'CBIBRNY__c')));
            
            DS_DATA__c internalizing = scaleInfo.get(age+'-null-'+gender+'-'+String.valueOf(obj.get(BorF+'CBIBRNY__c'))+'-Internalizing');
            
            obj.put(BorF+'CBIBTY__c', String.valueOf(internalizing.T_Score__c));
            obj.put(BorF+'CBIBTNY__c', internalizing.T_Score__c);
            obj.put(BorF+'CBIBPY__c', internalizing.Percentile__c);
            obj.put(BorF+'CBIBSY__c', internalizing.Sig_Range__c);
            
            // External (b) raw score
            obj.put(BorF+'CBEBRNY__c', Integer.valueOf(obj.get(BorF+'CBAPRNY__c')) + Integer.valueOf(obj.get(BorF+'CBABRNY__c')));
            obj.put(BorF+'CBEBRY__c', string.valueof(obj.get(BorF+'CBEBRNY__c')));
            
            DS_DATA__c externalizing = scaleInfo.get(age+'-null-'+gender+'-'+String.valueOf(obj.get(BorF+'CBEBRNY__c'))+'-Externalizing');
            
            obj.put(BorF+'CBEBTY__c', string.valueOf(externalizing.T_Score__c));
            obj.put(BorF+'CBEBTNY__c', externalizing.T_Score__c);
            obj.put(BorF+'CBEBPY__c', externalizing.Percentile__c);
            obj.put(BorF+'CBEBSY__c', externalizing.Sig_Range__c);
            
            // Total (a)+(b)+(V)+(Other) raw score
            obj.put(BorF+'CBTSRNY__c', Integer.valueOf(obj.get(BorF+'CBIBRNY__c')) + Integer.valueOf(obj.get(BorF+'CBEBRNY__c')) + 
                    Integer.valueOf(obj.get(BorF+'CBSPRNY__c')) + Integer.valueOf(obj.get(BorF+'CBOTPNY__c')));
            
            obj.put(BorF+'CBTSRY__c', string.valueof(obj.get(BorF+'CBTSRNY__c')));
            
            DS_DATA__c total = scaleInfo.get(age+'-null-'+gender+'-'+String.valueOf(obj.get(BorF+'CBTSRNY__c'))+'-Total');
            
            obj.put(BorF+'CBTSTY__c', string.valueOf(total.T_Score__c));
            obj.put(BorF+'CBTSTNY__c', total.T_Score__c);
            obj.put(BorF+'CBTSPY__c', total.Percentile__c);
            obj.put(BorF+'CBTSSY__c', total.Sig_Range__c);
            
        }
        
        return obj;
    }
    
    
}