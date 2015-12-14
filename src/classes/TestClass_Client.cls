/****
*@description This test provides code coverage for Client
*includes
*Trigger 
*Bulkified testing
*
*@group Test Script 
*@group-content /ApexDocContent/Test/Client.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
private class TestClass_Client {
    
    /****
    *@description Initialize reference to TestClass_A_Utility
    ****/
    public static TestClass_A_Utility test_ut = new TestClass_A_Utility();
    
    /****
    *@description Initialize reference to Utility
    ****/
    public static Utility ut = new Utility();
    
    /****
    *@description method to test a bulk creation of object
    ****/
    static TestMethod void bulkifyObj(){
    
        Clinician__c clinician = test_ut.createClinician();
                
        List<Client__c> bulkObj = new List<Client__c>();
        
        for(Integer i=0;i<65;i++){
            test_ut.addAdminToCounter();
            bulkObj.add(new Client__c(Clinician__c= clinician.id, INIT__c= 'KEW',DOB1__c=date.today(), DOB2__c=date.today() , AGE__c=0 , GENDER__c='Female' ));
        }
        insert bulkObj;
    }
    
    /****
    *@description method to test creation of client record
    ****/
      static TestMethod void Test_ClientController_CreateClient() {

        test_ut.addAdminToCounter();

        Client__c client = new Client__c();

        PageReference pageRef = ApexPages.currentPage();
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(client);

        ClientController controller = new ClientController(sc);
            
      }

    /****
    *@description method to test editing a record
    ****/
      static TestMethod void Test_ClientController_EditClient() {

        Client__c client = Test0_TestClientInsert();

        PageReference pageRef = ApexPages.currentPage();
        pageRef.getParameters().put('id', client.id);
        Test.setCurrentPage(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(client);

        ClientController controller = new ClientController(sc);    

      }

    /****
    *@description method to test inserting a record
    ****/
      static TestMethod Client__c Test0_TestClientInsert() {

        Client__c client = test_ut.createClient();
        
        return client;

      }

    /****
    *@description method to test updating a record
    ****/
      static TestMethod void Test1_TestClientUpdate() {

        Client__c client = Test0_TestClientInsert();
        
        update client;

      }

}