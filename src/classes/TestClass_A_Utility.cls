@isTest (SeeAllData=false)
public class TestClass_A_Utility {

    public TestClass_A_Utility() {}
    
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
    
    public void addAdminToCounter() {
        
        UserRole role = [SELECT id FROM UserRole WHERE Name = 'Administrator'];
        
        Counter__C counter = new Counter__C(Type__c = 0, Item_Name__c = 'administrator', 
                                            Role_ID__c = role.id);
        
        insert counter;
        
        
    } 
    
    public String getAdminRoleID() {
        UserRole role = [SELECT id FROM UserRole WHERE Name = 'Administrator'];
        return role.id;
    }
    
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
    
    public Client__c createClient() {
                
        Clinician__c clinician = createClinician();
                
        Client__c client = getClient('Female', 0);
        
        client.Clinician__c = clinician.id;
        
        insert client;
        
        return client;
        
    }
    
    public Client__c createClient(Client__c client) {
                
        Clinician__c clinician = createClinician();
        
        client.Clinician__c = clinician.id;
        
        System.debug(client);
        System.debug(client.AGE__c);
        
        insert client;
        
        return client;
        
    }
    
    public String addNewFollowupVisit(Client__c client) {

        Set<String> clients = new Set<String>();
        
        clients.add(client.id);
        
        System.debug(clients);
        
        String followupInfoSummaryId = FormBuilder.followup(clients);
        
        system.debug(followupInfoSummaryId);
        
        Client_Summary__c summary = [SELECT id, SECTION__c 
                                       FROM Client_summary__c
                                      WHERE client__c = :client.Id
                                        AND id = : followupInfoSummaryId];
        
        System.debug(summary);
        
        return summary.SECTION__c;

    }
    
    public String getClientSummaryId(String clientId, String form, String section) {
        
        system.debug(section);
        
        List<Client_Summary__c> lists = [SELECT id, Page__r.Form__c, section__c from Client_summary__c where client__c =: clientid];
        
        for(Client_summary__c s : lists) {
            System.debug(s.id+'-'+s.Page__r.form__c+'-'+s.section__c);
        }
        
        Client_Summary__c summary = [SELECT id 
                                       FROM Client_Summary__c 
                                      WHERE client__c =:clientid
                                        AND Page__r.form__c = :form
                                        AND SECTION__c = :section];
        
        return summary.id;
        
    }
       
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
    
    public Client__c createClientPTSD_CA_B() {
                
        Client__c client = createClient();
        
        DS_PTSD_CA_B__c obj = new DS_PTSD_CA_B__c();
        
        obj.client__c = client.id;
        
        obj.BMETPTSD__c = '1';
        
        obj.BPTSV1__c = obj.BPTSV2__c = obj.BPTSV3__c = obj.BPTSV4__c = '1';
        obj.BPTSV6__c = obj.BPTSV7__c = obj.BPTSV8__c = obj.BPTSV9__c = obj.BPTSV10__c = '4';
        obj.BPTSV11__c = obj.BPTSV12__c = obj.BPTSV13__c = obj.BPTSV14__c = obj.BPTSV15__c = '4';
        obj.BPTSV16__c = obj.BPTSV17__c = obj.BPTSV18__c = obj.BPTSV19__c = obj.BPTSV20__c ='2';
        obj.BPTSV21__c = obj.BPTSV22__c = obj.BPTSV23__c = obj.BPTSV24__c = obj.BPTSV25__c ='3';
        obj.BPTSV26__c = obj.BPTSV27__c = obj.BPTSV28__c = obj.BPTSV29__c = obj.BPTSV30__c ='1';
        
        insert obj;
        
        return client;
    }
    
    public Client__c createClientCBCL() {
                
        Client__c client = createClient();
        
        DS_CBCL_B__c obj = new DS_CBCL_B__c();
        
        obj.client__c = client.id;
        
        insert obj;
        
        return client;
    }
    
    public Client__c createClientSDQO(){
                
        Client__c client = createClient(getClient('Female', 14)); 
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c();
        
        obj.client__c = client.id;
        //obj.Form__c = 'DS_SDQ_P_04_10';
        
        obj.BDOASDYP__c =date.parse('10/30/2014');
        obj.BDOASDOP__c =date.parse('10/30/2014');
        obj.BDOASDOS__c =date.parse('10/30/2014');
        
        obj.BSDPTYP__c='Clinical';
        obj.BSDPETYP__c='Clinical';
        obj.BSDPBTYP__c='Clinical';
        obj.BSDPHTYP__c='Clinical';
        obj.BSDPOTYP__c='Clinical';
        obj.BSDPKTYP__c='Clinical';
        obj.BSDPITYP__c='Clinical';
        
        obj.BSDSTYP__c='Clinical';
        obj.BSDSETYP__c='Clinical';
        obj.BSDSBTYP__c='Clinical';
        obj.BSDSHTYP__c='Clinical';
        obj.BSDSOTYP__c='Clinical';
        obj.BSDSKTYP__c='Clinical';
        obj.BSDSITYP__c='Clinical';
        
        obj.BMETSDOP__c = '1';
        obj.BMETSDOS__c = '1';
        obj.BMETSDYP__c = '1';
        
        insert obj;
        
        return client;
        
    }
    public Client__c createClientSDQY(){
                
        Client__c client = createClient(getClient('Female', 5)); 
        
        DS_SDQ_PSI_CDI_B__c obj = new DS_SDQ_PSI_CDI_B__c();
        
        obj.client__c = client.id;
        obj.BDOASDYP__c =date.parse('10/30/2014');
        obj.BDOASDOP__c =date.parse('10/30/2014');
        obj.BDOASDOS__c =date.parse('10/30/2014');
        
        obj.BSDPTYP__c='Clinical';
        obj.BSDPETYP__c='Clinical';
        obj.BSDPBTYP__c='Clinical';
        obj.BSDPHTYP__c='Clinical';
        obj.BSDPOTYP__c='Clinical';
        obj.BSDPKTYP__c='Clinical';
        obj.BSDPITYP__c='Clinical';
        
        obj.BSDSTYP__c='Clinical';
        obj.BSDSETYP__c='Clinical';
        obj.BSDSBTYP__c='Clinical';
        obj.BSDSHTYP__c='Clinical';
        obj.BSDSOTYP__c='Clinical';
        obj.BSDSKTYP__c='Clinical';
        obj.BSDSITYP__c='Clinical';
        
        obj.BMETSDOP__c = '1';
        obj.BMETSDOS__c = '1';
        obj.BMETSDYP__c = '1';
        
        insert obj;
        
        return client;
    }
    
    public void terminateSchduledJob() {
        
        List<CronTrigger> cronJob = [SELECT id FROM CronTrigger];
        
        system.debug(cronJob);
        
        for(CronTrigger job : cronJob) 
            System.abortJob(job.id);
        
    }
    
}