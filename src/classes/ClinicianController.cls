/*Page Description:
 *  Controller Class for Clinician
 * Last Updated on:
 *  7/17/2014
 * Update Purpose:
 *      
 * Programmer:
 *  
 */
public with sharing class ClinicianController {
    
  String ID = Apexpages.currentPage().getParameters().get('id');
  
  public Clinician__c clinician {get;set;}
  
  public Integer edit {get; set;}
  
  public String title {get; set;}
  public String subtitle {get; set;}
  
  public Integer roleType {get; set;}

  public RoleController roleManager = new RoleController();
  
  public ClinicianController(ApexPages.StandardController controller) {

    title = 'Create Clinician';
    subtitle = 'Clinician';
    edit = 0;
    roleType = 0;
    
    Counter__c roleInfo = roleManager.RoleType(UserInfo.getUserRoleId());
    
    roleType = Integer.valueof(roleInfo.Type__c);
    
    if(ID != null) {
        
      clinician = [SELECT Center__c, Name, Name__c
                     FROM Clinician__c 
                    WHERE id = :ID];
  
      edit = 1;
      title = 'Clinician Edit';
      subtitle = '(' + clinician.Name + ') ' + clinician.Name__c;
        
    }
    
  }

}