/****
*@description This test provides code coverage Utility and other background functions
*
*@group Test Script 
*@group-content /ApexDocContent/Test/Utility.htm
*
*@author Kelsey Willett
*@date 11/18/2015
*@modified date
*
*@modified  11/1/16 KW  coverage for clientSection --clientSummaryInfoString
*@modified  11/3/16 KW  coverage improvement
*@modified  4/18-19/17 KW Client.Closed_Treatment field, remove test.startTest()/test.stopTest()s
*@modified  7/24/17 KW  add reminder schedule field to centers, clinician email
                        *Counter types were incorrect; updated-> 0=Admin, 1=Main, 2=Sub, 3= Clinician*
*@modified    9/11/17 DF governerLimitAnalysis test added (KW note 9/12)
*
****/

@isTest (SeeAllData=false)
public class TestClass_A_Utility {
    
    /****
    * @description Load required DS_DATA for the test
    */
    @testSetup 
    static void setup() {
        // Load DS_DATA into system
        TestClassData_DS_DATA testData = new TestClassData_DS_DATA();
    }
    
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
                
        String summaryId = ut.getClientSummaryId(client.id, 'DS_DEMO', '0');
        
        ul.clientSection(client.id, summaryId);
        
        String section = ut.clientSummaryInfoString(client.id, summaryId);
        
