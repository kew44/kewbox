global with sharing class Form {

    public Utility ut = new Utility();
    
    public String title { get; set; }
    
    public String subTitle { get; set; }
    
    public String cID { get; set; }
  
    public String summaryID { get; set; }
    
    public String forceRedirect { get; set; } 
    
    public Client__c client { get; set; }
    
    public Client_Summary__c summary { get; set; }
    
    public Sobject obj { get; set; }
    
    public String BorF { get; set; }

    public Boolean isBaseline { get; set; }

    public Boolean isFollowup { get; set; }
    
    public String objName { get; set; }
    
    public Boolean edit = FALSE;

    public String visitType { get; set; }
    
    public SkipLogic skip { get; set; }
    
    Map<String, String> parameter;
    
    
    public Form(String cimi) {
    
        parameter = ut.urlDecode(cimi);
    
        this.cID = parameter.get('c');
        this.summaryID = parameter.get('summary');
        this.forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';
                
        this.client = (cID != null) ? [SELECT Name, INIT__c, GENDER__c, CURRENT_AGE__c FROM Client__c WHERE id =: cID] : null;
        this.summary = (summaryID != null) ? [SELECT SECTION__c, Page__r.CONTENT__c FROM Client_Summary__c WHERE ID =:summaryID] : null;
          
        this.BorF = (Integer.valueOf(summary.SECTION__c) > 0) ? 'F' : 'B';

        this.isBaseline = (Integer.valueOf(summary.SECTION__c) > 0) ? false : true;
        this.isFollowup = (Integer.valueOf(summary.SECTION__c) > 0) ? true : false;

        this.visitType = (summary.SECTION__c == '-1') ? 'trauma' : ((Integer.valueOf(summary.SECTION__c) > 0) ? 'followup' : 'baseline');
        
        this.title = summary.Page__r.CONTENT__c;
        this.subTitle = '(' + client.Name + ') ' + client.INIT__c;
        
    }
    
    public void setObjName(String objName) {
        this.objName = objName;
    }
    
    public void setSkipLogic(SkipLogic skip) {
        this.skip = skip;
    }
    
    public String getClientInfo() { return ut.clientSection(cID, SummaryID); }
    
    public Map<String, String> getVariable(String sourceForm) {

        Map<String, String> bfVariableMap = new Map<String, String>();

        Set<String> vars = new Set<String>();

        List<DS_DATA__c> varFromData = [SELECT VARIABLE_NAME__c 
                                          FROM DS_DATA__c
                                         WHERE SOURCE_FORM__c = :sourceForm];

        for(DS_DATA__c var : varFromData) {
            if(var.VARIABLE_NAME__c != null) 
                vars.add(var.VARIABLE_NAME__c.substring(1, var.VARIABLE_NAME__c.length()));
        }

        for(String bfVar : vars)
          bfVariableMap.put(bfVar, this.BorF+bfVar+'__c');

        bfVariableMap.put('STATUS', 'STATUS_'+sourceForm+'__c');
        
        return bfVariableMap;

    }
    
    public void getObjRecord() {
    
        String objFields = ut.getFields(objName);
        
        List<SObject> record = 
          Database.query('SELECT ' + objFields + ',' +
                                 'Client__r.Name, Client__r.INIT__c' +  
                         '  FROM ' + objName +                          
                         ' WHERE Client__c = \''+ cID + '\'' +
                         '    AND SECTION__c = \'' + summary.SECTION__c + '\'');
    
        if(record.size() == 0) { // New record
          
          Schema.SObjectType objType = Schema.getGlobalDescribe().get(objName);
    
          obj = objType.newSObject();
    
          obj.put('Client__c', cID);
          obj.put('SECTION__c', summary.SECTION__c);
           
        }
        else {   // Update record
          
          obj = record.get(0);
          edit = TRUE;
          if(skip != null) {
            for(String lKey : skip.skipList.keySet()) 
                for(String sKey : skip.skipList.get(lKey).keySet()) {
                  skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(BorF+lKey+'__c')));
                }
          }
          
        } 
    
    }

    public Boolean saveObjRecord() {

        try {
            upsert obj;
            system.debug(obj);
            return true;
        } 
        catch(DMLException e) { system.debug(e); }

        return false;

    }
    
   
    

}