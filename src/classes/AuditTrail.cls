/**
* @author Danny Fu
* @date 11/09/2015
* @modified date
*
* @group Audit Trail
* @group-content /ApexDocContent/AuditTrail.htm
*
* @description An apex controller on any object that handles ensuring any changes in the system 
* are recorded in the audit trail object. It is used in triggers. 
* e.g. :
*    if(Trigger.isAfter) {
*    	AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
* 	    if(Trigger.isInsert) { audit.generateLog(); }
*       if(Trigger.isUpdate) { audit.generateLog(); } 
*    }
*/
public class AuditTrail {
    
    Utility ut = new Utility();
    
    Map<String, String> codeList = new Map<String, String>();
    
    Set<String> forms = new Set<String>();
    
    Set<String> formsWithDS = new Set<String>();
    
    Set<String> clients = new Set<String>();
    
    Map<String, DS_DATA__c> formList = new Map<String, DS_DATA__c>();
    
    Map<String, client__c> clientList = new Map<String, client__c>();
    
    Map<String, List<DS_DATA__c>> dataDictionary = new Map<String, List<DS_DATA__c>>();
    
    public Set<String> existedInitialEntry;
    
    // Get user alias
    String creator = String.valueOf(UserInfo.getUserId());
    User user = [SELECT CommunityNickname FROM User WHERE id=: creator];

    private List<SObject> newObj = new List<SObject>();
    private List<SObject> oldObj = new List<SObject>();
    
    /****
    * @description Constructor, gather form information, data dictionary and client infomation. 
    * @param newObj new insert/update records
    * @param oldObj existed records
    * @return null
    * @example
    * 	AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old);
    */
    public AuditTrail(List<SObject> newObj, List<SObject> oldObj) { 
        
        this.newObj = newObj;
        this.oldObj = oldObj;
        
        for(SObject obj : newObj) { 
            
            // Find the forms which status is not null.  
            forms.addAll(getActivateForm(obj));
            
            // Collect clients 
            String clientID = String.valueOf(obj.get('client__c'));
            clients.add(clientID);
            
        }
        
        // List of form with DS_ in the front
        for(String form : forms) formsWithDS.add('DS_'+form);
        
        // Query for the form Information
        List<DS_DATA__c> formInfo = [SELECT Content__c, Page__c
                                     FROM DS_DATA__c
                                     WHERE Data_Type__c = 'DS_Form_Info'
                                     AND Page__c IN : formsWithDS];
        
        // Map for the form information
        for(DS_DATA__c f : formInfo) formList.put(f.Page__c, f);
        
        // Query for clients' information
        List<client__c> clientInfo = [SELECT id, AGE__c, DOB1__c, GENDER__c, 
                                      INIT__c, Clinician__c
                                      FROM Client__c
                                      WHERE id IN : clients];
        
        // Map for client information - Map<Client_id, Client>
        for(Client__c c : clientInfo) clientList.put(c.id, c);
        
        // Query the variables for only the audit trail forms
        List<DS_DATA__c> variables = [SELECT CODELIST__c, FILE_NAME__c, 
                                      SOURCE_FORM__c, VARIABLE_NUMBER__c,
                                      LONG_DESCRIPTION__c, VARIABLE_LABEL__c,
                                      VARIABLE_NAME__c, VARIABLE_TYPE__c,
                                      VARIABLE_VALUE__c
                                      FROM DS_DATA__c 
                                      WHERE Data_Type__c = 'DS_VARIABLE'
                                      AND SOURCE_FORM__c IN :forms];
        
        // Get the data dictory - e.g. Map<'DEMO-BASELINE', DS_DATA>
        for(DS_DATA__c var : variables) {
                
            String formID = var.SOURCE_FORM__c;
            String formType = var.FILE_NAME__c;
            List<DS_DATA__c> data = new List<DS_DATA__c>(); 
            
            if(dataDictionary.containsKey(formID+'-'+formType)) 
                data = dataDictionary.get(formID+'-'+formType);
            
            data.add(var); 
            
            dataDictionary.put(formID+'-'+formType, data);
                        
        }
        
        // Get code list - e.g. Map<'ZYES-true', 'Yes'>
        List<DS_Data__c> codeListDB = [SELECT LONGLABEL__c, CODE__c, CODELIST__c
                                       FROM DS_DATA__c
                                       WHERE Data_Type__c = 'DS_CODELIST'];
        
        for(DS_DATA__c code : codeListDB) 
            codeList.put(code.CODELIST__c+'-'+code.CODE__c, code.LONGLABEL__c);
        
        // Find the records which have initial entry
        existedInitialEntry = findExistedInitialEntry();
        
    }
        
