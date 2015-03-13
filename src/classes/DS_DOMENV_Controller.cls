/*Page Description:
 *  Controller for VisualForce page DS_DOMENV
 * Last Updated on:
 *  7/18/2014
 * Update Purpose:
 *  Link to the DS_BASELINE2__c object instead of DS_DOMENV__c as part of restructuring
 7/24/2014-fix redirect
 7/31/14-Link to DS_Background_Family_Info__c
 8/13/14-Link to DS_Background_Family_Info_B__c
 * Programmer:
 *  Kelsey
 */
public with sharing class DS_DOMENV_Controller {

  Utility ut = new Utility();
  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

  public DS_Background_Family_Info_B__c obj { get; set; }

  String cID { get; set; }
  
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

  public DS_DOMENV_Controller(ApexPages.StandardController controller) {

    parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

    cID = parameter.get('c');

    summaryID = parameter.get('summary');
    
    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    skip = new SkipLogic();
  
    skip.skipLibrary('BPRIMRES', 'show', '98', new Map<String, String>{'BPRIMRSP'=>'text'}); 
    skip.skipLibrary('BNOMHOUSE', 'show', '98', new Map<String, String>{'BNOMHOUSESP'=>'text'}); 
    skip.skipLibrary('BLOTHR', 'show', 'true', new Map<String, String>{'BLOTHRSP'=>'text'}); 
    skip.skipLibrary('BLANGHOM', 'show', '98', new Map<String, String>{'BLANGHMS'=>'text'}); 
    skip.skipLibrary('BINCOMNW', 'show', '98', new Map<String, String>{'BINCOMSP'=>'text'}); 
    

    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
//    Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

    String getDEMOFields = ut.getFields('DS_Background_Family_Info_B__c');

    List<DS_Background_Family_Info_B__c> record = 
      Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  
                     '  FROM DS_Background_Family_Info_B__c' +                              
                     ' WHERE Client__c = \''+ cID + '\'');

    if(record.size() == 0) { // New record
      obj = new DS_Background_Family_Info_B__c(CLIENT__c = cID, FORM__c = 'DS_DOMENV');      
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;

      obj.FORM__c = 'DS_DOMENV';

      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          //skip.runSkipLogic(lKey, String.valueOf(obj.get(lKey+'__c')), obj);
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
        }
        
    } 
    skipElementToJson = JSON.serialize(skip.skipList);
  }

  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}  
  
  
  public List<SelectOption> getPrimeRestIems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('1','Independent (alone or with peers)')); 
    options.add(new SelectOption('2','Home (with parent(s)) ')); 
    options.add(new SelectOption('3','With relatives or other family ')); 
    options.add(new SelectOption('4','Regular foster care ')); 
    options.add(new SelectOption('5','Treatment foster care')); 
    options.add(new SelectOption('6','Residential treatment center ')); 
    options.add(new SelectOption('7','Correctional facility')); 
    options.add(new SelectOption('8','Homeless')); 
    options.add(new SelectOption('9','Shelter'));
    options.add(new SelectOption('99','Unknown'));     
    options.add(new SelectOption('98','Other'));  
    
    return options; 
        
  }
  
  public List<SelectOption> getHowLongIems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','Less than 1 month '));
    options.add(new SelectOption('1','Entire Life '));
    options.add(new SelectOption('2','1-6 months'));
    options.add(new SelectOption('3','7-12 months'));
    options.add(new SelectOption('4','13-24 months'));
    options.add(new SelectOption('5','Greater than 24 months '));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

  public List<SelectOption> getOutPlaceIems() {
   
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','0'));
    options.add(new SelectOption('1','1'));
    options.add(new SelectOption('2','2'));
    options.add(new SelectOption('3','3'));
    options.add(new SelectOption('4','4'));
    options.add(new SelectOption('5','5'));
    options.add(new SelectOption('6','More than 5 placements'));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }
  
  public List<SelectOption> getLiveMostItems() {
   
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('1','Caregiver’s owned or rented house, apartment, trailer, or room '));
    options.add(new SelectOption('2','Independently owned or rented house, apartment, trailer, or room '));
    options.add(new SelectOption('3','Someone else’s house, apartment, trailer, or room '));
    options.add(new SelectOption('4','Homeless (shelter, street/outdoors, park) '));
    options.add(new SelectOption('5','Group home '));
    options.add(new SelectOption('6','Foster care (specialized therapeutic treatment) '));
    options.add(new SelectOption('7','Transitional living facility '));
    options.add(new SelectOption('8','Hospital (medical)'));
    options.add(new SelectOption('9','Hospital (psychiatric)'));
    options.add(new SelectOption('10','Detox/inpatient or residential substance abuse treatment facility '));
    options.add(new SelectOption('11','Correctional facility (juvenile detention center/jail/prison) '));
    options.add(new SelectOption('96','Refused'));
    options.add(new SelectOption('99','Unknown')); 
    options.add(new SelectOption('98','Other housing '));
    
    return options; 
        
  }
  
  public List<SelectOption> getCTYREFUSEItems(){
  
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('96','Refused'));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }  
  
  public List<SelectOption> getLangItems(){
  
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('1','English'));
    options.add(new SelectOption('2','Spanish'));
    options.add(new SelectOption('3','French'));
    options.add(new SelectOption('4','Mandarin'));
    options.add(new SelectOption('5','Cantonese'));
    options.add(new SelectOption('6','Navaho'));
    options.add(new SelectOption('7','Japanese'));
    options.add(new SelectOption('8','Korean'));
    options.add(new SelectOption('9','Russian'));
    options.add(new SelectOption('10','Arabic'));
    options.add(new SelectOption('11','Hebrew'));
    options.add(new SelectOption('99','Unknown')); 
    options.add(new SelectOption('98','Other'));
    
    return options; 
        
  }  
  
  public List<SelectOption> getIncomeItems(){
  
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('1','Less than $5,000 '));
    options.add(new SelectOption('2','$5,000 – $9,999 '));
    options.add(new SelectOption('3','$10,000 – $14,999 '));
    options.add(new SelectOption('4','$15,000 – $19,999 '));
    options.add(new SelectOption('5','$20,000 – $24,999 '));
    options.add(new SelectOption('6','$25,000 – $34,999 '));
    options.add(new SelectOption('7','$35,000 – $49,999 '));
    options.add(new SelectOption('8','$50,000 – $74,999 '));
    options.add(new SelectOption('9','$75,000 – $99,999 '));
    options.add(new SelectOption('10','$100,000 and over '));
    options.add(new SelectOption('99','Unknown')); 
    options.add(new SelectOption('98','Other'));
    
    return options; 
        
  }

  public List<SelectOption> getFamResItems() {
   
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','My family has financial resources necessary to meet our needs'));
    options.add(new SelectOption('1','My family has financial resources necessary to meet most of our needs; however, some limitations exist '));
    options.add(new SelectOption('2','My family has financial difficulties that limit our ability to meet significant family needs '));
    options.add(new SelectOption('3','My family has been experiencing financial hardship, poverty '));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

  public List<SelectOption> getCareGiveItems() {
   
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','Resilient, able to bounce back despite stress, no intervention needed'));
    options.add(new SelectOption('1','Average adaptive, could benefit from education or information on post-trauma adjustment '));
    options.add(new SelectOption('2','Risk of disturbance and intervention recommended '));
    options.add(new SelectOption('3','Disturbance and in need of intensive intervention'));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  } 
  
  public List<SelectOption> getGradeItems(){
  
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('0','Never attended'));
    options.add(new SelectOption('1','Preschool '));
    options.add(new SelectOption('2','Kindergarten '));
    options.add(new SelectOption('3','1st Grade '));
    options.add(new SelectOption('4','2nd Grade '));
    options.add(new SelectOption('5','3rd Grade '));
    options.add(new SelectOption('6','4th Grade '));
    options.add(new SelectOption('7','5th Grade '));
    options.add(new SelectOption('8','6th Grade '));
    options.add(new SelectOption('9','7th Grade '));
    options.add(new SelectOption('10','8th Grade '));
    options.add(new SelectOption('11','9th Grade '));
    options.add(new SelectOption('12','10th Grade '));
    options.add(new SelectOption('13','11th Grade '));
    options.add(new SelectOption('14','12th Grade '));
    options.add(new SelectOption('15','12th Grade/high school diploma/equivalent (GED)'));
    options.add(new SelectOption('16','Vocational/technical diploma '));
    options.add(new SelectOption('17','Some college or university'));
    options.add(new SelectOption('96','Refused'));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }
  
  public List<SelectOption> getAbsentItems(){
  
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('0','0 days '));
    options.add(new SelectOption('1','1 day '));
    options.add(new SelectOption('2','2 days '));
    options.add(new SelectOption('3','3 to 5 days '));
    options.add(new SelectOption('4','6 to 10 days '));
    options.add(new SelectOption('5','More than 10 days '));
    options.add(new SelectOption('96','Refused'));
    options.add(new SelectOption('99','Unknown')); 
    options.add(new SelectOption('97','Not applicable '));
    
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