/**
* @author Kelsey Willett
* @date 2/23/17
*
* @group Cocap Demographics
* @group-content /ApexDocContent/CocapDemographics.htm
*
* @description An apex class to process cocap 
*/
public class CocapDemographics {
    //start and end dates
    public Date StartDate{get;set;}
    public Date EndDate{get;set;}
    public List<Date> dateRange{get;set;}
    
    //querries
    public List<Client__c> clients{get;set;}
    public List<DS_Background_Family_Info_B__c> backgroundBs{get;set;}
    
    //init Maps
    public Map<String, Integer> genderMap{get;set;}
    public Map<String, Integer> ageMap{get;set;}
    public Map<String, Integer> ethnicMap{get;set;}
    public Map<String, Integer> raceMap{get;set;}
            
    public void getGender(List<DS_Background_Family_Info_B__c> backgroundBs){
        
        //initialize counts to 0
        Integer countGenMale=0;
        Integer countGenFemale=0;
        Integer countGenTrans=0;
        Integer countGenOther=0;
        Integer countGenRef_Unk=0;
        Integer countGenMissing=0;   
        
        Map<String, Integer> genderCounts = new Map<String, Integer>();
        
        for(DS_Background_Family_Info_B__c b: backgroundBs ){
            if((b.BDOV__c >= StartDate) && (b.BDOV__c <= EndDate)){  
            
                //genderParsing
                Integer genId = Integer.valueOf(b.get('BIDENT__c'));
                
                if(genId == 1){
                    countGenMale = countGenMale +1;
                }
                else if(genId == 2){
                    countGenFemale = countGenFemale +1;
                }
                else if((genId == 3) || (genId == 4)){
                    countGenTrans = countGenTrans+1;
                }
                else if(genId == 98){
                    countGenOther = countGenOther+1;
                }
                else if((genId == 96) || (genId == 99)){
                    countGenRef_Unk=countGenRef_Unk+1;
                }
                else{
                    countGenMissing = countGenMissing+1;
                }
                //end gender
                
            }
        }
        genderCounts.put('Male',countGenMale);
        genderCounts.put('Female',countGenFemale );
        genderCounts.put('Transgender',countGenTrans);
        genderCounts.put('Other',countGenOther);
        genderCounts.put('Unknown or declined to provide',countGenRef_Unk);
        genderCounts.put('Gender Identity is Missing',countGenMissing);
        System.debug(genderCounts);
        }
    }