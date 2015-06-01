public with sharing class DS_BIS_F_Controller {
        Utility ut = new Utility();
Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));
   public DS_Functioning_Forms_F__c obj { get; set; }                                                        //BIS
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
  public SkipLogic skip {get;set;} 
  public String skipElementToJson { get; set; }
  public String dateModuleStatus{get;set;}//
  public String ynModuleStatus{get;set;}//

    public DS_BIS_F_Controller(ApexPages.StandardController controller) {

   cID = parameter.get('c');
    summaryID = parameter.get('summary');
    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';
    skip = new SkipLogic();
    
    skip.skipLibrary('FCBISRECV', 'show', '1', 
      new Map<String,String>{'FCBISCREE'=>'checkbox', //if Q1 yes, show Q2 checkboxes
                             'FCBISASSM'=>'checkbox',
                             'FCBISCONS'=>'checkbox',
                             'FCBISMANA'=>'checkbox',
                             'FCBISCFTS'=>'checkbox',
                             'FCBISPFA' =>'checkbox',
                             'FCBISSPR' =>'checkbox',
                             'FCBISCRIM'=>'checkbox',
                             'FCBISRFSE'=>'checkbox',
                             'FCBISPSYE'=>'checkbox',
                             'FCBISSFTP'=>'checkbox',
                             'FCBISINDT'=>'checkbox',
                             'FCBISFAMT'=>'checkbox',
                             'FCBISGRPT'=>'checkbox',
                             'FCBISSUPG'=>'checkbox',
                             'FCBISOTHE'=>'checkbox',
                             ////Q3 date
                             'FCBISTCDT'=>'text',
                              ////Q4 radiobuttons   
                             'FCBISCOMP'=>'radio'});
                             
     skip.skipLibrary('FCBISOTHE', 'show', 'true', new Map<String,String>{'FCBISOTHS'=>'text'});//Q2 other
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
     subtitle = '(' + client.Name + ') ' + client.INIT__c;
    String getDEMOFields = ut.getFields('DS_Functioning_Forms_F__c');
    List<DS_Functioning_Forms_F__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  
                                               '  FROM DS_Functioning_Forms_F__c' +                                            
                                                 ' WHERE Client__c = \''+ cID + '\'');
    if(record.size() == 0) { // New record
      obj = new DS_Functioning_Forms_F__c(CLIENT__c = cID, FORM__c = 'DS_BIS_F');  
    }
    else {   // Update record
      obj = record.get(0);
      edit = TRUE;

      obj.FORM__c = 'DS_BIS_F';
      
      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
        }
    } 
  //  dateModuleStatus= String.valueOf(obj.get('FCBISCOMP__c'));
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
  public PageReference cancel() {//section number?
    PageReference summaryPage = new PageReference('/apex/ClientSummary?s=1&id=' + cID);
    summaryPage.setRedirect(true);
    return summaryPage;
  }
  public PageReference save() {//section number?
    PageReference nextPage;
    try {
      if(edit == FALSE) insert obj;
      else update obj;
      nextPage = new PageReference(skip.formRedirct(cID, '1', forceRedirect));
      nextPage.setRedirect(true);
    }
    catch(DMLException e) { nextPage = null; }
    return nextPage;
  }

}