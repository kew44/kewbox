/****
*@description A class to change TSCC-A and/or TSCYC t-scores to 0 when corresponding raw score is 999
*
*@date 6/22/16
*@author KW
*
*@modified	6/24/16		KW	RL,ATR,UND,HYP added to maps	
*
*@group Assessment
*@group-content /ApexDocContent/Assessment/DS_TSCC_TSCYC_Scoring.htm
****/

public class DS_TSCC_TSCYC_Scoring{

    public Map<String,String> tsccPMap = new Map<String, String>();
    public Map<String,String> tscycPMap = new Map<String, String>();
    		
    public SObject delta_TSCC(Sobject obj){
	
		//string of object name
		String thisObject =String.valueOf(obj.getsObjectType());
		
		//B or F function based on object name
		String BorF = (thisObject == 'DS_TSCC_TSCYC_B__c') ? 'B' : 'F'; 
		
        //map of prefix and subscale name
        tsccPMap.put('N' ,'Underresponse');
        tsccPMap.put('HY','Hyperresponse');
        tsccPMap.put('AX','Anxiety');
        tsccPMap.put('DP','Depression');
        tsccPMap.put('AG','Anger');
        tsccPMap.put('PT','Post-Traumatic Stress');
        tsccPMap.put('DS','Dissociation');
        tsccPMap.put('OD','Overt Dissociation');
        tsccPMap.put('FN','Fantasy');		
		
        //use map as list to iterate for each subscale
        for(String pm : tsccPMap.keySet()){
            String raw1;
            
			//temp strings for variables			
			if(pm =='AG'){
				//exception for anger variable name construct
				raw1 = String.valueOf(BorF+'TSC'+pm+'G__c');
			}
			else if(pm =='N'){
				//exception for underresponse variable name construct
				raw1 = String.valueOf(BorF+'TSCU'+pm+'N__c');
			}
			else{
				raw1 = String.valueOf(BorF+'TSC'+pm+'N__c');
			}
            Integer rVal1 = Integer.valueOf(obj.get(raw1));
                              
            String t1 = String.valueOf(BorF+'TSC'+pm+'TN__c');
            String t2 = String.valueOf(BorF+'TSC'+pm+'TN2__c');
            
            //if raw score is unknown, assign value of 0 to both t-scores
            if(rVal1 == 999){
                obj.put(t1, 0);
                obj.put(t2, 0);
            }
        }
        return obj;
	}
	
    public SObject delta_TSCYC(Sobject obj){
	
		//string of object name
		String thisObject =String.valueOf(obj.getsObjectType());
		
		//B or F function based on object name
		String BorF = (thisObject == 'DS_TSCC_TSCYC_B__c') ? 'B' : 'F'; 
		
        //map of prefix and subscale name
        tscycPMap.put('RL','Response Level');
        tscycPMap.put('ATR','Atypical Response');
        tscycPMap.put('PTSTOT','Posttraumatic Stress-Total');
        tscycPMap.put('ANX','Anxiety');
        tscycPMap.put('DEP','Depression');
        tscycPMap.put('ANG','Anger');
        tscycPMap.put('SC','Sexual Concerns');
        tscycPMap.put('DIS','Dissociation');
        tscycPMap.put('PTSI','Posttraumatic Stress-Intrusion');
        tscycPMap.put('PTSAV','Posttraumatic Stress-Avoidance');
        tscycPMap.put('PTSAR','Posttraumatic Stress-Arousal');
		
        //use map as list to iterate for each subscale
        for(String pm : tscycPMap.keySet()){
            
            //temp strings for variables
            String raw1 = String.valueOf(BorF+pm+'_R__c');
            Integer rVal1 = Integer.valueOf(obj.get(raw1));
                              
            String t1 = String.valueOf(BorF+pm+'_T__c');
            String t2 = String.valueOf(BorF+pm+'_T2__c');
            
            //if raw score is unknown, assign value of 0 to both t-scores
            if(rVal1 == 999){
                obj.put(t1, 0);
                obj.put(t2, 0);
            }
        }
        return obj;
	}
}