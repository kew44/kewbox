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
public with sharing class DS_CLINEVAL_Controller {

  Utility ut = new Utility();

//  public DS_CLINEVAL__c obj { get; set; }        //
  public DS_Functioning_Forms_B__c obj { get; set; }        
  
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


    public DS_CLINEVAL_Controller(ApexPages.StandardController controller) {
    
    cID = parameter.get('c');

    summaryID = parameter.get('summary');

    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    skip = new SkipLogic();
    
    skip.skipLibrary('BCEOTHY', 'show', '1', new Map<String,String>{'BCEOTHER'=>'text'});    
    skip.skipLibrary('BCEPRIM', 'show', '98', new Map<String,String>{'BCEPRIMSP'=>'text'});    
  
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];
  // Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

    String getDEMOFields = ut.getFields('DS_Functioning_Forms_B__c');  
   // String getDEMOFields = ut.getFields('DS_CLINEVAL__c');
    
    List<DS_Functioning_Forms_B__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //CLINEVAL
   // List<DS_CLINEVAL__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' + 
                                     //        '  FROM DS_CLINEVAL__c ' +                                            //CLINEVAL
                                             '  FROM DS_Functioning_Forms_B__c ' +                                        
                                                 ' WHERE Client__c = \''+ cID + '\'');
    
    
    if(record.size() == 0) { // New record
      
    //  obj = new DS_CLINEVAL__c(client__c = cID);                //
      obj = new DS_Functioning_Forms_B__c(client__c = cID, FORM__c = 'DS_CLINEVAL');               
    //  summary = new Client_Summary__c(FORM_ID__c=summaryID);//
      
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;

      obj.FORM__c = 'DS_CLINEVAL';

      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          //skip.runSkipLogic(lKey, String.valueOf(obj.get(lKey+'__c')), obj);
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
        }
        
    } 

    skipElementToJson = JSON.serialize(skip.skipList);

    }
  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}  
  
  public List<SelectOption> getYNIems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    return options; 
        
  }  
  public List<SelectOption> getPrimaryProbIems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('1','Attention-Deficit/Hyperactivity Disorder (ADHD) ')); 
    options.add(new SelectOption('2','Bipolar Disorder ')); 
    options.add(new SelectOption('3','Depressive Symptoms ')); 
    options.add(new SelectOption('4','Depressive Disorder')); 
    options.add(new SelectOption('5','Traumatic/Complicated Grief ')); 
    options.add(new SelectOption('6','Generalized Anxiety Disorder ')); 
    options.add(new SelectOption('7','Separation Anxiety Disorder ')); 
    options.add(new SelectOption('8','Social Anxiety Disorder (Social Phobia) ')); 
    options.add(new SelectOption('9','Panic Disorder')); 
    options.add(new SelectOption('10','Specific Phobia ')); 
    options.add(new SelectOption('11','Obsessive Compulsive and Related Disorders ')); 
    options.add(new SelectOption('12','Acute Stress Disorder ')); 
    options.add(new SelectOption('13','Post-Traumatic Stress Disorder ')); 
    options.add(new SelectOption('14','Adjustment Disorder')); 
    options.add(new SelectOption('15','Attachment Problems/ Difficulties')); 
    options.add(new SelectOption('16','Dissociative Disorder')); 
    options.add(new SelectOption('17','Dissociative Symptoms')); 
    options.add(new SelectOption('18','Somatization ')); 
    options.add(new SelectOption('19','Feeding and Eating Disorder ')); 
    options.add(new SelectOption('20','Sleep-Wake Disorder ')); 
    options.add(new SelectOption('21','Sexual Behavioral Problems ')); 
    options.add(new SelectOption('22','Oppositional Defiant Disorder ')); 
    options.add(new SelectOption('23','Conduct Disorder ')); 
    options.add(new SelectOption('24','Intermittent Explosive Disorder ')); 
    options.add(new SelectOption('25','General Behavioral Problems')); 
    options.add(new SelectOption('26','Substance Abuse Problems ')); 
    options.add(new SelectOption('27','Substance-Related and Addictive Disorders ')); 
    options.add(new SelectOption('28','Suicidality')); 
    options.add(new SelectOption('29','Suicidal Behavior Disorder ')); 
    options.add(new SelectOption('98','Other')); 
    
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