/*Page Description:
 *  Controller for VisualForce page DS_DEMO
 *
 * Update History -----------------------
 *
 * Last Updated on: 7/29/2014
 * Update Purpose:
 *  Avoiding to use the query inside the loop in method traumaHistoryRowList()
 *  The totoal query number reduced from 51 -> 23 after modification.
 * Edited by: Danny
 *
 * Last Updated on: 7/29/2014
 * Update Purpose:
 *  Minor continuity edits  
 7/31/14 link to DS_Background_Family_Info__c   
 8/5/14 content edits, new ?'s, renumbering
 7/31/14 link to DS_Background_Family_Info_B__c
 1/20/14 filled out method add ''
 1/8/15-?/?/15 add skip logic/module q15,16,17
 * Edited By: Kelsey
 *
 */

public with sharing class DS_DEMO_Controller {

  Utility ut = new Utility();
  
  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

  public DS_Background_Family_Info_B__c obj { get; set; }

  String cID;
  
  String summaryID;
  
  public String forceRedirect {get; set;} 

  Boolean edit = FALSE;

  public String subtitle {get; set;}
    
  public Client__c client { get; set; }

  public Client_Summary__c summaryInfo { get; set; }

  public String triggerValue {get; set;}
  public String skipTrigger {get; set;}
  public Boolean noddAction {get; set;}

  public SkipLogic skip {get;set;}

  public String skipElementToJson { get; set; }
  
  public String noddModuleStatus {get; set;}
    
  public DS_DEMO_Controller(ApexPages.StandardController controller) {

    parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));
    
    cID = parameter.get('c');

    summaryID = parameter.get('summary');
    
    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    skip = new SkipLogic();
   
    //2
    skip.skipLibrary('CUREPI', 'show', '0', 
                     new Map<String, String>{'CUREPVS'=>'text'});
    //3
    skip.skipLibrary('BINFOTHR', 'show', 'true', 
                      new Map<String, String>{'BINFOSP'=>'text'}); 
    //4
    skip.skipLibrary('BGUARD', 'show', '98', 
                      new Map<String, String>{'BGUARDSP'=>'text'}); 
    skip.skipLibrary('BIDENT', 'show', '98', 
                      new Map<String, String>{'BIDENTSP'=>'text'}); 
    skip.skipLibrary('BORIENT', 'show', '98', 
                      new Map<String, String>{'BORIENTSP'=>'text'}); 
    //5
    skip.skipLibrary('BREFSRO', 'show', 'true', 
                      new Map<String, String>{'BREFSOSP'=>'text'}); 
                      
    //Demographic 1
    skip.skipLibrary('ETHNIC', 'show', '1', new Map<String, String>{'ETHNICHCA'=>'checkbox', 'ETHNICHC'=>'checkbox',
                                                                  'ETHNICHD'  =>'checkbox', 'ETHNICHM' =>'checkbox',
                                                                  'ETHNICHPR'=>'checkbox', 'ETHNICHSA' =>'checkbox',
                                                                  'ETHNICHO'=>'checkbox', 'ETHNICHU' =>'checkbox'});
                                                                  
    skip.skipLibrary('ETHNICHO', 'show', 'true', 
                      new Map<String, String>{'ETHNICHOSP'=>'text'}); 
                      
    //3
    skip.skipLibrary('BUSBORN', 'show', '0', 
                      new Map<String, String>{'CTYBORN'=>'text'}); 
    //4
    skip.skipLibrary('BPUSBORN', 'show', '0', 
                      new Map<String, String>{'BPUSBORNSP'=>'text'}); 
    //5
    skip.skipLibrary('BSIBLING', 'show', '1', 
                      new Map<String, String>{'BSIBNUM' =>'text', 
                                              'BSIBID'  =>'text'});
    skip.skipLibrary('BTREATO', 'show', 'true', 
                      new Map<String, String>{'BTREATOSP'=>'text'}); 
    //7
    skip.skipLibrary('BPROTHNW', 'show', 'true', 
                      new Map<String, String>{'BPROSPNW'=>'text'}); 
    //16.1
    skip.skipLibrary('BTRT', 'show', '1', 
                      new Map<String, String>{'BTRTOMED'=>'checkbox', 
                                              'BTRTINJ' =>'checkbox',
                                              'BTRTPL'  =>'checkbox', 
                                              'BTRTPD'  =>'checkbox',
                                              'BTRTOTHR'=>'checkbox', 
                                              'BTRTUK'  =>'checkbox'});
    //16.2 Other
    skip.skipLibrary('BTRTOTHR', 'show', 'true', 
                      new Map<String, String>{'BTRTOTSP'=>'text'});
    //17
    skip.skipLibrary('BHSR', 'show', '1', 
                      new Map<String, String>{'BHSRHOS'=>'checkbox', 
                                              'BHSRED' =>'checkbox',
                                              'BHSRSUR'=>'checkbox', 
                                              'BHSRUC' =>'checkbox',
                                              'BHSROT' =>'checkbox', 
                                              'BHSRUK' =>'checkbox'});
    //15
    skip.skipLibrary('BDEVCON', 'show', '1', 
                      new Map<String, String>{'BDEVAUT' =>'checkbox', 
                                              'BDEVCP'  =>'checkbox',
                                              'BDEVCF'  =>'checkbox', 
                                              'BDEVDS'  =>'checkbox',
                                              'BDEVEP'  =>'checkbox', 
                                              'BDEVID'  =>'checkbox',
                                              'BDEVMD'  =>'checkbox', 
                                              'BDEVSB'  =>'checkbox',
                                              'BDEVOTHR'=>'checkbox', 
                                              'BDEVUK'  =>'checkbox',
                                              'BDVTR' => 'radio'});
    //15 other
    skip.skipLibrary('BDEVOTHR', 'show', 'true', 
                      new Map<String, String>{'BDEVOTSP'=>'text'});
    //16
    skip.skipLibrary('BDVTR', 'show', '1', 
                      new Map<String, String>{'BDVTROMD'=>'checkbox', 
                                              'BDVTRINJ'=>'checkbox',
                                              'BDVTRPL' =>'checkbox', 
                                              'BDVTRPD' =>'checkbox',
                                              'BDVTROTR'=>'checkbox', 
                                              'BDVTRUK' =>'checkbox'});
    //16 other
    skip.skipLibrary('BDVTROTR', 'show', 'true', 
                      new Map<String, String>{'BDVTROSP'=>'text'});
    //17
    skip.skipLibrary('BDVSR', 'show', '1', 
                      new Map<String, String>{'BDVSRHOS'=>'checkbox', 
                                              'BDVSRED'=>'checkbox',
                                              'BDVSRSUR'=>'checkbox', 
                                              'BDVSRUC'=>'checkbox',
                                              'BDVSROT' =>'checkbox', 
                                              'BDVSRUK'=>'checkbox'});
                                                                       
    skip.skipLibrary('BDEVOTHR', 'show', 'true', 
                      new Map<String, String>{'BDEVOTSP'=>'text'}); 
    skip.skipLibrary('BRHCO', 'show', 'true', 
                      new Map<String, String>{'BRHCOSP'=>'text'}); 
    skip.skipLibrary('BPROTHNW', 'show', 'true', 
                      new Map<String, String>{'BPROSPNW'=>'text'}); 
   /* skip.skipLibrary('BDVTR', 'show', 'true', 
                      new Map<String, String>{'BDVTROMD'=>'checkbox', 
                                              'BDVTRINJ' =>'checkbox',
                                              'BDVTRPL' =>'checkbox',
                                              'BDVTRPD' =>'checkbox',
                                              'BDVTRODV' =>'checkbox',
                                              'BDVTRUK' =>'checkbox',
                                              'BDVTROTR' =>'checkbox'});*/
                      
                                                                   
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID]; 
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

    String getDEMOFields = ut.getFields('DS_Background_Family_Info_B__c');

    List<DS_Background_Family_Info_B__c> record = 
      Database.query('SELECT ' + getDEMOFields + ',' +
                             'Client__r.Name, Client__r.INIT__c' +  
                     '  FROM DS_Background_Family_Info_B__c ' +                          
                     ' WHERE Client__c = \''+ cID + '\'');
    
    if(record.size() == 0) { // New record

      obj = new DS_Background_Family_Info_B__c(client__c = cID, 
                                               FORM__c = 'DS_DEMO'
                                               );
      
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;
      
      obj.FORM__c = 'DS_DEMO';

      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
        }        
    } 

    noddModuleStatus = String.valueOf(obj.get('BDEVCON__c'));
    skipElementToJson = JSON.serialize(skip.skipList);

  }

  public String getClientInfo() { return ut.clientSection(cID,SummaryID);} 

  /*
   * q2. Previous visits to center for episodes of care
   * creates select list and saves result in a string
   */

  //create empty string
  String qtwo = ''; 

  //
  public PageReference test() {
    return null;
  }

  //create list of options for q2
  public List<SelectOption> getQ2Items() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    
    return options; 
        
  }

  //returns string set in q2
  public String getQtwo(){
    return qtwo;
  }

  //sets string q2
  public void setQtwo(String qtwo) {
    this.qtwo = qtwo;
  }


  public List<SelectOption> getQ4Items() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('1','Parent')); 
    options.add(new SelectOption('2','Other adult relative')); 
    options.add(new SelectOption('3','State'));
    options.add(new SelectOption('4','Emancipated minor (self)')); 
    options.add(new SelectOption('98','Other')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

  public List<SelectOption> getHispLatItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('1','Hispanic or Latino ')); 
    options.add(new SelectOption('2','Not Hispanic or Latino ')); 
    options.add(new SelectOption('96','Refused')); 
    options.add(new SelectOption('99','Unknown '));
    
    return options; 
        
  }

  public List<SelectOption> getQ14Items() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','Child has no current health problems or chronic conditions.')); 
    options.add(new SelectOption('1','Child has mild/treatable medical problems that require medical treatment. ')); 
    options.add(new SelectOption('2','Child has chronic illness that requires ongoing medical intervention. '));
    options.add(new SelectOption('3','Child has life threatening illness or medical condition that requires frequent hospitalization and medical intervention. '));
    options.add(new SelectOption('99','Unknown '));
    
    return options; 
        
  }
  
  public List<SelectOption> getNYUrItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
  //  options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

  public List<SelectOption> getNYUItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }
  
  public list<SelectOption> getMilSelfItems() {
  
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('96','Refused')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }
  
  public list<SelectOption> getMilFamItems() {
  
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes, only one person')); 
    options.add(new SelectOption('2','Yes, more than one person')); 
    options.add(new SelectOption('96','Refused')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }
      
  public list<SelectOption> getOverAllItems() {
  
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('1','Excellent')); 
    options.add(new SelectOption('2','Very Good')); 
    options.add(new SelectOption('3','Good')); 
    options.add(new SelectOption('4','Fair')); 
    options.add(new SelectOption('5','Poor')); 
    options.add(new SelectOption('96','Refused')); 
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
  
  
  public List<SelectOption> getGenIdenItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('1','Male'));
    options.add(new SelectOption('2','Female'));
    options.add(new SelectOption('3','Transmale (female to male)'));
    options.add(new SelectOption('4','Transfemale (male to female)'));
    options.add(new SelectOption('98','Other'));
    options.add(new SelectOption('96','Declined'));
    options.add(new SelectOption('99','Unknown'));
    
    return options; 
    
    }
    
    public List<SelectOption> getOrientItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('1','Heterosexual (that is straight) ')); 
    options.add(new SelectOption('2','Gay or Lesbian')); 
    options.add(new SelectOption('3','Bisexual')); 
    options.add(new SelectOption('98','Other'));
    options.add(new SelectOption('96','Declined'));
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