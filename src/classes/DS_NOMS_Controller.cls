/*Page Description:
 *  Controller for VisualForce page DS_NOMS
 * Last Updated on:
 *  7/18/2014
 * Update Purpose:
 *      fix redirect
 7/31/14- Link to DS_Functioning_Forms__c
 8/5/14-Danny-radiobuttons
 * Programmer:
 *   Kelsey
 */
public with sharing class DS_NOMS_Controller {

        Utility ut = new Utility();
Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));
        
        // public DS_NOMS__c obj { get; set; }//
         public DS_Functioning_Forms_B__c obj { get; set; }//NOMS

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

    public DS_NOMS_Controller(ApexPages.StandardController controller) {
    
        cID = parameter.get('c');

    summaryID = parameter.get('summary');
          
        forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

        skip = new SkipLogic();  
        
        skip.skipLibrary('BNADMIN', 'show', '98', new Map<String, String>{'BNADMINOSP'=>'text'});     
       
        client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];  
 //   Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;
   
    
   // String getDEMOFields = ut.getFields('DS_NOMS__c');//
    String getDEMOFields = ut.getFields('DS_Functioning_Forms_B__c');//NOMS
    

  //  List<DS_NOMS__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //NOMS
    List<DS_Functioning_Forms_B__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //NOMS
                                               '  FROM DS_Functioning_Forms_B__c' +                                 
                                                 ' WHERE Client__c = \''+ cID + '\'' 
                                           //      +    '   AND FORM__c = \'DS_NOMS\''
                                                     );                                          
    
    if(record.size() == 0) { // New record
      
   //   obj = new DS_NOMS__c(CLIENT__c = cID);            //NOMS
      obj = new DS_Functioning_Forms_B__c(CLIENT__c = cID, FORM__c = 'DS_NOMS');            //NOMS
      
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;

      obj.FORM__c = 'DS_NOMS';
   
     for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
        }
        }
    skipElementToJson = JSON.serialize(skip.skipList);
}
  
        
  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}  
 
     public List<SelectOption> getAdminItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    //options.add(new SelectOption('','')); 
    options.add(new SelectOption('1','Administrative staff ')); 
    options.add(new SelectOption('2','Care coordinator ')); 
    options.add(new SelectOption('3','Case manager ')); 
    options.add(new SelectOption('4','Clinician providing direct services '));
    options.add(new SelectOption('5','Clinician not providing services '));
    options.add(new SelectOption('6','Consumer peer'));
    options.add(new SelectOption('7','Data collector '));
    options.add(new SelectOption('8','Evaluator'));
    options.add(new SelectOption('9','Family advocate '));
    options.add(new SelectOption('10','Research assistant staff '));
    options.add(new SelectOption('11','Self-administered '));
    options.add(new SelectOption('98','Other '));
    
    return options; 
        
  }
 
//     public List<SelectOption> getQ1ResponseItems() {
    
 //   List<SelectOption> options = new List<SelectOption>(); 
    
    //options.add(new SelectOption('','')); 
  //  options.add(new SelectOption('1','Strongly Disagree')); 
 //   options.add(new SelectOption('2','Disagree ')); 
 //   options.add(new SelectOption('3','Undecided ')); 
 //   options.add(new SelectOption('4','Agree '));
 //   options.add(new SelectOption('5','Strongly Agree'));
 //   options.add(new SelectOption('96','Refused '));
  //  options.add(new SelectOption('97','Not Applicable'));
    
//   return options; 
        
 // }
  
 //   public List<SelectOption> getQ2ResponseItems() {
    
//    List<SelectOption> options = new List<SelectOption>(); 
    
    //options.add(new SelectOption('','')); 
 //   options.add(new SelectOption('4','All of the Time '));
 //   options.add(new SelectOption('3','Most of the Time '));  
 //   options.add(new SelectOption('2','Some of the Time')); 
 //   options.add(new SelectOption('1','A Little of the Time'));
  //  options.add(new SelectOption('0','None of the Time'));
  //  options.add(new SelectOption('96','Refused '));
 //   options.add(new SelectOption('99','Unknown'));
    
 //   return options; 
        
//  }
  
 //   public List<SelectOption> getQ3ResponseItems() {
    
  //  List<SelectOption> options = new List<SelectOption>(); 
    
    //options.add(new SelectOption('','')); 
  //  options.add(new SelectOption('1','Never'));
  //  options.add(new SelectOption('2','Once or Twice'));  
  //  options.add(new SelectOption('3','Weekly')); 
 //   options.add(new SelectOption('4','Daily or Almost Daily'));
  //  options.add(new SelectOption('96','Refused '));
 //   options.add(new SelectOption('99','Unknown'));
    
 //   return options; 
        
 // }
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