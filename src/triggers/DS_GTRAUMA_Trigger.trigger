trigger DS_GTRAUMA_Trigger on DS_GTRAUMA__c (before insert, before update, after insert, after update) {

  Utility ut = new Utility();

  List<DS_DATA__c> formInfo = [SELECT Category__c, Content__c, 
                                      Variable__c, Page__c 
                                 FROM DS_DATA__c 
                                WHERE Category__c = 'TD'
                                  AND Data_Type__c = 'DS_Form_Info' 
                                  AND weight__c != 23
                             ORDER BY weight__c];

  List<Client_Summary__c> newSummaryList = new List<Client_Summary__c>();

  if(Trigger.isInsert && Trigger.isAfter){ 
        
    for(DS_GTRAUMA__c g: Trigger.new) {

      for(DS_DATA__c f : formInfo) {

        if(g.get(f.Variable__c+'__c') == '1' || g.get(f.Variable__c+'__c') == '2') {

          Client_Summary__c newSummary = 
            new Client_Summary__c(client__c = g.client__c, Page__c = f.id, 
                                  FORM_TYPE__c = f.Category__c, SECTION__c = '-1');

          newSummary.REQUIRED__c = true;

          newSummaryList.add(newSummary);

          }

      }

    }

    if(newSummaryList.size() > 0) insert newSummaryList;

  }
  
  if(Trigger.isUpdate && Trigger.isBefore) {

    String gtFields = ut.getFields('DS_GTRAUMA__c');

    Set<String> needUpdateformIDList = new Set<String>();

    Set<String> clientAddForm = new Set<String>();

    List<String> gtID = new List<String>();

    List<String> clientIDList = new List<String>();

    for(DS_GTRAUMA__c g: Trigger.new) {
        gtID.add('\''+g.id+'\'');
        clientIDList.add(g.Client__c);
    }

    Map<ID, DS_GTRAUMA__c> oldGTDataList = new Map<Id, DS_GTRAUMA__c>( 
        (List<DS_GTRAUMA__c>)
            Database.query('SELECT ' + gtFields +  
                           '  FROM DS_GTRAUMA__c' +
                           ' WHERE id IN ('+StringUtils.joinArray(gtID, ',')+')')
    );


    for(DS_GTRAUMA__c g: Trigger.new) {

      DS_GTRAUMA__c oldGTData = oldGTDataList.get(g.id);

      for(DS_DATA__c f : formInfo) {

        Boolean formUpdated = false;
        String var = '';

        if(g.get(f.Variable__c+'__c') == '1' || g.get(f.Variable__c+'__c') == '2') {

          // Age 0 ~ 18
          for(Integer i = 0; i <= 18; i++) {

              var = f.Variable__c+'A'+i+'__c';

              if( oldGTData.get(var) == false && g.get(var) == true )
                          formUpdated = true;   

          }

          // Unknown
          var = f.Variable__c+'AU__c';

          if( oldGTData.get(var) == false && g.get(var) == true )
              formUpdated = true;                 

          if(formUpdated == true) {

              needUpdateformIDList.add(f.id);
              clientAddForm.add(g.client__c+'_'+f.id);

          }   

        }

      }

    }

    List<Client_Summary__c> updateSummaryList = new List<Client_Summary__c>();

    List<Client_Summary__c> tdSummary = [SELECT id, Client__c, Page__c 
                                           FROM Client_Summary__c
                                          WHERE client__c IN :clientIDList
                                            AND Page__c IN :needUpdateformIDList];

    // Check all the td record in summary
    for(Client_Summary__c td : tdSummary) {

      String client_Form = td.Client__c+'_'+td.Page__c;

      // If the td record exist, update the status to NULL    
      if(clientAddForm.contains(client_Form)) {
          td.STATUS__c = null;
          updateSummaryList.add(td);
          clientAddForm.remove(client_Form);
      }

    }

    // The leftover in clientAddForm should be the ones 
    // which don't have td record in Client_Summary__c.
    for(String cf : clientAddForm) {

      List<String> content = cf.split('_');

      Client_Summary__c newSummary = 
          new Client_Summary__c(client__c = content.get(0), 
                                Page__c = content.get(1), 
                                FORM_TYPE__c = 'TD', 
                                SECTION__c = '-1');

      newSummary.REQUIRED__c = true;

      newSummaryList.add(newSummary);

    }

    if(updateSummaryList.size() > 0) update updateSummaryList;
    if(newSummaryList.size() > 0) insert newSummaryList;

  }

  if(Trigger.isAfter) { 

    //ut.updateSummaryStatus(Trigger.new, 'DS_GTRAUMA', 'STATUS_GTRAUMA__c');
      
      ut.updateSummaryStatusForMergedObject(Trigger.new);

    /*AuditTrail audit = new AuditTrail(Trigger.new, Trigger.old); 
  
    if(Trigger.isInsert) { audit.generateLog(Trigger.new, Trigger.old); }
    if(Trigger.isUpdate) { audit.generateLog(Trigger.new, Trigger.old); }*/

  }
    
}