    /****
    * @description Get the form ids which need to run audit trail 
    * @param obj new insert/update records
    * @return a set of form id
    * @example
    * 	Set<String> formIDs = getActivateForm(obj);
    */
    public Set<String> getActivateForm(Sobject obj) {
        
        Set<String> actforms = new Set<String>();
        
        String objectType = String.valueOf(obj.getsObjectType());
        
        String objName = objectType.substringBefore('__c');
        
        List<String> statusFields = ut.getFieldSetFields('STATUS', objectType);
        
        for(String statusField : statusFields) {
            
            // If the status is not null, it means there is some data for that form
            // Add the form and run the auditrail. 
            if(obj.get(statusField) != null) {
                
                Pattern p = Pattern.compile('STATUS_(.*?)__c');
                Matcher pm = p.matcher(statusField);
                
                if( pm.matches() ) {
                    actforms.add(pm.group(1));
                }
            }
        }
        
        return actforms;
        
    }

    /****
    * @description Find the records which have the initial entry
    * @param 
    * @return a set of form ID, client, section number
    * @example
    * 	Set<String> existedInitialEntry = findExistedInitialEntry();
    */
    public Set<String> findExistedInitialEntry() {
        
        Set<String> existedInitialEntry = new Set<String>();
        
        List<Audit_Trail__c> existData = [SELECT CLIENT__c, FORM__c, FORM_ID__c, SECTION__c
                                          FROM Audit_Trail__c
                                          WHERE FORM_ID__c IN : forms
                                          AND CLIENT__c IN : clients];
        
        for(Audit_Trail__c audit : existData)
            existedInitialEntry.add(audit.FORM_ID__c+'-'+audit.CLIENT__c+'-'+audit.SECTION__c);
        
        return existedInitialEntry;
        
    }
    
    /****
    * @description Generate the audit trail log
    * @param 
    * @return null
    * @example
    * 	AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
    *   if(Trigger.isInsert) { audit.generateLog(); }
    *   if(Trigger.isUpdate) { audit.generateLog(); } 
    */
    public void generateLog() {
                        
        Map<String, SObject> oldObjs = new Map<String, SObject>();
        
        // If there is a existed data, add the data into oldObjs
        if(oldObj != null)
            for(Sobject oObj : oldObj)
                oldObjs.put(String.valueOf(oObj.get('id')), oObj);
        
        // List for the inserted audit trail records
        List<Audit_Trail__c> auditTrialList = new List<Audit_Trail__c>();

        for(Sobject obj : newObj) {
            
            String BorF = null;
            Date visitDate = null;
            
            Set<String> formIDs = getActivateForm(obj);
            
            String section = String.valueOf(obj.get('SECTION__c'));
            String clientID = String.valueOf(obj.get('client__c'));
            
            Integer intSection = Integer.valueOf(section);
            
            if(intSection == 0) BorF = 'B';
            else if(intSection > 0) BorF = 'F';
            
            // The object is bseline or follow-up not trauma
            if (BorF != null) {
                visitDate = Date.valueOf(obj.get(BorF+'DOV__c'));
            }
            
            for(String fID : formIDs) {
                                
                // If the form doesn't have inital entry, run initialEntry()
                if(!existedInitialEntry.contains(fID+'-'+clientID+'-'+section))
                    auditTrialList.addAll(initialEntry(fID, clientID, section, visitDate));
                else 
                    auditTrialList.addAll(updateEntry(fID, obj, oldObjs.get(String.valueOf(obj.get('id'))), section, visitDate));
                
            }
            
        }
                
        insert auditTrialList;
        
    }
    
	/****
    * @description Create record for initial entry
    * @param formID Form id
    * @param clientID client id
    * @param section Section number
    * @param visitDate Visit date
    * @return list of the audit trail records
    * @example
    * 	List<Audit_Trail__c> auditTrialList = initialEntry('DEMO', clientID, '1', '11/08/2015')
    */
    public List<Audit_Trail__c> initialEntry(String formID, String clientID, String section, Date visitDate) {
                
        DateTime currentTime = System.now();
        
        List<Audit_Trail__c> auditTrialList = new List<Audit_Trail__c>();
        
        Client__c client = clientList.get(clientID);
        
        DS_DATA__c form = formList.get('DS_'+formID);
        
        Audit_Trail__c log = new Audit_Trail__c();
        
        log.Action__c = 'Initial Entry';
        log.Client__c = client.id;
        log.Date__c = currentTime.date();
        log.Time__c = currentTime.format('HH:mm:ss');
        log.Form__c = form.Content__c;
        log.FORM_ID__c = formID;
        log.User_Initial__c = user.CommunityNickname;
        log.User_ID__c = creator;
        log.SECTION__c = section;
        log.VISIT_DATE__c = visitDate;
        
        auditTrialList.add(log);
        
        return auditTrialList;
        
    }
    
