/****
*@description  Class for necessary background utility functions
*
*@modified    3/2/17     KW    treatment status
*@modified    4/18/17    KW    clean stray debugs & commented out stubs, edit treatment status/helpers to updateTreatmentStatus
*@modified    4/19/17    KW    updateClientTxStatus
*@modified    5/4/17     KW    clean updateClientTxStatus
*@modified    08/18/17   DF    Add governerLimitAnalysis
*
*@group System
*@group-content /ApexDocContent/System/Utility.htm
****/
public class Utility {
    
    public Utility() {}
    
    public String clientSectionInfo(ID clientID) {///heading specific to client info page, no section column
        
        Client__c c = [SELECT name, INIT__c, AGE__c, CURRENT_AGE__c, GENDER__c, DOB1__c
                       FROM Client__c
                       WHERE id = :clientID ];
        
        Integer year = Integer.valueOf(date.valueof(c.DOB1__c).daysBetween(Date.today()) / 365);
        
        String info = '<div class="header-info-table"><table class="table table-bordered">' +
            '<thead>'+
            '<th>Client ID</th><th>Initials</th>'+
            '<th>Current Age</th><th>Gender</th>'+
            '</thead>'+
            '<tbody>'+
            '<td>' + c.name + '</td><td>' + c.INIT__c + '</td>'+
            '<td>' + year + '</td><td>' + c.GENDER__c + '</td>'+
            '</tbody>'+
            '</table></div>';
        
        return info;
        
    }////////////////////////////////////////end    
   
     public String clientSection(ID clientID, ID SummaryID ) {//heading used on form pages?
  
    String SectionType;
   
    Client__c c = [SELECT name, INIT__c, AGE__c, GENDER__c, DOB1__c
                     FROM Client__c
                    WHERE id = :clientID];  

    Client_Summary__c summary = [SELECT SECTION__c, Client__r.DOB1__c, 
                                        Client__r.INIT__c, Client__r.AGE__c,
                                        Client__r.GENDER__c, Client__r.name
                                   FROM Client_Summary__c 
                                  WHERE ID =:summaryID];

    Integer year = Integer.valueOf(date.valueof(summary.Client__r.DOB1__c).daysBetween(Date.today()) / 365);
    
    if(summary.SECTION__c == '0'){
        SectionType='Baseline';
    }
    else if(summary.SECTION__c == '-1'){
        SectionType='Trauma';
    }
    else {//if(summary.SECTION__c => '1')
        SectionType='FollowUp';
    }            
    
    String info = '<table class="table">' +
                    '<thead>'+
                      '<th>ID</th><th>Initials</th>'+
                      '<th>Current Age</th><th>Gender</th>'+
                      '<th>Visit Type</th>'+
                    '</thead>'+
                    '<tbody>'+
                      '<td>' + summary.Client__r.name + '</td><td>' + summary.Client__r.INIT__c + '</td>'+
                      '<td>' + year + '</td><td>' + summary.Client__r.GENDER__c + '</td>'+
                      '<td>' + SectionType+ '</td>'+//Section.Category__c
                    '</tbody>'+
                  '</table>';

         return info;
     }
    
    public String getFields(String objName) {
        
        SObjectType objToken = Schema.getGlobalDescribe().get(objName);
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fieldMap  = objDef.fields.getMap(); 
        
        String fields = '';
        Integer counter = 0;
        
        for(String f : fieldMap.keySet()) {
            
            if(counter != 0)
                fields += ',';
            
            fields += fieldMap.get(f).getDescribe().getName();
            
            counter++;
            
        }        
        return fields;         
    }
    
    public String urlEncode(String param) {
        
        Double rnd1 =  Math.random();
        
        Double rnd2 =  Math.random();
        
        Integer numCode = getRandomInt(1, 9);
        
        String redundentCode = EncodingUtil.convertToHex(crypto.generateAesKey(128)).substring(0,numCode);
                
        // create a blob from our parameter value before we send it as part of the url
        Blob beforeblob = Blob.valueOf(param);
        
        // base64 encode the blob that contains our url param value
        string paramvalue = redundentCode + EncodingUtil.base64Encode(beforeblob) + numCode;
        
        return paramvalue;        
    }
    
