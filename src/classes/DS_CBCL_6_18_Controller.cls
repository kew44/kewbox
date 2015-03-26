/*Page Description:
 *  Controller for VisualForce page DS_CBCL_6_18
 * Last Updated on:
 *  7/17/2014
 * Update Purpose:
 *      
 * Programmer:
 *  
 */
public with sharing class DS_CBCL_6_18_Controller {
    
  Utility ut = new Utility();

  public SObject obj {get; set;}

  String cID { get; set; }
  
  String summaryID;

  public String forceRedirect {get; set;} 

  Boolean edit = FALSE;

  public String subtitle {get; set;}
    
  public Client__c client { get; set; }

  public Client_Summary__c summary { get; set; }

  public List<Item> items {get;set;}

  public SkipLogic skip {get;set;}

  public Map<String, String> bfVariableMap { get; set; }
  
  
  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

  public class Item {
      
    public String num {get;set;}
    public String question {get;set;}
    public String questionField {get;set;}
    public String symptom {get;set;}
    public String describeField { get;set; }
    public Boolean section { get;set; }
    
    public Item(String num, String question, String questionField, 
                String symptom, String describeField, Boolean section) {

      this.num = num;
      this.question = question;
      this.questionField = questionField;
      this.symptom = symptom;
      this.describeField = describeField;
      this.section = section;

    }
      
  }

    
  public DS_CBCL_6_18_Controller(ApexPages.StandardController controller) {
  
    skip = new SkipLogic();

    cID = parameter.get('c');

    summaryID = parameter.get('summary');

    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];

    summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];

    String BorF = (Integer.valueOf(summary.SECTION__c) > 0) ? 'F' : 'B';
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;

    String getCBCLFields = ut.getFields('DS_CBCL_'+BorF+'__c');

    List<Sobject> record = 
      Database.query('SELECT ' + getCBCLFields + ', ' + 
                            'Client__r.Name, Client__r.INIT__c' +  
                     '  FROM DS_CBCL_'+BorF+'__c ' +
                     ' WHERE Client__c = \''+ cID + '\'');

    if(record.size() == 0)  {// New record

      Schema.SObjectType objType = Schema.getGlobalDescribe().get('DS_CBCL_'+BorF+'__c');
      obj = objType.newSObject();

      obj.put('Client__c', cID);
      obj.put('FORM__c', 'DS_CBCL_6_18');

    }
    else {   // Update record
      obj = record.get(0);
      obj.put('FORM__c', 'DS_CBCL_6_18');
      edit = TRUE;
    } 

    String getFormFields = ut.getFields('DS_DATA__c');
    
    List<DS_DATA__c> formInfo = 
      Database.query('SELECT ' + getFormFields +   
                     '  FROM DS_DATA__c ' +
                     ' WHERE Type__c = \'6_18\'' +
                     '   AND Data_Type__c = \'DS_CBCL_Form_Info\'' +
                  ' ORDER BY Number__c');
    
    items = new List<Item>();
    
    for(DS_DATA__c info : formInfo) {

      String describeField = (info.Describe_Field__c == '' || info.Describe_Field__c == null) ? BorF+'CBO1__c' : BorF+info.Describe_Field__c+'__c';

      String itemNumber = string.valueof(integer.valueof(info.Number__c));

      if(info.Number__c > 56 && info.Number__c < 57) {

        Integer infoNumber = Integer.valueOf(info.Number__c * 100);

        itemNumber = '56';
//////added to display heading
if(infoNumber == 5600) itemNumber = itemNumber;
/////////
        else if(infoNumber == 5610) itemNumber += 'a';
        else if(infoNumber == 5620) itemNumber += 'b';
        else if(infoNumber == 5630) itemNumber += 'c';
        else if(infoNumber == 5640) itemNumber += 'd';
        else if(infoNumber == 5650) itemNumber += 'e';
        else if(infoNumber == 5660) itemNumber += 'f';
        else if(infoNumber == 5670) itemNumber += 'g';
        else if(infoNumber == 5680) itemNumber += 'h';

      }

      items.add(new Item(itemNumber, info.Content__c, 
                         BorF+info.Question_Field__c+'__c', info.Symptom__c,  
                         describeField, info.Section__c));  
    }

    bfVariableMap = new Map<String, String>();

    List<String> bfVariable = 
      new List<String>{'CBOMETH', 'DOACO'};
    
    for(String var : bfVariable)
      bfVariableMap.put(var, BorF+var+'__c');

    bfVariableMap.put('STATUS', 'STATUS_CBCL_6_18__c');


  }

  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}  

  public List<SelectOption> getNSVItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','0 = Not True')); 
    options.add(new SelectOption('1','1 = Somewhat or Sometimes True')); 
    options.add(new SelectOption('2','2 = Very True or Often True')); 
    
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

    PageReference summaryPage = new PageReference('/apex/ClientSummary?s=' + summary.SECTION__c + '&id=' + cID);
    summaryPage.setRedirect(true);
    
    return summaryPage;

  }
  
  public PageReference save() {

    String url;
    PageReference nextPage;
      
    try {
      
      if(edit == FALSE)
        insert obj;
      else
        update obj;

      url = '/apex/ClientSummary?s=' + summary.SECTION__c + '&id=' + cID;

      nextPage = new PageReference(url);
      nextPage.setRedirect(true);

    }
    catch(DMLException e) { nextPage = null; }

    return nextPage;
      
  }

  public PageReference saveviewOld() {

    PageReference nextPage = new PageReference('/apex/DS_CBCL_6_18_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));
    nextPage.setRedirect(true);
    try {
      if(edit == FALSE) insert obj;
      else update obj;
    }
    catch(DMLException e) { nextPage = null; }
    
    return nextPage;        
      
  }

}