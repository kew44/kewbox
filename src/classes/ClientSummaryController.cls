/*Page Description:
* An apex page controller that exposes the client summary functionality
* 
* Update History -----------------------
*
8/1/14-found and fixed reference to DS_Form_Info__c-KW
7/31/14-LINK TO DS_Background_Family_Info__c-KW

* Updated on: 7/30/2014
* Update Purpose: 
*  Reduce the number of query
*  1.Move building client_summary__c data function to Datase_base_SSI trigger. 
*  2.After creating the clients, it would create the baseline and 
*    general trauma forms in Client_summary__c.
*  Total query number reduced from 23 -> 6. 
* Edited by: Danny
*
* Updated on: 7/25/2014
* Update Purpose:
*  Avoiding to use the query inside the loop in method traumaHistoryRowList()
*  The total query number reduced from 51 -> 23 after modification.
* Edited by: Danny
*
* Updated on: 7/17/2014
* Update Purpose:
*  Replace the DS_Form_Info__c object with the new structure object DS_Data__c 
* Edited by: Danny
*
5/6/15
cleaned follow-up logic
KW

5/14
changed from FollowUpFormBuilder class to FormBuilder
*/

public with sharing class ClientSummaryController {

public String forceRedirect {get; set;} 

//parse section for use in url encoding
public Decimal SectionNum{get;set;}

//init client id
public ID clientID { get; set; }

//string heading (will be used for client number and initials)
public String subtitle { get; set; }

//date of visits
public Date baselineDate { get; set; }
public Date followDate { get; set; }

//Client record
public Client__c client { get; set; }

//DS_DATA record for form information
public DS_DATA__c section { get; set; }

//used to disable assessments where gender information is needed
public Boolean genderUnknown { get; set; }

//section 'button' variables
public Boolean baselineBtn { get; set; }
public Boolean traumaBtn { get; set; }
public Boolean fuBtn {get;set;}

//list of baseline forms
public List<Client_Summary__c> baseline { get; set; }

public List<Client_Summary__c> follow_up { get; set; }

//trauma types
public List<Item> rowsGTRAUMA {get; set;}
//trauma ages
public List<String> ageNum { get; set; } 

//list of all follow-up forms for client
public List<Client_Summary__c> followUp { get; set; }
//list of follow-up records
public List<DS_Background_Family_Info_F__c> backgroundFU {get;set;}
public List<DS_Background_Family_Info_F__c> visitsList {get;set;}

//list of follow-up forms per visit
public List<Client_Summary__c> visitFormList { get; set; }

//current section focus
public String openSection { get; set; }

//current visit number (for follow-up)
public Decimal VisitNum{get;set;}

//init gen trauma object
public DS_GTRAUMA__c gtObj { get; set; }

//init follow-up background object
public DS_Background_Family_Info_F__c fuObj { get; set; }

//init util
Utility ut = new Utility();

//FormBuilder init for follow-up
FormBuilder FB = new FormBuilder();

//url encoding
public String urlClientID { get; set; }

//url encoding for follow-up
public String urlClientIDF { get; set; }
    
public String urlClientIDBase { get; set; }
public String urlClientIDTrauma { get; set; }
public String urlClientIDFollowUp {get;set;}

public String urlClientIDBaseDEMO { get; set; }
public String urlClientIDGTrauma { get; set;}
public String urlClientIDFollowInfo { get; set;}

public String urlFollowUpFormUnique {get;set;}

//url maps
public Map<String, String> urlSummary { get; set;}
public Map<String, String> urlClientSummaryReport { get; set; }

//display logic
public SkipLogic skip {get;set;}
public String skipElementToJson { get; set; }

////Danny
public List<Visit2> Visits2 { get; set; }
//////////////////////////trauma item///////////////////////////////////////////
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
//end trauma item

public class Visit2 {

    Utility ut = new Utility();

    public Integer CurrentVisitNumber { get; set;}
    public String status { get; set; }
    public List<Client_Summary__c> visitFormList {get;set;}
    public Map<String, String> visitFormUrl { get; set; }
    public Date visitDate {get;set;}
    //public String visitFormUrl{get;set;}
    
    public Visit2(List<Client_Summary__c> visitFormList, Date visitDate){

        this.CurrentVisitNumber = Integer.valueOf(visitFormList.get(0).SECTION__c);
        this.visitFormList = visitFormList;
        this.visitDate = visitDate;

        this.visitFormUrl = new Map<String, String>();

        for(Client_Summary__c vfList : visitFormList) {
           this.visitFormUrl.put(vfList.id, ut.urlEncode('c='+vflist.Client__c+'&summary='+vfList.Id));
        }

    }

}

//////////////////////////////////////////////////////////start popup class
// public class popup
public boolean displayPopup {get;set;}

public void closePopup(){
    displayPopup = false;
}
public void showPopup(){
    displayPopup = true;
}  

//////////////////////////////////////////////////////////end popup class

public ClientSummaryController (ApexPages.StandardController controller) {
            
    ///////////////////init vars
    
    skip = new SkipLogic();

    urlSummary = new Map<String, String>();
    
    //pass client id through url parameters
    clientID = Apexpages.currentPage().getParameters().get('id');
    
    //pass current section through parameters
    openSection = Apexpages.currentPage().getParameters().get('s');
    
    //a string of specified Client__c fields
    String clientFields = ut.getFields('Client__c');
    
    //the record for the current client
    client = Database.query('SELECT ' + clientFields +  
                            '  FROM Client__c ' +
                            ' WHERE id = \'' + clientID + '\'');
    
    //encode url with client id parameter
    urlClientID = ut.urlEncode('c='+client.id);
    
    //checks for adequate gender information
    genderUnknown = (client.Gender__c == 'Male' || client.Gender__c == 'Female') ? false : true;
    
    //assigns client name and id to heading string
    subtitle = '(' + client.Name + ') ' + client.INIT__c;
    
    ////////////////////end var init
    
    ////////////////////Baseline background information object record///////////////////////////////////////////////
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
    //////end baseline info record
            
    ////////////////////general trauma object record///////////////////////////////////////////////
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
    ////end gtrauma record
    
    //////////////////////////////////////////////////////////////Background////////////////////////////////////////////////////////////////////////////////////////////////////   
    String fuFields = ut.getFields('DS_Background_Family_Info_F__c');
    List<DS_Background_Family_Info_F__c> returnVis = 
        Database.query('SELECT ' + fuFields +   
                       '  FROM DS_Background_Family_Info_F__c ' +
                       ' WHERE Client__c = \''+ clientID + '\'' +                                
                       'ORDER BY  Visit_Number__c DESC '//newest first
                    );
                            
    //list of background information records                        
    backgroundFU = new List<DS_Background_Family_Info_F__c>(); 
    
    //most current background information record
    fuObj =  new DS_Background_Family_Info_F__c();  
    
    //first follow-up visit 
    if (returnVis.size() != 0) {   
        fuBtn = false;
        VisitNum = returnVis.size();         
        fuObj.Client__c =clientID;  
        fuObj.Visit_Number__c=VisitNum;
        followDate = fuObj.FDOV__c;
    }
    
    //returning follow-up visit
    else{
        fuBtn = true;            
        fuObj.Visit_Number__c = 0;
        VisitNum = Integer.valueOf(fuObj.Visit_Number__c)+1;
        fuObj.Client__c =clientID;  
    }   
    
    //visit number and section number are equal across objects w/ local VisitNum
    fuObj.Visit_Number__c=VisitNum;
    fuObj.SECTION__c=String.valueOf(VisitNum);
    
        //Date is required for visit. Prevents cancelled/interrupted follow-ups from being recorded as a true visit
        if (followDate!=null){
            returnVis.add(fuObj);      
        }
        
    //add to list of background records
    backgroundFU.addAll(returnVis);
        
    //pass visit number through url
    urlClientIDF = ut.urlEncode('c='+client.id+'&f=1&s=VisitNum');
}  

public void SummaryInit() {
    
    String summaryFields = ut.getFields('Client_Summary__c');
    
    ////////////form information for baseline pages
    List<Client_Summary__c> base = 
        Database.query('SELECT ' + summaryFields + ', Page__r.Content__c, Page__r.Variable__c, Page__r.Age_Range__c, Page__r.Gender_Required__c' + 
                       '  FROM Client_Summary__c ' +
                       ' WHERE Client__c = \'' + clientID + '\'' +
                       '   AND SECTION__c = \'0\''+
                       '   AND REQUIRED__c = TRUE '+
                       'ORDER BY FORM_TYPE__c, Page__r.weight__c');
    
    //construct 
    baseline = new List<Client_Summary__c>();
    
    //add
    baseline.addAll(base);
    
    for(Client_Summary__c s : baseline) {
        
        //redirects first page to specific url
        if(s.Page__r.Variable__c == 'DS_DEMO')
            urlClientIDBaseDEMO = ut.urlEncode('c='+s.Client__c+'&f=0&summary='+s.Id);
        
        urlSummary.put(s.Id, ut.urlEncode('c='+s.Client__c+'&summary='+s.Id+'&section='+s.Section__c));
        
    }   
    ///////////end baseline form info
    
    //urilfy
    urlClientSummaryReport = new Map<String, String>();
    
    urlClientSummaryReport.put('0', ut.urlEncode('c='+clientID+'&section=0'));
    
    ////////////trauma information, general
    List<Client_Summary__c> traumaGT = 
        Database.query('SELECT ' + summaryFields + 
                       ', Page__r.Content__c, Page__r.Variable__c' + 
                       '  FROM Client_Summary__c ' +
                       ' WHERE Client__c = \'' + clientID + '\'' +
                       '   AND SECTION__c = \'-1\''+
                       '   AND Page__r.Variable__c = \'GT\'');
    
    if(traumaGT.size() != 0)
        urlClientIDGTrauma = ut.urlEncode('c='+traumaGT.get(0).Client__c+'&summary='+traumaGT.get(0).Id);
    //////////end trauma info
    
    ////////////////////////////Danny/////////////////////////////////////

    //////follow-up form information
    List<Client_Summary__c> followUpSummary = 
        Database.query('SELECT ' + summaryFields + ', Page__r.Form__c, Page__r.Content__c, Page__r.Variable__c, Page__r.Age_Range__c,Page__r.Weight__c, Page__r.Gender_Required__c, Page__r.Page__c' + 
                       '  FROM Client_Summary__c ' +
                       ' WHERE Client__c = \'' + clientID + '\'' +
                       '   AND REQUIRED__c = TRUE '+
                       '   AND SECTION__c != \'-1\'' +
                       '   AND SECTION__c != \'0\'' +
                       'ORDER BY SECTION__c DESC, Page__r.weight__c');
//we may need to edit the weights of the assessments on the DS_DATA
System.debug(followUpSummary.size());

/*kw*/
//construct
follow_up = new List<Client_Summary__c>();

follow_up.addAll(followUpSummary);
System.debug(follow_up);
System.debug(follow_up.size());
System.debug(VisitNum);
String sectionNum = String.valueOf(VisitNum);
System.debug(sectionNum);
/**/

   // if(followUpSummary.size() > 0) {//should we have any 'else' handling?

       // String sectionNum = '0';///is this variable being used properly? 
System.debug(sectionNum);
        List<Client_Summary__c> followUpForms;//is this list for all forms or all for visit?

        Visits2 = new List<Visit2>();

        Set<String> sectionList = new Set<String>();//so this is a list of string section numbers?

        Map<String, Date> visitDates = new Map<String, Date>();

        for(Client_Summary__c fus: followUpSummary) {        
            sectionList.add(fus.SECTION__c);//get the section number of summary and add to list
            
        }
        System.debug(followUpSummary);
System.debug(sectionList);

        List<DS_Background_Family_Info_F__c> backgroundFollowInfo =
            [SELECT SECTION__c, FDOV__c 
               FROM DS_Background_Family_Info_F__c 
              WHERE Client__c = : clientID
                AND SECTION__c IN :sectionList
                AND FDOV__c != null
                ];
                visitsList= new List<DS_Background_Family_Info_F__c>(); 
                visitsList.addAll(backgroundFollowInfo);
                System.debug(backgroundFollowInfo.size());

        for(DS_Background_Family_Info_F__c bfInfo : backgroundFollowInfo){
            visitDates.put(bfInfo.SECTION__c, bfInfo.FDOV__c);
}
                System.debug(backgroundFollowInfo.size());
                System.debug(visitDates);
                
            for(Client_Summary__c fus: followUpSummary) {
    
              /*  if(sectionNum != fus.SECTION__c) { //why is this !=? 'fus' query says SECTION__c != '0', sectionNum == '0', they will always be !=
                
                    if(sectionNum != '0') { //sectionNum has only been set to '0', there is no other value. why are we testing it here?
                    
                       Visits2.add(new visit2(followUpForms, visitDates.get(followUpForms.get(0).SECTION__c))); //this should not be doing anything
                    }
                    sectionNum =String.valueOf(VisitNum);//
System.debug(sectionNum);
                    followUpForms = new List<Client_Summary__c>(); //again, what is this variable supposed to be?
                }*/
                followUpForms = new List<Client_Summary__c>();
    
                followUpForms.add(fus);
                System.debug(followUpForms);
    
                fus.SECTION__c = sectionNum;
System.debug(sectionNum);
    
Visits2.add(new visit2(followUpForms, visitDates.get(followUpForms.get(0).SECTION__c)));
            }
    
//            Visits2.add(new visit2(followUpForms, visitDates.get(followUpForms.get(0).SECTION__c)));//this statement is here b/c it's not doing anything above
            
System.debug(Visits2);
            System.debug(sectionNum);
            sectionNum = String.valueOf(Integer.valueOf(sectionNum)+1);
            
System.debug(VisitNum);
System.debug(VisitNum+1);
            System.debug(sectionList);
            System.debug(sectionNum);
            //there should be an incrementation of the section somewhere. sectionList={1}, sectionNum = 1
            //the page keys off of the "CurrentVisitNumber" to seperate forms into visits
        
  //  }

    //////////////////////////////////////////////////////////////////////



    }
    
public void traumaHistoryRowList() {
    
    //////////////Trauma DETAILS information from Data
    List<DS_DATA__c> info = [SELECT Content__c, Weight__c, Page__c, Variable__c
                             FROM DS_DATA__c 
                             WHERE Category__c = 'TD' 
                             AND Data_Type__c = 'DS_Form_Info'
                             ORDER BY weight__c];
    
    Set<String> formId = new Set<String>();
    
    for(DS_DATA__c i : info) formId.add(i.id);
    
    /////////////////trauma details form information from summary
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
        
        //age range information
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
}

////////////////////////////////////////////////////
public PageReference No()
{
    closePopup();
    return null;
}

public PageReference Yes()
{
  Set<String> clientList = new Set<String>();
clientList.add(clientID);        
FormBuilder.followup(clientList);  

    closePopup();
PageReference followPage;
followPage = new  PageReference('/apex/DS_INFO_F?cimi='+urlClientIDF );

  followPage.setRedirect(true);
    
  return followPage;
}

//public PageReference Later()
/*{
    closePopup();
    return null;
}*/
}