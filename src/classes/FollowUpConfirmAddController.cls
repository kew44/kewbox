public with sharing class FollowUpConfirmAddController {

  public ID clientID { get; set; }

  public String subtitle { get; set; }
  
  public String openSection { get; set; } 
  
  Utility ut = new Utility();

  public String urlClientID { get; set; }
  public Map<String, String> urlSummary { get; set;}
  
  public Client__c client { get; set; }
  public DS_DATA__c section { get; set; }//DS_DATA
    public FollowUpConfirmAddController(ApexPages.StandardController controller) {
    
    urlSummary = new Map<String, String>();

    clientID = Apexpages.currentPage().getParameters().get('id');

    openSection = Apexpages.currentPage().getParameters().get('s');

    String clientFields = ut.getFields('Client__c');

   /* client = Database.query('SELECT ' + clientFields +  
                            '  FROM Client__c ' +
                            ' WHERE id = \'' + clientID + '\'');

    urlClientID = ut.urlEncode('c='+client.id);
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;*/
    
    
   
    }


}