trigger DS_Background_Family_Info_F_Trigger on DS_Background_Family_Info_F__c (before insert, after insert, after delete, after update) {

  Utility ut = new Utility();  
  

  if(Trigger.isAfter) { 

    ut.updateSummaryStatusForMergedObject(Trigger.new);
  
   // FormBuilder.MilitaryRefugeHealthDisplayLogic(Trigger.new);

    /*AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
  
    if(Trigger.isInsert) { audit.generateLog(Trigger.new, Trigger.old); }
    if(Trigger.isUpdate) { audit.generateLog(Trigger.new, Trigger.old); }*/

  }
  
}
/*
     List<DS_DATA__c> formInfo = [SELECT Category__c, Content__c, 
                                      Variable__c, Page__c 
                                 FROM DS_DATA__c 
                                  WHERE Category__c = 'FollowUp'
                                  AND Data_Type__c = 'DS_Form_Info' 
                             ORDER BY weight__c];  
  
  List<Client_Summary__c> newSummaryList = new List<Client_Summary__c>();

  if(Trigger.isInsert && Trigger.isAfter){ 
        
    for(DS_Background_Family_Info_F__c u: Trigger.new) {    

      for(DS_DATA__c f : formInfo) {
      
          Client_Summary__c newSummary = 
            new Client_Summary__c(client__c = u.client__c, Page__c = f.id, 
                                  FORM_TYPE__c = f.Category__c, SECTION__c = '1');

          newSummary.REQUIRED__c = true;

          newSummaryList.add(newSummary);
  }
  u.Visit_Number__c += u.Visit_Number__c;
  }   

    if(newSummaryList.size() > 0) insert newSummaryList;

  }
  
  if(Trigger.isUpdate && Trigger.isBefore) {

    String fuFields = ut.getFields('DS_Background_Family_Info_F__c');
    
    Set<String> needUpdateformIDList = new Set<String>();

    Set<String> clientAddForm = new Set<String>();

    List<String> fuID = new List<String>();

    List<String> clientIDList = new List<String>();

    for(DS_Background_Family_Info_F__c f: Trigger.new) {
        fuID.add('\''+f.id+'\'');
        clientIDList.add(f.Client__c);
    }

    Map<ID, DS_Background_Family_Info_F__c> oldFUDataList = new Map<Id, DS_Background_Family_Info_F__c>( 
        (List<DS_Background_Family_Info_F__c>)
            Database.query('SELECT ' + fuFields +  
                           '  FROM DS_Background_Family_Info_F__c' +
                           ' WHERE id IN ('+StringUtils.joinArray(fuID, ',')+')')
    );
  
    for(DS_Background_Family_Info_F__c f: Trigger.new) {

      DS_Background_Family_Info_F__c oldFUData = oldFUDataList.get(f.id);

      for(DS_DATA__c d : formInfo) {

        Boolean formUpdated = false;
        String var = '';


          if( oldFUData.get(var) == false && f.get(var) == true )
              formUpdated = true;                 

          if(formUpdated == true) {

              needUpdateformIDList.add(d.id);
              clientAddForm.add(f.client__c+'_'+d.id);
              }
              }
              }
          
    List<Client_Summary__c> updateSummaryList = new List<Client_Summary__c>();

    List<Client_Summary__c> fuSummary = [SELECT id, Client__c, Page__c 
                                           FROM Client_Summary__c
                                          WHERE client__c IN :clientIDList
                                            AND Page__c IN :needUpdateformIDList];    
  
    for(Client_Summary__c fu : fuSummary) {

      String client_Form = fu.Client__c+'_'+fu.Page__c;
      
      if(clientAddForm.contains(client_Form)) {
          fu.STATUS__c = null;
          updateSummaryList.add(fu);
          clientAddForm.remove(client_Form);
      }

    }
    
    for(String cf : clientAddForm) {

      List<String> content = cf.split('_');

      Client_Summary__c newSummary = 
          new Client_Summary__c(client__c = content.get(0), 
                                Page__c = content.get(1), 
                                FORM_TYPE__c = 'FollowUp', 
                                SECTION__c = '1');
                                
      newSummary.REQUIRED__c = true;

      newSummaryList.add(newSummary);

    }

    if(updateSummaryList.size() > 0) update updateSummaryList;
    if(newSummaryList.size() > 0) insert newSummaryList;

  }
  if(Trigger.isAfter) { 

  
    FormBuilder.startFollowUp(Trigger.new);
  
    AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
  
    if(Trigger.isInsert) { audit.generateLog(Trigger.new, Trigger.old); }
    if(Trigger.isUpdate) { audit.generateLog(Trigger.new, Trigger.old); }
    }
}*/