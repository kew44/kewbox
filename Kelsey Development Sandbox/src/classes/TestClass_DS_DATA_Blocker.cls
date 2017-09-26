/****
* @author Danny Fu
* @date 10/13/2016
*
* @group Test Script 
* @group-content /ApexDocContent/Test/DS_DATA_Blocker.htm
*
* @description This test provides code coverage for DS_DATA_Blocker
* includes
* 1. DS_DATA_Trigger 
* 2. DS_DATA_Blocker class
* 3. Bulkified testing
* 4. Asserted Variables
*/

@isTest (SeeAllData=false)
public class TestClass_DS_DATA_Blocker {

    /****
    *@description Initialize reference to TestClass_A_Utility
    ****/
    private static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    /****
    *@description Initialize reference to Utility
    ****/
    private static Utility ut = new Utility();
    
    /****
    *@description Initialize reference to TestClass_DS_DATA_Blocker_Tester
    ****/
    private static TestClass_DS_DATA_Blocker_Tester blocker = new TestClass_DS_DATA_Blocker_Tester();
    
    /****
    *@description Load required data from TestClassData
    ****/
    @testSetup 
    static void setup() {   
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();  
    }
    
    /****
    *@description method to set DS_DATA record Allow_Modify__c field to true
    *@return true
    ****/
    static TestMethod Boolean setAllowModifyOn(){
        
        List<DS_DATA__c> blockerRecord = [SELECT DATA_TYPE__c, ALLOW_MODIFY__c 
                                    FROM DS_DATA__c
                                    WHERE DATA_TYPE__c = 'DS_Blocking'];
        
        System.assertNotEquals(blockerRecord.size(), 0, 'The test blocker record does not exist.');
        
        System.assert(!(blockerRecord.size() > 1), 'There are more than two blocker records.');
        
        // Blocker record exists
        if(blockerRecord.size() == 1) {
            
            blockerRecord.get(0).ALLOW_MODIFY__c = true;
            
            update blockerRecord;
            
        }
        
        DS_DATA__c updatedBlocker = [SELECT DATA_TYPE__c, ALLOW_MODIFY__c 
                                    FROM DS_DATA__c
                                    WHERE DATA_TYPE__c = 'DS_Blocking'
                                    AND id =: blockerRecord.get(0).id];
        
        System.assertEquals(updatedBlocker.ALLOW_MODIFY__c, true, 'The test blocker record update failed.');
        
        return true;
        
    }
    
    /****
    *@description method to set DS_DATA record Allow_Modify__c field to false
    *@return false
    ****/
    static TestMethod Boolean setAllowModifyOff(){
        
        List<DS_DATA__c> blockerRecord = [SELECT DATA_TYPE__c, ALLOW_MODIFY__c 
                                    FROM DS_DATA__c
                                    WHERE DATA_TYPE__c = 'DS_Blocking'];
        
        System.assertNotEquals(blockerRecord.size(), 0, 'The test blocker record does not exist.');
        
        System.assert(!(blockerRecord.size() > 1), 'There are more than two blocker records.');
        
        // Blocker record exists
        if(blockerRecord.size() == 1) {
            
            blockerRecord.get(0).ALLOW_MODIFY__c = false;
            
            update blockerRecord;
            
        }
        
        DS_DATA__c updatedBlocker = [SELECT DATA_TYPE__c, ALLOW_MODIFY__c 
                                    FROM DS_DATA__c
                                    WHERE DATA_TYPE__c = 'DS_Blocking'
                                    AND id =: blockerRecord.get(0).id];
         
        System.assertEquals(updatedBlocker.ALLOW_MODIFY__c, false, 'The test blocker record update failed.');
        
        return false;
        
    }
    
    /****
    *@description method to test insert DS_DATA record 
    *with the blocker record allow modify ON or oFF 
    ****/
    static TestMethod void TestInsertData(){
        
        // Allow_Modify__c False
        insertWithAllowModify(setAllowModifyOff());
        
        // Allow_Modify__c True
        insertWithAllowModify(setAllowModifyOn());
                
    }
    
    /****
    *@description method to test insert DS_DATA record 
    *with the blocker record allow modify ON or oFF 
    ****/
    static TestMethod void TestUpdateData(){
            
        // Allow_Modify__c False
        updateWithAllowModify(setAllowModifyOff());
        
        // Allow_Modify__c True
        updateWithAllowModify(setAllowModifyOn());
        
    }
    
    /****
    *@description method to test delete DS_DATA record 
    *with the blocker record allow modify ON or oFF 
    ****/
    static TestMethod void TestDeleteData(){
                
        // Allow_Modify__c False
        deleteWithAllowModify(setAllowModifyOff());
        
        // Allow_Modify__c True
        deleteWithAllowModify(setAllowModifyOn());
        
    }
    
