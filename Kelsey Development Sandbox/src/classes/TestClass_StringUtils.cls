/****
*@description Provides coverage for class StringUtils
*
*@group Test Script 
*@group-content /ApexDocContent/Test/StringUtils.htm
*
****/
@isTest (SeeAllData=false)
private class TestClass_StringUtils {
    
    /****
    *@description method to test an empty array
    ****/
    static TestMethod void emptyArrayTest() {
        
        String[] testArray = null;
        
        String emptyArray = StringUtils.joinArray(testArray);
        
        emptyArray = StringUtils.joinArray(testArray, '-', -1, 0);
        
    }
    
    /****
    *@description method to test an array with data
    ****/
    static TestMethod void notEmptyArrayTest() {
        
        String[] testArray = new List<String>();
        
        testArray.add('AAA');
        testArray.add('BBB');
        
        String notEmptyArray = StringUtils.joinArray(testArray);
        
        notEmptyArray = StringUtils.joinArray(testArray, '-', -1, testArray.size());
        
    }

}