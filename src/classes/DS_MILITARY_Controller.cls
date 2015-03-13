/*Page Description:
 *  Controller for VisualForce page DS_MILITARY
 * Last Updated on:
 *  7/24/2014
 * Update Purpose:
 *      fix redirect
 7/31/14- Link to DS_Background_Family_Info__c
 8/13/14- Link to DS_Background_Family_Info_B__c
 8/15/2014- specify other relations and sl
 * Programmer:
 *  Kelsey
 */
public with sharing class DS_MILITARY_Controller {

  Utility ut = new Utility();

  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

 // public DS_MILITARY__c obj { get; set; }//
  public DS_Background_Family_Info_B__c obj { get; set; }//MILITARY

  String cID;
  
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
  
  public DS_MILITARY_Controller(ApexPages.StandardController controller) {
    
    cID = parameter.get('c');

    summaryID = parameter.get('summary');

    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    skip = new SkipLogic();
        
        skip.skipLibrary('BMFMR1', 'show', '98', new Map<String, String>{'BMFMR1SP'=>'text'}); 
        skip.skipLibrary('BMFMR2', 'show', '98', new Map<String, String>{'BMFMR2SP'=>'text'}); 
        skip.skipLibrary('BMFMR3', 'show', '98', new Map<String, String>{'BMFMR3SP'=>'text'}); 
        skip.skipLibrary('BMFMR4', 'show', '98', new Map<String, String>{'BMFMR4SP'=>'text'}); 
    
    skip.skipLibrary('BOTHMIL', 'show', 'true', new Map<String, String>{'BOTHMILSP'=>'text'});///////other relationship
    
    skip.skipLibrary('BMPI', 'show', 'true', new Map <String, String>{'BMPIAMP'=>'checkbox',  ///////physical injury
                                                                        'BMPITBI'=>'checkbox',
                                                                        'BMPIBRN'=>'checkbox',
                                                                        'BMPICPF'=>'checkbox',
                                                                        'BMPIOTH'=>'checkbox',
                                                                        'BMPIUK'=>'checkbox'
                                                                      });
                                                                      
    skip.skipLibrary('BMST', 'show', 'true', new Map <String, String>{'BMSTPTSD'=>'checkbox',  ///////stress
                                                                        'BMSTDEP'=>'checkbox',
                                                                        'BMSTSUIC'=>'checkbox',
                                                                        'BMSTOTH'=>'checkbox',
                                                                        'BMSTUK'=>'checkbox'
                                                                      });
                                                                      
    skip.skipLibrary('BMKIL', 'show', 'true', new Map <String, String>{'BMKILCOM'=>'checkbox',  ///////killed
                                                                        'BMKILACC'=>'checkbox',
                                                                        'BMKILMED'=>'checkbox',
                                                                        'BMKILSUIC'=>'checkbox',
                                                                        'BMKILOTH'=>'checkbox',
                                                                        'BMKILUK'=>'checkbox'
                                                                      });
    
    skip.skipLibrary('BMDIFRI','show','1', new Map<String,String>{'BMDIFRIE'=>'text'});///////difficulties
    
    skip.skipLibrary('BMPIOTH', 'show', 'true', new Map<String, String>{'BMPIOSP'=>'text'});//other physical injury  
      
    skip.skipLibrary('BMSTOTH', 'show', 'true', new Map<String, String>{'BMSTOSP'=>'text'});//other stress
      
    skip.skipLibrary('BMKILOTH', 'show', 'true', new Map<String, String>{'BMKILOSP'=>'text'});//other killed    
      
    skip.skipLibrary('BMDIFRIO', 'show', 'true', new Map<String, String>{'BMDIFRIOSP'=>'text'});//other difficulties
    
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
  //  Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;


   // String getDEMOFields = ut.getFields('DS_MILITARY__c');
    String getDEMOFields = ut.getFields('DS_Background_Family_Info_B__c');

  //  List<DS_MILITARY__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //MILITARY
    List<DS_Background_Family_Info_B__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //MILITARY
    //                                               '  FROM DS_MILITARY__c' +                                        //MILITARY
                                               '  FROM DS_Background_Family_Info_B__c' +                                                  
                                                 ' WHERE Client__c = \''+ cID + '\'');

    if(record.size() == 0) { // New record
      
   //   obj = new DS_MILITARY__c(CLIENT__c = cID);                                                //MILITARY
      obj = new DS_Background_Family_Info_B__c(CLIENT__c = cID, FORM__c = 'DS_MILITARY');                                                //MILITARY
    //  summary = new Client_Summary__c(FORM_ID__c=summaryID);//
      
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;

      obj.FORM__c = 'DS_MILITARY';
        
      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          //skip.runSkipLogic(lKey, String.valueOf(obj.get(lKey+'__c')), obj);
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));     
    } 
   
   }

    skipElementToJson = JSON.serialize(skip.skipList);

  }
  
  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}  
   
   public List<SelectOption> getMoveItems(){
   
   List<SelectOption> options = new List<SelectOption>();
   
   options.add(new SelectOption('0', '0'));
   options.add(new SelectOption('1', '1-2'));
   options.add(new SelectOption('2', '3-4'));
   options.add(new SelectOption('3', '5-10'));
   options.add(new SelectOption('4', 'Greater than 10'));
   options.add(new SelectOption('99', 'Unknown'));
   
   return options;
   }
   
   public List<SelectOption> getServeItems(){
   
   List<SelectOption> options = new List<SelectOption>();
   
   options.add(new SelectOption('0', '0'));
   options.add(new SelectOption('1', '1'));
   options.add(new SelectOption('2', '2'));
   options.add(new SelectOption('3', '3'));
   options.add(new SelectOption('4', '4'));
   options.add(new SelectOption('5', 'Greater than 4'));
   options.add(new SelectOption('99', 'Unknown'));
   
   return options;
   }
   public List<SelectOption> getIsDiffItems(){
   
   List<SelectOption> options = new List<SelectOption>();
   
   options.add(new SelectOption('0', 'No'));
   options.add(new SelectOption('1', 'Yes'));
   options.add(new SelectOption('99', 'Unknown'));
   
   return options;
   }
   
   public List<SelectOption> getRelationItems(){
   
   List<SelectOption> options = new List<SelectOption>();
   
   options.add(new SelectOption('0', 'Mother'));
   options.add(new SelectOption('1', 'Father'));
   options.add(new SelectOption('2', 'Brother'));
   options.add(new SelectOption('3', 'Sister'));
   options.add(new SelectOption('98', 'Other'));   
    
   return options;
   }
   
   public List<SelectOption> getBranch1Items(){
   
   List<SelectOption> options = new List<SelectOption>();
   
   options.add(new SelectOption('0', 'Army'));
   options.add(new SelectOption('1', 'Air Force'));
   options.add(new SelectOption('2', 'Navy'));
   options.add(new SelectOption('3', 'Marine Corps'));
   options.add(new SelectOption('4', 'Coast Guard'));  
   options.add(new SelectOption('99', 'Unknown'));   
    
   return options;
   
   }
   public List<SelectOption> getBranch2Items(){
   
   List<SelectOption> options = new List<SelectOption>();
   
   options.add(new SelectOption('0', 'Reserve'));
   options.add(new SelectOption('1', 'National Guard'));
   options.add(new SelectOption('99', 'Unknown'));   
    
   return options;
   }   
   
   public List<SelectOption> getStatusItems(){
   
   List<SelectOption> options = new List<SelectOption>();
   
   options.add(new SelectOption('0', 'Active Duty'));
   options.add(new SelectOption('1', 'Retired'));
   options.add(new SelectOption('2', 'Separated'));
   options.add(new SelectOption('98', 'Other')); 
   options.add(new SelectOption('99', 'Unknown'));     
    
   return options;
   }
   
   public List<SelectOption> getWartimeItems(){
   
   List<SelectOption> options = new List<SelectOption>();
   
   options.add(new SelectOption('0', 'No'));
   options.add(new SelectOption('1', 'Yes'));
   options.add(new SelectOption('99', 'Unknown'));   
    
   return options;
   }
   
   public List<SelectOption> getDeployItems(){
   
   List<SelectOption> options = new List<SelectOption>();
   
   options.add(new SelectOption('0', 'Currently'));
   options.add(new SelectOption('1', 'Past 30 Days'));
   options.add(new SelectOption('2', 'Past Year'));
   options.add(new SelectOption('3', 'Greater than 1 Year'));
   options.add(new SelectOption('99', 'Unknown'));   
    
   return options;
   }
   
   public List<SelectOption> getDeployAllItems(){
   
   List<SelectOption> options = new List<SelectOption>();
   
   options.add(new SelectOption('0', 'Less than 1 year'));
   options.add(new SelectOption('1', '1-2 Years'));
   options.add(new SelectOption('2', 'Greater than 2 Years'));
   options.add(new SelectOption('99', 'Unknown'));   
    
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