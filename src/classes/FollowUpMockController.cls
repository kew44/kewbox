/*Page Description:
Copy of ClientSummaryController to use with Follow-Up Mockup
 */

public with sharing class FollowUpMockController {



  public ID clientID { get; set; }

  public String subtitle { get; set; }
  public Date baselineDate { get; set; }

  public Client__c client { get; set; }
  public DS_DATA__c section { get; set; }//DS_DATA
  
  public Boolean genderUnknown { get; set; }

  public Boolean baselineBtn { get; set; }
  public Boolean traumaBtn { get; set; }
  public Boolean fuBtn {get;set;}

  public List<Client_Summary__c> baseline { get; set; }
  public List<Client_Summary__c> followUp { get; set; }

  public List<Item> rowsGTRAUMA {get; set;}
  public List<String> ageNum { get; set; } 

  public String openSection { get; set; }

  public DS_GTRAUMA__c gtObj { get; set; }

  Utility ut = new Utility();

  public String urlClientID { get; set; }
  public String urlClientIDF { get; set; }

  public Map<String, String> urlSummary { get; set;}

  public String urlClientIDBase { get; set; }
  public String urlClientIDTrauma { get; set; }

  public String urlClientIDBaseDEMO { get; set; }
  public String urlClientIDGTrauma { get; set;}

  public Map<String, String> urlClientSummaryReport { get; set; }

  public class Item {
      
    public String num { get; set; }
    public String trauma { get; set; }
    public String exp { get; set; }
    public List<String> ages { get; set; }
    public String status { get; set; }
    public String url { get; set; }
        
    public Item(String num, String trauma, String exp, List<String> ages, String status, String url) {
      this.num = num;
      this.trauma = trauma;
      this.exp = exp;
      this.ages = ages;      
      this.status = status;
      this.url = url;
    }
  
  }
  
  //////////////////////////////////////////////////////////start popup class
  public class popup{
  public boolean displayPopup {get;set;}
  
  public void closePopup(){
      displayPopup = false;
  }
  public void ShowPopup(){
      displayPopup = true;
  }  
  }
  //////////////////////////////////////////////////////////end popup class
  
  
  public FollowUpMockController (ApexPages.StandardController controller) {

    urlSummary = new Map<String, String>();

    clientID = Apexpages.currentPage().getParameters().get('id');

    openSection = Apexpages.currentPage().getParameters().get('s');

    String clientFields = ut.getFields('Client__c');
    
   // String sectionField = ut.getFields('Category__c');
    
    client = Database.query('SELECT ' + clientFields +  
                            '  FROM Client__c ' +
                            ' WHERE id = \'' + clientID + '\'');

    urlClientID = ut.urlEncode('c='+client.id);
    urlClientIDF = ut.urlEncode('c='+client.id+'&f=1&s=0');
    
    genderUnknown = (client.Gender__c == 'Male' || client.Gender__c == 'Female') ? false : true;

    //urlClientIDBaseDEMO = ut.urlEncode('c='+client.id+'&s=0');
    //urlClientIDGTrauma = ut.urlEncode('c='+client.id+'&s=-1');


    subtitle = '(' + client.Name + ') ' + client.INIT__c;

    // Check baseline information 
    //List<DS_DEMO__c> demo = [SELECT id, BDOV__c FROM DS_DEMO__c WHERE client__c = :clientID];
    List<DS_Background_Family_Info_B__c> demo = [SELECT id, BDOV__c 
                                    FROM DS_Background_Family_Info_B__c 
                                   WHERE client__c = :clientID];
                                                                 
    baselineDate = null;

    if(demo.size() != 0) {
      baselineBtn = false; 
      baselineDate = demo.get(0).BDOV__c; 
    }
    else 
      baselineBtn = true;


    // Trauma Detail

    rowsGTRAUMA = new List<Item>();

    ageNum = new List<String>{'0','1','2','3','4','5','6','7','8','9','10',
                              '11','12','13','14','15','16','17','18'};

    String gtFields = ut.getFields('DS_GTRAUMA__c');
    
    List<DS_GTRAUMA__c> gt = 
      Database.query('SELECT ' + gtFields +   
                     '  FROM DS_GTRAUMA__c ' +
                     ' WHERE Client__c = \''+ clientID + '\'');

    if(gt.size() != 0) { 
      traumaBtn = false; 
      traumaHistoryRowList(); 
      gtObj = gt.get(0); 
    }
    else { 
      traumaBtn = true; 
      gtObj = new DS_GTRAUMA__c(); 
    }
        
  }

  public void SummaryInit() {

    String summaryFields = ut.getFields('Client_Summary__c');

    List<Client_Summary__c> base = 
      Database.query('SELECT ' + summaryFields + ', Page__r.Content__c, Page__r.Variable__c, Page__r.Age_Range__c, Page__r.Gender_Required__c' + 
                     '  FROM Client_Summary__c ' +
                     ' WHERE Client__c = \'' + clientID + '\'' +
                     '   AND SECTION__c = \'0\''+
                     '   AND REQUIRED__c = TRUE '+
                   'ORDER BY FORM_TYPE__c, Page__r.weight__c');


    baseline = new List<Client_Summary__c>();

    baseline.addAll(base);

    for(Client_Summary__c s : baseline) {

      if(s.Page__r.Variable__c == 'DS_DEMO')
        urlClientIDBaseDEMO = ut.urlEncode('c='+s.Client__c+'&f=1&summary='+s.Id);

      urlSummary.put(s.Id, ut.urlEncode('c='+s.Client__c+'&summary='+s.Id+'&section='+s.Section__c));
      
    }

    urlClientSummaryReport = new Map<String, String>();

    urlClientSummaryReport.put('0', ut.urlEncode('c='+clientID+'&section=0'));

    List<Client_Summary__c> traumaGT = 
      Database.query('SELECT ' + summaryFields + 
                             ', Page__r.Content__c, Page__r.Variable__c' + 
                     '  FROM Client_Summary__c ' +
                     ' WHERE Client__c = \'' + clientID + '\'' +
                     '   AND SECTION__c = \'-1\''+
                     '   AND Page__r.Variable__c = \'GT\'');

    if(traumaGT.size() != 0)
      urlClientIDGTrauma = ut.urlEncode('c='+traumaGT.get(0).Client__c+'&summary='+traumaGT.get(0).Id);

//////This starts follow-up


    List<Client_Summary__c> follow = 
      Database.query('SELECT ' + summaryFields + 
                     '  FROM Client_Summary__c ' +
                     ' WHERE Client__c = \'' + clientID + '\'' +
                     '   AND SECTION__c = \'1\'');


    followUp = new List<Client_Summary__c>();

    followUp.addAll(follow);

    for(Client_Summary__c s : followUp) {

      if(s.Page__r.Variable__c == 'DS_DEMO')
        urlClientIDBaseDEMO = ut.urlEncode('c='+s.Client__c+'&f=1&summary='+s.Id);

      urlSummary.put(s.Id, ut.urlEncode('c='+s.Client__c+'&summary='+s.Id+'&section='+s.Section__c));
      
    }

    urlClientSummaryReport = new Map<String, String>();

    urlClientSummaryReport.put('0', ut.urlEncode('c='+clientID+'&section=1'));

  }
//////////////////////////////////////////////////////////////
  public void traumaHistoryRowList() {
      
    List<DS_DATA__c> info = [SELECT Content__c, Weight__c, Page__c, Variable__c
                               FROM DS_DATA__c 
                              WHERE Category__c = 'TD' 
                                AND Data_Type__c = 'DS_Form_Info'
                           ORDER BY weight__c];


    Set<String> formId = new Set<String>();

    for(DS_DATA__c i : info) formId.add(i.id);

    List<Client_Summary__c> td = [SELECT STATUS__c, id, 
                                         Page__r.Weight__C, Page__c
                                    FROM Client_Summary__c 
                                   WHERE Page__c IN :formId
                                     AND Client__c = :clientID];

    Map<String, Client_Summary__c> tdList = new Map<String, Client_Summary__c>();

    for(Client_Summary__c tdSummary : td) 
      tdList.put(tdSummary.Page__c, tdSummary);

    Map<String, String> agesVarList = new Map<String, String>();

    for(DS_DATA__c i : info) {

      String status = 'none';
    
      String count = string.valueof(i.Weight__c);
                        
      String trauma = i.Content__c;
      
      List<String> ages = new List<String>();
      
      for(Integer j = 0; j<19; j++) 
        ages.add('GT'+count+'RA'+j+'__c');
      
      ages.add('GT'+count+'RAU__c');

      String url = '';

      if(tdList.containsKey(i.id)) {

        status = tdList.get(i.id).STATUS__c;

        url = 'DS_TDETAIL?cimi=' + 
              ut.urlEncode('c='+clientID+'&summary='+tdList.get(i.id).id+'&TDF='+i.Page__c.substringAfter('DS_'));
      
      }    

      rowsGTRAUMA.add(new Item(count, trauma, 'GT'+count+'R__c', ages, status, url));
      
    }
      
  }    

  public String getClientInfo() {
    return ut.clientSectionInfo(clientID);
    //return null;
  }
    

}