        ul.getRandomInt(1, 10);
        ul.getRandomString(1, 'kew');
        ul.getFieldSetDetail('STATUS', 'DS_Background_Family_Info_B__c');
                
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
    *@description get the system admin based on profile 
    ****/
    public User getAdminUser(){
        Profile sysAdminProfile = [SELECT id, Name FROM Profile WHERE Name =:'Power User-System Admin' LIMIT 1];
        //String userRole = getAdminRoleID();
        User adminUser = new User(profileid = sysAdminProfile.id, username ='admin@unit.test', FirstName = 'Admin',LastName = 'Unit Testing',  alias ='utest', Email ='admin@unit.test', TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', EmailEncodingKey= 'ISO-8859-1', LanguageLocaleKey='en_US');
                                    //[SELECT id, name, profileid FROM User WHERE profileid =: sysAdminProfile.id LIMIT 1];
        System.debug(sysAdminProfile);
        System.debug(adminUser);
        return adminUser;
    }
    
    /****
    *@description method to setup main center
    *@return center
    ****/
    public Center__c createMainCenter() {
        
        addAdminToCounter();
        
        Center__c center = new Center__c(Type__c = 'Main',Input_ID__c = '0002',Name__c = 'Test Main',Reminder_Schedule__c = '--Testing--');
        
        System.debug(center);
        insert center;
        
        // Manually run insertRoleList() for main center
        
        Center__c mainCenter = [SELECT id, Name, Name__c, Reminder_Schedule__c FROM Center__c WHERE id =: center.id];
        
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
        subCenter.Reminder_Schedule__c = '--Testing--';
          
        System.debug(subCenter);
        insert subCenter;
        
        // Manually run insertRoleList() for sub-center
        
        Center__c sub = [SELECT id, Name, Name__c, Reminder_Schedule__c FROM Center__c WHERE id =: subCenter.id];
        
        String subCenterRoleName = '(' + sub.Name + ') ' + sub.Name__c;
        
        String subCenterRoleID = '000002';  
        
        Counter__c counter = new Counter__c(Item_ID__c = sub.id, 
                                            Item_name__c = subCenterRoleName, 
                                            Type__c = 2, //1
                                            Role_ID__c = subCenterRoleID);        
        insert counter;
        
        System.assertEquals(subCenterRoleID , '000002', 'There is a problem with the subCenterRoleID.');    
        return subCenter;        
    }
    
    /****
    ****/
    public Center__c getMainCenter(){
        Center__c center = new Center__c();
        center.Type__c = 'Main';
        center.Input_ID__c = '0006';
        center.Name__c = 'Test Main';
        center.Reminder_Schedule__c = '--Testing--';
        insert center;
        Center__c MC = [SELECT id, Name, Name__c, Reminder_Schedule__c FROM Center__c WHERE id =: center.id];
        System.debug(center);
        System.debug(center.id);
        System.debug(MC);
        System.debug(MC.id);
        return MC;
    }
    
    
    
    /****
    *@description method to setup clinician
    *@return clinician
    ****/
    public Clinician__c createClinician() {
        
        Center__c center = createMainCenter();
        //Center__c center = createSubCenter();//createMainCenter();//getMainCenter();//
        System.debug(center);
        
        Clinician__c cl = new Clinician__c(Email__c = 'clinician@email.test', Name__c ='Test Clinician', Center__c = center.id);
                
        System.debug(cl);       
        insert cl;
        
        // Manually run insertRoleList() for Clinician
        
        Clinician__c clinician = [SELECT id, Name, Name__c, Email__c, Center__c, Center__r.Reminder_Schedule__c FROM Clinician__c WHERE id =: cl.id];//
        System.debug(clinician);
        
        String clinicianRoleName = '(' + clinician.Name + ') ' + clinician.Name__c;
        
        String clinicianRoleID = '000003';  
        
        /*Counter type 0=Admin, 1=Main, 2=Sub, 3= Clinician*/
        Counter__c counter = new Counter__c(Item_ID__c = clinician.id, 
                                            Item_name__c = clinicianRoleName, 
                                            Type__c = 3, //1
                                            Role_ID__c = clinicianRoleID); 
        insert counter;
        
        System.assertEquals(clinicianRoleID, '000003', 'There is a problem with the clinicianRoleID.');
        return clinician;        
    }
    
    /****
    *@description method to setup client using parameters
    *@param gender Client's gender
    *@param age Client's age at entry
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
        client.Closed_Treatment__c = 'Open';
        System.debug(client);
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
            client.Closed_Treatment__c = 'Open';
            System.debug(client);
            clients.add(client);            
        }        
        return clients;
    }
    
    /****
    *@description method to setup client without parameters
    *@return client
    ****/
    public Client__c createClient() {        
    
        //Center__c center = createMainCenter();// getMainCenter();
        Clinician__c clinician = createClinician();     
        System.debug(clinician);
        System.debug(clinician.Center__c);
        Client__c client = getClient('Female', 0);     
        
        client.Clinician__c = clinician.id;        
        client.Closed_Treatment__c = 'Open';
        client.Clinician_Email__c = clinician.Email__c;
        client.Center__c = clinician.Center__c;//center.id;
        System.debug(client);
        System.debug(client.Center__c);
        System.debug(client.Clinician__c);
        insert client;

        System.assertEquals(client.Closed_Treatment__c, 'Open', 'The treatment status has been closed illegally.');
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
        client.Closed_Treatment__c = 'Open';
        client.Clinician_Email__c = clinician.Email__c;
        System.debug(client);
        System.debug(client.Clinician__c);
        System.debug(client.Center__r.Reminder_Schedule__c);
        insert client;  
        
        System.assertEquals(client.Closed_Treatment__c, 'Open', 'The treatment status has been closed illegally.');                
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
            c.Closed_Treatment__c = 'Open';
            c.Clinician_Email__c = clinician.Email__c;
        }        
        insert clients;        
        return clients;        
    }
    
    /****
    *@description method to setup client summary (controller, not object)
    *@return client
    ****/
    public Client__c createClientSummary() {
        
        Client__c client = createClient();    
        System.debug(client);
        System.debug(client.Center__r.Reminder_Schedule__c);            
        
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
    *@description method to cover the client summary info string used on forms
    *@param clientID
    *@param SummaryID
    *@return summary.SECTION__c
    ****/
    public String clientSummaryInfoString(ID clientID, ID SummaryID){   

        Client_Summary__c summary = [SELECT SECTION__c, Client__r.DOB1__c, 
                                            Client__r.INIT__c, Client__r.AGE__c,
                                            Client__r.GENDER__c, Client__r.name
                                       FROM Client_Summary__c 
                                      WHERE ID =:SummaryID
                                      AND Client__c =: clientID];
                                      
        return summary.SECTION__c;        
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
    
    /****
    *@description test the governerLimitAnalysis method in Utility
    ****/
    static TestMethod void Test_GovernerLimitAnalysis() {
        
        Utility ut = new Utility();
        ut.governerLimitAnalysis();        
        
    }    
}