    /****
    *@description method to test insert DS_DATA record 
    *@param AllowModify Allow_Modify__c vlue
    *@example
    *   insertWithAllowModify(True);
    ****/
    static void insertWithAllowModify(Boolean AllowModify){
        
        // Set Allow_Modify__c value
        blocker.setAllowModify(AllowModify);
                       
        // Insert single record
        List<DS_DATA__c> singleRecord = new List<DS_DATA__c>();
        
        singleRecord.add(new DS_DATA__c(DATA_TYPE__c = 'type', WEIGHT__c = 2));
                            
        blocker.setData(singleRecord);
                
        blocker.insertTest();
        
        // Insert multiple records 
        List<DS_DATA__c> multipleRecords = new List<DS_DATA__c>();
        
        multipleRecords.add(new DS_DATA__c(DATA_TYPE__c = 'type', WEIGHT__c = 2));
        multipleRecords.add(new DS_DATA__c(DATA_TYPE__c = 'type', WEIGHT__c = 3));
        
        blocker.setData(multipleRecords);
        
        blocker.insertTest();
    }
    
    /****
    *@description method to test update DS_DATA record 
    *@param AllowModify Allow_Modify__c vlue
    *@example
    *   updateWithAllowModify(True);
    ****/
    static void updateWithAllowModify(Boolean AllowModify){
        
        // Set Allow_Modify__c value
        blocker.setAllowModify(AllowModify);
        
        // Update single record
        List<DS_DATA__c> singleRecord = [SELECT id, PAGE__C, WEIGHT__c 
                                           FROM DS_DATA__c 
                                          WHERE DATA_TYPE__c = 'DS_Form_Info' 
                                          LIMIT 1];
                            
        blocker.setData(singleRecord);
        
        blocker.updateTest();
        
        // Update multiple records 
        List<DS_DATA__c> multipleRecords = [SELECT id, PAGE__C, WEIGHT__c 
                                              FROM DS_DATA__c 
                                             WHERE DATA_TYPE__c = 'DS_Form_Info'];
        
        blocker.setData(multipleRecords);
                
        blocker.updateTest();
    }
    
    /****
    *@description method to test delete DS_DATA record 
    *@param AllowModify Allow_Modify__c vlue
    *@example
    *   deleteWithAllowModify(True);
    ****/
    static void deleteWithAllowModify(Boolean AllowModify){
        
        // Set Allow_Modify__c value
        blocker.setAllowModify(AllowModify);
        
        // Delete single data
        List<DS_DATA__c> singleRecord = [SELECT id, PAGE__C, WEIGHT__c 
                                           FROM DS_DATA__c 
                                          WHERE DATA_TYPE__c = 'DS_Form_Info' 
                                          LIMIT 1];
                
        blocker.setData(singleRecord);
        blocker.deleteTest();
        
        // Delete multiple data
        List<DS_DATA__c> multipleRecords = [SELECT id, PAGE__C, WEIGHT__c 
                                              FROM DS_DATA__c 
                                             WHERE DATA_TYPE__c = 'DS_Form_Info'];
        
        blocker.setData(multipleRecords);
        blocker.deleteTest();        
    }
    
    /****
    *@description test method to insert new DS_DATA record
    ****/
    static TestMethod void insertNewBlockerRecordWithAllowModify(){
        
        // Insert blocker record with Allow Modify ON
        setAllowModifyOn();
        
        TestClass_DS_DATA_Blocker_Tester.insertNewBlockerRecord();
        
        // Insert blocker record with Allow Modify OFF
        setAllowModifyOff();
                
        TestClass_DS_DATA_Blocker_Tester.insertNewBlockerRecord();
        
    }
    
    /****
    *@description test method to update DS_DATA record 
    *DATA_TYPE__c value 
    ****/
    static TestMethod void updateBlockerRecordDataTypeWithAllowModify(){
                
        // Update blocker record with Allow Modify ON
        setAllowModifyOn();
        
        TestClass_DS_DATA_Blocker_Tester.updateBlockerRecordDataType();
        
        // Update blocker record with Allow Modify OFF
        setAllowModifyOff();
        
        TestClass_DS_DATA_Blocker_Tester.updateBlockerRecordDataType();
        
    }
    
    /****
    *@description test method to delete DS_DATA record 
    ****/
    static TestMethod void deleteBlockerRecordWithAllowModify(){
        
        // Delete blocker record with Allow Modify ON
        setAllowModifyOn();
        
        TestClass_DS_DATA_Blocker_Tester.deleteBlockerRecord();
        
        // Update blocker record with Allow Modify OFF
        setAllowModifyOff();
        
        TestClass_DS_DATA_Blocker_Tester.deleteBlockerRecord();
    }
    
}