public with sharing class DS_INFO_Controller {
    
    Utility ut = new Utility();
    
    Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));
    
    public DS_Background_Family_Info_F__c obj { get; set; }
    
    String VisitNum;
    
    String PastVisitNum;
    
    String NextVisitNum;
    
    Decimal PastVisitDecimal;
    
    Decimal VisitDecimal;
    
    String cID;
    
    String summaryID;
    
    FormBuilder FB = new FormBuilder();
    
    public String forceRedirect {get; set;} 
    
    Boolean edit = FALSE;
    
    public String subtitle {get; set;}
    
    public Client__c client { get; set; }
    
    public Client_Summary__c summaryInfo { get; set; }
    
    public SkipLogic skip {get;set;}
    
    public String skipElementToJson { get; set; }
    
    public DS_INFO_Controller(ApexPages.StandardController controller) {
        
        parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));
        
        PastVisitNum= parameter.get('section');//1; 
        
        cID = parameter.get('c');
        
        summaryID = parameter.get('summary');
        
        forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';
        
        skip = new SkipLogic();   
        
        client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID]; 
        
        subtitle = '(' + client.Name + ') ' + client.INIT__c;
        
        String getINFOFields = ut.getFields('DS_Background_Family_Info_F__c');
        
        List<DS_Background_Family_Info_F__c> record = 
            Database.query('SELECT ' + getINFOFields + ',' +
                           'Client__r.Name, Client__r.INIT__c' +  
                           '  FROM DS_Background_Family_Info_F__c '
                           +  ' WHERE Client__c = \''+ cID + '\''
                          );   
          System.debug(record);          
          System.debug(DS_Background_Family_Info_F__c.FORM__c);
          System.debug(DS_Background_Family_Info_F__c.FDOV__c);
          System.debug(DS_Background_Family_Info_F__c.SECTION__c);
          System.debug(DS_Background_Family_Info_F__c.Visit_Number__c);
          System.debug(record.size());                    
        
        if(record.size() == 0) { // New record
            
            obj = new DS_Background_Family_Info_F__c(client__c = cID, 
                                                     FORM__c = 'DS_INFO_F'
                                                     ,Visit_Number__c = 1
                                                        ,SECTION__c ='1'
                                                    );     
          System.debug(obj);  
          System.debug(obj.FORM__c);
          System.debug(obj.FDOV__c);
          System.debug(obj.SECTION__c);
          System.debug(obj.Visit_Number__c);
            
            PastVisitNum = '0'; 
            PastVisitDecimal = Decimal.valueOf(PastVisitNum);
            System.debug(PastVisitDecimal);
            System.debug(PastVisitNum);
            
            VisitDecimal= obj.Visit_Number__c;
            VisitNum = String.valueOf(VisitDecimal);
            System.debug(VisitDecimal);
            System.debug(VisitNum);
            
            NextVisitNum = String.valueOf(obj.Visit_Number__c+1);
            System.debug(NextVisitNum);
                        
          obj.SECTION__c=VisitNum;
          System.debug(obj.FORM__c);
          System.debug(obj.SECTION__c);
          System.debug(obj.Visit_Number__c);
            System.debug(VisitDecimal);
            System.debug(VisitNum);
            System.debug(PastVisitDecimal);
            System.debug(PastVisitNum);
            
            
        }
        else {   // Update record    
            for (DS_Background_Family_Info_F__c r: record){
                
                PastVisitDecimal=record.get(record.size()-1).Visit_Number__c;
                PastVisitNum = String.valueOf(PastVisitDecimal);//String.valueOf(record.get(0).Visit_Number__c);
                System.debug(PastVisitDecimal);
                System.debug(PastVisitNum);
                
                VisitDecimal= PastVisitDecimal+1;
                VisitNum = String.valueOf(VisitDecimal);               
                System.debug(VisitDecimal);
                System.debug(VisitNum);      
                
                obj = new DS_Background_Family_Info_F__c(client__c = cID, 
                                                         FORM__c = 'DS_INFO_F'
                                                         ,Visit_Number__c =VisitDecimal//PastVisitDecimal
                                                            ,SECTION__c =VisitNum//PastVisitDecimal
                                                        );       
                System.debug(obj);
                
          System.debug(obj.FORM__c);
          System.debug(obj.FDOV__c);
          System.debug(obj.SECTION__c);
          System.debug(obj.Visit_Number__c);
          
          obj.SECTION__c=VisitNum;
          System.debug(obj.SECTION__c);
          
                edit = TRUE;      
            System.debug(VisitDecimal);
            System.debug(VisitNum);
            System.debug(PastVisitDecimal);
            System.debug(PastVisitNum);                           
                
                for(String lKey : skip.skipList.keySet()) 
                    for(String sKey : skip.skipList.get(lKey).keySet()) {
                        skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));
                    }      
            }       
            
            obj.FORM__c = 'DS_INFO_F';      
            System.debug(VisitNum);
            System.debug(VisitDecimal);
            System.debug(VisitNum);
            System.debug(PastVisitDecimal);
            System.debug(PastVisitNum);  
            obj.Visit_Number__c = Decimal.valueOf(VisitNum);   
            obj.SECTION__c=VisitNum;
          System.debug(obj.FORM__c);
          System.debug(obj.FDOV__c);
          System.debug(obj.SECTION__c);
          System.debug(obj.Visit_Number__c);
            
            System.debug(obj);
            System.debug(obj.Visit_Number__c);
            System.debug(obj.SECTION__c);
            System.debug(VisitNum);
            System.debug(PastVisitNum);
            NextVisitNum = String.valueOf(obj.Visit_Number__c+1);
            System.debug(NextVisitNum);// = String.valueOf(obj.Visit_Number__c+1);
            
        }
        
        
        skipElementToJson = JSON.serialize(skip.skipList);
    }
    
    public String getClientInfo() { return ut.clientSectionInfo(cID);}
    
    public PageReference cancel() {
        
   /*     System.debug(PastVisitDecimal);
        
        PageReference summaryPage = new PageReference('/apex/ClientSummary?s='+PastVisitDecimal+'&id=' + cID);
        summaryPage.setRedirect(true);
        
        return summaryPage;*/
        return null;
        
    }
    
    public PageReference save() {
        //we should build in a condition where this form can only be saved once per visit.
        
        System.debug(PastVisitDecimal);
            System.debug(NextVisitNum);
            System.debug(obj);
            System.debug(obj.Visit_Number__c);
            System.debug(obj.SECTION__c);
            System.debug(VisitNum);
          System.debug(obj.FORM__c);
          System.debug(obj.FDOV__c);
        
        PageReference nextPage;
        
        // try {
        //if(edit == FALSE)
        //update clientSumary.SECTION__c = obj.section?
        insert obj;
        // else update obj;
        // else insert obj;
        
        nextPage = new PageReference(skip.formRedirct(cID, NextVisitNum, forceRedirect));
        nextPage.setRedirect(true);
        System.debug(nextPage);
        // }
        //catch(DMLException e) { nextPage = null; }
        
        System.debug(nextPage);
        return nextPage;
        
    }
    
}