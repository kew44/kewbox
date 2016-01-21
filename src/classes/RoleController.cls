/****
*@description Controller Class for Roles
*
*@group System
*@group-content /ApexDocContent/System/RoleController.htm
****/
public class RoleController {

  public Map<String, Counter__c> roleType = new Map<String, Counter__c>();
  public Map<String, UserRole> roleInfoByName = new Map<String, UserRole>();
  public Map<String, UserRole> roleInfoByID = new Map<String, UserRole>();
  public Map<String, Counter__c> roleIDFromCounterItemID = new Map<String, Counter__c>();
  public Map<String, Group> roleGroupFromRoleID = new Map<String, Group>();
  public Map<String, Center__c> roleCenterFromID = new Map<String, Center__c>();

  public RoleController() {

    for(Counter__c counterRole : [SELECT Type__c, Item_ID__c, Item_Name__c, 
                                         Role_ID__c, Counter_2__c 
                                    FROM Counter__c]) {

      roleType.put(counterRole.Role_ID__c, counterRole);
      roleIDFromCounterItemID.put(counterRole.Item_ID__c, counterRole);

    }

    for(UserRole rInfo : [SELECT Id, Name, ParentRoleId FROM UserRole]) {
      roleInfoByName.put(rInfo.Name, rInfo);
      roleInfoByID.put(rInfo.id, rInfo);
    }

    for(Group roleGroup : [SELECT Id, RelatedId FROM Group WHERE Type = 'Role'])
      roleGroupFromRoleID.put(roleGroup.RelatedId, roleGroup);

    for(Center__c center : [SELECT id, Name FROM Center__c])
      roleCenterFromID.put(center.id, center);

  }
  
  public void CleanUserRole(ID UserRoleID) {
      
     User[] urole = [SELECT ID, name, UserRoleId 
                        FROM User 
                       WHERE UserRoleId = :UserRoleID];
              
      for(User ruser : urole) {
          
          ruser.UserRoleId = null;
          
          update ruser;
      }
     
  }
    
  public Counter__c RoleType(ID RoleID) {
    return roleType.get(RoleID);
  }
  
  public String fillZero(Integer digits, Decimal value) {
      
    String result = string.valueof(value);
    
    for(Integer i=0; i < digits - string.valueof(value).length(); i++) {
        result = '0' + result ;
    }
        
    return result;
  }
  
  public UserRole getRoleInfo(String roleName) {
      return roleInfoByName.get(roleName);
  }
  
  public UserRole roleInfo(ID roleID) {
      return roleInfoByID.get(roleID);
  }
    
}