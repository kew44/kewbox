public class FormBuilder {
    
    // New Summary method 
    public static Client_Summary__c newSummary(String clientID, ID formID, String formCategory, String sectionNum, Boolean required) {
        
        Client_Summary__c newSummary = 
            new Client_Summary__c(client__c = clientID, Page__c = formID, 
                                  FORM_TYPE__c = formCategory, REQUIRED__c = required,
                                  SECTION__c = sectionNum);
        
        return newSummary;
    }
    
    // Baseline method
    public static void baseline(Set<String> clients) {
        
        List<Client_Summary__c> newSummaryList = new List<Client_Summary__c>();
        
        List<DS_Data__c> formInfo = [SELECT Category__c, Content__c, Variable__c,  
                                     Age_Range__c, Form__c
                                     FROM DS_Data__c 
                                     WHERE (Category__c = 'Baseline' 
                                            OR Category__c = 'Assessment'
                                            OR Category__c = 'GT')
                                     AND Data_Type__c = 'DS_Form_Info'
                                     AND FILE_NAME__c = 'Baseline'
                                     ORDER BY Category__c, weight__c];
        
        
        Map<Id, Client__c> clientInfo = 
            new Map<Id, Client__c>([SELECT id, Current_Age__c, gender__c, Age__c
                                    FROM Client__c
                                    WHERE id IN : clients]); 
        
        // For display logic. Don't add Military, REFIMM, and Health in client summary object. 
        Set<String> skippedForm = new Set<String>();
        skippedForm.add('DS_MILITARY');
        skippedForm.add('DS_REFIMM');
        skippedForm.add('DS_HEALTH');
        
        for(DS_Data__c f : formInfo) {
            
            String sectionNum = (f.Category__c == 'GT') ? '-1' : '0';
            
            // Skip and jump to next form
            if(skippedForm.contains(f.Form__c)) continue;
            
            for(String c : clients) {
                
                if(f.Age_Range__c == null) {
                    newSummaryList.add(newSummary(c, f.id, f.Category__c, sectionNum, true));
                }
                else {
                    
                    List<String> range = f.Age_Range__c.split('_', 0); 
                    
                    if((Double.valueOf(range.get(0)) <= Double.valueOf(clientInfo.get(c).Age__c)) && (Double.valueOF(range.get(1)) >= Double.valueOf(clientInfo.get(c).Age__c)))           
                        newSummaryList.add(newSummary(c, f.id, f.Category__c, sectionNum, true));
                    
                }
                
            }
            
        }
        
        insert newSummaryList;
        
    }
    
    // Follow-up method
    public static String followup(Set<String> clients) {
        
        DS_Background_Family_Info_F__c background = new DS_Background_Family_Info_F__c();
        
        List<DS_Background_Family_Info_F__c> backgroundList= new List<DS_Background_Family_Info_F__c>();

        String followupDataFormId = '';
        String followupInfoSummaryID = '';
        
        //for query
        Client_Summary__c summary = new Client_Summary__c();
        
        //new visit
        List<Client_Summary__c> newSummaryList = new List<Client_Summary__c>();
        
        //forms for visit
        List<DS_Data__c> followformInfo = [SELECT Category__c, Content__c, Variable__c,  
                                           Age_Range__c, Form__c
                                           FROM DS_Data__c 
                                           WHERE (Category__c = 'FollowUp' 
                                                  OR Category__c = 'Assessment')
                                           AND Data_Type__c = 'DS_Form_Info'
                                           AND FILE_NAME__c = 'FOLLOWUP'
                                           ORDER BY Category__c, weight__c];
                        
        //client
        Map<Id, Client__c> clientInfo = 
            new Map<Id, Client__c>([SELECT id, Current_Age__c, gender__c
                                    FROM Client__c
                                    WHERE id IN : clients]); 
        
        //check to see if skipped rules apply
        Set<String> skippedForm = new Set<String>(); 
        skippedForm.add('DS_MILITARY');      
        skippedForm.add('DS_HEALTH');                 
        
        String sectionNum;
        String client_id;
        
        Map<String, Integer> sectionNumList= new Map<string, Integer>();
                
        for(DS_Data__c f : followformInfo) {

            List<aggregateResult> sections = [SELECT Max (Section__c) section,client__c  FROM Client_summary__c WHERE client__c IN: clients GROUP BY client__c ];//String.valueOf([SELECT Max (Section__c) FROM Client_summary__c WHERE client__c IN: clients GROUP BY client__c ]);
            
            // Skip and jump to next form
            if(skippedForm.contains(f.Form__c)) continue;
            
            for (AggregateResult ar : sections)  {
                client_id= String.valueOf(ar.get('client__c'));
                
                sectionNum = String.valueOf(ar.get('section'));
                
                sectionNumList = new Map<string, Integer>();
                sectionNumList.put(client_id,Integer.valueOf(sectionNum));
            }        
            
            for(String c : clients) {
                
                sectionNum = String.valueOf(sectionNumList.get(c)+1);
                
                //age range check
                if(f.Age_Range__c == null) {
                    newSummaryList.add(newSummary(c, f.id, f.Category__c, sectionNum, true));
                }
                else {
                    
                    List<String> range = f.Age_Range__c.split('_', 0); 
                    
                    if((Double.valueOf(range.get(0)) <= Double.valueOf(clientInfo.get(c).Current_Age__c)) && (Double.valueOF(range.get(1)) >= Double.valueOf(clientInfo.get(c).Current_Age__c)))           
                        newSummaryList.add(newSummary(c, f.id, f.Category__c, sectionNum, true));
                    
                }
                                
            }

            if(f.Form__c == 'DS_FOLLOWUPINFO') followupDataFormId = f.id;
            
        }
        
        insert newSummaryList;
        
        for(Client_Summary__c s: newSummaryList)
          if(s.Page__c == followupDataFormId) followupInfoSummaryID = s.id;
        
        return followupInfoSummaryID;
    }
    
    // Display for Military, Refuge, and Health
    public static void MilitaryRefugeHealthDisplayLogic(List<SObject> obj) {  
        
        String section = String.valueOf(obj.get(0).get('SECTION__c'));
        
        String BorF = (Integer.valueOf(section) > 0) ? 'F' : 'B';
        
        String category = (Integer.valueOf(section) > 0) ? 'FollowUp' : 'Baseline';
        
        List<String> forms = new List<String>{'DS_HEALTH', 'DS_MILITARY', 'DS_REFIMM'};
            
            List<DS_Data__c> formInfo = [SELECT Content__c, Variable__c,  
                                         Form__c, id
                                         FROM DS_Data__c 
                                         WHERE Category__c = : category 
                                         AND Data_Type__c = 'DS_Form_Info'
                                         AND Form__c IN : forms];
        
        Map<String, DS_DATA__c> formMap = new Map<String, DS_DATA__c>();                                    
        for(DS_Data__c info : formInfo) formMap.put(info.Form__c, info);
        
        List<String> clients = new List<String>();
        
        for(SObject b : obj) clients.add(String.valueOf(b.get('Client__c')));
        
        List<Client_Summary__c> clientSummary = [SELECT Page__c, Client__c
                                                 FROM Client_Summary__c
                                                 WHERE Client__c IN : clients
                                                 AND Page__r.Form__c IN : forms
                                                 AND SECTION__c = : section];
        
        Set<String> clientSummaryExisted = new Set<String>();
        
        for(Client_Summary__c cs : clientSummary)
            clientSummaryExisted.add(cs.Client__c+'-'+cs.Page__c);
        
        Map<Id, Client__c> clientInfo = 
            new Map<Id, Client__c>([SELECT id, Current_Age__c, gender__c
                                    FROM Client__c
                                    WHERE id IN : clients]); 
        
        List<Client_Summary__c> insertClientSummary = new List<Client_Summary__c>();
        
        for(SObject b : obj) {
            
            String clientID = String.valueOf(b.get('Client__c'));
            String sectionNum = String.valueOf(b.get('SECTION__c'));
            
            if (BorF ==  'B'){
                // DS_REFIMM
                if ((b.get(BorF+'USBORN__c') == '0' || b.get(BorF+'PUSBORN__c') == '0') && (!clientSummaryExisted.contains(clientID+'-'+formMap.get('DS_REFIMM').id)))        
                    insertClientSummary.add(newSummary(clientID, formMap.get('DS_REFIMM').id, category, sectionNum, true));
                // DS_MILITARY
                if ((b.get(BorF+'MILSELF__c') == '1' || b.get(BorF+'MILFAMILY__c') == '1' || b.get(BorF+'MILFAMILY__c') == '2') && (!clientSummaryExisted.contains(clientID+'-'+formMap.get('DS_MILITARY').id)))
                    insertClientSummary.add(newSummary(clientID, formMap.get('DS_MILITARY').id, category, sectionNum, true));    
                // DS_HEALTH
                if ((b.get(BorF+'HOVERALL__c') == '4' || b.get(BorF+'HOVERALL__c') == '5' || b.get(BorF+'HTHSTAT__c') == '1' || b.get(BorF+'HTHSTAT__c') == '2' || b.get(BorF+'HTHSTAT__c') == '3') && (!clientSummaryExisted.contains(clientID+'-'+formMap.get('DS_HEALTH').id)))
                    insertClientSummary.add(newSummary(clientID, formMap.get('DS_HEALTH').id, category, sectionNum, true));       
            }
            else if (BorF == 'F'){ 
                // DS_MILITARY
                if ((b.get(BorF+'MSTAT__c') == '1' ) && (!clientSummaryExisted.contains(clientID+'-'+formMap.get('DS_MILITARY').id)))
                    insertClientSummary.add(newSummary(clientID, formMap.get('DS_MILITARY').id, category, sectionNum, true));
                // DS_HEALTH    
                if ((b.get(BorF+'HOVERALL__c') == '4' || b.get(BorF+'HOVERALL__c') == '5') && (!clientSummaryExisted.contains(clientID+'-'+formMap.get('DS_HEALTH').id)))
                    insertClientSummary.add(newSummary(clientID, formMap.get('DS_HEALTH').id, category, sectionNum, true));   
            }
        }           
        
        insert insertClientSummary;
        
    }
    
    
}