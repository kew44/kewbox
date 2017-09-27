/*Page Description:
 *  Controller for VisualForce page DS_HEALTH
 * Last Updated on:
 *  7/24/2014
 * Update Purpose:
 *         fix redirect
 7/31/14-Link to DS_Background_Family_Info__c
 8/13/14-Link to DS_Background_Family_Info_B__c
 * Programmer:
 *  Kelsey
 */
public with sharing class DS_HEALTH_Controller {

  Utility ut = new Utility();

  public DS_Background_Family_Info_B__c obj { get; set; }        //HEALTH
 // public DS_HEALTH__c obj { get; set; }        //
  
  String cID;
  
  String summaryID;
  
  public String forceRedirect {get; set;} 

  Boolean edit = FALSE;

  public String subtitle {get; set;}
    
  public Client__c client { get; set; }

  public Client_Summary__c summaryInfo { get; set; }

  public String triggerValue {get; set;}
  public String skipTrigger {get; set;}

  public SkipLogic skip {get;set;}

  public String skipElementToJson { get; set; }


  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));


    public DS_HEALTH_Controller(ApexPages.StandardController controller) {
    
    cID = parameter.get('c');

    summaryID = parameter.get('summary');

    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    skip = new SkipLogic();
  
    skip.skipLibrary('BTRT', 'show', '1', new Map<String, String>{'BTRTOMED'=>'checkbox', 'BTRTINJ'=>'checkbox',
                                                                  'BTRTPL'  =>'checkbox', 'BTRTPD' =>'checkbox',
                                                                  'BTRTOTHR'=>'checkbox', 'BTRTUK' =>'checkbox'});

    skip.skipLibrary('BTRTOTHR', 'show', 'true', new Map<String, String>{'BTRTOTSP'=>'text'});

    skip.skipLibrary('BHSR', 'show', '1', new Map<String, String>{'BHSRHOS'=>'checkbox', 'BHSRED'=>'checkbox',
                                                                  'BHSRSUR'=>'checkbox', 'BHSRUC'=>'checkbox',
                                                                  'BHSROT' =>'checkbox', 'BHSRUK'=>'checkbox'});
   
    skip.skipLibrary('BDEVCON', 'show', '1', new Map<String, String>{'BDEVAUT' =>'checkbox', 'BDEVCP'=>'checkbox',
                                                                     'BDEVCF'  =>'checkbox', 'BDEVDS'=>'checkbox',
                                                                     'BDEVEP'  =>'checkbox', 'BDEVID'=>'checkbox',
                                                                     'BDEVMD'  =>'checkbox', 'BDEVSB'=>'checkbox',
                                                                     'BDEVOTHR'=>'checkbox', 'BDEVUK'=>'checkbox'});
  
    skip.skipLibrary('BDEVOTHR', 'show', 'true', new Map<String, String>{'BDEVOTSP'=>'text'});

    skip.skipLibrary('BDVTR', 'show', '1', new Map<String, String>{'BDVTROMD'=>'checkbox', 'BDVTRINJ'=>'checkbox',
                                                                   'BDVTRPL' =>'checkbox', 'BDVTRPD' =>'checkbox',
                                                                   'BDVTROTR'=>'checkbox', 'BDVTRUK' =>'checkbox'});
  
    skip.skipLibrary('BDVTROTR', 'show', 'true', new Map<String, String>{'BDVTROSP'=>'text'});
 
    skip.skipLibrary('BDVSR', 'show', '1', new Map<String, String>{'BDVSRHOS'=>'checkbox', 'BDVSRED'=>'checkbox',
                                                                   'BDVSRSUR'=>'checkbox', 'BDVSRUC'=>'checkbox',
                                                                   'BDVSROT' =>'checkbox', 'BDVSRUK'=>'checkbox'});


    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
   // Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

   // String getDEMOFields = ut.getFields('DS_HEALTH__c');
    String getDEMOFields = ut.getFields('DS_Background_Family_Info_B__c');
    
    //    List<DS_HEALTH__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //HEALTH
    List<DS_Background_Family_Info_B__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //HEALTH
                          //                   '  FROM DS_HEALTH__c ' +                                                    //HEALTH
                                             '  FROM DS_Background_Family_Info_B__c ' +                                  
                                                 ' WHERE Client__c = \''+ cID + '\'');
    
    
    if(record.size() == 0) { // New record
      
      //obj = new DS_HEALTH__c(client__c = cID);        //HEALTH
      obj = new DS_Background_Family_Info_B__c(client__c = cID, FORM__c = 'DS_HEALTH');        //HEALTH
      
      /*for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) 
          skip.skipAction.put(sKey, !skip.skipList.get(lKey).get(sKey).rendered);*/
      
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;

      obj.FORM__c = 'DS_HEALTH';

      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          //skip.runSkipLogic(lKey, String.valueOf(obj.get(lKey+'__c')), obj);
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
        }
        
    } 

    skipElementToJson = JSON.serialize(skip.skipList);

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