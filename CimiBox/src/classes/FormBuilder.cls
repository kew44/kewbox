/**
* @author Danny Fu, Kelsey Willett
* @date 11/30/2014
* @modified date 11/30/2015
*
* @group Form Builder
* @group-content /ApexDocContent/FormBuilder.htm
*
* @description An apex class on objects that handles createing the forms in client summary object 
* depended on some specific conditions. 
*/
public class FormBuilder{
    
    /****
    * @description Create new client summary record  
    * @param clientID client id
    * @param formID form id (DS_DATA id)
    * @param formCategory form category
    * @param sectionNum section number
    * @param required the form is required or optional 
    * @return client_aummary___c 
    * @example
    * List<Client_Summary__c> newSummaryList = new List<Client_Summary__c>();
    * newSummaryList.add(newSummary(client.id, form.id, 'baseline', '0', true));
    */ 
    public static Client_Summary__c newSummary(String clientID, ID formID, String formCategory, String sectionNum, Boolean required) {
        
        //create new record of page information on Client_Summary__c
        Client_Summary__c newSummary = 
            new Client_Summary__c(client__c = clientID, Page__c = formID, 
                                  FORM_TYPE__c = formCategory, REQUIRED__c = required,
                                  SECTION__c = sectionNum);
        
        return newSummary;
    }
    
    //baseline creation of forms
    public static void baseline(Set<String> clients) { 
        
        //new list of Client_Summary__c for visit
        List<Client_Summary__c> newSummaryList = new List<Client_Summary__c>();
        
        //new list of form info specifically for baseline forms                 
        List<DS_DATA__c> baselineformInfo = [SELECT Category__c, Content__c, Variable__c, Age_Range__c, Form__c
                                             FROM DS_Data__c 
                                             WHERE (Category__c = 'Baseline' 
                                                    OR Category__c = 'Assessment'
                                                    OR Category__c = 'GT')
                                             AND Data_Type__c = 'DS_Form_Info'
                                             AND FILE_NAME__c = 'Baseline'
                                             ORDER BY Category__c, weight__c];     
        
        //maps Client__c to Id
        Map<Id, Client__c> clientInfo = new Map<Id, Client__c>(
            [SELECT id, Current_Age__c, gender__c, AGE__c
             FROM Client__c
             WHERE id IN : clients]); 
        
        // For display logic. Don't add Military, REFIMM, and Health in client summary object. 
        Set<String> skippedForm = new Set<String>();
        skippedForm.add('DS_MILITARY');
        skippedForm.add('DS_REFIMM');
        skippedForm.add('DS_HEALTH');
        
        //iterate DS_DATA__c form info
        for(DS_Data__c f : baselineformInfo ) {
            
            //skip ones w/ age range
            if(f.Age_Range__c != null) {
                skippedForm.add(f.FORM__c);
            }
            
            String sectionNum = (f.Category__c == 'GT') ? '-1' : '0';
            
            // Skip and jump to next form
            if(skippedForm.contains(f.Form__c)) continue;
            
            //iterate over Client__c
            for(String c : clients) {  
                
                //if no age range
                if(f.Age_Range__c == null) {
                    
                    //add client summary to list
                    newSummaryList.add(newSummary(c, f.id, f.Category__c, sectionNum, true));
                    
                }               
            }
        }
        
        //insert list of client summary info list
        insert newSummaryList;                               
    }
    
