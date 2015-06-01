/**
 * The controller class for PTSD Reaction Index for Children/Adolescents.  
 * 
 **/

public with sharing class DS_PTSD_CA_Controller extends DS_BasicForm_Controller {

  public List<Item> items { get; set; }

  public class Item {
      
    public String num {get;set;}
    public String content {get;set;}
    public String field {get;set;}
    public String symptom {get;set;}
    public Boolean section { get;set; }
    
    public Item(String num, String symptom, String field, Boolean section, String content) {
      this.num = num;
      this.content = content;
      this.field = field;
      this.symptom = symptom;
      this.section = section;
    }
      
  }
  
  public DS_PTSD_CA_Controller(ApexPages.StandardController controller) {

    // Initilize the DS_BasicForm_Controller
    super(Apexpages.currentPage().getParameters().get('cimi'));

    List<DS_DATA__c> formInfo = 
      Database.query('SELECT ' + form.ut.getFields('DS_DATA__c') +   
                     '  FROM DS_DATA__c ' +
                     ' WHERE Data_Type__c = \'DS_PTSD_Form_Info\'' +
                  ' ORDER BY Number__c');
    
    items = new List<Item>();

    for(DS_DATA__c info : formInfo) {
      items.add(new Item(string.valueof(integer.valueof(info.Number__c)), info.Symptom__c, 'B'+info.Field__c+'__c', info.Section__c, info.Content__c));
    }

    // Set the obj name 
    form.setObjName('DS_PTSD_CA_'+form.BorF+'__c');

    // Get the object record into form.obj
    form.getObjRecord();
    
    // Get field name from DS_DATA (variable)
    bfVariableMap = form.getVariable('PTSD_CA');

  }
  
  public List<SelectOption> getRadioItems() {
  
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','None')); 
    options.add(new SelectOption('1','Little')); 
    options.add(new SelectOption('2','Some')); 
    options.add(new SelectOption('3','Much')); 
    options.add(new SelectOption('4','Most')); 
    
    return options; 
      
  }
  
  public List<SelectOption> getRadioYesNo() {
      
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('0','No')); 
    
    return options; 

  }

}