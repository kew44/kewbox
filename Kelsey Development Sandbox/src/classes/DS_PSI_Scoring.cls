/****
*@description A class to change PSI percentile scores to 0 when corresponding raw score is 999
*
*@date 4/26/15
*@author KW
*
*@group Assessment
*@group-content /ApexDocContent/Assessment/DS_PSI_Scoring.htm
****/

public class DS_PSI_Scoring{

    public Map<String,String> prefixMap = new Map<String, String>();
    
    public SObject delta_PSI(Sobject obj){
    
        //map of prefix and subscale name
        prefixMap.put('DR',  'Defensive Responding');
        prefixMap.put('TS',  'Total Stress');
        prefixMap.put('PD',  'Parental Distress');
        prefixMap.put('PCDI','Parent-Child Dysfunctional Interaction');
        prefixMap.put('DC',  'Difficult Child');
            
        //string of object name
        String thisObject =String.valueOf(obj.getsObjectType());
        
        //B or F function based on object name
        String BorF = (thisObject == 'DS_SDQ_PSI_CDI_B__c') ? 'B' : 'F'; 
        
        //use map as list to iterate for each subscale
        for(String pm : prefixMap.keySet()){
            
            //temp strings for variables
            
            String raw1 = String.valueOf(BorF+'PSI'+pm+'__c');
            Integer rVal1 = Integer.valueOf(obj.get(raw1));
                              
            String p1 = String.valueOf(BorF+'PSI'+pm+'_PTLE__c');
            String p2 = String.valueOf(BorF+'PSI'+pm+'_PTLE2__c');
            
            //if raw score is unknown, assign value of 0 to both percentiles
            if(rVal1 == 999){
                obj.put(p1, 0);
                obj.put(p2, 0);
            }
        }
        return obj;
    }
}