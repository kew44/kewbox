trigger ClinicianTrigger on Clinician__c (before insert, after insert, after delete, after update, before update) {
    
  RoleController roleManager = new RoleController();

  RecordSharing roleShare = new RecordSharing();


  Counter__c roleInfo = roleManager.RoleType(UserInfo.getUserRoleId());
    
  if(Trigger.isInsert){ 

    Map<String, Counter__c> updatedConuter;
              
    if(Trigger.isBefore) {

      updatedConuter = new Map<String, Counter__c>();

      for(Clinician__c c: Trigger.new) {
    
        if(roleInfo.Type__c == 2) {
          c.Center__c = roleInfo.Item_ID__c;
        }

        Counter__c counter = roleManager.roleIDFromCounterItemID.get(c.Center__c);

        if(updatedConuter.containsKey(c.Center__c))
          counter = updatedConuter.get(c.Center__c);

        List<Counter__c> counterRole = [SELECT Type__c, Item_ID__c, Item_Name__c, Role_ID__c, Counter_2__c 
                                      FROM Counter__c];
        

        Center__c center = roleManager.roleCenterFromID.get(c.Center__c);
    
        String clID = roleManager.fillZero(2, counter.Counter_2__c++);
        
        c.Name = center.Name + '-' + clID;
        
        //update counter;
        updatedConuter.put(counter.Item_ID__c, counter);

      }

      update updatedConuter.values();
        
    }
    else if (Trigger.isAfter){

      for(Clinician__c c: Trigger.new) {

        Counter__c counter = roleManager.roleIDFromCounterItemID.get(c.Center__c);

        String roleName = '(' + c.Name + ') ' + c.Name__c;
        
        if(!Test.isRunningTest()) RoleControllerStatic.CreateCenter(roleName, counter.Role_ID__c);

        //RoleController.scheduleInsertRole(roleName, c.id, 3);
        
        if(!Test.isRunningTest()) RoleControllerStatic.insertRoleList(roleName, c.id, 3);  // 3: type - clinician
        
        if(roleInfo.Type__c != 2)
          if(!Test.isRunningTest()) roleShare.sharingLoop(c.Center__c, c.id, 'Clinician__Share', roleManager);
        
      }
        
    }
        
  }
  else if(Trigger.isDelete) {
    
    if(Trigger.isAfter) {

      List<Counter__c> deletedCounter =  new List<Counter__c>();
        
      for(Clinician__c c : Trigger.old) {

        if(roleManager.roleIDFromCounterItemID.containsKey(c.id)) {

          Counter__c counter = roleManager.roleIDFromCounterItemID.get(c.id);

          if(!Test.isRunningTest()) RoleControllerStatic.DeleteRole(counter.Role_ID__c); 
          
          deletedCounter.add(counter);

        }
             
      }  

      delete deletedCounter;           
        
    }
    
  }
   
  else if(Trigger.isUpdate) {
    
    if(Trigger.isAfter) {
            
      UserRole role = new UserRole();

      List<Counter__c> updatedCounter =  new List<Counter__c>();
      
      for(Clinician__c c: Trigger.new) {
      
        String centerIDName = '(' + c.Name + ') ' + c.Name__c;

        Counter__c counter = roleManager.roleIDFromCounterItemID.get(c.id);
        
        counter.Item_Name__c = centerIDName;
        
        if(!Test.isRunningTest()) RoleControllerStatic.UpdateCenter(centerIDName, counter.Role_ID__c); 
        
        updatedCounter.add(counter);
                     
      }   

      update updatedCounter;          
        
    }
        
  }
  
}