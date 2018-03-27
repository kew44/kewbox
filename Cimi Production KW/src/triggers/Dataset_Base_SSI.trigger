/****
*@description trigger for Client object
*
*@modified    11/30/16    KW    remove unhandled 'after delete' clause
*@modified    3/9/17    KW    debugging ownership validation
*@modified    4/18/17    KW    removed extra debugs
*@modified    9/18/17    KW    Clinician Email on update
*@modified    9/19/17    KW    Clinician Email on insert
****/
trigger Dataset_Base_SSI on Client__c (before insert, after insert, after update, before update) {
    
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
                    if(c.Clinician__c != null) 
                        clinicianList.add(c.Clinician__c);  
                }
            
                if(roleInfo.Type__c == 3) {
                    cl = [SELECT Center__r.Name, id, Email__c 
                          FROM Clinician__c
                          WHERE id = :roleInfo.Item_ID__c];
                    clinicianList.add(cl.id);
                }
            
                Map<Id, Clinician__c> clinicianInfo = 
                    new Map<Id, Clinician__c> ([SELECT id, Center__r.Name, Email__c 
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
                
                for(Counter__c co : counterList) 
                    counterMap.put(co.Item_ID__c, co);   
                                 
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
                c.Center__c = cl.Center__c;          
                c.Clinician_Email__c = cl.Email__c;
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
    
    if(Trigger.isUpdate) {        
        Set<String> clinicianList = new Set<String>();        
            for(Client__c c: Trigger.new) {
                    if(c.Clinician__c != null) clinicianList.add(c.Clinician__c);  
            }
        
        Map<Id, Clinician__c> clinicianInfo = 
                new Map<Id, Clinician__c> ([SELECT id, Center__c, Email__c 
                                            FROM Clinician__c
                                            WHERE id IN : clinicianList]);
                                            
        if(Trigger.isBefore) {            
            for(Client__c c: Trigger.new) {                
                c.CENTER__c = clinicianInfo.get(c.Clinician__c).Center__c;
                 c.Clinician_Email__c = clinicianInfo.get(c.Clinician__c).Email__c;  
            }        
        }      
    }
}