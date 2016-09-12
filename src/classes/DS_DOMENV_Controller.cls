/**
 * The controller class for Domestic Environment.  
 * 
 **/

public with sharing class DS_DOMENV_Controller extends DS_BasicForm_Controller {

  public DS_DOMENV_Controller(ApexPages.StandardController controller) {
  
    // Initilize the DS_BasicForm_Controller
    super(Apexpages.currentPage().getParameters().get('cimi'));
    
    // Skiplogic library
    skip.skipLibrary('PRIMRES', 'show', '98',   new Map<String, String>{'PRIMRSP'    => 'text'}); 
    skip.skipLibrary('NOMHOUSE','show', '98',   new Map<String, String>{'NOMHOUSESP' => 'text'}); 
    skip.skipLibrary('LOTHR',   'show', 'true', new Map<String, String>{'LOTHRSP'    => 'text'}); 
    skip.skipLibrary('LANGHOM', 'show', '98',   new Map<String, String>{'LANGHMS'    => 'text'}); 
    skip.skipLibrary('INCOMNW', 'show', '98',   new Map<String, String>{'INCOMSP'    => 'text'}); 
    
    // Set the skip object to form object
    form.setSkipLogic(skip);

    // Set the obj name 
    form.setObjName('DS_Background_Family_Info_'+form.BorF+'__c');

    // Get the object record into form.obj
    form.getObjRecord();

    // Serialize the skip library to JSON format
    skipElementToJson = JSON.serialize(skip.skipList);

    // Get field name from DS_DATA (variable)
    bfVariableMap = form.getVariable('DOMENV');

  }  
  
  public List<SelectOption> getPrimeRestIems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('1','Independent (alone or with peers)')); 
    options.add(new SelectOption('2','Home (With parent(s)) ')); 
    options.add(new SelectOption('3','With relatives or other family ')); 
    options.add(new SelectOption('4','Regular foster care ')); 
    options.add(new SelectOption('5','Treatment foster care')); 
    options.add(new SelectOption('6','Residential treatment center ')); 
    options.add(new SelectOption('7','Correctional facility')); 
    options.add(new SelectOption('8','Homeless')); 
    options.add(new SelectOption('9','Shelter'));   
    options.add(new SelectOption('98','Other'));  
    options.add(new SelectOption('99','Unknown'));  
    
    return options; 
        
  }
  
  public List<SelectOption> getHowLongIems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','Less than 1 month '));
    options.add(new SelectOption('1','Entire Life '));
    options.add(new SelectOption('2','1-6 months'));
    options.add(new SelectOption('3','7-12 months'));
    options.add(new SelectOption('4','13-24 months'));
    options.add(new SelectOption('5','Greater than 24 months '));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

  public List<SelectOption> getOutPlaceIems() {
   
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','0'));
    options.add(new SelectOption('1','1'));
    options.add(new SelectOption('2','2'));
    options.add(new SelectOption('3','3'));
    options.add(new SelectOption('4','4'));
    options.add(new SelectOption('5','5'));
    options.add(new SelectOption('6','More than 5 placements'));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }
  
  public List<SelectOption> getLiveMostItems() {
   
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('1','Caregiver’s owned or rented house, apartment, trailer, or room '));
    options.add(new SelectOption('2','Independently owned or rented house, apartment, trailer, or room '));
    options.add(new SelectOption('3','Someone else’s house, apartment, trailer, or room '));
    options.add(new SelectOption('4','Homeless (shelter, street/outdoors, park) '));
    options.add(new SelectOption('5','Group home '));
    options.add(new SelectOption('6','Foster care (specialized therapeutic treatment) '));
    options.add(new SelectOption('7','Transitional living facility '));
    options.add(new SelectOption('8','Hospital (medical)'));
    options.add(new SelectOption('9','Hospital (psychiatric)'));
    options.add(new SelectOption('10','Detox/inpatient or residential substance abuse treatment facility '));
    options.add(new SelectOption('11','Correctional facility (juvenile detention center/jail/prison) '));
    options.add(new SelectOption('96','Refused'));
    options.add(new SelectOption('98','Other housing '));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }
  
  public List<SelectOption> getCTYREFUSEItems(){
  
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('96','Refused'));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }  
  
  public List<SelectOption> getLangItems(){
  
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('1','English'));
    options.add(new SelectOption('2','Spanish'));
    options.add(new SelectOption('3','French'));
    options.add(new SelectOption('4','Mandarin'));
    options.add(new SelectOption('5','Cantonese'));
    options.add(new SelectOption('6','Navaho'));
    options.add(new SelectOption('7','Japanese'));
    options.add(new SelectOption('8','Korean'));
    options.add(new SelectOption('9','Russian'));
    options.add(new SelectOption('10','Arabic'));
    options.add(new SelectOption('11','Hebrew'));
    options.add(new SelectOption('98','Other'));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }  
  
  public List<SelectOption> getIncomeItems(){
  
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('1','Less than $5,000 '));
    options.add(new SelectOption('2','$5,000 – $9,999 '));
    options.add(new SelectOption('3','$10,000 – $14,999 '));
    options.add(new SelectOption('4','$15,000 – $19,999 '));
    options.add(new SelectOption('5','$20,000 – $24,999 '));
    options.add(new SelectOption('6','$25,000 – $34,999 '));
    options.add(new SelectOption('7','$35,000 – $49,999 '));
    options.add(new SelectOption('8','$50,000 – $74,999 '));
    options.add(new SelectOption('9','$75,000 – $99,999 '));
    options.add(new SelectOption('10','$100,000 and over '));
    options.add(new SelectOption('98','Other'));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

  public List<SelectOption> getFamResItems() {
   
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','My family has financial resources necessary to meet our needs'));
    options.add(new SelectOption('1','My family has financial resources necessary to meet most of our needs; however, some limitations exist '));
    options.add(new SelectOption('2','My family has financial difficulties that limit our ability to meet significant family needs '));
    options.add(new SelectOption('3','My family has been experiencing financial hardship, poverty '));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }

  public List<SelectOption> getCareGiveItems() {
   
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','Resilient, able to bounce back despite stress, no intervention needed'));
    options.add(new SelectOption('1','Average adaptive, could benefit from education or information on post-trauma adjustment '));
    options.add(new SelectOption('2','Risk of disturbance and intervention recommended '));
    options.add(new SelectOption('3','Disturbance and in need of intensive intervention'));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  } 
  
  public List<SelectOption> getGradeItems(){
  
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('0','Never attended'));
    options.add(new SelectOption('1','Preschool '));
    options.add(new SelectOption('2','Kindergarten '));
    options.add(new SelectOption('3','1st Grade '));
    options.add(new SelectOption('4','2nd Grade '));
    options.add(new SelectOption('5','3rd Grade '));
    options.add(new SelectOption('6','4th Grade '));
    options.add(new SelectOption('7','5th Grade '));
    options.add(new SelectOption('8','6th Grade '));
    options.add(new SelectOption('9','7th Grade '));
    options.add(new SelectOption('10','8th Grade '));
    options.add(new SelectOption('11','9th Grade '));
    options.add(new SelectOption('12','10th Grade '));
    options.add(new SelectOption('13','11th Grade '));
    options.add(new SelectOption('14','12th Grade '));
    options.add(new SelectOption('15','12th Grade/high school diploma/equivalent (GED)'));
    options.add(new SelectOption('16','Vocational/technical diploma '));
    options.add(new SelectOption('17','Some college or university'));
    options.add(new SelectOption('96','Refused'));
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }
  
  public List<SelectOption> getAbsentItems(){
  
    List<SelectOption> options = new List<SelectOption>(); 
    options.add(new SelectOption('0','0 days '));
    options.add(new SelectOption('1','1 day '));
    options.add(new SelectOption('2','2 days '));
    options.add(new SelectOption('3','3 to 5 days '));
    options.add(new SelectOption('4','6 to 10 days '));
    options.add(new SelectOption('5','More than 10 days '));
    options.add(new SelectOption('96','Refused'));
    options.add(new SelectOption('99','Unknown')); 
    options.add(new SelectOption('97','Not applicable '));
    
    return options; 
        
  }  

}