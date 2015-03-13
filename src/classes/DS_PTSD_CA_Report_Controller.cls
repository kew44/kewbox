/*Page Description:
 *  Controller Class for DS_PTSD_CA Reports
 * Last Updated on:
 *  7/17/2014
 11/6/14
 * Update Purpose: change PTSDATE to DOAPTSD
 *      
 * Programmer:KW
 *  
 */
public with sharing class DS_PTSD_CA_Report_Controller {

  Utility ut = new Utility();
  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

  public String cimi { get; set; }

  public SObject obj { get; set; }

  public String cID { get; set; }
    
  String summaryID;

  public String forceRedirect { get; set; } 
    
  Boolean edit = FALSE;

  public String subtitle { get; set; }

  public Client__c client { get; set; }

  public Client_Summary__c summaryInfo { get; set; }
  
  public String skipElementToJson { get; set; }

  public Map<String, String> bfVariableMap { get; set; }

  public String BorF { get; set; }
  
  public Boolean printReport { get; set; }
  
  public void init() {
      printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
  }
    
  public DS_PTSD_CA_Report_Controller(ApexPages.StandardController controller) {
  
    cimi = Apexpages.currentPage().getParameters().get('cimi');

    cID = parameter.get('c');

    summaryID = parameter.get('summary');
      
    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';
     
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];

    Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];

    BorF = (Integer.valueOf(summary.SECTION__c) > 0) ? 'F' : 'B';
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

    String getDEMOFields = ut.getFields('DS_PTSD_CA_'+BorF+'__c');

    obj = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  
                         '  FROM DS_PTSD_CA_'+BorF+'__c ' +
                         ' WHERE Client__c = \''+ cID + '\'' + 
                         '   AND SECTION__c = \'' + summary.SECTION__c + '\''); 

    List<String> bfVariable = 
      new List<String>{'PTSAPPCN','DOAPTSD', 'PTSOCN', 'PTSORN', 'PTSBRN', 
                       'PTSBMN',  'PTSCRN', 'PTSCMN', 'PTSDRN',  'PTSDMN',
                       'PTSERN',  'PTSEMN', 'PTSDURA',  'PTSDC',  'PTSFC', 
                       'PTSVDSN',
                       'PTSAB1', 'PTSAB2',  'PTSAB3',  'PTSAB4', 'PTSAB5',
                       'PTSAC1', 'PTSAC2', 
                       'PTSAD1', 'PTSAD2', 'PTSAD3', 'PTSAD4', 'PTSAD5', 
                       'PTSAD6', 'PTSAD7', 
                       'PTSAE1', 'PTSAE2', 'PTSAE3', 'PTSAE4', 'PTSAE5', 'PTSAE6',
                       'PTSFHC', 'PTSFSC', 'PTSFRC', 'PTSFPC',
                       'PTSVDA1', 'PTSVDA2'};
    
    bfVariableMap = new Map<String, String>();

    for(String var : bfVariable)
      bfVariableMap.put(var, BorF+var+'__c');

  }

  public String getClientInfo() {
    return ut.clientSection(cID, summaryID);
  }

  public PageReference cancel() {

    PageReference summaryPage = new PageReference('/apex/ClientSummary?id=' + cID);
    summaryPage.setRedirect(true);
    
    return summaryPage;

  }

  public PageReference save() {
        
    PageReference ptsdPage = new PageReference('/apex/DS_PTSD_CA?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
    ptsdPage.setRedirect(true);
    
    return ptsdPage;
      
  }

}