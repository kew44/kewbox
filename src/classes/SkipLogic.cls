/*Page Description:
 *  Class to Control Skip Logic
 * Last Updated on:
 *  7/17/2014
 * Update Purpose:
 *      
 * Programmer:
 *  
 */
public class SkipLogic {

  Utility ut = new Utility();
   
  public Map<String, Map<String, SkipElement>> skipList {get; set;}
  public Map<String, Boolean> skipAction {get; set;}

  Object emptyTextNumber = null;
  Object emptyCheck = FALSE;
  Object emptyNumber = 0;
   
  public class SkipElement {
        
    public String source { get;set; }
    public String triggerValue { get;set; }
    public Boolean rendered { get;set; }
    public String fieldType { get;set; }
    public String targetValue { get; set; }

    public SkipElement(Boolean rendered, String triggerValue, String fieldType) {
      this.triggerValue = triggerValue;
      this.rendered = rendered;
      this.fieldType = fieldType;
    }

    public void addTargetValue(String targetValue) {
      this.targetValue = targetValue;
    }


  } 

  public SkipLogic() {

    skipList = new Map<String, Map<String, SkipElement>>();
    skipAction = new Map<String, Boolean>();

  }

  public void skipLibrary(String triggerField, String display, String triggerValue, Map<String, String> target) {

    Map<String, SkipElement> elements = new Map<String, SkipElement>();

    Boolean show = (display == 'show') ? TRUE : FALSE;

    for(String key : target.keySet()) 
      elements.put(key, new SkipElement(show, triggerValue, target.get(key)));
    
    skipList.put(triggerField, elements);

  }
  
  public void runSkipLogic(String source, String value, Sobject ob) {
      
    Boolean action = TRUE;
    String fieldType = '';

    Map<String, SkipElement> element = skipList.get(source);

    for(String key : element.keySet()) { 

      if(value == element.get(key).triggerValue) 
        action = element.get(key).rendered; 
      else { 
        action = !element.get(key).rendered;
        fieldType = element.get(key).fieldType;

        if(fieldType == 'text' || fieldType == 'number') ob.put(key+'__c', emptyTextNumber);
        else if(fieldType == 'checkbox') ob.put(key+'__c', emptyCheck);
      }

      //system.debug(key + ' ' + action);
      
      skipAction.put(key, action);

    } 

    //return ob;
  }
  

  public String formRedirct(ID clientID, String section, String forceRedirect) {

    String url;
    String formType;

    String urlClientIDF;

    System.debug(clientID + '-' + section + '-' + forceRedirect);

    if(forceRedirect == '1') {

      if (section == '0')       formType = 'Baseline'; 
      else if(section == '-1')  formType = 'TD';
      else                      formType = 'FollowUp';

      // Old structure
      /*List<Client_Summary__c> nextForm = Database.query('SELECT FORM_ID__r.Variable__c, FORM_ID__r.Page__c' + 
                                                        '  FROM Client_Summary__c ' +
                                                        ' WHERE Client__c = \'' + clientID + '\'' +
                                                        '   AND SECTION__c = \'' + section + '\''+
                                                        '   AND REQUIRED__c = TRUE ' +
                                                        '   AND FORM_TYPE__c = \'' + formType + '\'' +
                                                        '   AND STATUS__c = null ' +
                                                      'ORDER BY FORM_TYPE__c, FORM_ID__r.weight__c');*/


      List<Client_Summary__c> nextForm = 
          Database.query('SELECT Page__r.Variable__c, Page__r.Page__c' + 
                         '  FROM Client_Summary__c ' +
                         ' WHERE Client__c = \'' + clientID + '\'' +
                         '   AND SECTION__c = \'' + section + '\''+
                         '   AND REQUIRED__c = TRUE ' +
                         '   AND FORM_TYPE__c = \'' + formType + '\'' +
                         '   AND STATUS__c = null ' +
                       'ORDER BY FORM_TYPE__c, Page__r.weight__c');
        
      System.debug('SELECT Page__r.Variable__c, Page__r.Page__c' + 
                         '  FROM Client_Summary__c ' +
                         ' WHERE Client__c = \'' + clientID + '\'' +
                         '   AND SECTION__c = \'' + section + '\''+
                         '   AND REQUIRED__c = TRUE ' +
                         '   AND FORM_TYPE__c = \'' + formType + '\'' +
                         '   AND STATUS__c = null ' +
                       'ORDER BY FORM_TYPE__c, Page__r.weight__c');

      url = 'ClientSummary?s='+section+'&id='+clientID+'&f=1';


      if(section != '-1') {
        //urlClientIDF = ;
        url = (nextForm.size() > 0) ?  
          nextForm.get(0).Page__r.Page__c + 
          '?cimi=' + ut.urlEncode('c='+clientID+'&f=1&summary='+nextForm.get(0).id) : url;

      }
      // Trauma detail forms
      else {
        //urlClientIDF = ;
        url = (nextForm.size() > 0) ? 
          'DS_TDETAIL?cimi=' + 
          ut.urlEncode('c='+clientID+'&f=1&TDF='+nextForm.get(0).Page__r.Page__c.substringAfter('DS_')+'&summary='+nextForm.get(0).id) : url;
      }

    }
    else {
      url = 'ClientSummary?s='+section+'&id='+clientID;
    }

    return '/apex/' + url;

  }
}