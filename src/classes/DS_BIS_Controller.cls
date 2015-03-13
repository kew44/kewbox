/*Page Description:
 *  Controller for VisualForce page DS_CLINEVAL
 * Last Updated on:
 *  7/24/2014
 * Update Purpose:
 *         fix redirect
 7/31/14-Link to DS_Functioning_Forms__c
 * Programmer:
 *  Kelsey
 */
public with sharing class DS_BIS_Controller {
    Utility ut = new Utility();
Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));
 //   public DS_BIS__c obj { get; set; }                                                        //BIS
    public DS_Functioning_Forms_B__c obj { get; set; }                                                        //BIS
    public Client_Summary__c Summary1{ get; set; }
  String cID;
  String summaryID;
  public String forceRedirect { get; set; } 
  Boolean edit = FALSE;
  public String subtitle {get; set;}
  public Client__c client { get; set; }
  public Client_Summary__c summaryInfo { get; set; }
  public String triggerValue {get; set;}
  public String skipTrigger {get; set;}
  public Boolean dateAction {get; set;}
//  public Boolean ynAction {get; set;}
  public SkipLogic skip {get;set;} 
  public String skipElementToJson { get; set; }
  public String dateModuleStatus{get;set;}//
  public String ynModuleStatus{get;set;}//
  public DS_BIS_Controller(ApexPages.StandardController controller) {
    cID = parameter.get('c');
    summaryID = parameter.get('summary');
    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';
    skip = new SkipLogic();
//   /*
    skip.skipLibrary('BCBISRECV', 'show', '1', 
      new Map<String,String>{'BCBISCREE'=>'checkbox', //if Q1 yes, show Q2 checkboxes
                             'BCBISASSM'=>'checkbox',
                             'BCBISCONS'=>'checkbox',
                             'BCBISMANA'=>'checkbox',
                             'BCBISCFTS'=>'checkbox',
                             'BCBISPFA' =>'checkbox',
                             'BCBISSPR' =>'checkbox',
                             'BCBISCRIM'=>'checkbox',
                             'BCBISRFSE'=>'checkbox',
                             'BCBISPSYE'=>'checkbox',
                             'BCBISSFTP'=>'checkbox',
                             'BCBISINDT'=>'checkbox',
                             'BCBISFAMT'=>'checkbox',
                             'BCBISGRPT'=>'checkbox',
                             'BCBISSUPG'=>'checkbox',
                             'BCBISOTHE'=>'checkbox',
                             ////Q3 date
                             'BCBISTCDT'=>'text',
                              ////Q4 radiobuttons   
                             'BCBISCOMP'=>'radio'});
                                                                // */
  //  skip.skipLibrary('BCBISCOMP','show', '', new Map<String,String>{'BCBISLFDT'=>'date','BCBISCODT'=>'date'  });
  //  skip.skipLibrary('BCBISCOMP','show', '0', new Map<String,String>{'BCBISLFDT'=>'date'});//if Q4 no, show date quit
//   skip.skipLibrary('BCBISCOMP','show', '1', new Map<String,String>{'BCBISCODT'=>'date'});//if Q4 yes, show date completed
    skip.skipLibrary('BCBISOTHE', 'show', 'true', new Map<String,String>{'BCBISOTHS'=>'text'});//Q2 other
   // skip.skipLibrary(('BCBISCOMP', 'show', '0', new Map<String,String>{'BCBISLFDT'=>'text'}) ('BCBISCOMP', 'show', '1', new Map<String,String>{'BCBISCODT'=>'date'}))
   // skip.skipLibrary('BCBISCOMP', 'show', '1', new Map<String,String>{'BCBISCODT'=>'date'}); 
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
    //Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    subtitle = '(' + client.Name + ') ' + client.INIT__c;
  //  String getDEMOFields = ut.getFields('DS_BIS__c');
    String getDEMOFields = ut.getFields('DS_Functioning_Forms_B__c');
//    List<DS_BIS__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //BIS
    List<DS_Functioning_Forms_B__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //BIS
                              //                 '  FROM DS_BIS__c' +                                                //BIS
                                               '  FROM DS_Functioning_Forms_B__c' +                                            
                                                 ' WHERE Client__c = \''+ cID + '\'');
    if(record.size() == 0) { // New record
   //   obj = new DS_BIS__c(CLIENT__c = cID);                            //BIS
      obj = new DS_Functioning_Forms_B__c(CLIENT__c = cID, FORM__c = 'DS_BIS');                            //
     // summary = new Client_Summary__c(FORM_ID__c=summaryID);//
    }
    else {   // Update record
      obj = record.get(0);
      edit = TRUE;

      obj.FORM__c = 'DS_BIS';
      
      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          //skip.runSkipLogic(lKey, String.valueOf(obj.get(lKey+'__c')), obj);
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
        }
    } 
    dateModuleStatus= String.valueOf(obj.get('BCBISCOMP__c'));
  //  ynModuleStatus= String.valueOf(obj.get('BCBISRECV__c'));
    skipElementToJson = JSON.serialize(skip.skipList);
  }
  public String getClientInfo() { return ut.clientSection(cID,SummaryID);} 
  public List<SelectOption> getYNIems() {
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    return options; 
  }
  public List<SelectOption> getYNCompletedIems() {
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('0','No, left treatment before completing ')); 
    options.add(new SelectOption('1','Yes, completed treatment ')); 
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