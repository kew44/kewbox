/****
*@description Controller Class for Centers
*
*@group Center 
*@group-content /ApexDocContent/Center/CenterController.htm
****/

 public with sharing class CenterController {

    String ID = Apexpages.currentPage().getParameters().get('id');
    
    public Boolean createSub {get; set;}
    
    public Integer mainSub {get; set;}
    public Boolean isAdmin {get; set;}
    public Boolean newEdit {get; set;}
    
    public Center__c center {get;set;}
    
    public String title {get; set;}
    public String subtitle {get; set;}

    public RoleController roleManager = new RoleController();

    public CenterController(ApexPages.StandardController controller) {
    
        mainSub = 0;
        newEdit = TRUE;
            
        createSub = (Apexpages.currentPage().getParameters().get('CF00Ni000000Bk39L') != null) ? TRUE : FALSE;
        
        title = 'Create Center';
        subtitle = 'Center';
                
        Counter__c roleInfo = roleManager.RoleType(UserInfo.getUserRoleId());
        
        isAdmin = (roleInfo.Type__c == 0) ? TRUE : FALSE;
            
        if(ID != null) {
            
            newEdit = FALSE;
        
            center = [SELECT Main_center__c, Name, CreatedDate, IsDeleted, 
                             Input_ID__c, Name__c, OwnerId, Type__c 
                        FROM Center__c
                       WHERE id = :Apexpages.currentPage().getParameters().get('id')
                         AND IsDeleted = false]; 
        
            mainSub = (center.Type__c == 'Main') ? 1 : 2;
                        
            title = 'Cetner Edit';
            subtitle = '(' + center.Name + ') ' + center.Name__c;
            
        }
    }
       
    public List<SelectOption> getItems() {
    
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('Main','Main Center')); 
        options.add(new SelectOption('Sub','Sub-center')); 
                
        return options; 
    }
        
}