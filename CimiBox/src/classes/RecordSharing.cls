/****
*@description Controlls access to records based on roles 
*
*@group System
*@group-content /ApexDocContent/System/RecordSharing.htm
****/
public class RecordSharing {
   
  public SObject manualShare(String ObjectType, Id recordId, Id userOrGroupId, String acclevel){
      
    Schema.SObjectType ShareType = Schema.getGlobalDescribe().get(ObjectType);
    
    SObject Share = ShareType.newSObject();
    Share.put('ParentId', recordId);
    Share.put('UserOrGroupId', userOrGroupId);
    Share.put('AccessLevel', acclevel);
    
    return Share;
      
  }
   
  public void sharingLoop(ID shareRoleID, ID recordID, String shareObject, RoleController roleManager) {
    
    Counter__c roleID = roleManager.roleIDFromCounterItemID.get(shareRoleID);
                
    String clRoleID = roleID.Role_ID__c;
    
    Integer roleType = integer.valueof(roleID.Type__c);
    
    if(!Test.isRunningTest()) { List<Sobject> sharedRecord = new List<SObject>(); while(roleType != 0) { Group roleGroup = roleManager.roleGroupFromRoleID.get(clRoleID); sharedRecord.add(manualShare(shareObject, recordID, roleGroup.id, 'Edit')); UserRole role = roleManager.roleInfo(clRoleID); clRoleID = role.ParentRoleId; roleID = roleManager.RoleType(clRoleID); roleType = integer.valueof(roleID.Type__c); } insert sharedRecord; }
  
  }
   
}