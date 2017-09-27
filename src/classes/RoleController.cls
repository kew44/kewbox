/*Page Description:
 *  Controller Class for Roles
 * Last Updated on:
 *  7/17/2014
 * Update Purpose:
 *      
 * Programmer:
 *  
 */
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
  
  /*public static void sleep(Integer sleepSeconds) {
  
      Long startTS = System.currentTimeMillis();
      HttpRequest req = new HttpRequest();
      req.setEndpoint('http://1.cuzillion.com/bin/resource.cgi?sleep=' + sleepSeconds);
      req.setMethod('GET');
      Http http = new Http();
      if(!Test.isRunningTest()) HTTPResponse res = http.send(req);
      Long duration = System.currentTimeMillis() - startTS;
      
  }*/
  
  public UserRole getRoleInfo(String roleName) {

      return roleInfoByName.get(roleName);

  }
  
  public UserRole roleInfo(ID roleID) {

      return roleInfoByID.get(roleID);

  }

  
  /*@Future(callout=true)
  public static void insertRoleList(String roleName, String centerID, Integer type) {
              
      RoleController.sleep(1); 

      UserRole rInfo = [SELECT Id, name 
                          FROM UserRole
                         WHERE Name LIKE :roleName];

      Counter__c counter = new Counter__c(Item_ID__c = centerID, 
                                          Item_name__c = roleName, 
                                          Type__c = type, 
                                          Role_ID__c = rInfo.id); 

      insert counter;
              
      if(type == 1) { 
        Group roleGroup = [SELECT Id 
                             FROM Group 
                            WHERE RelatedId = :rInfo.id 
                              AND Type = 'Role']; 

        RecordSharing.manualShare('Center__Share', centerID, roleGroup.id, 'Read'); 
      }
              
  }
  

  @future
  public static void CreateCenter(String name, ID parentRoleID) {
      
    UserRole crole = new UserRole(Name = name, ParentRoleID = parentRoleID);
    
    insert crole;
      
  }
  
  
  @future
  public static void DeleteRole(String roleID) {
    
    RoleController role = new RoleController();

    UserRole crole = [SELECT Id, name 
                        FROM UserRole
                       WHERE id = :roleID];
                       
    role.CleanUserRole(roleID);
      
    if(!Test.isRunningTest()) delete crole;

  }
  
  @future
  public static void UpdateCenter(String roleName, ID roleID) {
      
      
    UserRole crole = [SELECT Id, name 
                        FROM UserRole
                       WHERE Id = :roleID];
    
    crole.Name = roleName;
            
    //if(!Test.isRunningTest())
    update crole;
          
  }*/
    
}