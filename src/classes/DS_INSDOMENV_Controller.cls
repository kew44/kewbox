/**
 * The controller class for Insurance Information.  
 * 
 **/

public with sharing class DS_INSDOMENV_Controller extends DS_BasicForm_Controller {

  public DS_INSDOMENV_Controller (ApexPages.StandardController controller) {

    // Initilize the DS_BasicForm_Controller
    super(Apexpages.currentPage().getParameters().get('cimi'));
    
    //show #1a question
    skip.skipLibrary('CINANY', 'show', '1', new Map<String,String>{'CINPUB'=>'checkbox', 'CINPRIV'=>'checkbox'});  //displays checkboxes if child insured
    
    //show #1a public choices if public checked
    skip.skipLibrary('CINPUB', 'show', 'true', new Map<String,String>{'CINCHIP'=>'checkbox',
                                                                      'CINIH'=>'checkbox',
                                                                      'CINMEDD'=>'checkbox',
                                                                      'CINMEDR'=>'checkbox',
                                                                      'CINMHC'=>'checkbox',
                                                                      'CINOPUB'=>'checkbox',
                                                                      //if other
                                                                      'CINPBUK'=>'checkbox'  
                                                                       }); 
                                                                       
    
    //show #1a private choices if private checked
    skip.skipLibrary('CINPRIV', 'show', 'true', new Map<String,String>{'CINHMO' =>'checkbox',
                                                                       'CINPPO' =>'checkbox',
                                                                       'CINFFS' =>'checkbox',
                                                                       'CINOPRI'=>'checkbox',
                                                                       //if other  
                                                                       'CINPRUK'=>'checkbox'
                                                                       }); 
    
    //show #2a question
    skip.skipLibrary('PINANY', 'show', '1', new Map<String,String>{'PINPUB'=>'checkbox', 'PINPRIV'=>'checkbox'});  //displays checkboxes if parent insured
    
    //show #2a public choices if public checked
    skip.skipLibrary('PINPUB', 'show', 'true', new Map<String,String>{'PINCHIP' =>'checkbox',
                                                                      'PINIH'   =>'checkbox',
                                                                      'PINMEDD' =>'checkbox',
                                                                      'PINMEDR' =>'checkbox',
                                                                      'PINMHC'  =>'checkbox',
                                                                      'PINOPUB' =>'checkbox'
                                                                      }); 
    //show #2a private choices if private checked
    skip.skipLibrary('PINPRIV', 'show', 'true', new Map<String,String>{'PINHMO' =>'checkbox',
                                                                       'PINPPO' =>'checkbox',
                                                                       'PINFFS' =>'checkbox',
                                                                       'PINOPRI'=>'checkbox'
                                                                        });
                                                                          
    
    //other, specify
    skip.skipLibrary('CINOPUB','show','true', new Map<String, String>{'CINOPSP'=>'text'});//#2, public
    skip.skipLibrary('CINOPRI','show','true', new Map<String, String>{'CINOPRS'=>'text'});//#2, private
    
    skip.skipLibrary('PINOPUB','show','true', new Map<String, String>{'PINOPSP'=>'text'});//#4, public
    skip.skipLibrary('PINOPRI','show','true', new Map<String, String>{'PINOPRS'=>'text'});//#4, private
    
    // Set the skip object to form object
    form.setSkipLogic(skip);

    // Set the obj name 
    form.setObjName('DS_Background_Family_Info_'+form.BorF+'__c');

    // Get the object record into form.obj
    form.getObjRecord();

    // Serialize the skip library to JSON format
    skipElementToJson = JSON.serialize(form.skip.skipList); 
    
    // Get field name from DS_DATA (variable)
    bfVariableMap = form.getVariable('INSDOMENV');

  }

}