    public Map<String, String> urlDecode(String param) {
        
        // print out the encoded value to the debug log so we can see it before/after base64 encode
        Map<String, String> parameter = new Map<String, String>();

        Integer numCode = integer.valueof(param.substring(param.length()-1, param.length()));
        
        param = param.substring(numCode, param.length()-1);
        
        // take the base64 encoded parameter and create base64 decoded Blob from it
        Blob afterblob = EncodingUtil.base64Decode(param);   
        
        String url = afterblob.toString();
        
        List<String> content = url.split('&');
        
        for(String c : content) {
            List<String> tmp = c.split('=');
            parameter.put(tmp.get(0), tmp.get(1));
        }
        
        return parameter;        
    }
    
    public List<SelectOption> getPicklistValues(SObject obj, String fld){
        
        List<SelectOption> options = new List<SelectOption>();
        
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType(); 
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        
        // Get a map of fields for the SObject
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        
        // Get the list of picklist values for this field.
        List<Schema.PicklistEntry> values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a : values)
        { 
            options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        
        return options;
    }
    
    /* updateSummaryStatus - update the status field in Client_Summary__c object
    *  Parameters --------
    *  obj: the object list from trigger
    *  singleObjectName: assign NULL if it is a merged object, 
    *                    else give the object name.
    *  statusField: the name of the status field.
    */
    public void updateSummaryStatus(List<Sobject> obj, String singleObjectName, String statusField) {
        
        List<String> clients = new List<String>();
        
        List<Client_Summary__c> summary; 
                
        Set<String> formName = new Set<String>();
        
        if(singleObjectName != null) formName.add(singleObjectName);
        
        Map<String, Sobject> targetObject = new Map<String, Sobject>();
        
        for(Sobject ob : obj) {
            
            String targetKey = '';
            
            String c = String.valueOf(ob.get('Client__c'));
            clients.add(c);
                        
            if(singleObjectName == null) {
                targetKey = c + '_' + String.valueOf(ob.get('form__c'));
                formName.add(String.valueOf(ob.get('form__c')));
            }
            else {
                targetKey = c + '_' + singleObjectName;
            }
            
            targetObject.put(targetKey, ob);
        }
        
        summary = [SELECT id, Client__c, Page__r.Page__c
                   FROM Client_Summary__c 
                   WHERE Client__c IN :clients
                   AND Page__r.Page__c IN :formName];
                
        List<Client_Summary__c> updateSummary = new List<Client_Summary__c>();
        
        for(Client_Summary__c s : summary) {
            
            String index = s.Client__c + '_' + s.Page__r.Page__c;
            
            if(targetObject.containsKey(index)) {
                s.STATUS__c = String.valueOf(targetObject.get(index).get(statusField));
                updateSummary.add(s);
            }
            
        }        
        update updatesummary;        
    }
    
    /* updateClientTxStatus
    *  description: update Client.Closed_Treatment__c value 
    *       based on DS_Background_Family_Info_F__c.FUTYPE__c, 
    *       limit by most recent FDOV__c
    *  Parameter:
    *       obj: List<SObject>
    *           Trigger.new returns a list of the trigger's object (in this case DS_Background_Family_Info_F__c)
    */
    public void updateClientTxStatus(List<SObject> obj){

        //get client ids from obj records
        List<String> clientIdList = new List<String>();

        for(Sobject c:obj){
            String clientId = String.valueOf(c.get('Client__c'));
            clientIdList.add(clientId);
        }

        DS_Background_Family_Info_F__c followupInfo = [SELECT Client__c, Client__r.id, FDOV__c, FUTYPE__c
                                                        FROM DS_Background_Family_Info_F__c
                                                        WHERE Client__r.id IN : clientIdList
                                                        ORDER BY FDOV__c DESC
                                                        LIMIT 1
                                                        ];

        Id cId = followupInfo.Client__c;

        String Futype = String.valueOf(followupInfo.FUTYPE__c);        

        Client__c client = [SELECT id, Closed_Treatment__c
                            FROM Client__c
                            WHERE id =: cId];
                
        //close if = 2
        if(Futype == '2'){
            client.Closed_Treatment__c = 'Closed';
        }                
        //if((client.Closed_Treatment__c ==null)||((Futype =='3'))){
        else{
            client.Closed_Treatment__c = 'Open';
        }
        
        String TxStatus = String.valueOf(client.Closed_Treatment__c);

        update client;

    }
    