    /****
    * @description Create records for update entry
    * @param formID Form id
    * @param newObj new update record
    * @param oldObj old existed record
    * @param section Section number
    * @param visitDate Visit date
    * @return list of the audit trail records
    * @example
    * 	List<Audit_Trail__c> auditTrialList = updateEntry('DEMO', obj, oldObj, '1', '11/08/2015')
    */
    public List<Audit_Trail__c> updateEntry(String formID, SObject newObj, SObject oldObj, String section, Date visitDate) {
                
        List<Audit_Trail__c> auditTrialList = new List<Audit_Trail__c>();
        String formType = '';
        
        // If there is no old record, it shouldn't update anything
        if(oldObj == null) return auditTrialList;

        // Get Baseline, Follow-up, Trauma 
        if(section == '-1') formType = 'TRAUMA';
        else if(section == '0') formType = 'BASELINE';
        else if(Integer.valueOf(section) > 0) formType = 'FOLLOWUP';
        
        // Get the fields from data dictionary
        List<DS_DATA__c> fields = dataDictionary.get(formID+'-'+formType);
        
        Client__c client = clientList.get(String.valueOf(newObj.get('Client__c')));
        
        DS_DATA__c form = formList.get('DS_'+formID);
        
        DateTime currentTime = System.now();
        
        List<Audit_Trail__c> logList = new List<Audit_Trail__c>();
                
        if(fields != null) {
            
            for(DS_DATA__c f : fields) {
                
                // If the field of DD doesn't exist in force, skip this field and move to the next one. 
                // Remove the comments after test is over. 
                if(ut.hasSObjectField(f.VARIABLE_NAME__c+'__c', oldObj)) continue;
                
                String priorRawValue = String.valueOf(oldObj.get(f.VARIABLE_NAME__c+'__c'));
                
                String updateRawValue = String.valueOf(newObj.get(f.VARIABLE_NAME__c+'__c'));
                
                // If there is an updated value, create an update log
                if(priorRawValue != updateRawValue) {
                    
                    // If the codelist is <None> or <Date>, just copy the field value to log
                    // else get the code value from the code list
                    String priorValue = (f.CODELIST__c == '<None>' || f.CODELIST__c == '<DATE>') ? 
                        String.valueOf(oldObj.get(f.VARIABLE_NAME__c+'__c')) : 
                    codeList.get(f.CODELIST__c+'-'+String.valueOf(oldObj.get(f.VARIABLE_NAME__c+'__c')));
                    
                    String updateValue = (f.CODELIST__c == '<None>' || f.CODELIST__c == '<DATE>') ? 
                        String.valueOf(newObj.get(f.VARIABLE_NAME__c+'__c')) : 
                    codeList.get(f.CODELIST__c+'-'+String.valueOf(newObj.get(f.VARIABLE_NAME__c+'__c')));
                    
                    Audit_Trail__c log = new Audit_Trail__c();
                    
                    log.Action__c = 'Update';
                    log.Client__c = client.id;
                    log.Date__c = currentTime.date();
                    log.Time__c = currentTime.format('HH:mm:ss');
                    log.Form__c = form.Content__c;
                    log.FORM_ID__c = formID;
                    log.Number__c = f.VARIABLE_NUMBER__c;
                    log.SECTION__c = String.valueOf(newObj.get('SECTION__c'));
                    log.Prior_Value__c = priorValue;
                    log.Updated_Value__c = updateValue;
                    log.Question__c = f.LONG_DESCRIPTION__c;
                    log.User_Initial__c = user.CommunityNickname;
                    log.User_ID__c = creator;
                    log.VISIT_DATE__c = visitDate;
                    log.LABEL__c = f.VARIABLE_LABEL__c;
                    log.VARIABLE__c = f.VARIABLE_NAME__c;
                    
                    auditTrialList.add(log);
                                        
                }
                
            }
            
        }
        
        return auditTrialList;
        
    }
}