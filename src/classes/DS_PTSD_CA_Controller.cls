/*Page Description:
 *  Controller for VisualForce page DS_PTSD_CA
 * Last Updated on:
 *  7/17/2014
 8/8/2014
 * Update Purpose:
 Change DS_PTSD_FORM_INFO__c to DS_DATA__c
 * Change Question__c to <Content__c>>
 8/12/2014
 11/6/14- changed ('B'+) PTSDATE to DOAPTSD
 * Programmer:
 *  Kelsey
 */
public with sharing class DS_PTSD_CA_Controller {

  Utility ut = new Utility();

  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

  public List<Item> items {get;set;}
  
  public DS_PTSD_CA_B__c ptsdca { get; set; }

  public SObject obj {get; set;}
  
  String cID;

  public Client_Summary__c summary;
  
  String summaryID;
  
  public String forceRedirect { get; set; } 
  
  Boolean edit = FALSE;
  
  public String subtitle {get; set;}
  
  public Client__c client { get; set; }

  public Client_Summary__c summaryInfo { get; set; }

  public SkipLogic skip {get;set;}
  
  public String skipElementToJson { get; set; }

  public Map<String, String> bfVariableMap { get; set; }

  public class Item {
      
    public String num {get;set;}
    public String content {get;set;}
    public String field {get;set;}
    public String symptom {get;set;}
    public Boolean section { get;set; }
    
    public Item(String num, String symptom, String field, Boolean section, String content) {
      this.num = num;
      this.content = content;
      this.field = field;
      this.symptom = symptom;
      this.section = section;
    }
      
  }
  
  public DS_PTSD_CA_Controller(ApexPages.StandardController controller) {
      
    cID = parameter.get('c');

    summaryID = parameter.get('summary');
          
    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    skip = new SkipLogic();
    
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];

    summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];

    String BorF = (Integer.valueOf(summary.SECTION__c) > 0) ? 'F' : 'B';
            
    subtitle = '(' + client.Name + ') ' + client.INIT__c;
       
    String getPTSDFields = ut.getFields('DS_PTSD_CA_'+BorF+'__c');
    
    List<SObject> record = 
      Database.query('SELECT ' + getPTSDFields + ', ' +
                             ' Client__r.Name, Client__r.INIT__c' +  
                     '  FROM DS_PTSD_CA_'+BorF+'__c ' + 
                     ' WHERE Client__c = \''+ cID + '\'' +
                     '   AND SECTION__c = \'' + summary.SECTION__c + '\''); 
                                                                                        
    if(record.size() == 0) {
      Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_PTSD_CA_'+BorF+'__c');
      obj = objType.newSObject();

      obj.put('Client__c', cID);
      obj.put('Form__c', 'DS_PTSD_CA');
    }
    else { 
      obj = record.get(0);
      obj.put('Form__c', 'DS_PTSD_CA');
      edit = TRUE;
    }  

    List<DS_DATA__c> formInfo = 
      Database.query('SELECT ' + ut.getFields('DS_DATA__c') +   
                     '  FROM DS_DATA__c ' +
                     ' WHERE Data_Type__c = \'DS_PTSD_Form_Info\'' +
                  ' ORDER BY Number__c');
    
    items = new List<Item>();

    for(DS_DATA__c info : formInfo) {
      items.add(new Item(string.valueof(integer.valueof(info.Number__c)), info.Symptom__c, 'B'+info.Field__c+'__c', info.Section__c, info.Content__c));
    }
    
    skipElementToJson = JSON.serialize(skip.skipList);

    bfVariableMap = new Map<String, String>();

    List<String> bfVariable = 
      new List<String>{'DOAPTSD', 'PTSDURA', 'PTSD1',   'PTSFH1',
                       'PTSFH2',  'PTSFH3',  'PTSFHSP', 'PTSFS1', 
                       'PTSFS2',  'PTSFSSP', 'PTSFR1',  'PTSFRSP', 
                       'PTSFP1',  'PTSFP2',  'PTSFPSP', 'BPTSFR1',
                       'METPTSD'};
    
    for(String var : bfVariable)
      bfVariableMap.put(var, BorF+var+'__c');

    bfVariableMap.put('STATUS', 'STATUS_PTSD_CA__c');


  }

  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}  

  public List<SelectOption> getNYUItems() {
  
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

  public List<SelectOption> getBMETItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','Pen and paper only')); 
    options.add(new SelectOption('1','Electronic only')); 
    
    return options; 
        
  }
  
  public List<SelectOption> getRadioItems() {
  
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','None')); 
    options.add(new SelectOption('1','Little')); 
    options.add(new SelectOption('2','Some')); 
    options.add(new SelectOption('3','Much')); 
    options.add(new SelectOption('4','Most')); 
    
    return options; 
      
  }
  
  public List<SelectOption> getRadioYesNo() {
      
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('0','No')); 
    
    return options; 

  }

  public PageReference cancel() {

    PageReference summaryPage = new PageReference('/apex/ClientSummary?s='+summary.SECTION__c+'&id=' + cID);
    summaryPage.setRedirect(true);
    
    return summaryPage;

  }
  
  public PageReference save() {

   // String url;
    PageReference nextPage;
      
    try {
      if(edit == FALSE) insert obj;
      else update obj;

      String url = '/apex/ClientSummary?s='+summary.SECTION__c+'&id=' + cID;

      //System.debug(url);

      nextPage = new PageReference(url);
      nextPage.setRedirect(true);

    }
    catch(DMLException e) { nextPage = null; }

    return nextPage;
      
  }

  public PageReference saveViewReport() {

    PageReference nextPage;
    
    try {
      if(edit == FALSE) insert obj;
      else update obj;
    }
    catch(DMLException e) { nextPage = null; }

    nextPage = new PageReference('/apex/DS_PTSD_CA_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
    nextPage.setRedirect(true);
    
    return nextPage;        
      
  }

}