    public void updateSummaryStatusForMergedObject(List<SObject> obj) {
        
        String objectType = String.valueOf(obj.get(0).getsObjectType());
        
        String objName = objectType.substringBefore('__c');
        
        List<String> statusFields = this.getFieldSetFields('STATUS', String.valueOf(obj.get(0).getsObjectType()));
        
        List<String> clients = new List<String>();
        
        List<String> formPages = new List<String>();
        
        Set<String> sections = new Set<String>();
        
        Map<String, Sobject> targetObjects = new Map<String, Sobject>();
        
        for(Sobject ob : obj) {
            
            String c = String.valueOf(ob.get('Client__c'));
            
            clients.add(c);
            
            targetObjects.put(c+ob.get('SECTION__c'), ob);
            
            sections.add(String.valueOf(ob.get('SECTION__c')));            
        }
        
        for(String sf : statusFields) {
            
            Pattern p = Pattern.compile('STATUS_(.*?)__c');
            Matcher pm = p.matcher(sf);
            
            if( pm.matches() )
                formPages.add('DS_' + pm.group(1));            
        }
        
        List<Client_Summary__c> summary = [SELECT id, Client__c, Page__r.Page__c, SECTION__c
                                           FROM Client_Summary__c 
                                           WHERE Client__c IN :clients
                                           AND Page__r.Page__c IN :formPages
                                           AND Page__r.Object__c =: objName
                                           AND SECTION__c IN :sections];
        
        List<Client_Summary__c> updateSummary = new List<Client_Summary__c>();
        
        for(Client_Summary__c s : summary) {
            
            String clientID = s.Client__c;
            
            if(targetObjects.containsKey(clientID+s.SECTION__c)) {
                String StatusField = 'STATUS_'+String.valueOf(s.Page__r.Page__c).substringAfter('DS_')+'__c';
                s.STATUS__c = String.valueOf(targetObjects.get(clientID+s.SECTION__c).get(StatusField));
                updatesummary.add(s);
            }
        }
        update updatesummary;        
    }  
    
    public Map<String, SObject> getObjectRecordWithClient(List<SObject> obj, String objName, List<String> customSections) {

        String[] clients = new List<String>();
        String[] sections = new List<String>();
        Map<String, SObject> objInfo = new Map<String, SObject>();
        
        if(customSections != null) sections = customSections;
        
        for(SObject sObj: obj){
            
            clients.add('\''+sObj.get('client__c')+'\'');
           
            if(customSections == null)
                sections.add('\''+sObj.get('SECTION__c')+'\'');
        }
        
        List<SObject> record = 
          Database.query('SELECT ' + getFields(objName) + ',' +
                                 'Client__r.Name, Client__r.INIT__c' +  
                         '  FROM ' + objName +                          
                         ' WHERE Client__c IN ('+ StringUtils.joinArray(clients, ',') + ')' +
                         '    AND SECTION__c IN (' + StringUtils.joinArray(sections, ',') + ')');
        
        for(SObject sObj : record) {
            objInfo.put(String.valueof(sObj.get('Client__c'))+'-'+String.valueof(sObj.get('SECTION__c')), sObj);
        }        
        return objInfo;        
    }
    
    public List<Schema.FieldSetMember> getFieldSetDetail(String fieldSetName, String ObjectName){
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        
        return fieldSetObj.getFields();                 
    }  
    
    public List<String> getFieldSetFields(String fieldSetName, String ObjectName) {
        
        List<String> fields = new List<String>();
        
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        
        for(Schema.FieldSetMember fieldSetMemberObj : fieldSetObj.getFields()) 
            fields.add(fieldSetMemberObj.getFieldPath());
        
        return fields;         
    }
    
