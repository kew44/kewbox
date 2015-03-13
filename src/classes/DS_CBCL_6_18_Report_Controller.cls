/*Class Description:
 *
 * Updated on: 10/07/2014
 * Update Purpose: 
 *  Change the way to display the significance range. 
 * Edited by: Danny
 *
 * Updated on: 7/30/2014
 * Update Purpose: 
 *  1. Re-structuring changes.
 *  2. Combining CBCL old and young objects together. 
 *  3. Compitable for follow-ups. 
 * Edited by: Danny
 *  
 */
public with sharing class DS_CBCL_6_18_Report_Controller {

  Utility ut = new Utility();

  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));
  
  public String cimi { get; set; } 
    
  public SObject obj { get; set; }

  public Client__c client { get; set; }

  String summaryID;

  public String subtitle { get; set; }

  public String cID { get; set; }
  
  public Boolean printReport { get; set; }

  public class Analysis {

    public Date  DOACO   { get; set; }    // Date of administration
      
    public Integer CBAPPCN { get; set; } 

    public Double  CBIBTN  { get; set; } // Internalizing Problems Score
    public String  CBIBP   { get; set; } 
    public String  CBIBS   { get; set; } 

    public Double  CBADTN  { get; set; } // Anxious/Depressed
    public String  CBADP   { get; set; }
    public String  CBADS   { get; set; }

    public Double  CBWDTN  { get; set; } // Withdrawn/Depressed
    public String  CBWDP   { get; set; }
    public String  CBWDS   { get; set; }

    public Double  CBSCTN  { get; set; } // Somatic Complaints
    public String  CBSCP   { get; set; }
    public String  CBSCS   { get; set; }

    public Double  CBEBTN  { get; set; } // Externalizing Problems Score
    public String  CBEBP   { get; set; }
    public String  CBEBS   { get; set; }

    public Double  CBRBTN  { get; set; } // Rule Braking Behavior
    public String  CBRBP   { get; set; }
    public String  CBRBS   { get; set; } 

    public Double  CBABTN  { get; set; } // Aggressive Behavior
    public String  CBABP   { get; set; }
    public String  CBABS   { get; set; }

    public Double  CBSOTN  { get; set; } // Social Problems
    public String  CBSOP   { get; set; }
    public String  CBSOS   { get; set; }

    public Double  CBTPTN  { get; set; } // Thought Problems
    public String  CBTPP   { get; set; }
    public String  CBTPS   { get; set; }

    public Double  CBAPTN  { get; set; } // Attention Problems
    public String  CBAPP   { get; set; }
    public String  CBAPS   { get; set; }

    public Double  CBTSTN  { get; set; } // Total Problems Score
    public String  CBTSP   { get; set; }
    public String  CBTSS   { get; set; }
  
  }
  

  public Analysis analysis { get; set; }

  public String clinicalRange { get; set; }
  public String borderlineRange { get; set; }
  
  public void init() {
      
      printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
      
  }

  public DS_CBCL_6_18_Report_Controller(ApexPages.StandardController controller) {
  
    cimi = Apexpages.currentPage().getParameters().get('cimi');

    cID = parameter.get('c');

    summaryID = parameter.get('summary');

    analysis = new Analysis();

    Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];

    String BorF = (Integer.valueOf(summary.SECTION__c) > 0) ? 'F' : 'B';

    String getFields = ut.getFields('DS_CBCL_'+BorF+'__c');

    obj = Database.query('SELECT ' + getFields + ', Client__r.Name, Client__r.INIT__c' +  
                         '  FROM DS_CBCL_'+BorF+'__c ' +
                         ' WHERE Client__c = \''+ cID + '\'' +
                         '   AND SECTION__c = \''+ summary.SECTION__c +'\'');

    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

    analysis.DOACO   = Date.valueOf(obj.get(BorF+'DOACO__c'));

    analysis.CBAPPCN = Integer.valueOf(obj.get(BorF+'CBAPPCN__c'));

    analysis.CBIBTN  = Double.valueOf(obj.get(BorF+'CBIBTN__c'));
    analysis.CBIBP   = String.valueOf(obj.get(BorF+'CBIBP__c'));
    analysis.CBIBS   = String.valueOf(obj.get(BorF+'CBIBS__c'));
    
    analysis.CBADTN  = Double.valueOf(obj.get(BorF+'CBADTN__c'));
    analysis.CBADP   = String.valueOf(obj.get(BorF+'CBADP__c'));
    analysis.CBADS   = String.valueOf(obj.get(BorF+'CBADS__c'));
    
    analysis.CBWDTN  = Double.valueOf(obj.get(BorF+'CBWDTN__c'));
    analysis.CBWDP   = String.valueOf(obj.get(BorF+'CBWDP__c'));
    analysis.CBWDS   = String.valueOf(obj.get(BorF+'CBWDS__c'));
    
    analysis.CBSCTN  = Double.valueOf(obj.get(BorF+'CBSCTN__c'));
    analysis.CBSCP   = String.valueOf(obj.get(BorF+'CBSCP__c'));
    analysis.CBSCS   = String.valueOf(obj.get(BorF+'CBSCS__c'));
    
    analysis.CBEBTN  = Double.valueOf(obj.get(BorF+'CBEBTN__c'));
    analysis.CBEBP   = String.valueOf(obj.get(BorF+'CBEBP__c'));
    analysis.CBEBS   = String.valueOf(obj.get(BorF+'CBEBS__c'));

    analysis.CBRBTN  = Double.valueOf(obj.get(BorF+'CBRBTN__c'));
    analysis.CBRBP   = String.valueOf(obj.get(BorF+'CBRBP__c'));
    analysis.CBRBS   = String.valueOf(obj.get(BorF+'CBRBS__c'));
    
    analysis.CBABTN  = Double.valueOf(obj.get(BorF+'CBABTN__c'));
    analysis.CBABP   = String.valueOf(obj.get(BorF+'CBABP__c'));
    analysis.CBABS   = String.valueOf(obj.get(BorF+'CBABS__c'));
    
    analysis.CBSOTN  = Double.valueOf(obj.get(BorF+'CBSOTN__c'));
    analysis.CBSOP   = String.valueOf(obj.get(BorF+'CBSOP__c'));
    analysis.CBSOS   = String.valueOf(obj.get(BorF+'CBSOS__c'));
    
    analysis.CBTPTN  = Double.valueOf(obj.get(BorF+'CBTPTN__c'));
    analysis.CBTPP   = String.valueOf(obj.get(BorF+'CBTPP__c'));
    analysis.CBTPS   = String.valueOf(obj.get(BorF+'CBTPS__c'));
    
    analysis.CBAPTN  = Double.valueOf(obj.get(BorF+'CBAPTN__c'));
    analysis.CBAPP   = String.valueOf(obj.get(BorF+'CBAPP__c'));
    analysis.CBAPS   = String.valueOf(obj.get(BorF+'CBAPS__c'));
    
    analysis.CBTSTN  = Double.valueOf(obj.get(BorF+'CBTSTN__c'));
    analysis.CBTSP   = String.valueOf(obj.get(BorF+'CBTSP__c'));
    analysis.CBTSS   = String.valueOf(obj.get(BorF+'CBTSS__c'));

    List<String> clinicalRangeList = new List<String>();
    List<String> borderlineRangeList = new List<String>();

    Map<String, String> category = new Map<String, String>();

    category.put('CBIBS', 'Internalizing Problems');
    category.put('CBADS', 'Anxious/Depressed');
    category.put('CBWDS', 'Withdrawn/Depressed');
    category.put('CBSCS', 'Somatic Complaints');
    category.put('CBEBS', 'Externalizing Problems');
    category.put('CBRBS', 'Rule Breaking Behavior');
    category.put('CBABS', 'Aggressive Behavior');
    category.put('CBSOS', 'Social Problems');
    category.put('CBTPS', 'Thought Problems');
    category.put('CBAPS', 'Attention Problems');
    category.put('CBTSS', 'Total Problems');

    for(String ca : category.keySet()) {
      String range = String.valueOf(obj.get(BorF+ca+'__c'));
      if(range == 'Clinical')
        clinicalRangeList.add(category.get(ca));
      else if(range == 'Borderline') 
        borderlineRangeList.add(category.get(ca));  
    }

    clinicalRange = String.join(clinicalRangeList, ', ');
    borderlineRange = String.join(borderlineRangeList, ', ');
    

  }
  

  public String getClientInfo() { return ut.clientSection(cID,SummaryID); }

  public PageReference cancel() {

    PageReference summaryPage = new PageReference('/apex/ClientSummary?id=' + cID);
    summaryPage.setRedirect(true);
    
    return summaryPage;

  }

  public PageReference save() {
        
    PageReference nextPage = new PageReference('/apex/DS_CBCL_6_18?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
    nextPage.setRedirect(true);
    
    return nextPage;
      
  }

}