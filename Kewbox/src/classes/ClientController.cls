/****
*@description Controller Class for Clients
*
*@group Client
*@group-content /ApexDocContent/Client/ClientController.htm
****/
public with sharing class ClientController{// extends DS_BasicForm_Controller {
    
    String ID = Apexpages.currentPage().getParameters().get('id');
    
    public Integer roleType {get; set;}
    
    public Boolean isNotClinician {get; set;}
    
    public String title {get; set;}
    public String subtitle {get; set;}
    
    public Client__c client {get; set;}

    public RoleController roleManager = new RoleController();
    public Utility ut = new Utility();
    
    public ClientController(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
       // super(ut.Form());
        
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
}