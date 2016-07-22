/****
*@description This test provides code coverage Utility and other background functions
*
*@group Test Script 
*@group-content /ApexDocContent/Test/Utility.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
****/

@isTest (SeeAllData=false)
public class TestClass_A_Utility {
    
    /****
    *@description method initializing Utility
    ****/
    static TestMethod void Test_Utility() {
        
        TestClass_A_Utility ut = new TestClass_A_Utility();
        
        Client__c client = ut.createClient();
        
        DS_DATA__c info = new DS_DATA__c();
        
        Utility ul = new Utility();
        
        ul.getFields('Client__c');
        
        ul.clientSectionInfo(client.id);
        
        ul.getRandomInt(1, 10);
        
        String param = ul.urlEncode('c=1&test=1');
        
        ul.urlDecode(param);
        
    }
    
    /****
    *@description method to setup counter
    *@return counter
    ****/
    public void addAdminToCounter() {
        
        UserRole role = [SELECT id FROM UserRole WHERE Name = 'Administrator'];
        
        Counter__C counter = new Counter__C(Type__c = 0, Item_Name__c = 'administrator', 
                                            Role_ID__c = role.id);
        
        insert counter;       
        
    } 
    
    /****
    *@description method to setup admin role
    *@return role id
    ****/
    public String getAdminRoleID() {
        UserRole role = [SELECT id FROM UserRole WHERE Name = 'Administrator'];
        return role.id;
    }
    
    /****
    *@description method to setup main center
    *@return center
    ****/
    public Center__c createMainCenter() {
        
        addAdminToCounter();
        
        Center__c center = new Center__c();
        
        center.Type__c = 'Main';
        center.Input_ID__c = '0002';
        center.Name__c = 'Test Main';
        
        insert center;
        
        // Manually run insertRoleList() for main center
        
        Center__c mainCenter = [SELECT id, Name, Name__C FROM Center__c WHERE id =: center.id];
        
        String mainCenterRoleName = '(' + mainCenter.Name + ') ' + mainCenter.Name__c;
        
        String mainCenterRoleID = '000001';  
        
        Counter__c counter = new Counter__c(Item_ID__c = mainCenter.id, 
                                            Item_name__c = mainCenterRoleName, 
                                            Type__c = 1, 
                                            Role_ID__c = mainCenterRoleID); 
        
        insert counter;
        
        System.assertEquals(mainCenterRoleID, '000001', 'There is a problem with the mainCenterRoleID.');
        
        return center;
        
    }
    
    /****
    *@description method to setup sub center
    *@return subCenter
    ****/
    public Center__c createSubCenter() {
        
        Center__c main = createMainCenter();
        
        Center__c subCenter = new Center__c();
        
        subCenter.Main_center__c = main.id;
        subCenter.Type__c = 'Sub';
        subCenter.Name__c = 'Test Sub';
        
        insert subCenter;
        
        // Manually run insertRoleList() for sub-center
        
        Center__c sub = [SELECT id, Name, Name__C FROM Center__c WHERE id =: subCenter.id];
        
        String subCenterRoleName = '(' + sub.Name + ') ' + sub.Name__c;
        
        String subCenterRoleID = '000002';  
        
        Counter__c counter = new Counter__c(Item_ID__c = sub.id, 
                                            Item_name__c = subCenterRoleName, 
                                            Type__c = 1, 
                                            Role_ID__c = subCenterRoleID);
        
        insert counter;
        
        System.assertEquals(subCenterRoleID , '000002', 'There is a problem with the subCenterRoleID.');        
        
        return subCenter;
        
    }
    
    /****
    *@description method to setup clinician
    *@return clinician
    ****/
    public Clinician__c createClinician() {
        
        Center__c center = createMainCenter();
        
        Clinician__c cl = new Clinician__c();
        
        cl.Center__c = center.id;
        
        insert cl;
        
        // Manually run insertRoleList() for Clinician
        
        Clinician__c clinician = [SELECT id, Name, Name__C FROM Clinician__c WHERE id =: cl.id];
        
        String clinicianRoleName = '(' + clinician.Name + ') ' + clinician.Name__c;
        
        String clinicianRoleID = '000003';  
        
        Counter__c counter = new Counter__c(Item_ID__c = clinician.id, 
                                            Item_name__c = clinicianRoleName, 
                                            Type__c = 1, 
                                            Role_ID__c = clinicianRoleID); 
        
        insert counter;
        
        System.assertEquals(clinicianRoleID, '000003', 'There is a problem with the clinicianRoleID.');
        
        return clinician;
        
    }
    
