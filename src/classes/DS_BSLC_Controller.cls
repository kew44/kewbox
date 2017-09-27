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
public with sharing class DS_BSLC_Controller {

  Utility ut = new Utility();
  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

//  public DS_BSLC__c obj { get; set; }//BSLC
  public DS_Functioning_Forms_B__c obj { get; set; }//BSLC

  String cID;
  
  String summaryID;
  
  public String forceRedirect {get; set;} 

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

    public DS_BSLC_Controller(ApexPages.StandardController controller) {
    
    cID = parameter.get('c');

    summaryID = parameter.get('summary');

    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    skip = new SkipLogic();
    
    skip.skipLibrary('BSLCTREATMENT', 'show', '1', new Map<String,String>{'BNCCTSBSLC'=>'text'});//Q1 yes
    
    skip.skipLibrary('BTXTYPE', 'show', '98', new Map<String,String>{'BTXTYPSP'=>'text'});//Q3 other
    
   // skip.skipLibrary('BTXCOMP', 'show', '1', new Map<String,String>{'BTXCPDT'=>'text'});//Q5 yes
    
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
  //  Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

//    String getDEMOFields = ut.getFields('DS_BSLC__c');
    String getDEMOFields = ut.getFields('DS_Functioning_Forms_B__c');
    
 //   List<DS_BSLC__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //BSLC
    List<DS_Functioning_Forms_B__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //BSLC
                         //                    '  FROM DS_BSLC__c ' +                                                        //BSLC
                                             '  FROM DS_Functioning_Forms_B__c ' +                                          
                                                 ' WHERE Client__c = \''+ cID + '\'');
    
    
    if(record.size() == 0) { // New record
      
  //    obj = new DS_BSLC__c(client__c = cID);                                                            //BSLC
      obj = new DS_Functioning_Forms_B__c(client__c = cID, FORM__c = 'DS_BSLC');                                                            //
   //   summary = new Client_Summary__c(FORM_ID__c=summaryID);//
      
      
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;

      obj.FORM__c = 'DS_BSLC';

      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          //skip.runSkipLogic(lKey, String.valueOf(obj.get(lKey+'__c')), obj);
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
        }
        
    } 
    dateModuleStatus= String.valueOf(obj.get('BTXCOMP__c'));
    skipElementToJson = JSON.serialize(skip.skipList);
    }
    
  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}  
   
  public List<SelectOption> getYNIems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes'));  
    
    return options; 
        
  }
  
  public List<SelectOption> getYNUIems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }
  
  public List<SelectOption> getTreatIems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('1','Trauma-Focused Cognitive Behavior Therapy (TF-CBT) ')); 
    options.add(new SelectOption('2','Life Skills/Life Stories ')); 
    options.add(new SelectOption('3','Structured Psychotherapy for Adolescents Responding to Chronic Stress (SPARCS)    ')); 
    options.add(new SelectOption('4','Trauma Adaptive Recovery Group Education and Therapy TARGET (TARGET)')); 
    options.add(new SelectOption('5','Trauma Systems Therapy (TST) ')); 
    options.add(new SelectOption('6','Child Parent Psychotherapy (CPP) ')); 
    options.add(new SelectOption('7','Cognitive-Behavioral Intervention for Trauma in Schools (CBITS) ')); 
    options.add(new SelectOption('8','Sexual Behavior Problems Therapy (SBP)')); 
    options.add(new SelectOption('9','Parent-Child Interaction Therapy (PCIT) ')); 
    options.add(new SelectOption('98','Other')); 
    
    return options; 
        
  }
  public List<SelectOption> getYNCompletedIems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','No, left treatment before completing ')); 
    options.add(new SelectOption('1','Yes, completed treatment ')); 
    return options; 
        
  }
  
  
  public  PageReference cancel() {

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