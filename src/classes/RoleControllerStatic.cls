public class RoleControllerStatic {
    
  public static void sleep(Integer sleepSeconds) {
  
      Long startTS = System.currentTimeMillis();
      HttpRequest req = new HttpRequest();
      req.setEndpoint('http://1.cuzillion.com/bin/resource.cgi?sleep=' + sleepSeconds);
      req.setMethod('GET');
      Http http = new Http();
      if(!Test.isRunningTest()) HTTPResponse res = http.send(req);
      Long duration = System.currentTimeMillis() - startTS;
      
  }
  
  @Future(callout=true)
  public static void insertRoleList(String roleName, String centerID, Integer type) {
              
      RoleControllerStatic.sleep(1); 

      RecordSharing roleShare = new RecordSharing();

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

        if(!Test.isRunningTest())
          roleShare.manualShare('Center__Share', centerID, roleGroup.id, 'Read'); 
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
          
  }



}