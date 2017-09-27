/*Page Description:
 *  Controller for VisualForce page DS_INDSEV
 * Last Updated on:
 *  7/18/2014
 * Update Purpose:
 *      fix redirect
 7/31/14- Link to DS_Functioning_Forms__c
 8/6/2014-Criminal Module KW
 * Programmer:
 *   Kelsey
 */
public with sharing class DS_INDSEV_Controller {

  Utility ut = new Utility();

  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

  public DS_Functioning_Forms_B__c obj { get; set; }                //INDSEV

  String cID;
  
  String summaryID;
  
  public String forceRedirect { get; set; } 

  Boolean edit = FALSE;

  public String subtitle {get; set;}
    
  public Client__c client { get; set; }

  public Client_Summary__c summaryInfo { get; set; }

  public String triggerValue {get; set;}
  public String skipTrigger {get; set;}
  public Boolean suicideAction {get; set;}

  public SkipLogic skip {get;set;}

  public String skipElementToJson { get; set; }

  public String suicideModuleStatus { get; set; }

  public String criminalModuleStatus { get; set; }

  public DS_INDSEV_Controller(ApexPages.StandardController controller) {

    cID = parameter.get('c');

    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    //forceRedirect = Apexpages.currentPage().getParameters().get('f');

    skip = new SkipLogic();

    summaryID = parameter.get('summary');

    //16
    skip.skipLibrary('BSUITALK', 'show', '1', new Map<String, String>{'BSUTAMO'=>'text'}); 
    //17
    skip.skipLibrary('BSUIATT', 'show', '1', new Map<String, String>{'BSUATMO'=>'text'});
    //18
    skip.skipLibrary('BISPCRRU', 'show', '', new Map<String, String>{'BISPCRSP'=>'text'}); 
    
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
  //  Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;


   // String getDEMOFields = ut.getFields('DS_INDSEV__c');
    String getDEMOFields = ut.getFields('DS_Functioning_Forms_B__c');

   // List<DS_INDSEV__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //INDSEV
    List<DS_Functioning_Forms_B__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //INDSEV
                          //                     '  FROM DS_INDSEV__c' +                                            //INDSEV
                                               '  FROM DS_Functioning_Forms_B__c' +                                               
                                                 ' WHERE Client__c = \''+ cID + '\'');

    if(record.size() == 0) { // New record
      
     // obj = new DS_INDSEV__c(CLIENT__c = cID);                                //INDSEV
      obj = new DS_Functioning_Forms_B__c(CLIENT__c = cID, FORM__c = 'DS_INDSEV');                                //INDSEV
//      summary = new Client_Summary__c(FORM_ID__c=summaryID);//
      
      /*for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) 
          skip.skipAction.put(sKey, !skip.skipList.get(lKey).get(sKey).rendered);*/
      
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;

      obj.FORM__c = 'DS_INDSEV';

      //suicideModule();

      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          //skip.runSkipLogic(lKey, String.valueOf(obj.get(lKey+'__c')), obj);
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
        }
        
    } 

    suicideModuleStatus = String.valueOf(obj.get('BISPSUIC__c'));
    
    criminalModuleStatus = String.valueOf(obj.get('BISPCRIM__c'));

    skipElementToJson = JSON.serialize(skip.skipList);

  }

  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}  

  public List<SelectOption> getNSVUItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','Not a problem')); 
    options.add(new SelectOption('1','Somewhat/sometimes a problem')); 
    options.add(new SelectOption('2','Very much/often a problem')); 
    options.add(new SelectOption('99','Unknown'));
    
    return options; 
        
  }
  
  public List<SelectOption> getRefUnkItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 

    options.add(new SelectOption('96','Refused    '));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

  public List<SelectOption> getNYUItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

  public List<SelectOption> getBNYUItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('',''));
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