/****
*@description Controller for cocap reporting page
*
*@date 8/10/16
*@author KW
*
****/
public with sharing class COCAP_Controller {

    //utility
    Utility ut = new Utility();
        
    //Client records
    public Client__c client{get;set;}
    
    //DS_DATA records for form information
    public DS_DATA__c data{ get; set; }
    
    //background object records
    public DS_Background_Family_Info_B__c backgroundB{ get; set; }
    public DS_Background_Family_Info_F__c backgroundF{ get; set; }
    
    //cbcl object records
    public DS_CBCL_B__c cbclB{ get; set; }
    public DS_CBCL_F__c cbclF{ get; set; }
    
    //ptsd object records
    public DS_PTSD_CA_B__c ptsdB{ get; set; }
    public DS_PTSD_CA_F__c ptsdF{ get; set; }
    
    //sdq/psi object records
    public DS_SDQ_PSI_CDI_B__c sdqB{ get; set; }
    public DS_SDQ_PSI_CDI_F__c sdqF{ get; set; }
    
    //tscc object records
    public DS_TSCC_TSCYC_B__c tsccB{ get; set; }
    public DS_TSCC_TSCYC_F__c tsccF{ get; set; }
    
    //booleans for if any treatment has occurred within range
    public Boolean hasB{get;set;}
    public Boolean hasF{get;set;}
    
    //beginning and ending quarter dates
    public Date dateBegins{get;set;}
    public Date dateEnds{get;set;}
    
    public COCAP_Controller(ApexPages.StandardController controller) {
    
        //get list of all clients
        List<Client__c> clients = [SELECT id, CURRENT_AGE__c, Age__c
                                   FROM Client__c ];

    }
    
    //List of Quarters
    public List<SelectOption> getQuarterItems(){
    
        List<SelectOption> options = new List<SelectOption>();        
            options.add(new SelectOption('', ''));
            options.add(new SelectOption('1', 'Q1: October 1 - December 31'));
            options.add(new SelectOption('2', 'Q2: January 1 - March 31'));
            options.add(new SelectOption('3', 'Q3: April 1 - June 30'));
            options.add(new SelectOption('4', 'Q4: July 1 - September 30'));
            
        return options;
    }

}