    public SObject resetFieldsValue(SObject obj, String BorF, Map<String, String> fields) {
        
        SObjectType objType = Schema.getGlobalDescribe().get(String.valueof(obj.getSObjectType()));
        Map<String,Schema.SObjectField> mfields = objType.getDescribe().fields.getMap();
        
        for(String key : fields.keyset()) {
                        
            Schema.SObjectField field = mfields.get(BorF+key+'__c');
            Boolean isUpdateable = field.getDescribe().isUpdateable();
                        
            if(isUpdateable == true) {
                obj.put(BorF+key+'__c', null);
            }            
        }        
        return obj;            
    }
    
    public Map<String, String> getFieldsFromDD(String sourceForm) {

        Map<String, String> bfVariableMap = new Map<String, String>();

        Set<String> vars = new Set<String>();

        List<DS_DATA__c> varFromData = [SELECT VARIABLE_NAME__c 
                                          FROM DS_DATA__c
                                         WHERE SOURCE_FORM__c = :sourceForm];

        for(DS_DATA__c var : varFromData) {
            if(var.VARIABLE_NAME__c != null) 
                vars.add(var.VARIABLE_NAME__c.substring(1, var.VARIABLE_NAME__c.length()));
        }

        for(String bfVar : vars)
          bfVariableMap.put(bfVar, bfVar+'__c');
        
        return bfVariableMap;
    }
    
    public boolean hasSObjectField(String fieldName, SObject so){
      return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName);
    }
    
    public Integer getRandomInt (Integer lower, Integer upper) {
        return Math.round(Math.random() * (upper - lower)) + lower;
    }
    
    public String getRandomString(Integer len, String chars) {
          
        String randStr = '';
        
        if(chars == null) { chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz'; }
        
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        
        return randStr;         
    }    
    
    
    /****
    * @description Apex governer limit analysis. 
    * @return null
    * @example 
    *     Utility ut = new Utility();
    * 	  ut.governerLimitAnalysis();
    * @reference
    * 	  https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_limits.htm
    */
    public void governerLimitAnalysis() {
        
        System.debug('------------------------------ Total Governer Limit ------------------------------ ');
        
        System.debug('Total Number of SOQL Queries allowed in this apex code context: ' +  Limits.getLimitQueries());
        System.debug('Total number of records that can be returned by issuing SOQL queries:' + Limits.getLimitQueryRows());
        System.debug('Total Number of records that can be queried in this apex code context: ' +  Limits.getLimitDmlRows());
        System.debug('Total Number of DML statements allowed in this apex code context: ' +  Limits.getLimitDmlStatements() );
        System.debug('Total Number of script statements allowed in this apex code context: ' +  Limits.getLimitScriptStatements());
        System.debug('Total amount of memory (in bytes) that can be used for the heap: ' + Limits.getLimitHeapSize());
        System.debug('The time limit (in milliseconds) of CPU usage in the current transaction:' + Limits.getLimitCpuTime());
        
        System.debug('------------------------------ Usage for this Class  ----------------------------- ');
		       
        System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries() + ' / ' + Limits.getLimitQueries());
        System.debug('2.Number of records returned by SOQL queries in this apex code so far: ' + Limits.getQueryRows() + ' / ' + Limits.getLimitQueryRows());
        System.debug('3.Number of rows queried in this apex code so far: ' + Limits.getDmlRows() + ' / ' + Limits.getLimitDmlRows());
        System.debug('4.Number of DML statements used so far: ' +  Limits.getDmlStatements() + ' / ' + Limits.getLimitDmlStatements());
        System.debug('5.Number of script statements used in this apex code so far: ' + Limits.getQueries() + ' / ' + Limits.getLimitScriptStatements());
        System.debug('6.Final heap size: ' +  Limits.getHeapSize() + ' / ' + Limits.getLimitHeapSize());
        System.debug('7.Final CPU usage: ' +  Limits.getCpuTime() + ' / ' + Limits.getLimitCpuTime());

        
    }
    
}