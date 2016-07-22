/**
* @author Danny Fu
* @date 11/08/2015
*
* @group Test Script
* @group-content ../../ApexDocContent/Test/AuditTrail.htm
*
* @description Test script for Audit trail class
*/

@isTest (SeeAllData=false)
public class TestClass_AuditTrail {
    
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    public static Utility ut = new Utility();
    
    private static Map<String, List<DS_DATA__c>> codeList = getCodeList();
    
    private static Map<String, List<DS_DATA__c>> dataDtionary = getDataDictionary();
    
    
    /****
    * @description Load required DS_DATA for the test
    */
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA testData = new TestClassData_DS_DATA();
        testData.variable();
    }
    
    /****
    * @description Get Data Dictionary from DS_DATA
    * @return the data dictionary result for DS_DATA
    * @example
    *   Map<String, List<DS_DATA__c>> dataDtionary = getDataDictionary();
	*   Map<'DEMO-BASELINE', {DS_DATA(codelist: ZYES, file_name: BASELINE, Source_form: DEMO, Object: DS_Background...)}>
    */
    public static Map<String, List<DS_DATA__c>> getDataDictionary() {
        
        Map<String, List<DS_DATA__c>> ddsTmp = new Map<String, List<DS_DATA__c>> ();
        
        List<DS_DATA__c> dds = [SELECT variable_name__c, codelist__c, variable_type__c, File_name__c, Source_form__c
                                     FROM DS_DATA__c
                                    WHERE Data_type__c = 'DS_VARIABLE'];
        
        for(DS_DATA__c data : dds) {
            String ddType = data.Source_form__c + '-' + data.File_name__c;
            if(ddsTmp.containsKey(ddType)) { ddsTmp.get(ddType).add(data); }
            else {  ddsTmp.put(ddType, new List<DS_DATA__c>{data}); }
        }
        
        return ddsTmp;
        
    }

    /****
    * @description Get Code List from DS_DATA
    * @return a collection of code list
    * @example
    *   Map<String, List<DS_DATA__c>> codeList = getCodeList();
	*   Map<'ZYES', {DS_DATA(code: true, codlist: ZYES, LongLABEL: Yes), DS_DATA(code: false, ...)}> 
    */
    public static Map<String, List<DS_DATA__c>> getCodeList() {
        
        Map<String, List<DS_DATA__c>> codeListTmp = new Map<String, List<DS_DATA__c>>();
    	
        List<DS_DATA__c> codeListQuery = [SELECT LONGLABEL__c, CODE__c, Codelist__c 
                                            FROM DS_DATA__c 
                                           WHERE Data_Type__c = 'DS_CODELIST'];
                
        for(DS_DATA__c data : codeListQuery) {
            String code = data.Codelist__c;
            if(codeListTmp.containsKey(code)) { codeListTmp.get(code).add(data); }
            else {  codeListTmp.put(code, new List<DS_DATA__c>{data}); }
        }
                
        return codeListTmp;
        
    }
    
    /****
    * @description Get standard controller from the object name
    * @param client client object
    * @param form form name
    * @param objectName the object name
    * @return the stand controller for ApexPages
    * @example
    *   ApexPages.StandardController sc = getStandardController(client, 'DEMO', 'DS_BACKGROUND_FAMILY_INFO_B__c');
    */
    public static ApexPages.StandardController getStandardController(Client__c client, String form, String objectName) {
        
        // Get summaryId for Url
        String summaryId = test_ut.getClientSummaryId(client.id, 'DS_'+form, '0');
        
        // Get cimi encoded url
        String cimi = ut.urlEncode('c='+client.id+'&summary='+summaryId);
        
        ApexPages.currentPage().getParameters().put('cimi',cimi);
        
        // Get sobject from the object name
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        SObject obj = objType.newSObject();
        
        obj.put('Client__c', client.id);  
        
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);    
        
        return sc;
    }
    
    /****
    * @description Get a random code value from the codelist
    * @param code the code name
    * @return a random code value from the code list
    * @example
    *   String codeValue = getRandomCodeValue('ZYESNO');
    *   codeValue could be 'No' or 'Yes'
    */
    public static String getRandomCodeValue(String code) {
        
        // Number of the items in the code list
        Integer count = codeList.get(code).size();
        
        // Get the random integer in the range of count variable
        Integer rand = Math.round(Math.random()*count);
		
        return String.valueof(codeList.get(code).get(Math.mod(rand, count)).code__c);
        
    }
    
    /****
    * @description Assign the random value to every field of the object
    * @param obj the sobject object
    * @param form the form name
    * @param visitType the visit type
    * @return a sobject with the random values for each field
    * @example
    * 	SObjectType objType = Schema.getGlobalDescribe().get('DS_BACKGROUND_FAMILY_INFO_B__c');
        SObject obj = objType.newSObject();
    *   obj = getObjectFieldRandomValue(obj, 'INSDOMENV', 'BASELINE');
    */
    public static SObject getObjectFieldRandomValue(SObject obj, String form, String visitType) {
        
        for(DS_DATA__c dd : dataDtionary.get(form+'-'+visitType)) {

            String field = dd.variable_name__c+'__c';
            
            if(dd.CODELIST__c == '<None>') {
                
                if(field == 'BWEIGHT__c' || field == 'BSIBNUM__c' || field == 'BHEIGHFT__c' || field == 'BHEIGHIN__c' )
                    continue;
                
                if(dd.VARIABLE_TYPE__c == 'DATE')
                    obj.put(field, System.now().date());
                else if(dd.VARIABLE_TYPE__c.contains('CHAR('))
                	obj.put(field, 'text');
                else if(dd.VARIABLE_TYPE__c == 'NUMBER')
                    obj.put(field, 1);
                
            }
            else {
            	String codeValue = getRandomCodeValue(dd.CODELIST__c);
            	
                if(codeValue == 'true' || codeValue == 'false')
            		obj.put(field, boolean.valueOf(codeValue));
                else 
                    obj.put(field, codeValue);
            }
        } 
        
        return obj;
        
    }
    
    /****
    * @description Get the audit trail data for a specific client
    * @param clientID Client id
    * @return a list of the audit trail data
    * @example
    * 	Map<String, Audit_Trail__c> auditData = getAuditTrailData(client.id);
	*   Map<'Action-Visit_TYPE-Visit_DATE-FORM_ID-NUMBER-LABEL', {Audit_Trail(...)}>
    */
    public static Map<String, Audit_Trail__c> getAuditTrailData(Id clientID) {
		
        Map<String, Audit_Trail__c> auditTrailMap = new Map<String, Audit_Trail__c>();
        
		List<Audit_Trail__c> audit = [SELECT Action__c, CLIENT__c, Date__c, FORM__c, FORM_ID__c, 
                                             NUMBER__c, Prior_Value__c, Question__c, SECTION__c, 
                                             SUBJECT_ID__c, Time__c, Updated_Value__c, User_ID__c, 
                                             User_Initial__c, Visit_Type__c, VISIT_DATE__c, LABEL__c 
                                        FROM Audit_Trail__c
                                       WHERE Client__c = :clientID];
        
        String[] key = new String[6];
        
        for(Audit_Trail__c a : audit) {
            
            key[0] = a.ACTION__c;
            key[1] = a.VISIT_TYPE__c;
            key[2] = String.valueof(a.VISIT_DATE__c);
            key[3] = a.FORM_ID__c;
            key[4] = a.NUMBER__c;
            key[5] = a.LABEL__c;
         	
            // Key = 'Action-Visit_TYPE-Visit_DATE-FORM_ID-NUMBER-LABEL'
           	auditTrailMap.put(StringUtils.joinArray(key, '-'), a);
            
        }
        
        return auditTrailMap;
    }
    
    /****
    * @description Test method for initial entry and update
    */
    static TestMethod void Test_InitialEntry_Update() {
        
        String objectName = 'DS_BACKGROUND_FAMILY_INFO_B__c';
        
        Client__c client = test_ut.createClient();
        
        ApexPages.StandardController sc = getStandardController(client, 'DEMO', objectName);
        
        DS_DEMO_Controller controller = new DS_DEMO_Controller(sc);
                
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        SObject obj = objType.newSObject();
        
        // Initial Entry
        obj.put('Client__c', client.id);
		obj.put('BMET__c', '0');   
        obj.put('BDOV__c', System.now().date());
        
        obj.put('RWHITE__c', true);
        
        obj.put('STATUS_DEMO__c' , 'complete');
        
        insert obj;
        
        // Update
        obj.put('BMET__c', '1');
        update obj;
        
        // Assert Test
        
        Map<String, Audit_Trail__c> auditData = getAuditTrailData(client.id);
                
        String currentDate = String.valueof(System.now().date());
        
        // Initial entry key
        String[] key = new List<String>{'Initial Entry', 'Baseline', currentDate, 'DEMO'};
                
        Audit_Trail__c initEntry = auditData.get(StringUtils.joinArray(key, '-'));
        
        System.assertEquals('Initial Entry', initEntry.ACTION__c);
        System.assertEquals(client.id, initEntry.Client__c);
        System.assertEquals(System.now().date(), initEntry.Date__c);
        System.assertEquals('DEMO', initEntry.FORM_ID__c);
        System.assertEquals(null, initEntry.NUMBER__c);
        System.assertEquals(null, initEntry.Question__c);
        System.assertEquals(null, initEntry.Prior_Value__c);
        System.assertEquals(null, initEntry.Updated_Value__c);
        
        
        // Update key
        key = new List<String>{'Update', 'Baseline', currentDate, 'DEMO', '2', 'Baseline method of administration'};
        
        Audit_Trail__c updateEnry = auditData.get(StringUtils.joinArray(key, '-'));    
            
        System.assertEquals('Update', updateEnry.ACTION__c);
        System.assertEquals(client.id, updateEnry.Client__c);
        System.assertEquals(System.now().date(), updateEnry.Date__c);
        System.assertEquals('DEMO', updateEnry.FORM_ID__c);
        System.assertEquals('2', updateEnry.NUMBER__c);
        System.assertEquals('How was this form administered?', updateEnry.Question__c);
        System.assertEquals('Pen and paper only', updateEnry.Prior_Value__c);
        System.assertEquals('Electronic only', updateEnry.Updated_Value__c);            
        
    }
    
    // Unfinished random test Method (need to change from static to testmethod later)
    public static void Test_INSDOMENV() {
        
        String objectName = 'DS_BACKGROUND_FAMILY_INFO_B__c';
        
        Client__c client = test_ut.createClient();
        
        ApexPages.StandardController sc = getStandardController(client, 'INSDOMENV', objectName);
        
        DS_INSDOMENV_Controller controller = new DS_INSDOMENV_Controller(sc);
        
        System.debug(controller.form.skip.skipList);
        
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        SObject obj = objType.newSObject();
        
        obj.put('Client__c', client.id);
        obj = getObjectFieldRandomValue(obj, 'INSDOMENV', 'BASELINE');
        
        System.debug(obj);
        
        obj.put('RWHITE__c', true);
        
        obj.put('BCINOPSP__c', 'TEST');
        obj.put('BCINOPRS__c', 'TEST');
        obj.put('BPINOPSP__c', 'TEST');
        obj.put('BPINOPRS__c', 'TEST');
        
        obj.put('STATUS_INSDOMENV__c' , 'complete');
        
        insert obj;
        
        
        // Update insurance info.
        obj = getObjectFieldRandomValue(obj, 'INSDOMENV', 'BASELINE');
        obj.put('BCINOPSP__c', 'TEST');
        obj.put('BCINOPRS__c', 'TEST');
        obj.put('BPINOPSP__c', 'TEST');
        obj.put('BPINOPRS__c', 'TEST');
        
        update obj;
        
        List<Audit_Trail__c> audit = [SELECT Action__c, CLIENT__c, Date__c, FORM__c, FORM_ID__c, NUMBER__c, Prior_Value__c, Question__c, SECTION__c, SUBJECT_ID__c, Time__c, Updated_Value__c, User_ID__c, User_Initial__c, Visit_Type__c 
                                        FROM Audit_Trail__c
                                       ];
        
        for(Audit_Trail__c a : audit) {
        	System.debug(a.Action__c);
            System.debug(a.SUBJECT_ID__c);
            System.debug(a.Date__c);
            System.debug(a.FORM_ID__c);
            System.debug(a.NUMBER__c);
            System.debug(a.Question__c);
            System.debug(a.Prior_Value__c);
            System.debug(a.Updated_Value__c);
        }
    }
    

}