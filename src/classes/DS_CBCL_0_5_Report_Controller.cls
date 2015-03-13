/* Class Description:
 *  Display the CBCL young 1.5-5 analyst report.
 *
 * Updated on: 10/07/2014
 * Update Purpose: 
 *  Change the way to display the significance range. 
 * Edited by: Danny Fu
 *
 * Updated on: 7/30/2014
 * Update Purpose: 
 *  1. Re-structuring changes.
 *  2. Combining CBCL old and young objects together. 
 *  3. Compitable for follow-ups. 
 * Edited by: Danny Fu
 *  
 */

public with sharing class DS_CBCL_0_5_Report_Controller {

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
  
  public Boolean printReport { get; set; }
  
  public String skipElementToJson { get; set; }

  public Map<String, String> bfVariableMap { get; set; }

  public String BorF { get; set; }
    
  public class Analysis {

    public Date  DOACY    { get; set; }    // Date of administration
      
    public Integer CBAPPCNY { get; set; } 

    public Double  CBIBTNY  { get; set; } // Internalizing Problems Score
    public String  CBIBPY   { get; set; } 
    public String  CBIBSY   { get; set; } 

    public Double  CBERTNY  { get; set; } // Emotionally Reactive
    public String  CBERPY   { get; set; }
    public String  CBERSY   { get; set; }

    public Double  CBADTNY  { get; set; } // Anxious/Depressed
    public String  CBADPY   { get; set; }
    public String  CBADSY   { get; set; }

    public Double  CBSCTNY  { get; set; } // Somatic Complaints
    public String  CBSCPY   { get; set; }
    public String  CBSCSY   { get; set; }

    public Double  CBWTNY   { get; set; } // Withdrawn
    public String  CBWPY    { get; set; } 
    public String  CBWSY    { get; set; } 

    public Double  CBEBTNY  { get; set; } // Externalizing Problems Score
    public String  CBEBPY   { get; set; }
    public String  CBEBSY   { get; set; }

    public Double  CBSPTNY  { get; set; } // Sleep Problems
    public String  CBSPPY   { get; set; }
    public String  CBSPSY   { get; set; }

    public Double  CBAPTNY  { get; set; } // Attention Problems
    public String  CBAPPY   { get; set; }
    public String  CBAPSY   { get; set; }

    public Double  CBABTNY  { get; set; } // Aggressive Behavior
    public String  CBABPY   { get; set; }
    public String  CBABSY   { get; set; }

    public Double  CBTSTNY  { get; set; } // Total Problems Score
    public String  CBTSPY   { get; set; }
    public String  CBTSSY   { get; set; }
  
  }

  public Analysis analysis { get; set; }

  public String clinicalRange { get; set; }
  public String borderlineRange { get; set; }
  
  public void init() {
      
      printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
      
  }


  public DS_CBCL_0_5_Report_Controller(ApexPages.StandardController controller) {

    cimi = Apexpages.currentPage().getParameters().get('cimi');
    
    cID = parameter.get('c');

    summaryID = parameter.get('summary');
      
    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';
     
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];

    Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];

    BorF = (Integer.valueOf(summary.SECTION__c) > 0) ? 'F' : 'B';
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

    analysis = new Analysis();

    String getFields = ut.getFields('DS_CBCL_'+BorF+'__c');

    obj = Database.query('SELECT ' + getFields + ', Client__r.Name, Client__r.INIT__c' +  
                         '  FROM DS_CBCL_'+BorF+'__c ' +
                         ' WHERE Client__c = \''+ cID + '\'' +
                         '   AND SECTION__c = \''+ summary.SECTION__c +'\'');

    analysis.DOACY   = Date.valueOf(obj.get(BorF+'DOACY__c'));   

    analysis.CBAPPCNY = Integer.valueOf(obj.get(BorF+'CBAPPCNY__c'));

    analysis.CBIBTNY  = Double.valueOf(obj.get(BorF+'CBIBTNY__c'));
    analysis.CBIBPY   = String.valueOf(obj.get(BorF+'CBIBPY__c'));
    analysis.CBIBSY   = String.valueOf(obj.get(BorF+'CBIBSY__c'));
    
    analysis.CBERTNY  = Double.valueOf(obj.get(BorF+'CBERTNY__c'));
    analysis.CBERPY   = String.valueOf(obj.get(BorF+'CBERPY__c'));
    analysis.CBERSY   = String.valueOf(obj.get(BorF+'CBERSY__c'));
    
    analysis.CBADTNY  = Double.valueOf(obj.get(BorF+'CBADTNY__c'));
    analysis.CBADPY   = String.valueOf(obj.get(BorF+'CBADPY__c'));
    analysis.CBADSY   = String.valueOf(obj.get(BorF+'CBADSY__c'));
    
    analysis.CBSCTNY  = Double.valueOf(obj.get(BorF+'CBSCTNY__c'));
    analysis.CBSCPY   = String.valueOf(obj.get(BorF+'CBSCPY__c'));
    analysis.CBSCSY   = String.valueOf(obj.get(BorF+'CBSCSY__c'));
    
    analysis.CBEBTNY  = Double.valueOf(obj.get(BorF+'CBEBTNY__c'));
    analysis.CBEBPY   = String.valueOf(obj.get(BorF+'CBEBPY__c'));
    analysis.CBEBSY   = String.valueOf(obj.get(BorF+'CBEBSY__c'));
    
    analysis.CBWTNY   = Double.valueOf(obj.get(BorF+'CBWTNY__c'));
    analysis.CBWPY    = String.valueOf(obj.get(BorF+'CBWPY__c'));
    analysis.CBWSY    = String.valueOf(obj.get(BorF+'CBWSY__c'));
    
    analysis.CBSPTNY  = Double.valueOf(obj.get(BorF+'CBSPTNY__c'));
    analysis.CBSPPY   = String.valueOf(obj.get(BorF+'CBSPPY__c'));
    analysis.CBSPSY   = String.valueOf(obj.get(BorF+'CBSPSY__c'));
    
    analysis.CBAPTNY  = Double.valueOf(obj.get(BorF+'CBAPTNY__c'));
    analysis.CBAPPY   = String.valueOf(obj.get(BorF+'CBAPPY__c'));
    analysis.CBAPSY   = String.valueOf(obj.get(BorF+'CBAPSY__c'));
    
    analysis.CBABTNY  = Double.valueOf(obj.get(BorF+'CBABTNY__c'));
    analysis.CBABPY   = String.valueOf(obj.get(BorF+'CBABPY__c'));
    analysis.CBABSY   = String.valueOf(obj.get(BorF+'CBABSY__c'));

    analysis.CBTSTNY  = Double.valueOf(obj.get(BorF+'CBTSTNY__c'));
    analysis.CBTSPY   = String.valueOf(obj.get(BorF+'CBTSPY__c'));
    analysis.CBTSSY   = String.valueOf(obj.get(BorF+'CBTSSY__c'));

    List<String> clinicalRangeList = new List<String>();
    List<String> borderlineRangeList = new List<String>();

    Map<String, String> category = new Map<String, String>();

    category.put('CBIBSY', 'Internalizing Problems');
    category.put('CBERSY', 'Emotionally Reactive');
    category.put('CBADSY', 'Anxious/Depressed');
    category.put('CBSCSY', 'Somatic Complaints');
    category.put('CBWSY',  'Withdrawn');
    category.put('CBEBSY', 'Externalizing Problems');
    category.put('CBSPSY', 'Sleep Problems');
    category.put('CBAPSY', 'Attention Problems');
    category.put('CBABSY', 'Aggressive Behavior');
    category.put('CBTSSY', 'Total Problems');

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
        
    PageReference nextPage = new PageReference('/apex/DS_CBCL_0_5?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
    nextPage.setRedirect(true);
    
    return nextPage;
      
  }

}