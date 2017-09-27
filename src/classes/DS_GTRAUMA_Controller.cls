/*Page Description:
 *  Controller for VisualForce page GTRAUMA
 * Last Updated on:
 *  7/17/2014
 * Update Purpose:
 *      
 * Programmer:
 *  
 */
public with sharing class DS_GTRAUMA_Controller {

  Utility ut = new Utility();

  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

  public List<Item> rows {get; set;}
  public List<String> ageTitle {  get; set; }

  public List<String> ageNum { get; set; } 

  public DS_GTRAUMA__c GTRAUMA { get; set; }

  public Client__c client { get; set; }

  public Client_Summary__c summaryInfo { get; set; }

  public Integer clientCurrentAge { get; set; } 
  
  String cID;
  
  String summaryID;
  
  Boolean edit = FALSE;
  
  public String subtitle {get; set;}

  public SkipLogic skip = new SkipLogic();
      
  public class Item {
      
    public String num { get; set; }
    public String trauma { get; set; }
    public String subtitle { get; set; }
    public String exp { get; set; }
    public List<String> ages { get; set; }
    
    
    public Item(String num, String trauma, String exp, List<String> ages, String subtitle) {
      this.num = num;
      this.trauma = trauma;
      this.exp = exp;
      this.ages = ages;
      this.subtitle = subtitle;
      
    }
  
  }
    
  public DS_GTRAUMA_Controller(ApexPages.StandardController controller) {
      
    cID = parameter.get('c');

    summaryID = parameter.get('summary');

    ageNum = new List<String>{'0','1','2','3','4','5','6','7','8','9','10',
                              '11','12','13','14','15','16','17','18'};
    
    String gtFields = ut.getFields('DS_GTRAUMA__c');
    
    List<DS_GTRAUMA__c> GT = 
      Database.query('SELECT ' + gtFields + ', Client__r.Name, Client__r.INIT__c' +  
                     '  FROM DS_GTRAUMA__c ' +
                     ' WHERE Client__c = \''+ cID + '\'');
    
    client = [SELECT Name, INIT__c, AGE__c, DOB1__c FROM Client__c WHERE id =: cID];
    
    clientCurrentAge = Integer.valueOf(date.valueof(client.DOB1__c).daysBetween(Date.today()) / 365);

    subtitle = '(' + client.Name + ') ' + client.INIT__c;
    
                                                                                    
    if(GT.size() == 0){
      GTRAUMA = new DS_GTRAUMA__c(client__c = cID);
      GTRAUMA.FORM__c = 'DS_GTRAUMA';
    }
    else { 
      GTRAUMA = GT.get(0);
      GTRAUMA.FORM__c = 'DS_GTRAUMA';
      edit = TRUE;
    }           

    rows = new List<Item>();
    
    ageTitle = new List<String>();
    
    for(Integer i = 0; i<19; i++)
      ageTitle.add(String.valueof(i));
    
    agetitle.add('Unknown'); 
    
    this.rowList();
  }

  public String getClientInfo() { return ut.clientSection(cID,SummaryID); }  
    
  public List<SelectOption> getTraumaType() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('0','No'));
    options.add(new SelectOption('1','Yes'));
    options.add(new SelectOption('2','Suspected'));
    options.add(new SelectOption('99','Unknown'));
    return options;
  }
    
  public List<SelectOption> getPrimaryType() {
      
    List<SelectOption> options = new List<SelectOption>();
    
    options.add(new SelectOption('','--None--'));
    
    for(Item i : rows)
      options.add(new SelectOption(i.num,i.trauma));
    
    return options;
      
  }
  
  public void rowList() {
      
    List<DS_DATA__c> info = [SELECT Content__c, Note__c, Weight__c 
                                    FROM DS_DATA__c 
                                   WHERE Category__c = 'TD'
                                     AND Data_Type__c = 'DS_Form_Info' 
                                ORDER BY weight__c];

    for(DS_DATA__c i : info) {
    
      String count = string.valueof(i.Weight__c);
      
      String subtitle = (i.Note__c == null) ? '' : '<small>' + i.Note__c + '</small>'; 
                  
      String trauma = i.Content__c;
      
      List<String> ages = new List<String>();
      
      for(Integer j = 0; j<19; j++) 
          ages.add('GT'+count+'RA'+j+'__c');
      
      ages.add('GT'+count+'RAU__c');
          
      rows.add(new Item(count, trauma, 'GT'+count+'R__c', ages, subtitle));
        
    }
      
  }    

  public PageReference cancel() {

    PageReference summaryPage = new PageReference('/apex/ClientSummary?s=Trauma&id=' + client.id);
    summaryPage.setRedirect(true);
    
    return summaryPage;

  }
  
  public PageReference save() {

    PageReference nextPage;
      
    try {
      if(edit == FALSE)
        insert GTRAUMA;
      else
        update GTRAUMA;

      nextPage = new PageReference(skip.formRedirct(cID, '-1', '1'));
      nextPage.setRedirect(true);
    }
    catch(DMLException e) { nextPage = null; }

    /*PageReference summaryPage = new PageReference('/apex/ClientSummary?s=Trauma&id=' + client.id);
    summaryPage.setRedirect(true);
      return summaryPage;
    */

    /*PageReference nextPage = new PageReference(skip.formRedirct(cID, '-1', '1'));
    system.debug(nextPage);
    nextPage.setRedirect(true);*/
    
    return nextPage;
    //return null;
      
  }

}