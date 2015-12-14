/****
*@description Tests Record Sharing capabilities
*
*@group Test Script 
*@group-content /ApexDocContent/Test/RecordSharing.htm
****/
@isTest (SeeAllData=false)
public Class TestClass_RecordSharing {

    static TestMethod void Test_Utility() {

        TestClass_A_Utility test_ut = new TestClass_A_Utility();

        Center__c subCenter = test_ut.createSubCenter();

        RoleController roleManager = new RoleController();

        RecordSharing roleShare = new RecordSharing();

        UserRole rInfo = [SELECT Id, name 
                          FROM UserRole
                         WHERE Name = 'Administrator'];

        Group roleGroup = [SELECT Id 
                             FROM Group 
                            WHERE RelatedId = :rInfo.id 
                              AND Type = 'Role']; 

        Clinician__c cl = new Clinician__c();

        cl.Center__c = subCenter.id;

        insert cl;

        // Manually run insertRoleList() for Clinician

        Clinician__c clinician = [SELECT id, Name, Name__C, Center__c FROM Clinician__c WHERE id =: cl.id];

        String clinicianRoleName = '(' + clinician.Name + ') ' + clinician.Name__c;

        String clinicianRoleID = '000003';  

        Counter__c counter = new Counter__c(Item_ID__c = clinician.id, 
                                            Item_name__c = clinicianRoleName, 
                                            Type__c = 1, 
                                            Role_ID__c = clinicianRoleID); 

        insert counter;

        Client__c client = new Client__c();

        client.INIT__c = 'BBB';
        client.Clinician__c = clinician.id;
        client.DOB1__c = date.today();
        client.DOB2__c = date.today();
        client.AGE__c = 0;
        client.GENDER__c = 'Female';

        insert client;

        roleShare.manualShare('Client__Share', client.id, roleGroup.Id, 'Read');

        roleShare.sharingLoop(subCenter.Main_center__c, clinician.Center__c, 'Center__Share', roleManager);

    }

}