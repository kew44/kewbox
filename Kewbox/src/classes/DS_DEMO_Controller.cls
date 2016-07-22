/*Page Description:
 *  Controller for VisualForce page DS_DEMO
 */

public with sharing class DS_DEMO_Controller extends DS_BasicForm_Controller{

  public String noddModuleStatus {get; set;}
    
  public DS_DEMO_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        // Set the obj name 
        form.setObjName('DS_Background_Family_Info_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('DEMO');              
        
        //nodd module
       // noddModuleStatus = String.valueOf(form.obj.get(form.BorF+'DEVCON__c'));
        noddModuleStatus = String.valueOf(form.obj.get(bfVariableMap.get('DEVCON')));    
    
        // Skip logic library
        //2
        skip.skipLibrary('CUREPI', 'show', '0', new Map<String, String>{'CUREPVS'=>'text'});
   
        //3
        skip.skipLibrary('INFOTHR', 'show', 'true', new Map<String, String>{'INFOSP'=>'text'}); 
    
        //4
        skip.skipLibrary('GUARD', 'show', '98', new Map<String, String>{'GUARDSP'=>'text'});    
        skip.skipLibrary('IDENT', 'show', '98', new Map<String, String>{'IDENTSP'=>'text'});                      
        skip.skipLibrary('ORIENT', 'show', '98', new Map<String, String>{'ORIENTSP'=>'text'}); 
                      
        //5
        skip.skipLibrary('REFSRO', 'show', 'true', new Map<String, String>{'REFSOSP'=>'text'}); 
                      
        //Demographic 1
        skip.skipLibrary('ETHNIC', 'show', '1', new Map<String, String>{'ETHNICHCA'=>'checkbox', 'ETHNICHC'=>'checkbox',
                                                                        'ETHNICHD'  =>'checkbox', 'ETHNICHM' =>'checkbox',
                                                                        'ETHNICHPR'=>'checkbox', 'ETHNICHSA' =>'checkbox',
                                                                        'ETHNICHO'=>'checkbox', 'ETHNICHU' =>'checkbox'});
                                                                      
        skip.skipLibrary('ETHNICHO', 'show', 'true', new Map<String, String>{'ETHNICHOSP'=>'text'}); 
                          
        //3
        skip.skipLibrary('USBORN', 'show', '0', new Map<String, String>{'CTYBORN'=>'text'}); 
        
        //4
        skip.skipLibrary('PUSBORN', 'show', '0', new Map<String, String>{'PUSBORNSP'=>'text'}); 
        
        //5
        skip.skipLibrary('SIBLING', 'show', '1', new Map<String, String>{'SIBNUM' =>'text', 
                                                                          'SIBID'  =>'text'});
                                                                          
        skip.skipLibrary('TREATO', 'show', 'true', new Map<String, String>{'TREATOSP'=>'text'}); 
        
        //7
        skip.skipLibrary('PROTHNW', 'show', 'true', new Map<String, String>{'PROSPNW'=>'text'}); 
        
        //16.1
        skip.skipLibrary('TRT', 'show', '1', new Map<String, String>{'TRTOMED'=>'checkbox', 
                                                                      'TRTINJ' =>'checkbox',
                                                                      'TRTPL'  =>'checkbox', 
                                                                      'TRTPD'  =>'checkbox',
                                                                      'TRTOTHR'=>'checkbox', 
                                                                      'TRTUK'  =>'checkbox'});
                            
        //16.2 Other
        skip.skipLibrary('TRTOTHR', 'show', 'true', new Map<String, String>{'TRTOTSP'=>'text'});
        
        //17
        skip.skipLibrary('HSR', 'show', '1', new Map<String, String>{'HSRHOS'=>'checkbox', 
                                                                      'HSRED' =>'checkbox',
                                                                      'HSRSUR'=>'checkbox', 
                                                                      'HSRUC' =>'checkbox',
                                                                      'HSROT' =>'checkbox', 
                                                                      'HSRUK' =>'checkbox'});
                            
        //15
        skip.skipLibrary('DEVCON', 'show', '1', new Map<String, String>{'DEVATL' => 'checkbox',
                                                                        'DEVAUT' => 'checkbox',
                                                                        'DEVBLND' => 'checkbox',
                                                                        'DEVCP'  => 'checkbox',
                                                                        'DEVCF'  => 'checkbox',
                                                                        'DEVDEF' => 'checkbox',
                                                                        'DEVDS'  => 'checkbox',
                                                                        'DEVID'  => 'checkbox',
                                                                        'DEVMD'  => 'checkbox',                                                                         
                                                                        'DEVSB'  => 'checkbox',
                                                                        'DEVTOUR' => 'checkbox',
                                                                        'DEVUK'  => 'checkbox',
                                                                        'DEVOTHR'=> 'checkbox' 
                                                                        });
        
        //15 other
        skip.skipLibrary('DEVOTHR', 'show', 'true',  new Map<String, String>{'DEVOTSP'=>'text'});
        
        //16
        skip.skipLibrary('DVTR', 'show', '1',  new Map<String, String>{'DVTROMD'=>'checkbox', 
                                                                       'DVTRINJ'=>'checkbox',
                                                                       'DVTRPL' =>'checkbox', 
                                                                       'DVTRPD' =>'checkbox',
                                                                       'DVTRODV' => 'checkbox',
                                                                       'DVTROTR'=>'checkbox', 
                                                                       'DVTRUK' =>'checkbox'});
        //16 other
        skip.skipLibrary('DVTROTR', 'show', 'true', new Map<String, String>{'DVTROSP'=>'text'});
        
        //17
        skip.skipLibrary('DVSR', 'show', '1', new Map<String, String>{'DVSRHOS'=>'checkbox', 
                                                                      'DVSRED'=>'checkbox',
                                                                      'DVSRSUR'=>'checkbox', 
                                                                      'DVSRUC'=>'checkbox',
                                                                      'DVSROT' =>'checkbox', 
                                                                      'DVSRUK'=>'checkbox'});
                                                                           
        skip.skipLibrary('DEVOTHR', 'show', 'true', new Map<String, String>{'DEVOTSP'=>'text'}); 
        
        skip.skipLibrary('RHCO', 'show', 'true', new Map<String, String>{'RHCOSP'=>'text'}); 
        
        skip.skipLibrary('PROTHNW', 'show', 'true', new Map<String, String>{'PROSPNW'=>'text'});     
                   
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(skip.skipList);
        
       }
    
  public List<SelectOption> getQ4Items() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('1','Parent')); 
    options.add(new SelectOption('2','Other adult relative')); 
    options.add(new SelectOption('3','State'));
    options.add(new SelectOption('4','Emancipated minor (self)')); 
    options.add(new SelectOption('99','Unknown')); 
    options.add(new SelectOption('98','Other')); 
    
    return options; 
        
  }

  public List<SelectOption> getHispLatItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('1','Hispanic or Latino ')); 
    options.add(new SelectOption('2','Not Hispanic or Latino ')); 
    options.add(new SelectOption('96','Refused')); 
    options.add(new SelectOption('99','Unknown '));
    
    return options; 
        
  }

  public List<SelectOption> getQ14Items() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','Child has no current health problems or chronic conditions.')); 
    options.add(new SelectOption('1','Child has mild/treatable medical problems that require medical treatment. ')); 
    options.add(new SelectOption('2','Child has chronic illness that requires ongoing medical intervention. '));
    options.add(new SelectOption('3','Child has life threatening illness or medical condition that requires frequent hospitalization and medical intervention. '));
    options.add(new SelectOption('99','Unknown '));
    
    return options; 
        
  }
  
  public list<SelectOption> getMilSelfItems() {
  
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('96','Refused')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }
  
  public list<SelectOption> getMilFamItems() {
  
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes, only one person')); 
    options.add(new SelectOption('2','Yes, more than one person')); 
    options.add(new SelectOption('96','Refused')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }
      
  public list<SelectOption> getOverAllItems() {
  
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('1','Excellent')); 
    options.add(new SelectOption('2','Very Good')); 
    options.add(new SelectOption('3','Good')); 
    options.add(new SelectOption('4','Fair')); 
    options.add(new SelectOption('5','Poor')); 
    options.add(new SelectOption('96','Refused')); 
    options.add(new SelectOption('99','Unknown')); 
    
    return options; 
        
  }    
  
  public List<SelectOption> getGenIdenItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('1','Male'));
    options.add(new SelectOption('2','Female'));
    options.add(new SelectOption('3','Transmale (female to male)'));
    options.add(new SelectOption('4','Transfemale (male to female)'));
    options.add(new SelectOption('98','Other'));
    options.add(new SelectOption('96','Declined'));
    options.add(new SelectOption('99','Unknown'));
    
    return options; 
    
    }
    
  public List<SelectOption> getOrientItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('','')); 
    options.add(new SelectOption('1','Heterosexual (that is straight) ')); 
    options.add(new SelectOption('2','Gay or Lesbian')); 
    options.add(new SelectOption('3','Bisexual')); 
    options.add(new SelectOption('98','Other'));
    options.add(new SelectOption('96','Declined'));
    options.add(new SelectOption('99','Unknown'));
    
    return options; 
        
  }

  
}