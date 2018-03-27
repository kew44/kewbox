/****
* @author Danny Fu
* @date 10/13/2016
*
* @group Test Script 
* @group-content /ApexDocContent/Test/DS_DATA_Blocker_Tester.htm
*
* @description Thie class provides the test methods for TestClass_DS_DATA_Blocker
*
*/
@isTest (SeeAllData=false)
public class TestClass_DS_DATA_Blocker_Tester {
    
    /****
    *@description Initialize DS_DATA__c list
    ****/
    private static List<DS_DATA__c> data;
    
    /****
    *@description Initialize isAllowModifyON 
    ****/
    private static Boolean isAllowModifyON;
    
    /****
    *@description Load required data from TestClassData
    ****/
    @testSetup 
    static void setup() {   
        TestClassData_DS_DATA importData = new TestClassData_DS_DATA();  
    }
    
    /****
    *@description method to set the DS_DATA list record 
	*@param data a list of the DS_DATA record
	*@example
    * 	List<DS_DATA__c> data = new List<DS_DATA__c>();
    * 	setData(data);
    ****/
    public void setData(List<DS_DATA__c> data2) {
        data = data2;
    }
    
    /****
    *@description method to set the AllowModify value 
	*@param allowModify allowModify__c field value
	*@example
    * 	setAllowModify(True);
    ****/
    public void setAllowModify(Boolean allowModify) {
        isAllowModifyON = allowModify;
    }
    
    /****
    *@description method extened Exception to throw exception  
	* if the test failed 
    ****/
    public class testDATAException extends Exception {}
    
