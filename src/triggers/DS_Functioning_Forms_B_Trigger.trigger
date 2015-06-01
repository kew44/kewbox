trigger DS_Functioning_Forms_B_Trigger on DS_Functioning_Forms_B__c  (before insert, before update, after insert, after delete, after update) {
  
 Utility ut = new Utility();

    List<DS_DATA__c> functiondata = [Select Data_Type__c, Content__c, Page__c, Variable__c,Object__c
                             FROM DS_DATA__c
                             WHERE Data_Type__c = 'DS_Form_Info'
                             AND Object__c = 'DS_Functioning_Forms_B'
                            // AND Form__c = 'DS_FAPGAR'
                             ];
                             
Map<String, List<DS_DATA__c>> functioningInfo = new Map<String, List<DS_DATA__c>>();  

 List<DS_DATA__c> fapgarList = new List<DS_DATA__c>();
  
  functioningInfo.put('FAPGAR',fapgarList);
  //////////////////////////////////////////////////
   List<String> clientIDs = new List<String>();

if(Trigger.isBefore) {

    Map<Integer, Integer> Scoring= new Map<Integer, Integer>();
    for(DS_Functioning_Forms_B__c FAPGAR: Trigger.new){
        clientIDs.add(FAPGAR.Client__c);
    }
        Map<Id, Client__c> clientInfo = new Map<Id, Client__c>([SELECT id, Gender__c, AGE__c
                                                                FROM Client__c
                                                                WHERE id IN : clientIDs]);
  //////////////////////////////////////////////////
for(DS_Functioning_Forms_B__c FAPGAR: Trigger.new){
  //  Client__c client = clientInfo.get(FAPGAR.Client__c);
    //alias variables
    Integer RawScore = 0;
    Integer fg1 =0;
    Integer fg2 = 0;
    Integer fg3 =0;
    Integer fg4 = 0;
    Integer fg5 = 0;
    String met = 'Not Met';
    Integer nullCount = 0;
    
     //nonnull, 99 not added to raw
     if( FAPGAR.BFAPGAR1__c == null)
        {fg1=0;nullCount++;}
            else if ( FAPGAR.BFAPGAR1__c == '99')
                {fg1=0;}
                    else{fg1 = Integer.valueOf(FAPGAR.BFAPGAR1__c);}
     if( FAPGAR.BFAPGAR2__c == null)
        {fg2=0;nullCount++;}
            else if( FAPGAR.BFAPGAR2__c == '99')
                {fg2=0;}
                    else{fg2 = Integer.valueOf(FAPGAR.BFAPGAR2__c);}
     if( FAPGAR.BFAPGAR3__c == null)
        {fg3=0;nullCount++;}
            else if( FAPGAR.BFAPGAR3__c == '99')
                {fg3=0;}
                    else{fg3 = Integer.valueOf(FAPGAR.BFAPGAR3__c);}
     if( FAPGAR.BFAPGAR4__c == null)
        {fg4=0;nullCount++;}
            else if( FAPGAR.BFAPGAR4__c == '99')
                {fg4=0;}
                    else{fg4 = Integer.valueOf(FAPGAR.BFAPGAR4__c);}
     if( FAPGAR.BFAPGAR5__c == null)
        {fg5=0;nullCount++;}
            else if( FAPGAR.BFAPGAR5__c == '99')
                {fg5=0;}
                    else{fg5 = Integer.valueOf(FAPGAR.BFAPGAR5__c);}
        
        //total
        RawScore=fg1+fg2+fg3+fg4+fg5;       
        
        if (RawScore >= 5 && RawScore <= 10)
            {met = 'Met';}
            FAPGAR.BFAPGAR_MET__c = met;
        FAPGAR.BFAPGAR_RAW__c = RawScore;
        //nullCount?
   }
 }
 //else if(Trigger.isAfter)
//  ut.updateSummaryStatus(Trigger.new, NULL, 'STATUS__c');


  if(Trigger.isAfter) { 

    ut.updateSummaryStatusForMergedObject(Trigger.new);

    /*AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
  
    if(Trigger.isInsert) { audit.generateLog(Trigger.new, Trigger.old); }
    if(Trigger.isUpdate) { audit.generateLog(Trigger.new, Trigger.old); }*/

  }
}