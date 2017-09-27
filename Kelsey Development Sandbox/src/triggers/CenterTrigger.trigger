trigger CenterTrigger on Center__c (before insert, after insert, after delete, after update, before update) {
    
    RoleController roleManager = new RoleController();

    RecordSharing roleShare = new RecordSharing();

    Counter__c roleInfo = roleManager.RoleType(UserInfo.getUserRoleId());
        
    //Boolean isAdmin = (counterRole.Type__c == 0) ? TRUE : FALSE;
        
    if(Trigger.isInsert){ 
        
        if(Trigger.isBefore) {
            
            for(Center__c c: Trigger.new) {
                
                if(roleInfo.Type__c == 1) {  // User is center manager
                    c.Main_center__c = roleInfo.Item_ID__c;
                    c.Type__c = 'Sub';
                }
            
                if(c.Type__c == 'Main') { // Main center
                     c.Name = c.Input_ID__c + '-00';
                }
                else if(c.Type__c == 'Sub') {
                                
                    Counter__c counter = [SELECT Role_ID__c, Counter__c
                                            FROM Counter__c
                                           WHERE Item_ID__c = :c.Main_center__c];
                                
                    Center__c center = [SELECT Input_ID__c
                                          FROM Center__c
                                         WHERE id = :c.Main_center__c];
                    
                    String subID = roleManager.fillZero(2, counter.Counter__c++);
                    
                    c.Name = center.Input_ID__c + '-' + subID;
                    
                    update counter; 
                
                }
                
            }
            
        
        }
        else if (Trigger.isAfter){
        
            for(Center__c c: Trigger.new) { 
            
              String roleName = '(' + c.Name + ') ' + c.Name__c;

              UserRole adminRoleID = [SELECT id FROM UserRole WHERE Name = 'Administrator'];
              
              String parentRole = adminRoleID.id;

              Integer type = 1;  // 1: type - main center
              
              if(c.Type__c == 'Sub') {
                  
                  Counter__c counter = [SELECT Role_ID__c
                                          FROM Counter__c
                                         WHERE Item_ID__c = :c.Main_center__c];
                                         
                  parentRole = counter.Role_ID__c;
                  
                  type = 2; // 2: type - sub-center
                  
                  if(roleInfo.Type__c != 1) {
                    if(!Test.isRunningTest()) roleShare.sharingLoop(c.Main_center__c, c.id, 'Center__Share', roleManager);
                  }
              
              }

              if(!Test.isRunningTest()) RoleControllerStatic.CreateCenter(roleName, parentRole);

              /*DateTime current = System.now();

              DateTime add1sec = current.addSeconds(1);

              scheduledRole sr = new scheduledRole();
              
              String sch = add1sec.second()+' '+
                           add1sec.minute()+' '+
                           add1sec.hour()+' '+
                           add1sec.day()+' '+
                           add1sec.month()+' ? '+
                           add1sec.year();

              sr.sentParameter(roleName, c.id, type);
              
              if(!Test.isRunningTest()) String jobID = system.schedule('role create'+System.now(), sch, sr);  */

              //RoleController.scheduleInsertRole(roleName, c.id, type);
                
              if(!Test.isRunningTest()) RoleControllerStatic.insertRoleList(roleName, c.id, type);
                
            }
        }
    
    }
    else if(Trigger.isDelete) {
    
        if(Trigger.isAfter) {     
            
          for(Center__c c: Trigger.old) {
              
            List<Counter__c> counter = [SELECT id, Role_ID__c 
                                          FROM Counter__c 
                                         WHERE Item_ID__c = :c.id];

            if(counter.size() != 0) {
              
              if(!Test.isRunningTest()) RoleControllerStatic.DeleteRole(counter.get(0).Role_ID__c); 
              
              delete counter;
             
            }

          }          
            
        }
        
    }
    else if(Trigger.isUpdate) {
    
        if(Trigger.isBefore) {
            
            for(Center__c c: Trigger.new) {
            
                if(c.Type__c == 'Main') 
                    c.Name = c.Input_ID__c + '-00';
                
            }
            
        }
    
        if(Trigger.isAfter) {
                
            UserRole role = new UserRole();
            
            for(Center__c c: Trigger.new) {
            
                String centerIDName = '(' + c.Name + ') ' + c.Name__c;
                
                Counter__c counter = [SELECT Role_ID__c 
                                        FROM Counter__c 
                                       WHERE Item_ID__c = :c.id];
                
                counter.Item_Name__c = centerIDName;
                
                if(!Test.isRunningTest()) RoleControllerStatic.UpdateCenter(centerIDName, counter.Role_ID__c); 
                
                update counter;
                           
            }             
            
        }
        
    }

}