public class FormBuilder {

    /////start newSummary method ////////
  public static Client_Summary__c newSummary(String clientID, ID formID, String formCategory, String sectionNum, Boolean required) {

    Client_Summary__c newSummary = 
      new Client_Summary__c(client__c = clientID, Page__c = formID, 
                            FORM_TYPE__c = formCategory, REQUIRED__c = required,
                            SECTION__c = sectionNum);

    return newSummary;
  }
    //////////end newSummary method////////////////
                                        
  ////////////start baseline method//////////////// 
  public static void baseline(Set<String> clients) {

    List<Client_Summary__c> newSummaryList = new List<Client_Summary__c>();
    
    List<DS_Data__c> formInfo = [SELECT Category__c, Content__c, Variable__c,  
                                        Age_Range__c, Form__c
                                   FROM DS_Data__c 
                                  WHERE (Category__c = 'Baseline' 
                                     OR Category__c = 'Assessment'
                                     OR Category__c = 'GT')
                                    AND Data_Type__c = 'DS_Form_Info'
                                    AND FILE_NAME__c = 'Baseline'
                               ORDER BY Category__c, weight__c];

    System.debug(formInfo);
                                        
    Map<Id, Client__c> clientInfo = 
      new Map<Id, Client__c>([SELECT id, age__c, gender__c
                                FROM Client__c
                               WHERE id IN : clients]); 

    // For display logic. Don't add Military, REFIMM, and Health in client summary object. 
    Set<String> skippedForm = new Set<String>();
    skippedForm.add('DS_MILITARY');
    skippedForm.add('DS_REFIMM');
    skippedForm.add('DS_HEALTH');

    for(DS_Data__c f : formInfo) {

      String sectionNum = (f.Category__c == 'GT') ? '-1' : '0';

      // Skip and jump to next form
      if(skippedForm.contains(f.Form__c)) continue;
  
      for(String c : clients) {
      
        if(f.Age_Range__c == null) {
          newSummaryList.add(newSummary(c, f.id, f.Category__c, sectionNum, true));
        }
        else {

          List<String> range = f.Age_Range__c.split('-', 0); 

          if((Double.valueOf(range.get(0)) <= Double.valueOf(clientInfo.get(c).AGE__c)) && (Double.valueOF(range.get(1)) >= Double.valueOf(clientInfo.get(c).AGE__c)))           
            newSummaryList.add(newSummary(c, f.id, f.Category__c, sectionNum, true));

        }

      }
        
    }

    insert newSummaryList;
  
  }
    ///////////////end baseline method/////////////////////      
    
          ////////////start follow-up method//////////////// 
  public static void followup(Set<String> clients) {
  
  DS_Background_Family_Info_F__c background = new DS_Background_Family_Info_F__c();
  
  List<DS_Background_Family_Info_F__c> backgroundList= new List<DS_Background_Family_Info_F__c>();
                       
  //for query
  Client_Summary__c summary = new Client_Summary__c();
  
  //new visit
    List<Client_Summary__c> newSummaryList = new List<Client_Summary__c>();
        
    //forms for visit
    List<DS_Data__c> followformInfo = [SELECT Category__c, Content__c, Variable__c,  
                                        Age_Range__c, Form__c
                                   FROM DS_Data__c 
                                  WHERE (Category__c = 'FollowUp' 
                                    OR Category__c = 'Assessment')
                                    AND Data_Type__c = 'DS_Form_Info'
                                    AND FILE_NAME__c = 'FOLLOWUP'
                               ORDER BY Category__c, weight__c];


    system.debug(followformInfo);
                               
    //client
    Map<Id, Client__c> clientInfo = 
      new Map<Id, Client__c>
          ([SELECT id, age__c, gender__c
                                FROM Client__c
                               WHERE id IN : clients]); 
      
    //check to see if skipped rules apply
Set<String> skippedForm = new Set<String>();                        
        
        String sectionNum;        
        String client_id;

    for(DS_Data__c f : followformInfo) {
        List<aggregateResult> sections= [SELECT Max (Section__c) section,client__c  FROM Client_summary__c WHERE client__c IN: clients GROUP BY client__c ];//String.valueOf([SELECT Max (Section__c) FROM Client_summary__c WHERE client__c IN: clients GROUP BY client__c ]);
        System.debug(sections);
        
        for (AggregateResult ar : sections)  {
        System.debug(ar.get('client__c'));
        client_id= String.valueOf(ar.get('client__c'));
        
          System.debug(ar.get('section'));
        sectionNum = String.valueOf(ar.get('section'));
        System.debug(sectionNum);

        }        
        
        System.debug(client_id);
    
        System.debug(sectionNum);
        
        
        Map<String, Integer> Section_Num = new Map<string, Integer>();
    Section_Num.put(client_id,Integer.valueOf(sectionNum));
    
    System.debug(Section_Num);
    
  //  Section_Num.put(2, integer.valueOf(sectionNum));//Max(section__c));
      //  String -> clientID
      //  int -> Max(section__c)

    //  for(Client__c c : clients) {

        //age range check

        sectionNum=String.valueOf(Integer.valueOf(sectionNum)+1);

        newSummaryList.add(newSummary(client_id, f.id, f.Category__c, sectionNum, true)); 
System.debug(newSummaryList);

        System.debug(sectionNum);
     // }

    }

        System.debug(sectionNum);
    insert newSummaryList;

        System.debug(sectionNum);
  }
      ///////////////end follow-up method///////////////////// 
    