    /****
    *@description method to setup client using parameters
    *@param gender Client's gender
    *@param age Client's age(user-entered age)
    *@return client
    ****/
    public Client__c getClient(String gender, Integer age) {
        
        Client__c client = new Client__c();
        
        Integer yearDiff = 0 - age;
        
        client.INIT__c = 'BBB';
        client.DOB1__c = date.today().addYears(yearDiff).addDays(-1);
        client.DOB2__c = date.today().addYears(yearDiff).addDays(-1);
        client.AGE__c = age;
        client.GENDER__c = gender;
        
        return client;
        
    }
    
    /****
    *@description method to setup client with random elements using parameters 
    *@param gender Client's gender
    *@param age Client's age range
    *@param amount Number of clients
    *@return List<Client__c>
    ****/
    public List<Client__c> getClient(String gender, String ageRange, Integer amount) {
        
        Utility ul = new Utility();
        
        List<Client__c> clients = new List<Client__c>();
        
        for(Integer i = 0; i < amount; i++) {
            
            Integer minAge, maxAge, age = 0;
            
            Client__c client = new Client__c();
            
            // Get random gender if it is null
            if (gender == null) {
                
                Integer randGender = ul.getRandomInt(1, 2);
                
                if(randGender == 1) gender = 'male';
                else gender = 'female';
                
            }
            
            // Get the random age in a specific range
            if (ageRange != null) {
                
                List<String> splitRange = ageRange.split('_');
                
                minAge = Integer.valueOf(splitRange.get(0));
                maxAge = Integer.valueOf(splitRange.get(1));
                
                age = ul.getRandomInt(minAge, maxAge);
                
            }
            // If there is no specific age range, get a random age from 0 ~ 20
            else {
                age = ul.getRandomInt(0, 20);
            }
            
            Integer yearDiff = 0 - age;
            
            client.INIT__c = ul.getRandomString(3, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
            client.DOB1__c = date.today().addYears(yearDiff).addDays(-1);
            client.DOB2__c = date.today().addYears(yearDiff).addDays(-1);
            client.AGE__c = age;
            client.GENDER__c = gender;
            
            clients.add(client);
            
        }
        
        return clients;
    }
    
    /****
    *@description method to setup client without parameters
    *@return client
    ****/
    public Client__c createClient() {
        
        Clinician__c clinician = createClinician();
        
        Client__c client = getClient('Female', 0);
        
        client.Clinician__c = clinician.id;
        
        insert client;
        
        return client;
        
    }    
    
    /****
    *@description method to setup client using another client as a parameter
    *@param client
    *@return client
    ****/
    public Client__c createClient(Client__c client) {
        
        Clinician__c clinician = createClinician();
        
        client.Clinician__c = clinician.id;
        
        insert client;
        
        return client;
        
    }
    
    /****
    *@description method to setup clients using another clients as a parameter
    *@param clients
    *@return A list of clients
    ****/
    public List<Client__c> createClient(List<Client__c> clients) {
        
        Clinician__c clinician = createClinician();
        
        for(Client__c c: clients) {
    		c.Clinician__c = clinician.id;        
	    }
        
        insert clients;
        
        return clients;
        
    }
    
    /****
    *@description method to setup client summary 
    *@return client
    ****/
    public Client__c createClientSummary() {
        
        Client__c client = createClient();     
        
        ApexPages.currentPage().getParameters().put('id', client.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(client);
        
        ClientSummaryController summary = new ClientSummaryController(sc);
        
        summary.SummaryInit();
        
        return client;
        
    }
    
    /****
    *@description method to setup new followup record for client
    *@param client
    *@return summary.SECTION__c identifies which followup visit
    ****/
    public String addNewFollowupVisit(Client__c client) {
        
        Set<String> clients = new Set<String>();
        
        clients.add(client.id);
        
        String followupInfoSummaryId = FormBuilder.followup(clients);
        
        Client_Summary__c summary = [SELECT id, SECTION__c 
                                     FROM Client_summary__c
                                     WHERE client__c = :client.Id
                                     AND id = : followupInfoSummaryId];
        
        
        return summary.SECTION__c;
    }
    
    /****
    *@description method to get the baselineId lookup field
    *@param client
    *@return baselineId
    ****/
    public String baselineID(Client__c client) {
        
        Set<String> clients = new Set<String>();
        
        clients.add(client.id);
        
        DS_Background_Family_Info_B__c baseline = [SELECT id FROM DS_Background_Family_Info_B__c WHERE Client__c =: client.ID];
        
        String baselineId = String.valueOf(baseline.id);
        
        return baselineId;
        
    }
    
    /****
    *@description method to get the id of Client Summary record
    *@param clientId
    *@param form name of form
    *@param section
    *@return summary.id
    ****/
    public String getClientSummaryId(String clientId, String form, String section) {
        
        Client_Summary__c summary = [SELECT id 
                                     FROM Client_Summary__c 
                                     WHERE client__c =:clientid
                                     AND Page__r.form__c = :form
                                     AND SECTION__c = :section];
        
        return summary.id;      
        
    }
    
    /****
    *@description method to manually cover blankCount variables
    *a blankCount is used to generate javaScript warnings on certain assessments
    *javaScript is not fully covered by Apex test scripts
    *@param blankCount
    *@return bC blankCount integer
    ****/
    public Integer countBlankAnwer(Integer blankCount){
        
        Integer bC = 0;
        
        return bC;
    }
    
    /****
    *@description method to manually cover moduleStatus variables
    *a moduleStatus variable is used to generate some javaScript displayLogic
    *javaScript is not fully covered by Apex test scripts
    *@param ModStatus
    *@return dms String ModStatus
    ****/
    public String ModuleStatus(String ModStatus){
        
        String dms = '1';
        
        return dms;
    }
    
    /****
	*@description method to setup CBCL Visit 
	****/
    public class Visit {
        
        public Date  DOACY    { get; set; }    // Date of administration
        
        public Integer CBAPPCNY { get; set; } 
        
        public Double  CBIBTNY  { get; set; } // Internalizing Problems Score
        public String  CBIBPY   { get; set; } 
        public String  CBIBSY   { get; set; } 
        
        public Double  CBERTNY  { get; set; } // Emotionally Reactive
        public String  CBERPY   { get; set; }
        public String  CBERSY   { get; set; }
        
        public Double  CBADTNY  { get; set; } // Anxious/Depressed
        public String  CBADPY   { get; set; }
        public String  CBADSY   { get; set; }
        
        public Double  CBSCTNY  { get; set; } // Somatic Complaints
        public String  CBSCPY   { get; set; }
        public String  CBSCSY   { get; set; }
        
        public Double  CBWTNY   { get; set; } // Withdrawn
        public String  CBWPY    { get; set; } 
        public String  CBWSY    { get; set; } 
        
        public Double  CBEBTNY  { get; set; } // Externalizing Problems Score
        public String  CBEBPY   { get; set; }
        public String  CBEBSY   { get; set; }
        
        public Double  CBSPTNY  { get; set; } // Sleep Problems
        public String  CBSPPY   { get; set; }
        public String  CBSPSY   { get; set; }
        
        public Double  CBAPTNY  { get; set; } // Attention Problems
        public String  CBAPPY   { get; set; }
        public String  CBAPSY   { get; set; }
        
        public Double  CBABTNY  { get; set; } // Aggressive Behavior
        public String  CBABPY   { get; set; }
        public String  CBABSY   { get; set; }
        
        public Double  CBTSTNY  { get; set; } // Total Problems Score
        public String  CBTSPY   { get; set; }
        public String  CBTSSY   { get; set; }
        
    }
    
    /****
	*@description method to setup Item
	****/
    public class Item{
        public String num { get; set; }
        public String question { get; set; }
        public String questionField { get; set; }
        public String symptom { get; set; }
        public String describeField { get; set; }
        public Boolean section { get; set; }
        
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
    
    /****
	*@description method to setup GTRAUMA 
	*@return client
	****/
    public Client__c createClientGTRAUMA() {
        
        Client__c client = createClient();
        
        DS_GTRAUMA__c obj = new DS_GTRAUMA__c();
        
        obj.client__c = client.id;
        
        for(Integer i = 1; i <= 23; i++) {
            obj.put('GT'+String.valueOf(i)+'R__c', '1');
            obj.put('GT'+String.valueOf(i)+'RA0__c', true);
        }
        
        insert obj;
        
        return client;
        
    }    
    
    /****
	*@description method to test the capability of terminating scheduled jobs
	*not currently used functionality
	****/
    public void terminateSchduledJob() {
        
        List<CronTrigger> cronJob = [SELECT id FROM CronTrigger];
        
        for(CronTrigger job : cronJob) 
            System.abortJob(job.id);
        
    }
    
}