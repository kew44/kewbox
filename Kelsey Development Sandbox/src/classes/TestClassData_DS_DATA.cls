/****
*@description This class provides test data for use in test classes
*Data is broken down by DS_DATA__c.Data_Type__c
*Grouped Categories are:
*    Form Info, Variable, Trauma, PTSD, CBCL
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_DATA.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*
*@modified DF 04/07/2017 Ln#30 Added the traume detail form default question. 
*
****/
@isTest
public class TestClassData_DS_DATA {
    
    public TestClassData_DS_DATA() {
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_BLOCKER');
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_FORM_INFO');   
    }
    
    public void variable() {
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_VARIABLE');
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_CODELIST');
    }
    
    public void trauma() {
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_TD_FORM_INFO');
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_TD_FORM_DEFAULT_QUESTION');
    }
    
    public void ptsd() {
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_PTSD_FORM_INFO');
    }
    public void cbcl(){
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_CBCL_FORM_INFO');
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_CBCL_SCALES');
    }
    
    /****
    *@description method to find the duplicate DS_DATA record 
    ****/
    @isTest(SeeAllData=true)
    static void Test_DuplicaedRecords() {
        
        Map<String, String> records = new Map<String, String>();
        
        String[] duplicatedRecords = new List<String>();
        
        for(DS_DATA__c d : [SELECT id, name FROM DS_DATA__c]) {
            
            if(records.containsKey(d.name)) { duplicatedRecords.add(d.name); }
            else { records.put(d.name, d.id); }
                
        }   
                    
        System.assertEquals(duplicatedRecords.size(), 0, 'Duplicate Records: '+StringUtils.joinArray(duplicatedRecords, ','));     
        
    }
    
    /****
    *@description method to make sure Allow_Modify__c field is always OFF 
    ****/
    @isTest(SeeAllData=true)
    static void Test_BlockerRecords() {
        
        List<DS_DATA__c> blocker = [SELECT DATA_TYPE__c, ALLOW_MODIFY__c 
                                    FROM DS_DATA__c
                                    WHERE DATA_TYPE__c = 'DS_Blocking'];
        
        System.assertNotEquals(blocker.get(0).ALLOW_MODIFY__c, TRUE, 'The Allow_Modify__c field is ON in blocker record.');
    
    }
    
}