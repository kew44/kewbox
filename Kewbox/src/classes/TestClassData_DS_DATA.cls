/****
*@description This class provides test data for use in test classes
*Data is broken down by DS_DATA__c.Data_Type__c
*Grouped Categories are:
    *Form Info, Variable, Trauma, PTSD, CBCL
*
*@group Test Script 
*@group-content /ApexDocContent/Test/DS_DATA.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/
@isTest
public class TestClassData_DS_DATA {
    
    public TestClassData_DS_DATA() {
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_FORM_INFO');   
    }
    
    public void variable() {
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_VARIABLE');
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_CODELIST');
    }
    
    public void trauma() {
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_TD_FORM_INFO');
    }
    
    public void ptsd() {
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_PTSD_FORM_INFO');
    }
    public void cbcl(){
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_CBCL_FORM_INFO');
        Test.loadData(DS_DATA__c.sobjectType, 'TESTDATA_DS_DATA_CBCL_SCALES');
    }
    
}