    //followup creation of forms
    public static String followup(Set<String> clients) {
        
        //get background f record
        DS_Background_Family_Info_F__c background = new DS_Background_Family_Info_F__c();
        
        List<DS_Background_Family_Info_F__c> backgroundList= new List<DS_Background_Family_Info_F__c>();
        
        //initialize String formId
        String followupDataFormId = '';
        
        //initialize String summaryId
        String followupInfoSummaryID = '';
        
        //initialize String sectionNum
        String sectionNum;
        
        //initialize String client id
        String client_id;
        
        //get Client_Summary__c record for use in query
        Client_Summary__c summary = new Client_Summary__c();
        
        //new list of Client_Summary__c for visit
        List<Client_Summary__c> newSummaryList = new List<Client_Summary__c>();
        
        //get form info for visit
        List<DS_DATA__c> followformInfo = [SELECT Category__c, Content__c, Variable__c,  Age_Range__c, Form__c
                                           FROM DS_DATA__c 
                                           WHERE (Category__c = 'FollowUp' 
                                                  OR Category__c = 'Assessment')
                                           AND Data_Type__c = 'DS_Form_Info'
                                           AND FILE_NAME__c = 'FOLLOWUP'
                                           ORDER BY Category__c, weight__c];
        
        //maps Client__c to Id
        Map<Id, Client__c> clientInfo = new Map<Id, Client__c>(
            [SELECT id, Current_Age__c, gender__c, AGE__c
             FROM Client__c
             WHERE id IN : clients]); 
        
        //set of forms to skip because of logic rules
        Set<String> skippedForm = new Set<String>(); 
        skippedForm.add('DS_MILITARY');      
        skippedForm.add('DS_HEALTH');
        
        //map list of section num to String
        Map<String, Integer> sectionNumList= new Map<string, Integer>();
        
        //iterate DS_DATA__c form info
        for(DS_DATA__c f : followformInfo) {
            
            //skip ones w/ age range
            if(f.Age_Range__c != null) {
                skippedForm.add(f.FORM__c);
            }                        
            
            //aggregate result list of sections and clients 
            List<aggregateResult> sections = [SELECT Max (Section__c) section,client__c  FROM Client_summary__c WHERE client__c IN: clients GROUP BY client__c ];
            
            //if part of skippedForm set, skip
            if(skippedForm.contains(f.Form__c)) continue;
            
            //iterate over aggregate result list
            for (AggregateResult ar : sections)  {
                
                //set client id
                client_id= String.valueOf(ar.get('client__c'));
                
                //set section number
                sectionNum = String.valueOf(ar.get('section'));
                
                //set aggregate result list of section number
                sectionNumList = new Map<string, Integer>();
                
                //add section and client to aggregate result list
                sectionNumList.put(client_id,Integer.valueOf(sectionNum));
            }   
            
            //iterate over Client__c
            for(String c : clients) {
                
                //increment section number
                sectionNum = String.valueOf(sectionNumList.get(c)+1);
                
                //if no age range
                if(f.Age_Range__c == null) {
                    
                    //add client summary to list
                    newSummaryList.add(newSummary(c, f.id, f.Category__c, sectionNum, true));                    
                }               
            }
            
            //if the form is FOLLOWUPINFO, set form id. 
            if(f.Form__c == 'DS_FOLLOWUPINFO') 
                followupDataFormId = f.id;
        }
        
        //insert list of client summary info list
        insert newSummaryList;
        
        //iterates over newSummaryList
        for(Client_Summary__c s: newSummaryList){
            
            //if summaryList Page is form id, set summary id to summaryList id. 
            if(s.Page__c == followupDataFormId)
                followupInfoSummaryID = s.id;                       
        }
        
        //return Summary ID. 
        return followupInfoSummaryID;               
    }
    
