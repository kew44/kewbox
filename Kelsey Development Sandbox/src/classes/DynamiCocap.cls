public with sharing class DynamiCocap {

    //soql query for custom reporting object
    public String crSOQL{get;set;}
    
    //lists of records from all main objects
    public List<Client__c> clients {get;set;}
    public List<DS_Background_Family_Info_B__c> backBs{get;set;}
    public List<DS_Background_Family_Info_F__c> backFs{get;set;}
    public List<DS_CBCL_B__c> cbclBs{get;set;}
    public List<DS_CBCL_F__c> cbclFs{get;set;}
    public List<DS_PTSD_CA_B__c> ptsdBs{get;set;}
    public List<DS_PTSD_CA_F__c> ptsdFs{get;set;}
    public List<DS_SDQ_PSI_CDI_B__c> sdqBs{get;set;}
    public List<DS_SDQ_PSI_CDI_F__c> sdqFs{get;set;}
    public List<DS_TSCC_TSCYC_B__c> tsccBs{get;set;}
    public List<DS_TSCC_TSCYC_F__c> tsccFs{get;set;}
    
    public Date startDate{get;set;}
    public Date endDate{get;set;}

    public DynamiCocap(ApexPages.StandardController controller) {
    
        String Role = String.valueOf(userrole.name);
    }

}