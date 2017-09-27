/*Page Description:
 *  Controller for VisualForce page DS_SERVREC
 * Last Updated on:
 *  7/18/2014
 * Update Purpose:
 *  Link to the DS_BASELINE2__c object instead of DS_SERVREC__c as part of restructuring
 7/24/2014-fix redirect
 7/31/14- Link to DS_Functioning_Forms__c
 * Programmer:
 *  Kelsey
 */
public with sharing class DS_SERVREC_Controller {

  Utility ut = new Utility();
  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

//  public DS_SERVREC__c obj  { get; set; } 
  public DS_Functioning_Forms_B__c obj { get; set; }
  
  String cID;
  
  String summaryID;
  
  public String forceRedirect { get; set; } 

  Boolean edit = FALSE;
  
  public String subtitle {get; set;}
    
  public Client__c client { get; set; }

  public Client_Summary__c summaryInfo { get; set; }  
  
   public String triggerValue {get; set;}
  public String skipTrigger {get; set;}

  public SkipLogic skip {get;set;}

  public String skipElementToJson { get; set; }

  public DS_SERVREC_Controller(ApexPages.StandardController controller) {
    
    cID = parameter.get('c');

    summaryID = parameter.get('summary');

    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    skip = new SkipLogic();
    
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
 //   Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;
    
    // String getDEMOFields = ut.getFields('DS_SERVREC__c');
     String getDEMOFields = ut.getFields('DS_Functioning_Forms_B__c');
     
    //   List<DS_SERVREC__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  
       List<DS_Functioning_Forms_B__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  
      //                                         '  FROM DS_SERVREC__c' +
                                               '  FROM DS_Functioning_Forms_B__c' +                              
                                                 ' WHERE Client__c = \''+ cID + '\'');
                                               
     if(record.size() == 0) {
     // obj = new DS_SERVREC__c(CLIENT__c = cID); 
      obj = new DS_Functioning_Forms_B__c(CLIENT__c = cID, FORM__c = 'DS_SERVREC');     
   //   summary = new Client_Summary__c(FORM_ID__c=summaryID);//     
         }
     else {   // Update record
      obj = record.get(0);
      edit = TRUE;

      obj.FORM__c = 'DS_SERVREC';
        }
        }


  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}  

  public List<SelectOption> getInItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('99','Unknown'));
    
    return options; 
        
  }


  public PageReference cancel() {

    PageReference summaryPage = new PageReference('/apex/ClientSummary?s=0&id=' + cID);
    summaryPage.setRedirect(true);
    
    return summaryPage;

  }

  public PageReference save() {

    PageReference nextPage;
        
    try {
      if(edit == FALSE) insert obj;
      else update obj;
      nextPage = new PageReference(skip.formRedirct(cID, '0', forceRedirect));
      nextPage.setRedirect(true);
    }
    catch(DMLException e) { nextPage = null; }
    
    return nextPage;
          
  }




     
    }