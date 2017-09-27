trigger DS_CBCL_B_Trigger on DS_CBCL_B__c (before insert, before update, after insert, after update) {

  Utility ut = new Utility();

  List<DS_DATA__c> cbclData = [Select Number__c, Question_Field__c, Type__c,
                                      Scale__c, Scale_Number__c, Data_Type__c
                                 FROM DS_DATA__c  
                                WHERE Data_Type__c = 'DS_CBCL_Form_Info'
                                  AND isDeleted = false      
                                  AND Section__c = false];

  Map<String, List<DS_DATA__c>> cbclInfo = new Map<String, List<DS_DATA__c>>();

  List<DS_DATA__c> cbclOld = new List<DS_DATA__c>();
  List<DS_DATA__c> cbclYoung = new List<DS_DATA__c>();

  for(DS_DATA__c cb : cbclData) {
    if(cb.Type__c == '6_18') cbclOld.add(cb);
    else cbclYoung.add(cb);
  }

  cbclInfo.put('6_18', cbclOld);
  cbclInfo.put('1.5_5', cbclYoung);

  List<String> scaleType = new List<String>{'','I','II','III','IV','V','VI','VII','VIII'};

  List<DS_DATA__c> scaleData = [SELECT T_Score__c, Percentile__c, Scale__c, 
                                       Sig_Range__c, Age_Range__c, Scale_Number__c,
                                       Raw_Score__c, Gender__c
                                  FROM DS_DATA__c
                                 WHERE Data_Type__c = 'DS_CBCL_SCALES'];

  Map<String, DS_DATA__c> scaleInfo = new Map<String, DS_DATA__c>();

  for(DS_DATA__c sc : scaleData) 
    scaleInfo.put(sc.Age_Range__c+'-'+sc.Scale_Number__c+'-'+ sc.Gender__c+'-'+sc.Raw_Score__c+'-'+sc.Scale__c, sc);
  

  List<String> clientIDs = new List<String>();

  if(Trigger.isBefore) {

    Map<Integer, Integer> Analysis = new Map<Integer, Integer>();

    for(DS_CBCL_B__c cbcl : Trigger.new) { clientIDs.add(cbcl.Client__c); }

    Map<Id, Client__c> clientInfo = 
      new Map<Id, Client__c>([SELECT id, Gender__c, AGE__c, 
                                     DOB1__c, CURRENT_AGE__c
                                FROM Client__c
                               WHERE id IN : clientIDs]);

    for(DS_CBCL_B__c cbcl : Trigger.new) {

      Client__c client = clientInfo.get(cbcl.Client__c);

      String gender = (client.GENDER__c == 'Male') ? 'Boy' : 'Girl';

      String age = '';

      List<Integer> blankFields = new List<Integer>();
      Integer questionNumForAvg = 0;
      Integer valueTotal = 0;    

      if(cbcl.STATUS_CBCL_6_18__c != null) {

        Integer countBlank = 0;

        Analysis = new Map<Integer, Integer>();

        List<String> scaleField = new List<String>{'AD', 'WD', 'SC', 'SO', 
                                                   'TP', 'AP', 'RB', 'AB'};

        cbcl.BCBAPPCN__c = 1;  // Record defalut to applicable. 
        
        Set<String> notCountForBlank = new Set<String> {'CBO56', 'CBO56H', 'CBO113', 'CBO114', 'CBO115'};

        for(DS_DATA__c info : cbclInfo.get('6_18')) {

          // Visit age
          Date dob = Date.valueOf(client.DOB1__c);
          Date visitDate = Date.valueOf(cbcl.BDOACO__c);
          Decimal visitAge = dob.daysBetween(visitDate)/365;

          if(Integer.valueOf(visitAge) > 11) age = '12_18';
          else age = '6_11';
                                  
          Integer num = Integer.valueof(info.Number__c);
          Integer scale = Integer.valueof(info.Scale_Number__c);

          Integer score = 0;
          Integer value = 0;

          if(Analysis.containsKey(scale)) 
            score = Analysis.get(scale); 

          if(cbcl.get('B'+info.Question_Field__c + '__c') != null) {
            value = Integer.valueof(cbcl.get('B'+info.Question_Field__c + '__c'));
          }
          else {
            
            if(!notCountForBlank.contains(info.Question_Field__c)) countBlank++;   
            
            if(countBlank == 8) {
              cbcl.BCBAPPCN__c = 0;
              break;
            }

          }

          score += value;

          Analysis.put(scale, score);

        }

        if(cbcl.BCBAPPCN__c == 0) continue;

        for(Integer i = 0; i < scaleField.size(); i++) {

          Integer index = i + 1;

          cbcl.put('BCB'+scaleField.get(i)+'R__c', String.valueof(Analysis.get(index)));
          cbcl.put('BCB'+scaleField.get(i)+'RN__c', Analysis.get(index));

          Integer rawScore = Analysis.get(index);

          DS_DATA__c scale = scaleInfo.get(age+'-'+index+'-'+gender+'-'+rawScore+'-'+scaleType.get(index));

          // T-Score
          cbcl.put('BCB'+scaleField.get(i)+'T__c', string.valueof(scale.T_Score__c));
          cbcl.put('BCB'+scaleField.get(i)+'TN__c', scale.T_Score__c);

          // Percentile
          cbcl.put('BCB'+scaleField.get(i)+'P__c', scale.Percentile__c);

          // Significance Range
          cbcl.put('BCB'+scaleField.get(i)+'S__c', scale.Sig_Range__c);

        }

        // Other Problems raw score
        List<String> otherProblems = 
          new List<String>{ '6', '7', '15', '24', '44', '53', '55', '56h', '74',
                            '77', '93', '98', '107', '108', '109', '110', '113',
                            '114', '115'};
        
        cbcl.BCBOTPN__c = 0;

        for(String o : otherProblems) {
          if(cbcl.get('BCBO'+o+'__c') != null) 
            cbcl.BCBOTPN__c += Integer.valueOf(cbcl.get('BCBO'+o+'__c'));
        }

        // Internal (a) raw score, T-score
        cbcl.BCBIBRN__c = cbcl.BCBADRN__c + cbcl.BCBWDRN__c + cbcl.BCBSCRN__c;
        cbcl.BCBIBR__c = string.valueof(cbcl.BCBIBRN__c);

        DS_DATA__c internalizing = scaleInfo.get(age+'-null-'+gender+'-'+cbcl.BCBIBRN__c+'-Internalizing');

        cbcl.BCBIBT__c = string.valueOf(internalizing.T_Score__c);
        cbcl.BCBIBTN__c = internalizing.T_Score__c;
        cbcl.BCBIBP__c = internalizing.Percentile__c;
        cbcl.BCBIBS__c = internalizing.Sig_Range__c;        

        // External (b) raw score
        cbcl.BCBEBRN__c = cbcl.BCBRBRN__c + cbcl.BCBABRN__c;
        cbcl.BCBEBR__c = string.valueof(cbcl.BCBEBRN__c);

        DS_DATA__c externalizing = scaleInfo.get(age+'-null-'+gender+'-'+cbcl.BCBEBRN__c+'-Externalizing');

        cbcl.BCBEBT__c = string.valueOf(externalizing.T_Score__c);
        cbcl.BCBEBTN__c = externalizing.T_Score__c;
        cbcl.BCBEBP__c = externalizing.Percentile__c;
        cbcl.BCBEBS__c = externalizing.Sig_Range__c;

        // Total (a)+(b)+(c) raw score
        cbcl.BCBTSRN__c = cbcl.BCBIBRN__c + cbcl.BCBEBRN__c + cbcl.BCBSORN__c + 
                          cbcl.BCBTPRN__c + cbcl.BCBAPRN__c + cbcl.BCBOTPN__c;

        cbcl.BCBTSR__c = string.valueof(cbcl.BCBTSRN__c);

        DS_DATA__c total = scaleInfo.get(age+'-null-'+gender+'-'+cbcl.BCBTSRN__c+'-Total');

        cbcl.BCBTST__c = string.valueOf(total.T_Score__c);
        cbcl.BCBTSTN__c = total.T_Score__c;
        cbcl.BCBTSP__c = total.Percentile__c;
        cbcl.BCBTSS__c = total.Sig_Range__c;

      }

      if(cbcl.STATUS_CBCL_0_5__c != null) {

        Integer countBlank = 0;

        Analysis = new Map<Integer, Integer>();

        age = '1.5_5';

        List<String> scaleField = new List<String>{'ER', 'AD', 'SC', 'W', 
                                                   'SP', 'AP', 'AB'};

        cbcl.BCBAPPCNY__c = 1;  // Record defalut to applicable. 

        Set<String> notCountForBlank = new Set<String> {'CBY100', 'CBY101', 'CBY102'};

        for(DS_DATA__c info : cbclInfo.get('1.5_5')) {
                                  
          Integer num = Integer.valueof(info.Number__c);
          Integer scale = Integer.valueof(info.Scale_Number__c);

          Integer score = 0;
          Integer value = 0;

          if(Analysis.containsKey(scale)) 
            score = Analysis.get(scale); 

          if(cbcl.get('B'+info.Question_Field__c + '__c') != null) {
            value = Integer.valueof(cbcl.get('B'+info.Question_Field__c + '__c'));
          }
          else {

            if(!notCountForBlank.contains(info.Question_Field__c)) countBlank++;   

            if(countBlank == 8) {
              cbcl.BCBAPPCNY__c = 0;
              break;
            }
          }

          score += value;

          Analysis.put(scale, score);

        }

        if(cbcl.BCBAPPCNY__c == 0) continue;

        for(Integer i = 0; i < scaleField.size(); i++) {

          Integer index = i + 1;

          cbcl.put('BCB'+scaleField.get(i)+'RY__c', String.valueof(Analysis.get(index)));
          cbcl.put('BCB'+scaleField.get(i)+'RNY__c', Analysis.get(index));

          Integer rawScore = Analysis.get(index);

          DS_DATA__c scale = scaleInfo.get(age+'-'+index+'-'+gender+'-'+rawScore+'-'+scaleType.get(index));

          // T-Score
          cbcl.put('BCB'+scaleField.get(i)+'TY__c', string.valueof(scale.T_Score__c));
          cbcl.put('BCB'+scaleField.get(i)+'TNY__c', scale.T_Score__c);

          // Percentile
          cbcl.put('BCB'+scaleField.get(i)+'PY__c', scale.Percentile__c);

          // Significance Range
          cbcl.put('BCB'+scaleField.get(i)+'SY__c', scale.Sig_Range__c);

        }

        // Other Problems raw score
        List<String> otherProblems = 
          new List<String>{ '3', '9', '11', '13', '14', '17', '25', '26', '28', '30', 
                            '31', '32', '34', '36', '41', '49', '50', '54', '57', 
                            '60', '61', '63', '65', '72', '73', '75', '76', '77', 
                            '80', '89', '91', '100', '101', '102'};
        
        cbcl.BCBOTPNY__c = 0;

        for(String o : otherProblems) {
          if(cbcl.get('BCBY'+o+'__c') != null) 
            cbcl.BCBOTPNY__c += Integer.valueOf(cbcl.get('BCBY'+o+'__c'));
        }
    
        // Internal (a) raw score, T-score
        cbcl.BCBIBRNY__c = cbcl.BCBERRNY__c + cbcl.BCBADRNY__c + 
                           cbcl.BCBSCRNY__c + cbcl.BCBWRNY__c;
        cbcl.BCBIBRY__c = string.valueof(cbcl.BCBIBRNY__c);

        DS_DATA__c internalizing = scaleInfo.get(age+'-null-'+gender+'-'+cbcl.BCBIBRNY__c+'-Internalizing');

        cbcl.BCBIBTY__c = string.valueOf(internalizing.T_Score__c);
        cbcl.BCBIBTNY__c = internalizing.T_Score__c;
        cbcl.BCBIBPY__c = internalizing.Percentile__c;
        cbcl.BCBIBSY__c = internalizing.Sig_Range__c;

        // External (b) raw score
        cbcl.BCBEBRNY__c = cbcl.BCBAPRNY__c + cbcl.BCBABRNY__c;
        cbcl.BCBEBRY__c = string.valueof(cbcl.BCBEBRNY__c);

        DS_DATA__c externalizing = scaleInfo.get(age+'-null-'+gender+'-'+cbcl.BCBEBRNY__c+'-Externalizing');

        cbcl.BCBEBTY__c = string.valueOf(externalizing.T_Score__c);
        cbcl.BCBEBTNY__c = externalizing.T_Score__c;
        cbcl.BCBEBPY__c = externalizing.Percentile__c;
        cbcl.BCBEBSY__c = externalizing.Sig_Range__c;

        // Total (a)+(b)+(V)+(Other) raw score
        cbcl.BCBTSRNY__c = cbcl.BCBIBRNY__c + cbcl.BCBEBRNY__c + cbcl.BCBSPRNY__c + cbcl.BCBOTPNY__c;

        cbcl.BCBTSRY__c = string.valueof(cbcl.BCBTSRNY__c);

        DS_DATA__c total = scaleInfo.get(age+'-null-'+gender+'-'+cbcl.BCBTSRNY__c+'-Total');

        cbcl.BCBTSTY__c = string.valueOf(total.T_Score__c);
        cbcl.BCBTSTNY__c = total.T_Score__c;
        cbcl.BCBTSPY__c = total.Percentile__c;
        cbcl.BCBTSSY__c = total.Sig_Range__c;

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