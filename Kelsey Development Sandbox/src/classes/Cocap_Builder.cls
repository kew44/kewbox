/****
*@description another cocap mockup
*
*@date    2/15/17
*@author    KW
*
*@group Cocap Builder
*@group-content /ApexDocContent/Cocap_Builder.htm
****/
public class Cocap_Builder{
    
    //gender
    public Integer countGenMale{get;set;}
    public Integer countGenFemale{get;set;}
    public Integer countGenTrans{get;set;}
    public Integer countGenOther{get;set;}
    public Integer countGenRef_Unk{get;set;}
    public Integer countGenMissing{get;set;}
   
   //start w/ genderclass construction
    public class genderClass{
      
        public String cid{get;set;}
        
        public String genIdentity{get;set;}        
        
        public Boolean genMale{get;set;}
        public Boolean genFemale{get;set;} 
        public Boolean genTrans{get;set;}
        public Boolean genOther{get;set;} 
        public Boolean genUnknown{get;set;}
        public Boolean genMissing{get;set;}   
        
        //initialize counts to 0
        Integer countGenMale=0;
        Integer countGenFemale=0;
        Integer countGenTrans=0;
        Integer countGenOther=0;
        Integer countGenRef_Unk=0;
        Integer countGenMissing=0;     
        
        
        public genderClass(List<Client__c> clients, List<DS_Background_Family_Info_B__c> backgroundBs){
            
            String cid;
            
            String genIdentity;
            genMale= FALSE;
            genFemale= FALSE;
            genTrans= FALSE;
            genOther= FALSE;
            genUnknown= FALSE;
            genMissing= FALSE;                        
            
            for(Client__c c: clients){
                
                cid = String.valueOf(c.id);
                
                for(DS_Background_Family_Info_B__c b: backgroundBs){              
                                
                    String bid = String.valueOf(b.Client__c);
                    System.debug(bid);
                    
                    if(bid ==cid){ 
                            
                           Integer genId = Integer.valueOf(b.get('BIDENT__c'));
                               
                            if(genId == 1){
                                genIdentity = 'Male';
                                genMale = TRUE;
                                countGenMale = countGenMale +1;
                            }
                            else if(genId == 2){
                                genIdentity = 'Female';
                                genFemale = TRUE;
                                countGenFemale = countGenFemale +1;
                            }
                            else if((genId == 3) || (genId == 4)){
                                genIdentity = 'Transgender';
                                genTrans = TRUE;
                                countGenTrans = countGenTrans+1;
                            }
                            else if(genId == 98){
                                genIdentity = 'Other';
                                genOther = TRUE;
                                countGenOther = countGenOther+1;
                            }
                            else if((genId == 96) || (genId == 99)){
                                genIdentity = 'Unknown or declined to provide';
                                genUnknown = TRUE;
                                countGenRef_Unk=countGenRef_Unk+1;
                            }
                            else{
                                genIdentity = 'Gender Identity is Missing';
                                genMissing = TRUE;
                                countGenMissing = countGenMissing+1;
                            }
                            
                            this.cid = bid;
                            this.genIdentity = genIdentity; 
                            this.genMale = genMale ; 
                            this.genFemale = genFemale ; 
                            this.genTrans = genTrans ; 
                            this.genOther = genOther ; 
                            this.genUnknown = genUnknown ; 
                            this.genMissing = genMissing ;                     
                        }       
                 }
                 
                System.debug(countGenMale);
                System.debug(countGenFemale);
                System.debug(countGenTrans);
                System.debug(countGenOther);
                System.debug(countGenRef_Unk);
                System.debug(countGenMissing);
            } 
            System.debug(countGenMale);
            System.debug(countGenFemale);
            System.debug(countGenTrans);
            System.debug(countGenOther);
            System.debug(countGenRef_Unk);
            System.debug(countGenMissing);
            
           // System.debug(genderClass);
         //   return genderClass();
      //   return null;
    }
}
}