    /****
    * @description Control form display on client summary page depened on the response and age    
    * @param obj a list of the SObject
    * @return null
    * @example
    * if(Trigger.isAfter) {
    *   FormBuilder.FormDisplayLogic(Trigger.new);
    * }
    */
    public static void FormDisplayLogic(List<SObject> obj) {
        
        Set<String> sections = new Set<String>();
        Set<String> clients = new Set<String>();
        String BorF = '';
        
        for(SObject o : obj) {
            sections.add(String.valueof(o.get('SECTION__c')));
            clients.add(String.valueof(o.get('CLIENT__c')));
        }
        
        //determine b/f based on section
        if(sections.isEmpty() == false)
            BorF = (Integer.valueOf((new list<string>(sections))[0]) > 0) ? 'F' : 'B';
                       
        //string to represent DS_DATA__c.FILE_NAME__c based on section number. FILE_NAME__c is distinct from Category__c or FORM_TYPE__c b/c it is all caps and is either baseline or followup, does not distinguish assessments
        String formFileName = (BorF == 'F') ? 'FOLLOWUP' : 'BASELINE';
                       
        //age range string
        List<String> range = new List<String>(); 
        
        //list of forms that use display logic
        Set<String> displayLogicForms = new Set<String>{'DS_HEALTH', 'DS_MILITARY', 'DS_REFIMM'};
                       
        //get form info from DS_DATA__c for affected forms
        List<DS_DATA__c> formInfo = [SELECT Content__c, Variable__c, Form__c, id, Age_Range__c, Category__c, FILE_NAME__c
                                       FROM DS_DATA__c 
                                      WHERE Data_Type__c = 'DS_Form_Info'
                                        AND FILE_NAME__c =: formFileName
                                        AND Category__c != 'GT'];
        
        //lists the Client_Summary__c record(s) to be inserted
        List<Client_Summary__c> insertClientSummary = new List<Client_Summary__c>();               
                       
        List<Client_Summary__c> existingClientSummary = [SELECT Client__c, Page__c, Page__r.Form__c, SECTION__c, Page__r.Page__c
                                                           FROM Client_Summary__c
                                                          WHERE SECTION__c IN : sections
                                                            AND Page__r.FILE_NAME__c =: formFileName
                                                            AND Client__c IN : clients];
                       
        Map<String, Client_Summary__c> existingClientSummaryMap = new Map<String, Client_Summary__c>(); 
        
        if(existingClientSummary.size() > 0){
            
            for(Client_Summary__c summary : existingClientSummary) {
                
                // key = 'clientID-FormForceID-SECTION'
                String[] key = new List<String>{summary.client__c, summary.Page__c, summary.SECTION__c};
                
                existingClientSummaryMap.put(StringUtils.joinArray(key, '-'), summary);
                
            }    
            
        }   
                
        for(DS_DATA__c info : formInfo) {//info loop before object
        
            String formName = info.Form__c;
            ID formId = info.id;
            String category = info.Category__c; 
                        
            List<String> ageRange = (info.Age_Range__c != null) ? info.Age_Range__c.split('_', 0) : new List<String>();
            
            Double minAgeRange, maxAgeRange = 0;
            
            if(ageRange.size() > 0) {
                minAgeRange = Double.valueOf(ageRange.get(0));
                maxAgeRange = Double.valueOf(ageRange.get(1));
            }
            
            for(SObject o : obj) {//object loop after info
                
                String clientID = String.valueOf(o.get('client__c'));
                String section = String.valueOf(o.get('SECTION__c'));
                
                //get visit age
                Double visitAge = Double.valueOf(o.get(BorF + '_VISIT_AGE__c'));
                
                String[] key = new List<String>{clientID, formId, section};
                
                // Skip the form if it exists in the client summary                    
                if(existingClientSummaryMap.containsKey(StringUtils.joinArray(key, '-'))) { 
                    continue; 
                }
                else {
                                                            
                    // if the form has display logic
                    if (displayLogicForms.contains(info.Form__c)) {
                        
                        // Form has age requirement and client visit age is not in the range, skip this form
                        if(info.Age_Range__c != null) {
                            // Visit age < Age range < Visit age
                            if(visitAge < minAgeRange && maxAgeRange < visitAge) {
                                continue;
                            }
                        }
                        
                        // baseline case
                        if (BorF ==  'B') {
                            //DS_REFIMM
                            if((o.get(BorF+'USBORN__c') == '0' || o.get(BorF+'PUSBORN__c') == '0') && (formName == 'DS_REFIMM')) {   
                                insertClientSummary.add(newSummary(clientID, formId, category, section, true)); 
                            }
                            //DS_MILITARY
                            if((o.get(BorF+'MILSELF__c') == '1' || o.get(BorF+'MILFAMILY__c') == '1' || o.get(BorF+'MILFAMILY__c') == '2') && formName == 'DS_MILITARY') {
                                insertClientSummary.add(newSummary(clientID, formId, category, section, true));                                
                            }
                            //DS_HEALTH
                            if(((o.get(BorF+'HOVERALL__c') == '4' || o.get(BorF+'HOVERALL__c') == '5' || o.get(BorF+'HTHSTAT__c') == '1' || 
                                 o.get(BorF+'HTHSTAT__c') == '2'  || o.get(BorF+'HTHSTAT__c') == '3') ) && (formName == 'DS_HEALTH')) {
                                insertClientSummary.add(newSummary(clientID, formId, category, section, true)); 
                            }
                        }                               
                        // followup case
                        else if(BorF == 'F') {
                            // DS_MILITARY
                            if (o.get(BorF+'MSTAT__c') == '1' && formName == 'DS_MILITARY') {  
                                insertClientSummary.add(newSummary(clientID, formId, category, section, true)); 
                            }
                            // DS_HEALTH
                            if((o.get(BorF+'HOVERALL__c') == '4' || o.get(BorF+'HOVERALL__c') == '5') && formName == 'DS_HEALTH') {  
                                insertClientSummary.add(newSummary(clientID, formId, category, section, true)); 
                            }
                        }
                                                                                
                    }
                    // Forms have age requirement
                    else if(info.Age_Range__c != null) {
                        // Min age range <= Visit age <= Max age range
                        if(minAgeRange <= visitAge && visitAge <= maxAgeRange) { 
                            insertClientSummary.add(newSummary(clientID, formId, category, section, true));     
                        }
                    }
                    // Forms don't have any special requirement and need to be filled out (for data import)
                    else {
                        insertClientSummary.add(newSummary(clientID, formId, category, section, true));
                    }
                                                    
                }                          
            
            }          
        
        }  
        
        insert insertClientSummary;
        
    }
    
}