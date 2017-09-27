/*
Updated 11/20/14
Print button functionality
KW
*/
public with sharing class DS_SDQ_S_B_Report_Controller {
      
  public String cimi { get; set; }
  
 Utility ut = new Utility();
 
  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

  public DS_SDQ_PSI_CDI_B__c obj { get; set; } 
  
  public String cID { get; set; }
  
  String summaryID;
  
  public String forceRedirect { get; set; }  
  
  Boolean edit = FALSE;
  
  public String subtitle { get; set; }
  
  public Client__c client { get; set; }
  
  public Client_Summary__c summaryInfo { get; set; }
  
  public Boolean printReport { get; set; }

  public Map<String, String> bfVariableMap { get; set; }

  public String BorF { get; set; }
  
  public SkipLogic skip {get;set;}      
  
  public String clinicalRange{get; set; }
  public String borderlineRange{get; set; }
  public String missingRange{get; set; }  
  
  public void init() {
      
      printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
      
  }

    public DS_SDQ_S_B_Report_Controller(ApexPages.StandardController controller) {
      
    parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));
    
    cimi = Apexpages.currentPage().getParameters().get('cimi');
    
    cID = parameter.get('c');
    
    summaryID = parameter.get('summary');
    
    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';  
    
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
    
    Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
  //  String BorF = 'B';
    String BorF = (Integer.valueOf(summary.SECTION__c) > 0) ? 'F' : 'B';
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

    String getFields = ut.getFields('DS_SDQ_PSI_CDI_'+BorF+'__c'); 
    
    skip = new SkipLogic();      
   // List<DS_SDQ_PSI_CDI_B__c> record
     obj= Database.query('SELECT ' + getFields + ', Client__r.Name, Client__r.INIT__c' +  
                                               '  FROM DS_SDQ_PSI_CDI_'+BorF+'__c' +                              
                                                ' WHERE Client__c = \''+ cID + '\''
                                                );                                           
                                               
List<String> clinicalRangeList = new List<String>();
List<String> borderlineList = new List<String>();
List<String> missingList = new List<String>();

String OverAll = String.valueOf(obj.BSDSTYP__c);
String EmoSym = String.valueOf(obj.BSDSETYP__c);
String BehDif = String.valueOf(obj.BSDSBTYP__c);
String Adhd = String.valueOf(obj.BSDSHTYP__c);
String DiffChld = String.valueOf(obj.BSDSOTYP__c);
String KindBeh = String.valueOf(obj.BSDSKTYP__c);
String ImpLife = String.valueOf(obj.BSDSITYP__c);

if (OverAll  == 'Clinical')
clinicalRangeList.add('Total Difficulties');
else if (OverAll  == 'Borderline')
borderlineList.add('Total Difficulties'); 
else if (OverAll  == 'Missing/Incomplete')
missingList.add('Total Difficulties'); 

if (EmoSym == 'Clinical')
clinicalRangeList.add('Emotional Symptoms');
else if (EmoSym == 'Borderline')
borderlineList.add('Emotional Symptoms'); 
else if (EmoSym == 'Missing/Incomplete')
missingList.add('Emotional Symptoms'); 

if (BehDif == 'Clinical')
clinicalRangeList.add('Behavioral Difficulties');
else if (BehDif == 'Borderline')
borderlineList.add('Behavioral Difficulties'); 
else if (BehDif == 'Missing/Incomplete')
missingList.add('Behavioral Difficulties'); 

if (Adhd == 'Clinical')
clinicalRangeList.add('Hyperactivity-Inattention');
else if (Adhd == 'Borderline')
borderlineList.add('Hyperactivity-Inattention'); 
else if (Adhd == 'Missing/Incomplete')
missingList.add('Hyperactivity-Inattention'); 

if (DiffChld == 'Clinical')
clinicalRangeList.add('Peer Problems');
else if (DiffChld == 'Borderline')
borderlineList.add('Peer Problems'); 
else if (DiffChld == 'Missing/Incomplete')
missingList.add('Peer Problems'); 

if (KindBeh == 'Clinical')
clinicalRangeList.add('Prosocial Behavior');
else if (KindBeh == 'Borderline')
borderlineList.add('Prosocial Behavior'); 
/*else if (KindBeh == 'Missing/Incomplete')
missingList.add('Prosocial Behavior'); */

if (ImpLife == 'Clinical')
clinicalRangeList.add('Impact of Difficulties');
else if (ImpLife == 'Borderline')
borderlineList.add('Impact of Difficulties'); 
else if (ImpLife == 'Missing/Incomplete')
missingList.add('Impact of Difficulties'); 

    clinicalRange = String.join(clinicalRangeList, ', ');
    borderlineRange= String.join(borderlineList, ', ');
    missingRange= String.join(missingList, ', ');
            }
            
  public String getClientInfo() { return ut.clientSection(cID,SummaryID); }
  
  public PageReference cancel() {
  
    PageReference summaryPage = new PageReference('/apex/ClientSummary?id=' + cID);
    summaryPage.setRedirect(true);
    
    return summaryPage;
    
    }
    
  public PageReference save() {
    PageReference nextPage = new PageReference('/apex/DS_SDQ_S_11_17?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
    nextPage.setRedirect(true);
    return nextPage;
    
  }
}