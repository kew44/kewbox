/*Page Description:
 *  Class to delete Center Information
 * Last Updated on:
 *  7/17/2014
 * Update Purpose:
 *      
 * Programmer:
 *  
 */
public with sharing class CenterDeletion {
    
    String ID = Apexpages.currentPage().getParameters().get('id');
    
    Center__c center {get;set;}
    
    public String subtitle {get; set;}
    
    private ApexPages.StandardController standardController;
    
    public Integer subcenter {get; set;}

    public Integer clinician {get; set;}
    
    public Integer total {get; set;}

    public CenterDeletion(ApexPages.StandardController controller) {
    
        total = 0;
    
        center = [
                    SELECT Name, 
                         CreatedDate, 
                         IsDeleted, 
                         Input_ID__c, 
                         Name__c, 
                         OwnerId, 
                         Type__c 
                    FROM Center__c
                   WHERE id = :Apexpages.currentPage().getParameters().get('id')
                                                                                ]; 
                   
        subtitle = '(' + 
                         center.Name 
                                     + ') ' + 
                                                center.Name__c; 
        

        if(!Test.isRunningTest()) {

            controller.addFields(new List<String> { 'Subcenters__r' }); 
            controller.addFields(new List<String> { 'Clinicians__r' });

        }
        
        subcenter = ((Center__c) controller.getRecord()).Subcenters__r.size(); 
        clinician = ((Center__c) controller.getRecord()).Clinicians__r.size(); 

        total = subcenter + clinician;
       
    
    }
    
    public PageReference checkDeletion() {
        
        if(total > 0) {  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info,'Your attempt to delete the center could not be completed because Sub-center(s) or Clinician(s) is currently assigned to this center. Please delete the following items first.'));
        }
        else { 
            delete center; 
            PageReference pageRef = new PageReference('/a00/o'); 
            return pageRef; 
        } 

        return null;
        
        
    }

}