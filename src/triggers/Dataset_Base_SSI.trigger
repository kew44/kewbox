/*Trigger Description:
 * An apex trigger that exposes the client information functionality
 * 
 * Update History -----------------------
 *
 * Last Updated on: 7/30/2014
 * Update Purpose:
 *  1. Avoiding to use the query inside the loop.
 *  2. Add formbuilder.baseline method for building the baseline forms and 
 *     general trauma form in client_summary__c.
 * Edited by: Danny
 *
 */

trigger Dataset_Base_SSI on Client__c (before insert, after insert, after delete, after update, before update) {//, after insert
  
  RoleController roleManager = new RoleController(); 
 
  RecordSharing roleShare = new RecordSharing();

  Counter__c roleInfo = roleManager.RoleType(UserInfo.getUserRoleId());

  Clinician__c cl;
  Center__c center;
  
  if(Trigger.isInsert){ 
  
    if(Trigger.isBefore) {

      Set<String> clinicianList = new Set<String>();
      Set<String> centerList = new Set<String>();

      for(Client__c c: Trigger.new) {
        if(c.Clinician__c != null) clinicianList.add(c.Clinician__c);
      }

      if(roleInfo.Type__c == 3) {
        cl = [SELECT Center__r.Name, id 
                FROM Clinician__c
               WHERE id = :roleInfo.Item_ID__c];
        clinicianList.add(cl.id);
      }
      
      Map<Id, Clinician__c> clinicianInfo = 
          new Map<Id, Clinician__c> ([SELECT id, Center__r.Name 
                                        FROM Clinician__c
                                       WHERE id IN : clinicianList]);
      
      for(String ci : clinicianInfo.keySet()) 
        centerList.add(clinicianInfo.get(ci).Center__c);

      Map<Id, Center__c> centerInfo = 
          new Map<Id, Center__c>([SELECT Name 
                                    FROM Center__c
                                   WHERE id IN : centerList]);


      List<Counter__c> counterList = [SELECT Counter_3__c, Item_ID__c
                                        FROM Counter__c
                                       WHERE Item_ID__c IN :centerList];

      Map<String, Counter__c> counterMap = new Map<String, Counter__c>();

      for(Counter__c co : counterList) counterMap.put(co.Item_ID__c, co);

      Map<String, Counter__c> updateCounter = new Map<String, Counter__c>();


      for(Client__c c: Trigger.new) {

        c.INIT__c = c.INIT__c.toUpperCase();
    
        if(roleInfo.Type__c == 3) {
          
          c.Clinician__c = cl.id;
        }
        else {
          cl = clinicianInfo.get(c.Clinician__c);
        }

        center = centerInfo.get(cl.Center__c);

        Counter__c counter = counterMap.get(cl.Center__c);

        if(updateCounter.containsKey(counter.id)) {
          counter = updateCounter.get(counter.id);
        }
                       
        String clientID = roleManager.fillZero(5, counter.Counter_3__c++);
         
        c.Name = center.Name + '-' + clientID;
        
        updateCounter.put(counter.id, counter);

      }

      update updateCounter.values();
    
    }
    else if (Trigger.isAfter){

      Set<String> clientList = new Set<String>();
        
      for(Client__c c: Trigger.new) { 
          
        if(roleInfo.Type__c != 3) {
        
          if(!Test.isRunningTest()) { 
            roleShare.sharingLoop(c.Clinician__c, c.id, 'Client__Share', roleManager);
          }
          
        }

        clientList.add(c.id);
      
      }

      FormBuilder.baseline(clientList);
    
    }
  
  }    
}