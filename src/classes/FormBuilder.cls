public class Formbuilder{
                
     // New Summary method 
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
                                     ORDER BY Category__c, weight__c];//new List<DS_DATA__c>();     
                                
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
        
        System.debug(f.Category__c);
        System.debug(f.Content__c);
        System.debug(f.Age_Range__c);
        System.debug(f.FORM__c);
        System.debug(f);
            
            //skip ones w/ age range
            if(f.Age_Range__c != null) {
                    skippedForm.add(f.FORM__c);
            }
            System.debug(skippedForm);
            
            String sectionNum = (f.Category__c == 'GT') ? '-1' : '0';
                        
            // Skip and jump to next form
            if(skippedForm.contains(f.Form__c)) continue;
            
            //iterate over Client__c
            for(String c : clients) {  
            
                //if no age range
                if(f.Age_Range__c == null) {
                
                    //add client summary to list
                    newSummaryList.add(newSummary(c, f.id, f.Category__c, sectionNum, true));
                    
                    System.debug(newSummaryList);
                }
               
            }
            System.debug(newSummaryList);
            System.debug(baselineformInfo );
        }
        System.debug(newSummaryList);
        System.debug(baselineformInfo );
        
        //insert list of client summary info list
        insert newSummaryList;                               
    }
    
       //followup creation of forms
    public static String followup(Set<String> clients) {
    
        //get background f record
        DS_Background_Family_Info_F__c background = new DS_Background_Family_Info_F__c();
        System.debug(background);
        
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
        
        System.debug(f.Category__c);
        System.debug(f.Content__c);
        System.debug(f.Age_Range__c);
        System.debug(f.FORM__c);
        System.debug(f);
        
            //skip ones w/ age range
            if(f.Age_Range__c != null) {
                    skippedForm.add(f.FORM__c);
            }
            System.debug(skippedForm);
            
            //aggregate result list of sections and clients 
            List<aggregateResult> sections = [SELECT Max (Section__c) section,client__c  FROM Client_summary__c WHERE client__c IN: clients GROUP BY client__c ];//String.valueOf([SELECT Max (Section__c) FROM Client_summary__c WHERE client__c IN: clients GROUP BY client__c ]);
                        
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
                
                    System.debug(newSummaryList);
                }
                                
            }
            
            //if the form is FOLLOWUPINFO, set form id. ?
            if(f.Form__c == 'DS_FOLLOWUPINFO') 
                followupDataFormId = f.id;
        }
        
        //insert list of client summary info list
        insert newSummaryList;
        
        //iterates over newSummaryList
        for(Client_Summary__c s: newSummaryList)
            
            //if summaryList Page is form id, set summary id to summaryList id. ?
            if(s.Page__c == followupDataFormId)
                followupInfoSummaryID = s.id;
        
        //return Summary ID. Still in loop? don't think so
        return followupInfoSummaryID;       
    }
    
    //display based on age and/or responses
    public static void FormDisplayLogic(List<SObject> obj) { 
        
        //get section
        String section = String.valueOf(obj.get(0).get('SECTION__c'));
        System.debug(section);

        //determine b/f based on section
        String BorF = (Integer.valueOf(section) > 0) ? 'F' : 'B';
        System.debug(BorF);
                
        //initialize category String (DS_DATA__c.Category__c = Client_Summary__c.FORM_TYPE__c)      
        String category;
        
        //string to represent DS_DATA__c.FILE_NAME__c based on section number. FILE_NAME__c is distinct from Category__c or FORM_TYPE__c b/c it is all caps and is either baseline or followup, does not distinguish assessments
        String dataFileName = (Integer.valueOf(section) > 0) ? 'FOLLOWUP' : 'BASELINE';
        System.debug(dataFileName);
        
        //list of forms that use display logic
        List<String> forms = new List<String>{'DS_HEALTH', 'DS_MILITARY', 'DS_REFIMM', 'DS_CANSTR', 'DS_CBCL_0_5', 'DS_CBCL_6_18', 'DS_INDSEV', 'DS_PTSD_CA', 'DS_SDQ_P_04_10', 'DS_SDQ_P_11_17', 'DS_SDQ_S_11_17', 'DS_YCINDSEV'};
        System.debug(forms);
        
        //get form info from DS_DATA__c for affected forms
        List<DS_DATA__c> formInfo = [SELECT Content__c, Variable__c, Form__c, id, Age_Range__c, Category__c, FILE_NAME__c
                             FROM DS_DATA__c 
                             WHERE Data_Type__c = 'DS_Form_Info'
                             AND FILE_NAME__c =: dataFileName
                             AND Form__c IN : forms];
                                        
        //maps DS_DATA__c record to String
        Map<String, DS_DATA__c> formMap = new Map<String, DS_DATA__c>(); 
        
        //iterates over DS_DATA__c and assigns to formMap                                
        for(DS_DATA__c info : formInfo) {
            formMap.put(info.Form__c, info);
            
                System.debug(info.FILE_NAME__c);
                
                System.debug(info.Category__c);
                category = info.Category__c;
            }
            
        //list of client string
        List<String> clients = new List<String>();
        
        //iterates over object to assign clients
        for(SObject b : obj) 
            clients.add(String.valueOf(b.get('Client__c')));
                        
        //get clientSummary information for client and forms
        List<Client_Summary__c> clientSummary = [SELECT Page__c, Client__c, FORM_TYPE__c//=category?
                                                 FROM Client_Summary__c
                                                 WHERE Client__c IN : clients
                                                 AND FORM_TYPE__c = :  category
                                                 AND Page__r.Form__c IN : forms
                                                 AND SECTION__c = : section];
        System.debug(clientSummary);
        
        //Strings together client and page
        Set<String> clientPage = new Set<String>();
        
        //iterates over Client_Summary__c and assigns clientPage
        for(Client_Summary__c cs : clientSummary){
        
            clientPage.add(cs.Client__c+'-'+cs.Page__c);
            
            System.debug(cs.FORM_TYPE__c);
            System.debug(category);
        }
        
        System.debug(clientPage);
        
        //maps Client__c to Id
        Map<Id, Client__c> clientInfo = new Map<Id, Client__c>(
                                                    [SELECT id, Current_Age__c, gender__c, AGE__c
                                                    FROM Client__c
                                                    WHERE id IN : clients]); 
        
        //lists the Client_Summary__c record(s) to be inserted
        List<Client_Summary__c> insertClientSummary = new List<Client_Summary__c>();
        
        //iterates over the object
        for(SObject b : obj) {
            
            //String for Client ID
            String clientID = String.valueOf(b.get('Client__c'));
            System.debug(clientID);
            
            //String for section number
            String sectionNum = String.valueOf(b.get('SECTION__c'));
            System.debug(sectionNum);
            
            //get visit age
            Integer VisitAge = Integer.valueOf(obj.get(0).get(BorF + '_VISIT_AGE__c'));
            System.debug(VisitAge);
            
            //iterates over DS_DATA__c                             
            for(DS_DATA__c info : formInfo) {
                        
                System.debug(category);
                
                System.debug(info);
                System.debug(info.Age_Range__c);
                                
                for (String c : clients){
                    if(info.Age_Range__c != null){
                    
                        //split age range into list of strings
                        List<String> range = info.Age_Range__c.split('_', 0); 
                        System.debug(range);
                        
                        System.debug(b.get(BorF + '_VISIT_AGE__c'));
                        System.debug(VisitAge);
                        System.debug(Double.valueOf(VisitAge));
                        System.debug(Double.valueOf(range.get(0)));
                        System.debug(Double.valueOf(range.get(1)));
                        System.debug(range.get(0));
                        System.debug(range.get(1));
                        System.debug(info.Form__c);
                        
                        String formName = String.valueOf(info.Form__c);
                        System.debug(formName);
                        
                        if((Double.valueOf(range.get(0)) <= Double.valueOf(VisitAge) && (Double.valueOF(range.get(1)) >= Double.valueOf(VisitAge))) )          
                            insertClientSummary.add(newSummary(c, formMap.get(formName).id, info.Category__c, sectionNum, true));
                    }
                }
            System.debug(insertClientSummary);
            }
            System.debug(category);
            
            //baseline case
            if (BorF ==  'B'){
                
                // DS_REFIMM
                if ((b.get(BorF+'USBORN__c') == '0' || b.get(BorF+'PUSBORN__c') == '0') && (!clientPage.contains(clientID+'-'+formMap.get('DS_REFIMM').id)))        
                    insertClientSummary.add(newSummary(clientID, formMap.get('DS_REFIMM').id, category, sectionNum, true));
                
                // DS_MILITARY
                if ((b.get(BorF+'MILSELF__c') == '1' || b.get(BorF+'MILFAMILY__c') == '1' || b.get(BorF+'MILFAMILY__c') == '2') && (!clientPage.contains(clientID+'-'+formMap.get('DS_MILITARY').id)))
                    insertClientSummary.add(newSummary(clientID, formMap.get('DS_MILITARY').id, category, sectionNum, true));    
                
                // DS_HEALTH
                if ((b.get(BorF+'HOVERALL__c') == '4' || b.get(BorF+'HOVERALL__c') == '5' || b.get(BorF+'HTHSTAT__c') == '1' || b.get(BorF+'HTHSTAT__c') == '2' || b.get(BorF+'HTHSTAT__c') == '3') && (!clientPage.contains(clientID+'-'+formMap.get('DS_HEALTH').id)))
                    insertClientSummary.add(newSummary(clientID, formMap.get('DS_HEALTH').id, category, sectionNum, true));       
            }
            
            //followup case
            else if (BorF == 'F'){ 
            
                // DS_MILITARY
                if ((b.get(BorF+'MSTAT__c') == '1' ) && (!clientPage.contains(clientID+'-'+formMap.get('DS_MILITARY').id)))
                    insertClientSummary.add(newSummary(clientID, formMap.get('DS_MILITARY').id, category, sectionNum, true));
                
                // DS_HEALTH
                if ((b.get(BorF+'HOVERALL__c') == '4' || b.get(BorF+'HOVERALL__c') == '5') && (!clientPage.contains(clientID+'-'+formMap.get('DS_HEALTH').id)))
                    insertClientSummary.add(newSummary(clientID, formMap.get('DS_HEALTH').id, category, sectionNum, true));   
            }
            
        System.debug(insertClientSummary);
        }
        System.debug(insertClientSummary);
        System.debug(category);
        System.debug(category);
        System.debug(forms);
        System.debug(dataFileName);
        System.debug(BorF);
        System.debug(section);
        
        insert insertClientSummary;
    }
}