/****
*@description Controller for the Strategic Reporting page
*
*@date 10/13/16
*@author KW
*
*@modified    12/1-2/16    KW more building
*
*@modified    1/12/17-1/13    KW ?
*@modified    1/23/17    KW    date filter class-->CoCap_Report_Filter_Controller 
*
*@group StrategicReports
*@group-content /ApexDocContent/StrategicReports/Report_Controller.htm
****/
public with sharing class Report_Controller{
    
    public Date DateStart{get;set;}
    public Date DateEnd{get;set;}
    
    public Report_Controller(ApexPages.StandardController controller) {    
    
        String Role = String.valueOf(userrole.name);    
    
        //start queries
        List<Client__c> clients = [SELECT AGE__c, CURRENT_AGE__c, Center__c, Clinician__c 
                                    FROM Client__c];
                                    
        System.debug(clients);
                                    
        List<Strategic_Reports__c> reportRecords = [SELECT
                                                        Client__c,
                                                        //age info
                                                        Age_Current_Age__c,
                                                        Age_Group__c,
                                                        Age_Group_0_4__c, Age_Group_5_9__c, Age_Group_10_12__c, Age_Group_13_17__c, Age_Group_18_21__c,
                                                        //gender info
                                                        Gender_Identity__c,
                                                        Gender_Female__c, Gender_Male__c, Gender_Missing__c, Gender_Other__c, Gender_Refused_or_Unknown__c, Gender_Transgender__c,
                                                        //ethnicity info
                                                        Ethnic_Group__c,
                                                        Ethnicity_Hispanic_or_Latino__c, Ethnicity_Missing__c, Ethnicity_Non_Hispanic__c, Ethnicity_Refused_or_Unknown__c,
                                                        //race info
                                                        Race__c,
                                                        Race_American_Indian_or_Alaskan_Native__c, Race_Asian__c, Race_Black_African_American__c, Race_Multiracial__c, Race_Native_Hawaiian_or_Pacific_Islander__c, Race_Refused_or_Unknown__c, Race_White__c,
                                                        //military info
                                                        Military_Associated__c, 
                                                        //services info
                                                        Treatment_Completed_as_Planned__c, Treatment_Ended__c, Treatment_Missing__c 
                                                    FROM Strategic_Reports__c
                                                    WHERE Client__c IN:clients
                                                    ];                     
                                                    System.debug(reportRecords);
                                                    System.debug(reportRecords.size());
                          
        System.debug(reportRecords);
        Map<String,Boolean> tfMap = new Map<String,Boolean>();
                          
        for(Strategic_Reports__c r: reportRecords){
            tfMap.put('0-4', r.Age_Group_0_4__c);
            tfMap.put('5-9', r.Age_Group_5_9__c);
            tfMap.put('10-12', r.Age_Group_10_12__c);
            tfMap.put('13-17', r.Age_Group_13_17__c);
            tfMap.put('18-21', r.Age_Group_18_21__c);
            tfMap.put('female', r.Gender_Female__c);
            tfMap.put('male', r.Gender_Male__c);
            tfMap.put('gender missing', r.Gender_Missing__c);
            tfMap.put('gender other', r.Gender_Other__c);
            tfMap.put('gender refused', r.Gender_Refused_or_Unknown__c);
            tfMap.put('hispanic', r.Ethnicity_Hispanic_or_Latino__c);
            tfMap.put('non-hispanic', r.Ethnicity_Non_Hispanic__c);
            tfMap.put('ethnicity refused', r.Ethnicity_Refused_or_Unknown__c);
            tfMap.put('ethnicity missing', r.Ethnicity_Missing__c);
            tfMap.put('native', r.Race_American_Indian_or_Alaskan_Native__c);
            tfMap.put('asia', r.Race_Asian__c);
            tfMap.put('black', r.Race_Black_African_American__c);
            tfMap.put('island', r.Race_Native_Hawaiian_or_Pacific_Islander__c);
            tfMap.put('white', r.Race_White__c);
            tfMap.put('race refused', r.Race_Refused_or_Unknown__c);
            tfMap.put('multi', r.Race_Multiracial__c);
            tfMap.put('military', r.Military_Associated__c);
          //  tfMap.put('military missing', r.Military_Missing__c);
            tfMap.put('ended', r.Treatment_Ended__c);
            tfMap.put('as planned', r.Treatment_Completed_as_Planned__c);
            tfMap.put('treatment missing', r.Treatment_Missing__c);            
        }                                            
        System.debug(tfMap);
                                       
    }
    public pageReference enterStartDate(){
        DateStart = Date.valueOf(Strategic_Reports__c.DateStart__c);
        System.debug(DateStart);
        return null;
    }
    public pageReference enterEndDate(){
        DateEnd = Date.valueOf(Strategic_Reports__c.DateEnd__c);
        System.debug(DateEnd);
        return null;
    }
    public PageReference runCoCap(){
        enterStartDate();
        enterEndDate();
        return null;
    }

}