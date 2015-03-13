@isTest (SeeAllData=false)
public Class TestClass_RecordSharing {

	static TestMethod void Test_Utility() {

		TestClass_Utility test_ut = new TestClass_Utility();

		Center__c subCenter = test_ut.createSubCenter();

		RoleController roleManager = new RoleController();

		RecordSharing roleShare = new RecordSharing();

		//RecordSharing.manualShare('Center__Share', subCenter.id, Id userOrGroupId, String acclevel)

		roleShare.sharingLoop(subCenter.Main_center__c, subCenter.id, 'Center__Share', roleManager);
	}

}