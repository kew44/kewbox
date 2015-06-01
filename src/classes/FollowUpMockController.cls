/*Page Description:
Copy of ClientSummaryController to use with Follow-Up Mockup
*/

public with sharing class FollowUpMockController {
    
    //init client id
    public ID clientID { get; set; }
    
    public String subtitle { get; set; }
    
    //date of visits
    public Date baselineDate { get; set; }
    public Date followDate { get; set; }
    
    public Client__c client { get; set; }
    public DS_DATA__c section { get; set; }//DS_DATA
    
    public Boolean genderUnknown { get; set; }
    
    //section 'button' variables
    public Boolean baselineBtn { get; set; }
    public Boolean traumaBtn { get; set; }
    public Boolean fuBtn {get;set;}
    
    //list of baseline forms
    public List<Client_Summary__c> baseline { get; set; }
    //list of follow-up forms
    public List<Client_Summary__c> followUp { get; set; }
    //fu visits
    public List<fuVisit> fuVisits{get;set;}
    //trauma types
    public List<Item> rowsGTRAUMA {get; set;}
    //trauma ages
    public List<String> ageNum { get; set; } 
    
    public String openSection { get; set; }
    
    //init gen trauma object
    public DS_GTRAUMA__c gtObj { get; set; }
    //init follow-up background object
    public DS_Background_Family_Info_F__c fuObj { get; set; }
    
    //init util
    Utility ut = new Utility();
    
    //url encoding
    public String urlClientID { get; set; }
    public String urlClientIDF { get; set; }
    
    public Map<String, String> urlSummary { get; set;}
    
    public String urlClientIDBase { get; set; }
    public String urlClientIDTrauma { get; set; }
    public String urlClientIDFollowUp {get;set;}
    
    public String urlClientIDBaseDEMO { get; set; }
    public String urlClientIDGTrauma { get; set;}
    public String urlClientIDFollowInfo { get; set;}
    
    public Map<String, String> urlClientSummaryReport { get; set; }
    
    public String sectionNum;
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
    
    //////////////////////////////////follow-up visit///////////////////////////
    public class fuVisit{
        
        public String visitNum {get;set;}
        public String formName {get;set;}
        public Date visitDate{get;set;}
        public String frmStatus {get;set;}
        public String urlf {get;set;}
        
        public fuVisit(String visitNum, String formName, Date visitDate, String frmStatus, String urlf){
            this.visitNum =visitNum;
            this.formName= formName;
            this.visitDate=visitDate;
            this.frmStatus=frmStatus;
            this.urlf=urlf;
        }
    }
    //end visit
    
    //////////////////////////////////////////////////////////start popup class
    // public class popup{//Pop?
    public boolean displayPopup {get;set;}
    
    public void closePopup(){
        displayPopup = false;
    }
    public void showPopup(){
        displayPopup = true;
    }  
    
    //////////////////////////////////////////////////////////end popup class
    
    public FollowUpMockController (ApexPages.StandardController controller) {
        
        /////init vars
        urlSummary = new Map<String, String>();
        
        clientID = Apexpages.currentPage().getParameters().get('id');
        
        openSection = Apexpages.currentPage().getParameters().get('s');
        
        String clientFields = ut.getFields('Client__c');
        
        client = Database.query('SELECT ' + clientFields +  
                                '  FROM Client__c ' +
                                ' WHERE id = \'' + clientID + '\'');
        
        urlClientID = ut.urlEncode('c='+client.id);
      //  urlClientIDF = ut.urlEncode('c='+client.id+'&f=1&s=1');
        
        genderUnknown = (client.Gender__c == 'Male' || client.Gender__c == 'Female') ? false : true;
        
        subtitle = '(' + client.Name + ') ' + client.INIT__c;
        //end var init
        
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
        
        ////////////////////follow-up background information object record///////////////////////////////////////////////
        List <DS_Background_Family_Info_F__c> returnVis = [SELECT id, FDOV__c
                                                           FROM DS_Background_Family_Info_F__c
                                                           WHERE client__c =: clientID];
        
        followDate = null;
        
        if (returnVis.size() != 0) {
            fuBtn = false;
            followDate = returnVis.get(0).FDOV__c;
        }
        else
            fuBtn = true;
        //end follow-up record
        
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
    }  
    //////////////////////////////////////////////////////
    
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
        
        baseline = new List<Client_Summary__c>();
        
        baseline.addAll(base);
        
        for(Client_Summary__c s : baseline) {
            
            if(s.Page__r.Variable__c == 'DS_DEMO')
                urlClientIDBaseDEMO = ut.urlEncode('c='+s.Client__c+'&f=0&summary='+s.Id);
            
            urlSummary.put(s.Id, ut.urlEncode('c='+s.Client__c+'&summary='+s.Id+'&section='+s.Section__c));
            
        }   
        ///////////end baseline form info
        
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
        
        //////follow-up form information
        List<Client_Summary__c> fUp = 
            Database.query('SELECT ' + summaryFields + ', Page__r.Content__c, Page__r.Variable__c, Page__r.Age_Range__c, Page__r.Gender_Required__c' + 
                           '  FROM Client_Summary__c ' +
                           ' WHERE Client__c = \'' + clientID + '\'' +
                           '   AND SECTION__c = \'1\''+
                           '   AND REQUIRED__c = TRUE '+
                           'ORDER BY FORM_TYPE__c, Page__r.weight__c');
        
        followUp = new List<Client_Summary__c>();
        followUp.addAll(fUp);
        
        for(Client_Summary__c f : followUp){
            
            if (f.Page__r.Variable__c == 'DS_INFO_F')
                urlClientIDFollowInfo = ut.urlEncode('c='+f.Client__c+'&f=1&summary='+f.Id);
            
            urlSummary.put(f.Id, ut.urlEncode('c='+f.Client__c+'&summary='+f.Id+'&section='+f.Section__c));
            
        }
        ///////////end follow-up form info
             
        urlClientSummaryReport = new Map<String, String>();
        
        urlClientSummaryReport.put('0', ut.urlEncode('c='+clientID+'&section=1'));    
   // }
    //////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////fuVisit////////////////////////////////////////////////////////////////////////////
 /*   public static void followUpFormList() {
        
        List<Client_Summary__c> fuSummaryList = new List<Client_Summary__c>();
        
        List<DS_Data__c> fuformInfo = [SELECT Category__c, Content__c, Variable__c,  Age_Range__c, Form__c
                                       FROM DS_Data__c 
                                       WHERE Category__c = 'FolowUp'
                                       AND Data_Type__c = 'DS_Form_Info'
                                       AND FILE_NAME__c = 'FOLLOWUP'
                                       ORDER BY weight__c];
        
        Set<String> fuformId = new Set<String>();
        
        for(DS_Data__c f : fuformInfo) fuformId.add(f.id);
        
        /////////////////follow-up form information from summary
        List<Client_Summary__c> fuFormSummary = [SELECT STATUS__c, id, 
                                                 Page__r.Weight__C, Page__c
                                                 FROM Client_Summary__c 
                                                 WHERE Page__c IN :fuformId
                                                 //AND Client__c = :id
                                                ];
        
        Map<String, Client_Summary__c> fuSumList = new Map<String, Client_Summary__c>();
        
        for(Client_Summary__c fuSummary : fuFormSummary) 
            fuSumList.put(fuSummary.Page__c, fuSummary);                                       
        /*                                       {
String sectionNum = '1';//sectionNum = sectionNum++ ?   
for(String c : clients) {
fuSummaryList.add(fuSummary(c, f.id, f.Category__c, sectionNum, true));   
}        
}       

insert fuSummaryList;  */
    }
    ///////////////////////////////////////////////////////////
    /*
Client_Summary__c fuSummary = 
new Client_Summary__c(client__c = clientID, Page__c = formID, 
FORM_TYPE__c = formCategory, REQUIRED__c = required,
SECTION__c = sectionNum);

return fuSummary;

}*/
    ///////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
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
        closePopup();
        
        
        PageReference followPage = new PageReference('/apex/DS_INFO_F?&s=1&id=' + clientID);//s=1&id=' + clientID
        followPage.setRedirect(true);
        
        return followPage;
        // return null;
    }
    
    public PageReference Later()
    {
        closePopup();
        return null;
    }
    ////////////////////////////////////////////////////
}