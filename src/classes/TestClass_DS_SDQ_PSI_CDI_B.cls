@isTest 
private class TestClass_DS_SDQ_PSI_CDI_B{
  static TestMethod void Test_TestInsertUpdateDelete() {
    TestClass_Utility test_ut = new TestClass_Utility(); 
    TestClassData_DS_SDQ_PSI_CDI_Form_Info formInfo = new TestClassData_DS_SDQ_PSI_CDI_Form_Info();
   

    Client__c client = test_ut.createClientSummary();
    ///begin bulk insert
    System.debug('Inserting 200 baseline records... (bulk validation)');   
    List<DS_SDQ_PSI_CDI_B__c> bulkObj = new List<DS_SDQ_PSI_CDI_B__c>();     
    for (Integer i=0;i<200;i++){
      bulkobj.add(new DS_SDQ_PSI_CDI_B__c(client__c = client.id,
                                          BDOASDYP__c =date.parse('10/30/2014'),
                                          BDOASDOP__c =date.parse('10/30/2014'),
                                          BDOASDOS__c =date.parse('10/30/2014'), 
                                          Form__c = 'DS_SDQ_P_04_10',
                                          BMETSDOP__c = '1', 
                                          BMETSDOS__c = '1', 
                                          BMETSDYP__c = '1' ));//,RREF__c= true?
      
    }
    insert bulkObj;

}
}