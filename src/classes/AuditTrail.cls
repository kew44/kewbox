public class AuditTrail {

  Utility ut = new Utility();

  Map<String, String> codeList = new Map<String, String>();

  Set<String> forms = new Set<String>();

  Set<String> formsWithDS = new Set<String>();

  Set<String> clients = new Set<String>();

  Map<String, DS_DATA__c> formList = new Map<String, DS_DATA__c>();

  Map<String, client__c> clientList = new Map<String, client__c>();

  Map<String, List<DS_DATA__c>> dataDictionaryForm = new Map<String, List<DS_DATA__c>>();
  Map<String, DS_DATA__c> dataDictionaryField = new Map<String, DS_DATA__c>();

  public Set<String> hasInitialEntry;

  String creator = String.valueOf(UserInfo.getUserId());

  User user = [SELECT CommunityNickname FROM User WHERE id=: creator];


  public AuditTrail(List<SObject> newObj, List<SObject> oldObj) { 

    //Set<String> forms2 = new Set<String>();

    //Set<String> formsWithDS2 = new Set<String>();

    for(SObject obj : newObj) { 

      forms.addAll(getActivateForm(obj));

      String clientID = String.valueOf(obj.get('client__c'));
      
      clients.add(clientID);

    }

    for(String form : forms) formsWithDS.add('DS_'+form);
    
    List<DS_DATA__c> formInfo = [SELECT Content__c, Page__c
                                   FROM DS_DATA__c
                                  WHERE Data_Type__c = 'DS_Form_Info'
                                    AND Page__c IN : formsWithDS];

    for(DS_DATA__c f : formInfo)
      formList.put(f.Page__c, f);

    List<client__c> clientInfo = [SELECT id, AGE__c, DOB1__c, GENDER__c, 
                                         INIT__c, Clinician__c
                                    FROM Client__c
                                   WHERE id IN : clients];

    for(Client__c c : clientInfo) 
      clientList.put(c.id, c);

    List<DS_DATA__c> variables = [SELECT CODELIST__c, FILE_NAME__c, 
                                         SOURCE_FORM__c, VARIABLE_NUMBER__c,
                                         LONG_DESCRIPTION__c, VARIABLE_LABEL__c,
                                         VARIABLE_NAME__c, VARIABLE_TYPE__c,
                                         VARIABLE_VALUE__c
                                    FROM DS_DATA__c 
                                   WHERE Data_Type__c = 'DS_VARIABLE'
                                     AND SOURCE_FORM__c IN :forms];
        
    for(DS_DATA__c var : variables) {

      String formID = var.SOURCE_FORM__c;
      List<DS_DATA__c> data = new List<DS_DATA__c>(); 

      if(dataDictionaryForm.containsKey(formID)) 
        data = dataDictionaryForm.get(formID);

      data.add(var); 

      dataDictionaryForm.put(formID, data);

      dataDictionaryField.put(var.VARIABLE_NAME__c, var);

    }

    List<DS_Data__c> codeListDB = [SELECT LONGLABEL__c, CODE__c, CODELIST__c
                                     FROM DS_DATA__c
                                    WHERE Data_Type__c = 'DS_CODELIST'];

    for(DS_DATA__c code : codeListDB) 
      codeList.put(code.CODELIST__c+'-'+code.CODE__c, code.LONGLABEL__c);

    hasInitialEntry = checkInitialEntry();
    
  }

  public Set<String> getActivateForm(Sobject obj) {

    Set<String> actforms = new Set<String>();

    String objectType = String.valueOf(obj.getsObjectType());

    String objName = objectType.substringBefore('__c');

    List<String> statusFields = ut.getFieldSetFields('STATUS', objectType);

    for(String statusField : statusFields) {

      // If status is not null, it means there is some data for that form
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

  public Set<String> checkInitialEntry() {

    Set<String> hasInitialEntry = new Set<String>();

    List<Audit_Trail__c> existData = [SELECT CLIENT__c, FORM__c, FORM_ID__c, 
                                             SECTION__c
                                        FROM Audit_Trail__c
                                       WHERE FORM_ID__c IN : forms
                                         AND CLIENT__c IN : clients];

    for(Audit_Trail__c audit : existData)
      hasInitialEntry.add(audit.FORM_ID__c+'-'+audit.CLIENT__c+'-'+audit.SECTION__c);
    
    return hasInitialEntry;

  }

  public void generateLog(List<SObject> newObj, List<SObject> oldObj) {

    Map<String, SObject> oldObjs = new Map<String, SObject>();

    if(oldObj != null)
      for(Sobject oObj : oldObj)
        oldObjs.put(String.valueOf(oObj.get('id')), oObj);

    List<Audit_Trail__c> auditTrialList = new List<Audit_Trail__c>();

    for(Sobject obj : newObj) {

      Set<String> formIDs = getActivateForm(obj);

      String section = String.valueOf(obj.get('SECTION__c'));
      String clientID = String.valueOf(obj.get('client__c'));

      for(String fID : formIDs) {

        if(!hasInitialEntry.contains(fID+'-'+clientID+'-'+section))
          auditTrialList.addAll(initialEntry(fID, clientID, section));
        else 
          auditTrialList.addAll(updateEntry(fID, obj, oldObjs.get(String.valueOf(obj.get('id')))));

      }

    }

    insert auditTrialList;

  }

  public List<Audit_Trail__c> initialEntry(String formID, String clientID, String section) {

    DateTime currentTime = System.now();

    List<Audit_Trail__c> auditTrialList = new List<Audit_Trail__c>();

    Client__c client = clientList.get(clientID);

    DS_DATA__c form = formList.get('DS_'+formID);

    System.debug(formList);
    System.debug(formID);

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

    auditTrialList.add(log);

    return auditTrialList;

  }

  public List<Audit_Trail__c> updateEntry(String formID, SObject newObj, SObject oldObj) {

    List<Audit_Trail__c> auditTrialList = new List<Audit_Trail__c>();

    if(oldObj == null) return auditTrialList;


    List<DS_DATA__c> fields = dataDictionaryForm.get(formID);

    Client__c client = clientList.get(String.valueOf(newObj.get('Client__c')));

    DS_DATA__c form = formList.get('DS_'+formID);

    DateTime currentTime = System.now();

    List<Audit_Trail__c> logList = new List<Audit_Trail__c>();

    if(fields != null) {

      for(DS_DATA__c f : fields) {

        // If the field of DD doesn't exist in force, skip this field and move to the next one. 
        //if(ut.hasSObjectField(f.VARIABLE_NAME__c+'__c', oldObj)) continue;

        String priorRawValue = String.valueOf(oldObj.get(f.VARIABLE_NAME__c+'__c'));

        String updateRawValue = String.valueOf(newObj.get(f.VARIABLE_NAME__c+'__c'));

        if(priorRawValue != updateRawValue) {

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

          auditTrialList.add(log);

          System.debug(log);

      	}

    	}

		}

  	return auditTrialList;

  }
}