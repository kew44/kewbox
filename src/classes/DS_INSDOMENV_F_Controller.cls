public with sharing class DS_INSDOMENV_F_Controller {

    Utility ut = new Utility();

  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

    public DS_Background_Family_Info_F__c obj { get; set; }
  //  System.debug(obj);

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

  public DS_INSDOMENV_F_Controller (ApexPages.StandardController controller) {
    
    cID = parameter.get('c');

    summaryID = parameter.get('summary');
    
    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    skip = new SkipLogic();
    
    //show #1a question
    skip.skipLibrary('FCINANY', 'show', '1', new Map<String,String>{'FCINPUB'=>'checkbox', 'FCINPRIV'=>'checkbox'});  //displays checkboxes if child insured
   
    
    //show #1a public choices if public checked
    skip.skipLibrary('FCINPUB', 'show', 'true', new Map<String,String>{'FCINCHIP'=>'checkbox',//if public
                                                                       'FCINIH'=>'checkbox',
                                                                       'FCINMEDD'=>'checkbox',
                                                                       'FCINMEDR'=>'checkbox',
                                                                       'FCINMHC'=>'checkbox',
                                                                       'FCINOPUB'=>'checkbox',
                                                                          // 'FCINOPSP'=>'checkbox',//if other
                                                                       'FCINPBUK'=>'checkbox'  ////?                                                                      
                                                                       }); 
                                                                       
    
    //show #1a private choices if private checked
    skip.skipLibrary('FCINPRIV', 'show', 'true', new Map<String,String>{'FCINHMO'=>'checkbox',//if public
                                                                       'FCINPPO'=>'checkbox',
                                                                       'FCINFFS'=>'checkbox',
                                                                       'FCINOPRI'=>'checkbox',
                                                                         //  'FCINOPRS'=>'checkbox',//if other  
                                                                       'FCINPRUK'=>'checkbox'////?                                                                  
                                                                       }); 
    
    //show #2a question
    skip.skipLibrary('FPINANY', 'show', '1', new Map<String,String>{'FPINPUB'=>'checkbox', 'FPINPRIV'=>'checkbox'});  //displays checkboxes if parent insured
    
    //show #2a public choices if public checked
    skip.skipLibrary('FPINPUB', 'show', 'true', new Map<String,String>{'FPINCHIP'=>'checkbox',
                                                                       'FPINIH'=>'checkbox',
                                                                       'FPINMEDD'=>'checkbox',
                                                                       'FPINMEDR'=>'checkbox',
                                                                       'FPINMHC'=>'checkbox',
                                                                       'FPINOPUB'=>'checkbox'
                                                                        //   'FPINOPSP'=>'checkbox'                                                                    
                                                                      }); 
    //show #2a private choices if private checked
    skip.skipLibrary('FPINPRIV', 'show', 'true', new Map<String,String>{'FPINHMO'=>'checkbox',
                                                                          'FPINPPO'=>'checkbox',
                                                                          'FPINFFS'=>'checkbox',
                                                                          'FPINOPRI'=>'checkbox'
                                                                            //  'FPINOPRS'=>'checkbox'
                                                                        });
                                                                          
    
    //other, specify
    skip.skipLibrary('FCINOPUB','show','true', new Map<String, String>{'FCINOPSP'=>'text'});//#2, public
    skip.skipLibrary('FCINOPRI','show','true', new Map<String, String>{'FCINOPRS'=>'text'});//#2, private
    
    skip.skipLibrary('FPINOPUB','show','true', new Map<String, String>{'FPINOPSP'=>'text'});//#4, public
    skip.skipLibrary('FPINOPRI','show','true', new Map<String, String>{'FPINOPRS'=>'text'});//#4, private
        
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
  //  Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

  //  String getDEMOFields = ut.getFields('DS_INSDOMENV_F__c');
    String getDEMOFields = ut.getFields('DS_Background_Family_Info_F__c');

  //  List<DS_INSDOMENV_F__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  
    List<DS_Background_Family_Info_F__c> record = 
      Database.query('SELECT ' + getDEMOFields + ',' +
                             'Client__r.Name, Client__r.INIT__c' +  
                     '  FROM DS_Background_Family_Info_F__c ' +                          
                     ' WHERE Client__c = \''+ cID + '\'');

    if(record.size() == 0) { // New record
      
      obj = new DS_Background_Family_Info_F__c(CLIENT__c = cID, FORM__c = 'DS_INSDOMENV_F');
       
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;
      obj.FORM__c = 'DS_INSDOMENV_F';

      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
        }
    } 
//insureModuleStatus=String.valueOf(obj.get('FCINANY__c'));

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

    PageReference summaryPage = new PageReference('/apex/ClientSummary?s=1&id=' + cID);
    summaryPage.setRedirect(true);
    
    return summaryPage;

  }
  public PageReference save() {

    PageReference nextPage;
        
    try {
      if(edit == FALSE) insert obj;
      else update obj;
      nextPage = new PageReference(skip.formRedirct(cID, '1', forceRedirect));
      nextPage.setRedirect(true);
    }
    catch(DMLException e) { nextPage = null; }
    
    return nextPage;
          
  }

}