    /****
    *@description method to set the run the insert test 
	*@example
    * 	TestClass_DS_DATA_Blocker_Tester blocker = new TestClass_DS_DATA_Blocker_Tester();
    * 	blocker.setAllowModify(True);
    * 	blocker.setData(List<DATA__c>);
    *   blocker.insertTest();
    ****/
    public void insertTest() {
        
        try {            
            insert data;
            
            if(isAllowModifyON == false) {
            	// If we get to this line it means an error was not added and the test class should throw an exception here. 
            	throw new testDATAException('An exception should have been thrown by the trigger.');  
            }
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('You do not have the permission to insert any record.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, !isAllowModifyON);
        } 
        
        // Verify the test result
        if(isAllowModifyON == true) {
        	
            List<DS_DATA__c> newData = [SELECT id FROM DS_DATA__c WHERE id =: data.get(0).id];
        
        	System.AssertEquals(1, newData.size(), 'Insert with allow modify ON failed.');
        
        }
        
    }
        
	/****
    *@description method to set the run the update test 
	*@example
    * 	TestClass_DS_DATA_Blocker_Tester blocker = new TestClass_DS_DATA_Blocker_Tester();
    * 	blocker.setAllowModify(True);
    * 	blocker.setData(List<DATA__c>);
    *   blocker.updateTest();
    ****/    
    public void updateTest() {
    
        Id updateId = data.get(0).id;
        
        for (DS_DATA__c d : data) {
            d.PAGE__c = 'test blocker page';
        }
        
        try {            
            update data;
            
            if(isAllowModifyON == false) {
                // If we get to this line it means an error was not added and the test class should throw an exception here. 
            	throw new testDATAException('An exception should have been thrown by the trigger.');  
            }
            
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  
                e.getMessage().contains('You do not have the permission to update any record.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, !isAllowModifyON);
        } 
        
        // Verify the test result
        DS_DATA__c updatedData = [SELECT id,PAGE__c  FROM DS_DATA__c WHERE id =: updateId];
        
        if(isAllowModifyON == false) {
            System.AssertNotEquals('test blocker page', updatedData.PAGE__c, 'Update with allow modify OFF failed.');
        }
        else {
            System.AssertEquals('test blocker page', updatedData.PAGE__c, 'Update with allow modify ON failed.');
        }
        
        
    }
    
    /****
    *@description method to set the run the delete test 
	*@example
    * 	TestClass_DS_DATA_Blocker_Tester blocker = new TestClass_DS_DATA_Blocker_Tester();
    * 	blocker.setAllowModify(True);
    * 	blocker.setData(List<DATA__c>);
    *   blocker.deleteTest();
    ****/ 
    public void deleteTest() {
        
        Id deletedId = data.get(0).id;
                            
        try {            
            delete data;
            
            if(isAllowModifyON == false) {
            	// If we get to this line it means an error was not added and the test class should throw an exception here. 
            	throw new testDATAException('An exception should have been thrown by the trigger.');  
            }
        }
        catch(Exception e) {
            System.debug(e.getMessage());
            Boolean expectedExceptionThrown =  e.getMessage().contains('You do not have the permission to delete any record.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, !isAllowModifyON);
        } 
        
        // Verify the test result
        List<DS_DATA__c> deletedData = [SELECT id,PAGE__c  FROM DS_DATA__c WHERE id =: deletedId];
        
        if(isAllowModifyON == true) {
        	System.AssertEquals(0, deletedData.size(), 'Delete with allow modify ON failed.');
        }
        else {
            System.AssertEquals(1, deletedData.size(), 'Delete with allow modify OFF failed.');
        }
        
    }
    
    /****
    *@description Used in test method insertNewBlockerRecordWithAllowModify to test
	* insert new blocker record without unique blocker id, with unique id or with wrong id
    ****/
    @isTest
    public static void insertNewBlockerRecord() {
        
        DS_DATA__c blockerData = new DS_DATA__c(DATA_TYPE__c = 'DS_Blocking', ALLOW_MODIFY__c = true); 
        
        // New blocker record with no blocker id
        try {            
            insert blockerData;
            
            // If we get to this line it means an error was not added and the test class should throw an exception here. 
            throw new testDATAException('An exception should have been thrown by the trigger.');  
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('You can not create new blocker record.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        } 
        
        // New blocker record with the correct id - thrown duplicate id exception
        // You can only have one blocker record 
        try {  
            blockerData.Blocker_ID__c = '20160930';
            insert blockerData;
            
            // If we get to this line it means an error was not added and the test class should throw an exception here. 
            throw new testDATAException('An exception should have been thrown by the trigger.');  
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('duplicate value found') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        } 
        
        // New blocker record with the wrong id
        // You can only have one blocker record and id has to be '20160903' 
        try {  
            blockerData.Blocker_ID__c = '20160933';
            insert blockerData;
            
            // If we get to this line it means an error was not added and the test class should throw an exception here. 
            throw new testDATAException('An exception should have been thrown by the trigger.');  
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('You can not create new blocker record.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        } 
        
        List<DS_DATA__c> blockerRecords = [SELECT id, Data_Type__c 
                                           FROM DS_DATA__c 
                                           WHERE DATA_TYPE__c = 'DS_Blocking'];
        
        System.AssertEquals(1, blockerRecords.size(), 'Insert new Blocker record with Allow Modify ON failed.');
        
    }
    
    /****
    *@description Used in test method updateBlockerRecordDataTypeWithAllowModify.
	* Update blocker record Data_Type__c field.
    ****/
    @isTest
    public static void updateBlockerRecordDataType() {
        
        DS_DATA__c blockerData = [SELECT id, PAGE__C, DATA_TYPE__c 
                           FROM   DS_DATA__c 
                           WHERE  DATA_TYPE__c = 'DS_Blocking'];
                            
        try {
            blockerData.DATA_TYPE__c = 'Update DS_Blocking';
            
            update blockerData;
            
            // If we get to this line it means an error was not added and the test class should throw an exception here. 
            throw new testDATAException('An exception should have been thrown by the trigger.');  
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('You are not supposed to change Data_Type__c value in blocker record.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        } 
        
        DS_DATA__c updatedBlockerData = [SELECT id, Data_Type__c FROM DS_DATA__c WHERE id =: blockerData.id];
        
        System.AssertEquals('DS_Blocking', updatedBlockerData.DATA_TYPE__c, 'Update Blocker record DATA_TYPE__c with Allow Modify ON failed.');
        
    }
    
    /****
    *@description Used in test method deleteBlockerRecordWithAllowModify to
	* delete blocker record.
    ****/
    @isTest
    public static void deleteBlockerRecord() {
        
        DS_DATA__c blockerData = [SELECT id, PAGE__C, DATA_TYPE__c 
                           		  FROM   DS_DATA__c 
                           		  WHERE  DATA_TYPE__c = 'DS_Blocking'];
        
        Id deltedRecordID = blockerData.id;
        
        try {            
            delete blockerData;
            
            // If we get to this line it means an error was not added and the test class should throw an exception here. 
            throw new testDATAException('An exception should have been thrown by the trigger.');  
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('You are not supposed to delete blocker record.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        } 
        
        List<DS_DATA__c> deletedBlockerData = [SELECT id 
                                         	   FROM DS_DATA__c 
                                         	   WHERE id =: deltedRecordID];
        
        System.AssertEquals(1, deletedBlockerData.size(), 'Delete Blocker record with Allow Modify ON failed.');
        
    }
}