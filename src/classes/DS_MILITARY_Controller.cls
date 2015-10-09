/**
* The controller class for Brief Intervention Services Information.  
* 
**/

public with sharing class DS_MILITARY_Controller extends DS_BasicForm_Controller {
    
    public DS_MILITARY_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        
        skip.skipLibrary('MFMR1', 'show', '98', new Map<String, String>{'MFMR1SP'=>'text'}); 
        skip.skipLibrary('MFMR2', 'show', '98', new Map<String, String>{'MFMR2SP'=>'text'}); 
        skip.skipLibrary('MFMR3', 'show', '98', new Map<String, String>{'MFMR3SP'=>'text'}); 
        skip.skipLibrary('MFMR4', 'show', '98', new Map<String, String>{'MFMR4SP'=>'text'}); 
        
        skip.skipLibrary('OTHMIL', 'show', 'true', new Map<String, String>{'OTHMILSP'=>'text'});///////other relationship
        
        skip.skipLibrary('MPI', 'show', 'true', new Map <String, String>{'MPIAMP'=>'checkbox',  ///////physical injury
                                                                        'MPITBI'=>'checkbox',
                                                                        'MPIBRN'=>'checkbox',
                                                                        'MPICPF'=>'checkbox',
                                                                        'MPIOTH'=>'checkbox',
                                                                        'MPIUK'=>'checkbox'
                                                                        });
        
        skip.skipLibrary('MST', 'show', 'true', new Map <String, String>{'MSTPTSD'=>'checkbox',  ///////stress
                                                                        'MSTDEP'=>'checkbox',
                                                                        'MSTSUB'=>'checkbox',
                                                                        'MSTSUIC'=>'checkbox',
                                                                        'MSTOTH'=>'checkbox',
                                                                        'MSTUK'=>'checkbox'
                                                                        });
        
        skip.skipLibrary('MKIL', 'show', 'true', new Map <String, String>{'MKILCOM'=>'checkbox',  ///////killed
                                                                        'MKILACC'=>'checkbox',
                                                                        'MKILMED'=>'checkbox',
                                                                        'MKILSUIC'=>'checkbox',
                                                                        'MKILOTH'=>'checkbox',
                                                                        'MKILUK'=>'checkbox'
                                                                        });
        
        skip.skipLibrary('MDIFRI','show','1', new Map<String,String>{'MDIFRIE'=>'checkbox', ///////difficulties
                                                                      'MDIFRIH'=>'checkbox',
                                                                      'MDIFRIL'=>'checkbox',
                                                                      'MDIFRIA'=>'checkbox',
                                                                      'MDIFRIUK'=>'checkbox',
                                                                      'MDIFRIO'=>'checkbox'
                                                                        });
        
        skip.skipLibrary('MPIOTH', 'show', 'true', new Map<String, String>{'MPIOSP'=>'text'});//other physical injury  
        
        skip.skipLibrary('MSTOTH', 'show', 'true', new Map<String, String>{'MSTOSP'=>'text'});//other stress
        
        skip.skipLibrary('MKILOTH', 'show', 'true', new Map<String, String>{'MKILOSP'=>'text'});//other killed    
        
        skip.skipLibrary('MDIFRIO', 'show', 'true', new Map<String, String>{'MDIFRIOSP'=>'text'});//other difficulties
        
        
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Set the obj name 
        form.setObjName('DS_Background_Family_Info_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(form.skip.skipList); 
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('MILITARY');
        
    }
    
    public List<SelectOption> getMoveItems(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0', '0'));
        options.add(new SelectOption('1', '1-2'));
        options.add(new SelectOption('2', '3-4'));
        options.add(new SelectOption('3', '5-10'));
        options.add(new SelectOption('4', 'Greater than 10'));
        options.add(new SelectOption('99', 'Unknown'));
        
        return options;
    }
    
    public List<SelectOption> getServeItems(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0', '0'));
        options.add(new SelectOption('1', '1'));
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5', 'Greater than 4'));
        options.add(new SelectOption('99', 'Unknown'));
        
        return options;
    }
    public List<SelectOption> getIsDiffItems(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0', 'No'));
        options.add(new SelectOption('1', 'Yes'));
        options.add(new SelectOption('99', 'Unknown'));
        
        return options;
    }
    
    public List<SelectOption> getRelationItems(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0', 'Mother'));
        options.add(new SelectOption('1', 'Father'));
        options.add(new SelectOption('2', 'Brother'));
        options.add(new SelectOption('3', 'Sister'));
        options.add(new SelectOption('98', 'Other'));   
        
        return options;
    }
    
    public List<SelectOption> getBranch1Items(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0', 'Army'));
        options.add(new SelectOption('1', 'Air Force'));
        options.add(new SelectOption('2', 'Navy'));
        options.add(new SelectOption('3', 'Marine Corps'));
        options.add(new SelectOption('4', 'Coast Guard'));  
        options.add(new SelectOption('99', 'Unknown'));   
        
        return options;
        
    }
    public List<SelectOption> getBranch2Items(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0', 'Reserve'));
        options.add(new SelectOption('1', 'National Guard'));
        options.add(new SelectOption('99', 'Unknown'));   
        
        return options;
    }   
    
    public List<SelectOption> getStatusItems(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0', 'Active Duty'));
        options.add(new SelectOption('1', 'Retired'));
        options.add(new SelectOption('2', 'Separated'));
        options.add(new SelectOption('98', 'Other')); 
        options.add(new SelectOption('99', 'Unknown'));     
        
        return options;
    }
    
    public List<SelectOption> getWartimeItems(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0', 'No'));
        options.add(new SelectOption('1', 'Yes'));
        options.add(new SelectOption('99', 'Unknown'));   
        
        return options;
    }
    
    public List<SelectOption> getDeployItems(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0', 'Currently'));
        options.add(new SelectOption('1', 'Past 30 days'));
        options.add(new SelectOption('2', 'Past year'));
        options.add(new SelectOption('3', 'Greater than 1 year'));
        options.add(new SelectOption('99', 'Unknown'));   
        
        return options;
    }
    
    public List<SelectOption> getDeployAllItems(){
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('0', 'Less than 1 year'));
        options.add(new SelectOption('1', '1-2 years'));
        options.add(new SelectOption('2', 'Greater than 2 years'));
        options.add(new SelectOption('99', 'Unknown'));   
        
        return options;
    }
    
}