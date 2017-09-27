public with sharing class DS_SDQ_P_Y_B_Controller {

        Utility ut = new Utility();
        
Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));        
     

   
        public DS_SDQ_PSI_CDI_B__c SDQobj { get; set; }//
         
         public SObject obj {get; set;}
         
   String cID;// { get; set; }
   
   public Client_Summary__c summary;///////
  
  String summaryID;
  
  public String forceRedirect { get; set; } 

  Boolean edit = FALSE;
  
  public String subtitle {get; set;} 
    
  public Client__c client { get; set; }

 public Client_Summary__c summaryInfo { get; set; }
  
  public SkipLogic skip {get;set;}
  
  public String skipElementToJson { get; set; }
  
  public Map<String, String> bfVariableMap { get; set; }
  
  public String triggerValue {get; set;}
  public String skipTrigger {get; set;}
  public Boolean difficultAction {get; set;}
  
  public String difficultModuleStatus { get; set; }

  //public String BorF { get; set; }
  










  public DS_SDQ_P_Y_B_Controller(ApexPages.StandardController controller) {
  
    parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

        cID = parameter.get('c');

    summaryID = parameter.get('summary');
          
        forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

        skip = new SkipLogic();  
   
   client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];  

   summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
//System.debug('>>>>>>>> the value of summary is ' + summary);
    String BorF = (Integer.valueOf(summary.SECTION__c) > 0) ? 'F' : 'B';
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;
    
    String getDEMOFields = ut.getFields('DS_SDQ_PSI_CDI_'+BorF+'__c');         
        skip.skipLibrary('SDPINFOR', 'show', '2', new Map<String, String>{'SDPINFSP'=>'text'});           
    List<SObject> youngRec = 
    Database.query('SELECT ' + getDEMOFields +  ', ' +
                             ' Client__r.Name, Client__r.INIT__c' +  
                            '  FROM DS_SDQ_PSI_CDI_'+BorF+'__c' + //'  FROM DS_SDQ_PSI_CDI_B__c' + 
                     ' WHERE Client__c = \''+ cID + '\'' +
                     '   AND SECTION__c = \'' + summary.SECTION__c + '\''); 
                                                     
         if(youngRec.size() == 0) { // New youngRec      
        Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_SDQ_PSI_CDI_'+BorF+'__c');    
        obj = objType.newSObject();
        obj.put('CLIENT__c', cID); 
        obj.put('FORM__c', 'DS_SDQ_P_04_10');
    }                  
    else {   // Update youngRec      
     obj = youngRec.get(0);
     obj.put('FORM__c', 'DS_SDQ_P_04_10');
      edit = TRUE;   
   }   
      //String getFormFields = ut.getFields('DS_DATA__c'); 
        List<DS_DATA__c> formInfo = 
      Database.query('SELECT ' + ut.getFields('DS_DATA__c') +   
                     '  FROM DS_DATA__c ' +
                     ' WHERE Data_Type__c = \'DS_Form_Info\'' +
                  ' ORDER BY Number__c');
                  
                  
                  
    difficultModuleStatus = String.valueOf(obj.get('BSDPEBCD__c'));
    
    
    
    skipElementToJson = JSON.serialize(skip.skipList);

    bfVariableMap = new Map<String, String>();    
    
    List<String> bfVariable =
        new List<String>{'DOASDYP','DOASDOP','METSDOP','METSDOS','METSDYP','SDPAFRA','SDPATTE','SDPBEH',
'SDPBTYP','SDPBULL','SDPCARI','SDPCLIN','SDPCOMM','SDPCONS','SDPDCL','SDPDIST',
'SDPEBCD','SDPEBDD','SDPEMO','SDPETYP','SDPFAM','SDPFIDG','SDPFIGH','SDPFRIE',
'SDPHELP','SDPHELPFL','SDPHTYP','SDPHYP','SDPIMPC','SDPIMPF','SDPIMPH','SDPIMPL',
'SDPINFOR','SDPINFSP','SDPITYP','SDPKHB','SDPKIND','SDPKTYP','SDPLIES','SDPLONE',
'SDPOBEY','SDPOLDB','SDPOTC','SDPOTYP','SDPPOPU','SDPPROB','SDPREFL','SDPREST',
'SDPSHAR','SDPSOMA','SDPSTEA','SDPTANT','SDPTIME','SDPTOT','SDPTYP','SDPUNHA',
'SDPUPSET','SDPWORR'};                

 
  for(String var : bfVariable)
      bfVariableMap.put(var, BorF+var+'__c');
      
     bfVariableMap.put('STATUS', 'STATUS_SDQ_P_04_10__c');
     
     
}

  public String getClientInfo() { return ut.clientSection(cID,SummaryID);} 
  
   public List<SelectOption> getOverallItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes- minor difficulties')); 
    options.add(new SelectOption('2','Yes- definite difficulties')); 
    options.add(new SelectOption('3','Yes- severe difficulties'));
    
    return options; 
        
  }
    
   public List<SelectOption> getHowLongItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','Less than a month')); 
    options.add(new SelectOption('1','1-5 months')); 
    options.add(new SelectOption('2','6-12 months')); 
    options.add(new SelectOption('3','Over a year'));
    
    return options; 
        
  }    
   public List<SelectOption> getUpsetItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','Not at all')); 
    options.add(new SelectOption('1','Only a little')); 
    options.add(new SelectOption('2','A medium amount')); 
    options.add(new SelectOption('3','A great deal'));
    
    return options; 
        
  }   
   public List<SelectOption> getDifficultItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','Not at all')); 
    options.add(new SelectOption('1','Only a little')); 
    options.add(new SelectOption('2','A medium amount')); 
    options.add(new SelectOption('3','A great deal'));
    
    return options; 
    }

  public List<SelectOption> getBMETItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','Pen and paper only')); 
    options.add(new SelectOption('1','Electronic only')); 
    
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

      String url = '/apex/ClientSummary?s='+summary.SECTION__c+'&id=' + cID;

      nextPage = new PageReference(url);
     //nextPage = new PageReference(skip.formRedirct(cID, '0', forceRedirect));
      nextPage.setRedirect(true);
    }
    catch(DMLException e) { nextPage = null; }
    
    return nextPage;         
    
        }
      
    ///////////////////////////////////////////////////
        
  public PageReference saveviewYoung() {

    PageReference nextPage = new PageReference('/apex/DS_SDQ_P_04_10_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
    nextPage.setRedirect(true);
        
    try {
      if(edit == FALSE) insert obj;
      else update obj;
    }
    catch(DMLException e) { nextPage = null; }
    
    return nextPage;        
    
        }
}