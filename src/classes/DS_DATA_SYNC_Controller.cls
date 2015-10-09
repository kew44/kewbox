public with sharing class DS_DATA_SYNC_Controller {

    
    public Connection connect { get; set; }
    
    public String instanceUrl {get; set;}
    
    private String accessToken = '';
    
    Utility ut = new Utility();
    
    private List<DS_DATA__C> upsertForms = new List<DS_DATA__C>();
    
    public Map<String, Integer> localRecordList { get; set; }
    public Map<String, Integer> createCounterList { get; set; }
    public Map<String, Integer> updateCounterList { get; set; }
    public Map<String, Integer> restCounterList { get; set; }
    public Map<String, List<DS_DATA__c>> createList { get; set; }
    public Map<String, List<DS_DATA__c>> updateList { get; set; }
    public Map<String, List<DS_DATA__c>> upsertFormsList { get; set; }
    
    private Map<String, List<String>> dataTypeList = new Map<String, List<String>>();
    
    public List<String> dataType { get; set; }
        
    public class Connection {
        
        public String instanceUrl { get;set; }
        public String clientId { get;set; }
        public String clientSecret { get;set; }
        public String username { get;set; }
        public String password { get;set; }
        public String token { get; set; }
        public String accessToken { get; set; }
    
    }
    
    /*To get aouthentication detail Wrapper*/
    public class OAuth2{
        public String id{get;set;}
        public String issued_at{get;set;}
        public String instance_url{get;set;}
        public String signature{get;set;}
        public String access_token{get;set;}    
    }
    
    public class RESTData { 
        public String totalSize { get; set; }
        public String done { get; set; }
        public List<DS_DATA__c> records { get; set; }
        public String nextRecordsUrl { get; set; }
        
        public RESTData() {
            totalSize = '';
            done = '';
            records = new List<DS_DATA__c>();
            nextRecordsUrl = '';
        }
    }
    
    public DS_DATA_SYNC_Controller() {
        
        connect = new Connection();
        connect.instanceUrl = 'https://cs15.salesforce.com';
        connect.clientId = '3MVG9dPGzpc3kWyfw2ObuMRxmn5c8ANtIRRTL2yc5qM2w_CJKIsnQPmWFW7M1lxcNzAbtf6wB2y8K8iv4Hshw';
        connect.clientSecret = '706370298950339355';
        connect.username = 'cds@nctsn.org.cimibox';
        connect.password = 'CimiNctsn2015!';
        connect.token = 'oRdT52FpjBlWrpjI4atBsGoI';
        
        instanceUrl = 'https://cs15.salesforce.com';
        
        localRecordList = new Map<String, Integer>();
        createCounterList = new Map<String, Integer>();
        updateCounterList = new Map<String, Integer>();
        restCounterList = new Map<String, Integer>();
        createList = new Map<String, List<DS_DATA__c>>();
        updateList = new Map<String, List<DS_DATA__c>>();
        upsertFormsList = new Map<String, List<DS_DATA__c>>();
        
        dataType = new List<String>();
        
        // CBCL Form Information
        dataTypeList.put('DS_CBCL_Form_Info', new List<String>{'Data_Type', 'Question_Field', 'Age_Range'});
        // CBCL Scales
        dataTypeList.put('DS_CBCL_SCALES', new List<String>{'Age_Range', 'Gender', 'Raw_Score', 'T_Score', 'Scale'}); 
        // CODELIST
        dataTypeList.put('DS_CODELIST', new List<String>{'CODE', 'Codelist', 'LONGLABEL'}); 
        // Form Information
        dataTypeList.put('DS_Form_Info', new List<String>{'Category', 'Page', 'Source_form', 'Form', 'Object'});
        //PTSD Form Info
        dataTypeList.put('DS_PTSD_Form_Info', new List<String>{'field', 'number'});
        //Trauma Details Form Info
        dataTypeList.put('DS_TD_Form_Info', new List<String>{'Weight', 'Category', 'Form'});
        // DDs
        
        List<String> varFields = new List<String>{'Object', 'VARIABLE_NUMBER', 'VARIABLE_NAME', 'Codelist', 'VARIABLE_LABEL', 'Source_form'};
         
        dataTypeList.put('DS_VARIABLE-CLIENT', varFields);
        dataTypeList.put('DS_VARIABLE-DS_GTRAUMA', varFields);
        dataTypeList.put('DS_VARIABLE-DS_BACKGROUND_FAMILY_INFO', varFields);
        dataTypeList.put('DS_VARIABLE-DS_PTSD_CA', varFields);
        dataTypeList.put('DS_VARIABLE-DS_FUNCTIONING_FORMS', varFields);
        dataTypeList.put('DS_VARIABLE-DS_SDQ_PSI_CDI', varFields);
        dataTypeList.put('DS_VARIABLE-DS_CBCL', varFields);
        dataTypeList.put('DS_VARIABLE-DS_TRDETAIL', varFields);
        dataTypeList.put('DS_VARIABLE-DS_TSCC_TSCYC_F', varFields);
    
    }
    
    public String getAccessToken() {
        
        String reqbody = 'grant_type=password&client_id='+connect.clientId+'&client_secret='+connect.clientSecret+'&username='+connect.username+'&password='+connect.password+connect.token;
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint(connect.instanceUrl+'/services/oauth2/token');//Note if my domain is set up use the proper domain name else use login.salesforce.com for prod or developer or test.salesforce.com for sandbox instance
        
        HttpResponse response = h.send(req);
        
        System.debug(response.getbody());
        
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(response.getbody(), OAuth2.class);
        
        return objAuthenticationInfo.access_token;
        
    }
    
    public RESTData getRestRecord(String dataType, String nextRecordsUrl, String extraWhere) {
        
        if(dataType.contains('DS_VARIABLE-')) dataType = 'DS_VARIABLE';
        
		String mainUrl = connect.instanceUrl+'/services/data/v34.0';
        
        String whereQuery = '+WHERE+Data_Type__c+=+\''+dataType+'\'' + extraWhere;
        
        String URL = '/sobjects/DS_DATA__c';
        String query = (nextRecordsUrl != null) ? connect.instanceUrl+nextRecordsUrl : mainUrl+'/query?q=SELECT+name+,+Age_Range__c+,+Category__c+,+CODE__c+,+CODELIST__c+,+Content__c+,+Data_Type__c+,+Describe_Field__c+,+Field__c+,+FILE_NAME__c+,+Form__c+,+Gender__c+,+Gender_Required__c+,+LONG_DESCRIPTION__c+,+LONGLABEL__c+,+Note__c+,+Number__c+,+Object__c+,+Page__c+,+Percentile__c+,+Question_Field__c+,+Raw_Score__c+,+Scale__c+,+Scale_Number__c+,+Section__c+,+Sig_Range__c+,+SOURCE_FORM__c+,+Symptom__c+,+T_Score__c+,+Type__c+,+Variable__c+,+VARIABLE_LABEL__c+,+VARIABLE_NAME__c+,+VARIABLE_NUMBER__c+,+VARIABLE_TYPE__c+,+VARIABLE_VALUE__c+,+Weight__c+from+DS_DATA__c'+whereQuery;
        
        System.debug(query);
        
        Http h1 = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setHeader('Authorization','Bearer '+connect.accessToken);
        req1.setHeader('Content-Type','application/json');
        req1.setHeader('accept','application/json');
        
        //req1.setBody(jsonstr);//Send JSON body
        req1.setMethod('GET');
        req1.setEndpoint(query);//URL will be your Salesforce REST API end point where you will do POST,PUT,DELETE orGET
        HttpResponse res1 = h1.send(req1);
        
        System.debug(res1.getbody());    
        
        return (RESTData)JSON.deserialize(res1.getbody(), RESTData.class); 
        
    }
    
    public void syncRecord(String dataType, List<String> compareFields, String extraWhere) {
        
        RESTData restRecord = new RESTData();
        RESTData tmpRecords = new RESTData();
        
       	
        
        String nextRecordsUrl = null;
        
        do {
            tmpRecords = new RESTData();
            tmpRecords = getRestRecord(dataType, nextRecordsUrl, extraWhere);
            
            System.debug(tmpRecords);
            
            nextRecordsUrl = tmpRecords.nextRecordsUrl;
			
			restRecord.totalSize = tmpRecords.totalSize;
            restRecord.done = tmpRecords.done;
            restRecord.records.addall(tmpRecords.records);
            
            System.debug(restRecord);
			            
        } while(tmpRecords.nextRecordsUrl != null);
        
        if(dataType.contains('DS_VARIABLE-')) {
            System.debug(extraWhere);
            extraWhere = extraWhere.replaceAll('[[:pun:]+]', ' ');
            System.debug(extraWhere);
        }
        
        String queryDataType = (dataType.contains('DS_VARIABLE-')) ? 'DS_VARIABLE' : dataType;
        
        List<SObject> localRecord = 
          Database.query('SELECT ' + ut.getFields('DS_DATA__c') +  
                         '  FROM DS_DATA__c ' +
                         ' WHERE DATA_TYPE__c = \''+ queryDataType + '\' ' + extraWhere);
        
		System.debug('SELECT id, name'   +
                         '  FROM DS_DATA__c ' +
                         ' WHERE DATA_TYPE__c = \''+ queryDataType + '\' ' + extraWhere);        
        
        Map<String, DS_DATA__c> localForms = new Map<String, DS_DATA__c>();
        
        for(SObject f : localRecord) {
            String localFormsKey = '';
            for(String cf : compareFields) { 
                localFormsKey += (f.get(cf+'__c') instanceof Decimal) ? 
                    			String.valueOf(Integer.valueOf(f.get(cf+'__c'))) + '-' : 
                				String.valueof(f.get(cf+'__c')) + '-'; 
            }
            localForms.put(localFormsKey, (DS_DATA__c)f);
            //System.debug('local '+localFormsKey);
        }
                
        upsertForms = new List<DS_DATA__C>();
        
        Integer createCounter = 0;
        Integer updateCounter = 0;
        
        List<DS_DATA__c> createRecords = new List<DS_DATA__c>();
        List<DS_DATA__c> updateRecords = new List<DS_DATA__c>();
        
        
        for(DS_DATA__c r : restRecord.records) {
            
            ID tmpId = null;
            String tmpName = '';
            
            String key = '';
            
            SObject obj = (SObject) r;
           
            
            //System.debug(fmap);
                        
            for(String cf : compareFields) { 
            	
   
                
                key += (r.get(cf+'__c') instanceof Decimal) ? 
                    	String.valueOf(Integer.valueOf(r.get(cf+'__c'))) + '-' : 
                		String.valueof(r.get(cf+'__c')) + '-';  
            
            }
            
			// Update the existed records            
            if(localForms.containsKey(key)) {
                DS_DATA__c updateRecord = localForms.get(key);
                tmpId = updateRecord.Id;
                //tmpName = updateRecord.Name;
                updateRecord = r;
                //updateRecord.Name = tmpName;
                updateRecord.id = tmpId;
                updateRecord.sync__c = 'u';
                upsertForms.add(updateRecord);
                updateCounter++;
                updateRecords.add(updateRecord);
            }
            // Create new records
            else {
                r.id = null;
                r.sync__c = 'i';
                upsertForms.add(r);
                createCounter++;
                createRecords.add(r);
            }
            
        }
        
            
        localRecordList.put(dataType, localRecord.size());
        createCounterList.put(dataType, createCounter);
        updateCounterList.put(dataType, updateCounter);
        restCounterList.put(dataType, restRecord.records.size());
        upsertFormsList.put(dataType, upsertForms);
		
		if(createRecords.size() > 0) 
            createList.put(dataType, createRecords);
        if(updateRecords.size() > 0) 
            updateList.put(dataType, updateRecords);
        
        System.debug('Local: '+ localRecord.size());
        System.debug('REST: '+ restRecord.records.size());
        System.debug('Create: '+ createCounter);
        System.debug('Update: '+ updateCounter);
        System.debug('upsertForms List: ' + upsertForms.size());
        
        System.debug(upsertForms);
        
        
                    
    }
    
    
    public List<SelectOption> getItems() {
	    List<SelectOption> options = new List<SelectOption>();
        
        for(String key : dataTypeList.keySet()) {
            options.add(new SelectOption(key, key));
        }
        
	    return options;
	}
    
    public PageReference step1() {
        return page.DS_DATA_SYNC;
    }
    
    public PageReference step2() {
        
        PageReference returnPage;
        
        connect.accessToken = this.getAccessToken();
        
        if(connect.accessToken != null) {
            
            for(String dt : dataType) {
                
                String extraWhere = '';
                
                String dtType = dt;  
                
                if(dt.contains('DS_VARIABLE-')) {
                    
                    String objType = dt.substringAfter('DS_VARIABLE-');
                    if(objType == 'CLIENT') extraWhere = '+AND+(+object__c+=+\'CLIENT\'+OR+object__c+=+\'USER_PROFILE\'+OR+object__c+=+\'\'+)';
                    else if(objType == 'DS_BACKGROUND_FAMILY_INFO') 
                        extraWhere = '+AND+(+object__c+=+\'DS_BACKGROUND_FAMILY_INFO_B\'+OR+object__c+=+\'DS_BACKGROUND_FAMILY_INFO_F\'+)';
                    else if(objType == 'DS_GTRAUMA') 
                    	extraWhere = '+AND+object__c+=+\'DS_GTRAUMA\'';
                    else if(objType == 'DS_FUNCTIONING_FORMS')
                        extraWhere = '+AND+(+object__c+=+\'DS_FUNCTIONING_FORMS_B\'+OR+object__c+=+\'DS_FUNCTIONING_FORMS_F\'+)';
                    else if(objType == 'DS_PTSD_CA')
                    	extraWhere = '+AND+(+object__c+=+\'DS_PTSD_CA_B\'+OR+object__c+=+\'DS_PTSD_CA_F\'+)';
                    else if(objType == 'DS_SDQ_PSI_CDI')
                        extraWhere = '+AND+(+object__c+=+\'DS_SDQ_PSI_CDI_B\'+OR+object__c+=+\'DS_SDQ_PSI_CDI_F\'+)';
                    else if(objType == 'DS_CBCL')
                        extraWhere = '+AND+(+object__c+=+\'DS_CBCL_B\'+OR+object__c+=+\'DS_CBCL_F\'+)';
                    else if(objType == 'DS_TRDETAIL')
                        extraWhere = '+AND+(+object__c+=+\'DS_TRDETAIL_1\'+OR+object__c+=+\'DS_TRDETAIL_2\'+)';
                    else if(objType == 'DS_TSCC_TSCYC_F') 
                    	extraWhere = '+AND+object__c+=+\'DS_TSCC_TSCYC_F\'';
                    
                        dtType = 'DS_VARIABLE';
                }
                
                syncRecord(dt, dataTypeList.get(dt), extraWhere);
            }
            
            
            
            
            returnPage = page.DS_DATA_SYNC_Comfirm;
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Can\'t build the connection. Please check the setting again.'));
            returnPage = page.DS_DATA_SYNC;
        }
        
        return returnPage;
        
    }
    
    public PageReference sync() {
        
        upsert upsertForms;
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Syncronization finished.'));
        
        return page.DS_DATA_SYNC_Comfirm;
        
    }
    
    public PageReference testConnection() {
        connect.accessToken = this.getAccessToken();
        if(connect.accessToken != null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Connect to the server successfully.'));
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Can\'t build the connection. Please check the setting again.'));
        }
        return page.DS_DATA_SYNC;
    }
    
}