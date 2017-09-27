/*Page Description:
 *  Controller for VisualForce page DS_INSDOMENV
 * Last Updated on:
 *  7/18/2014
 * Update Purpose:
 *  Link to the DS_BASELINE2__c object instead of DS_INSDOMENV__c as part of restructuring
 7/24/2014-fix redirect
 7/31/14- Link to DS_Background_Family_Info__c
 8/13/14- Link to DS_Background_Family_Info_B__c
 * Programmer:
 *  Kelsey
 */
public with sharing class DS_INSDOMENV_Controller {

    Utility ut = new Utility();

  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

 //   public DS_INSDOMENV__c obj { get; set; }
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
  public Boolean insureAction {get; set;}

  public SkipLogic skip {get;set;}

  public String skipElementToJson { get; set; } 

  public String insureModuleStatus {get; set;}

  public DS_INSDOMENV_Controller (ApexPages.StandardController controller) {
    
    cID = parameter.get('c');

    summaryID = parameter.get('summary');
    
    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    skip = new SkipLogic();
    
    //show #1a question
    skip.skipLibrary('BCINANY', 'show', '1', new Map<String,String>{'BCINPUB'=>'checkbox', 'BCINPRIV'=>'checkbox'});  //displays checkboxes if child insured
   
    
    //show #1a public choices if public checked
    skip.skipLibrary('BCINPUB', 'show', 'true', new Map<String,String>{'BCINCHIP'=>'checkbox',//if public
                                                                       'BCINIH'=>'checkbox',
                                                                       'BCINMEDD'=>'checkbox',
                                                                       'BCINMEDR'=>'checkbox',
                                                                       'BCINMHC'=>'checkbox',
                                                                       'BCINOPUB'=>'checkbox',
                                                                          // 'BCINOPSP'=>'checkbox',//if other
                                                                       'BCINPBUK'=>'checkbox'  ////?                                                                      
                                                                       }); 
                                                                       
    
    //show #1a private choices if private checked
    skip.skipLibrary('BCINPRIV', 'show', 'true', new Map<String,String>{'BCINHMO'=>'checkbox',//if public
                                                                       'BCINPPO'=>'checkbox',
                                                                       'BCINFFS'=>'checkbox',
                                                                       'BCINOPRI'=>'checkbox',
                                                                         //  'BCINOPRS'=>'checkbox',//if other  
                                                                       'BCINPRUK'=>'checkbox'////?                                                                  
                                                                       }); 
    
    //show #2a question
    skip.skipLibrary('BPINANY', 'show', '1', new Map<String,String>{'BPINPUB'=>'checkbox', 'BPINPRIV'=>'checkbox'});  //displays checkboxes if parent insured
    
    //show #2a public choices if public checked
    skip.skipLibrary('BPINPUB', 'show', 'true', new Map<String,String>{'BPINCHIP'=>'checkbox',
                                                                       'BPINIH'=>'checkbox',
                                                                       'BPINMEDD'=>'checkbox',
                                                                       'BPINMEDR'=>'checkbox',
                                                                       'BPINMHC'=>'checkbox',
                                                                       'BPINOPUB'=>'checkbox'
                                                                        //   'BPINOPSP'=>'checkbox'                                                                    
                                                                      }); 
    //show #2a private choices if private checked
    skip.skipLibrary('BPINPRIV', 'show', 'true', new Map<String,String>{'BPINHMO'=>'checkbox',
                                                                          'BPINPPO'=>'checkbox',
                                                                          'BPINFFS'=>'checkbox',
                                                                          'BPINOPRI'=>'checkbox'
                                                                            //  'BPINOPRS'=>'checkbox'
                                                                        });
                                                                          
    
    //other, specify
    skip.skipLibrary('BCINOPUB','show','true', new Map<String, String>{'BCINOPSP'=>'text'});//#2, public
    skip.skipLibrary('BCINOPRI','show','true', new Map<String, String>{'BCINOPRS'=>'text'});//#2, private
    
    skip.skipLibrary('BPINOPUB','show','true', new Map<String, String>{'BPINOPSP'=>'text'});//#4, public
    skip.skipLibrary('BPINOPRI','show','true', new Map<String, String>{'BPINOPRS'=>'text'});//#4, private
        
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
  //  Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

  //  String getDEMOFields = ut.getFields('DS_INSDOMENV__c');
    String getDEMOFields = ut.getFields('DS_Background_Family_Info_B__c');

  //  List<DS_INSDOMENV__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  
    List<DS_Background_Family_Info_B__c> record = 
      Database.query('SELECT ' + getDEMOFields + ',' +
                             'Client__r.Name, Client__r.INIT__c' +  
                     '  FROM DS_Background_Family_Info_B__c ' +                          
                     ' WHERE Client__c = \''+ cID + '\'');

    if(record.size() == 0) { // New record
      
      obj = new DS_Background_Family_Info_B__c(CLIENT__c = cID, FORM__c = 'DS_INSDOMENV');
       
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;
      obj.FORM__c = 'DS_INSDOMENV';

      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
        }
    } 
//insureModuleStatus=String.valueOf(obj.get('BCINANY__c'));

skipElementToJson = JSON.serialize(skip.skipList); 
  }

  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}
  
  public List<SelectOption> getCTYNUNItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

  
  public List<SelectOption> getPrimeRestIems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('1','Independent (alone or with peers)')); 
    options.add(new SelectOption('2','Home (With parent(s)) ')); 
    options.add(new SelectOption('3','With relatives or other family ')); 
    options.add(new SelectOption('4','Regular foster care ')); 
    options.add(new SelectOption('5','Treatment foster care')); 
    options.add(new SelectOption('6','Residential treatment center ')); 
    options.add(new SelectOption('7','Correctional facility')); 
    options.add(new SelectOption('8','Homeless')); 
    options.add(new SelectOption('9','Shelter'));     
    options.add(new SelectOption('98','Other, please specify:')); 
    options.add(new SelectOption('99','Unknown')); 
    
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
    options.add(new SelectOption('98','Other housing, please specify: '));
    options.add(new SelectOption('96','Refused'));
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