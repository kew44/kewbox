/*Page Description:
 *  Controller Class for Clients
 * Last Updated on:
 *  7/17/2014
 * Update Purpose:
 *      
 * Programmer:
 *  
 */
public with sharing class ClientController {
    
    String ID = Apexpages.currentPage().getParameters().get('id');
    
    public Integer roleType {get; set;}
    
    public Boolean isNotClinician {get; set;}
    
    public String title {get; set;}
    public String subtitle {get; set;}
    
    public Client__c client {get; set;}

    public RoleController roleManager = new RoleController();
    
    public ClientController(ApexPages.StandardController controller) {
        
        title = 'Create Client';
        subtitle = 'Client';
        
        Counter__c roleInfo = roleManager.RoleType(UserInfo.getUserRoleId());
        
        roleType = Integer.valueof(roleInfo.Type__c);
        
        if(roleType != 3) isNotClinician = True;
    
        if(ID != null) {
         
            client = [SELECT AGE__c, BENRCDS__c, BPREVCA__c, BPREVEPI__c, Name, 
                             Clinician__c, CreatedById, CreatedDate, DOB1__c, DOB2__c, 
                             IsDeleted, GENDER__c, INIT__c, Id, SITEID__c 
                        FROM Client__c 
                       WHERE id = :Apexpages.currentPage().getParameters().get('id')]; 
                       
            title = 'Client Edit';
            subtitle = '(' + client.Name + ') ' + client.INIT__c;
                       
        }
        
    }
    
    
    
    /*public Boolean getisClient() {
        
        Integer count = findRoleAdmin(UserInfo.getUserRoleId(), 0);
        
        System.debug(count);
        
        if(count < 3) return True;
        else return False;
    }
    
    public Integer findRoleAdmin(ID roleID, Integer count) {
        
        UserRole role = [SELECT Name, ParentRoleId FROM UserRole WHERE Id = :roleID];
        
        if(role.ParentRoleId == null) return count;
        else {
            count++;
            return findRoleAdmin(role.ParentRoleId, count);
        }
    }*/
    
    /*public PageReference save() {
        if(ID == null) {
            insert client;
        }
        else {
            update client;
        }
        
        PageReference acctPage = new ApexPages.StandardController(client).view();
        acctPage.setRedirect(true);
        return acctPage;
        
    }*/

    
    
}