  public static void MilitaryRefugeHealthDisplayLogic(List<SObject> obj) {  

    String section = String.valueOf(obj.get(0).get('SECTION__c'));

    String BorF = (Integer.valueOf(section) > 0) ? 'F' : 'B';

    String category = (Integer.valueOf(section) > 0) ? 'FollowUp' : 'Baseline';

    List<String> forms = new List<String>{'DS_HEALTH', 'DS_MILITARY', 'DS_REFIMM'};
    
    List<DS_Data__c> formInfo = [SELECT Content__c, Variable__c,  
                                        Form__c, id
                                   FROM DS_Data__c 
                                  WHERE Category__c = : category 
                                    AND Data_Type__c = 'DS_Form_Info'
                                    AND Form__c IN : forms];

    Map<String, DS_DATA__c> formMap = new Map<String, DS_DATA__c>();                                    
    for(DS_Data__c info : formInfo) formMap.put(info.Form__c, info);

    List<String> clients = new List<String>();

    for(SObject b : obj) clients.add(String.valueOf(b.get('Client__c')));

    List<Client_Summary__c> clientSummary = [SELECT Page__c, Client__c
                                               FROM Client_Summary__c
                                              WHERE Client__c IN : clients
                                                AND Page__r.Form__c IN : forms
                                                AND SECTION__c = : section];

    Set<String> clientSummaryExisted = new Set<String>();

    for(Client_Summary__c cs : clientSummary)
      clientSummaryExisted.add(cs.Client__c+'-'+cs.Page__c);

    Map<Id, Client__c> clientInfo = 
      new Map<Id, Client__c>([SELECT id, age__c, gender__c
                                FROM Client__c
                               WHERE id IN : clients]); 

    List<Client_Summary__c> insertClientSummary = new List<Client_Summary__c>();

    for(SObject b : obj) {

      String clientID = String.valueOf(b.get('Client__c'));
      String sectionNum = String.valueOf(b.get('SECTION__c'));

      if ((b.get(BorF+'USBORN__c') == '0' || b.get(BorF+'PUSBORN__c') == '0') && (!clientSummaryExisted.contains(clientID+'-'+formMap.get('DS_REFIMM').id)))        
        insertClientSummary.add(newSummary(clientID, formMap.get('DS_REFIMM').id, category, sectionNum, true));
      
      if ((b.get(BorF+'MILSELF__c') == '1' || b.get(BorF+'MILFAMILY__c') == '1' || b.get(BorF+'MILFAMILY__c') == '2') && (!clientSummaryExisted.contains(clientID+'-'+formMap.get('DS_MILITARY').id)))
        insertClientSummary.add(newSummary(clientID, formMap.get('DS_MILITARY').id, category, sectionNum, true));    
      
      if ((b.get(BorF+'HOVERALL__c') == '4' || b.get(BorF+'HOVERALL__c') == '5' || b.get(BorF+'HTHSTAT__c') == '1' || b.get(BorF+'HTHSTAT__c') == '2' || b.get(BorF+'HTHSTAT__c') == '3') && (!clientSummaryExisted.contains(clientID+'-'+formMap.get('DS_HEALTH').id)))
        insertClientSummary.add(newSummary(clientID, formMap.get('DS_HEALTH').id, category, sectionNum, true));       

    }           

    insert insertClientSummary;

  }
  

}