/*Page Description:
*  Controller for VisualForce page DS_BSLC
*
*/

public with sharing class DS_BSLC_Controller extends DS_BasicForm_Controller {
    
    public String dateModuleStatus{get;set;}
    
    public DS_BSLC_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));        
        
        skip.skipLibrary('BSLCTREATMENT', 'show', '1', 
                         new Map<String,String>{ 'NCCTSBSLC'=>'radio',//q2
                                                 'TXTYPE'=>'radio',//q3
                                                 'TXSTDT'=>'text',//q4
                                                 'TXCOMPL'=>'radio'//q5
                                                 });    
                         
        skip.skipLibrary('TXTYPE', 'show', '98', new Map<String,String>{'TXTYPSP'=>'text'});//Q3 other    
        
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Set the obj name 
        form.setObjName('DS_Functioning_Forms_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();        
                
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(form.skip.skipList); 
        
        // Get field name from DS_DATA (variable
        bfVariableMap = form.getVariable('BSLC');
        
        dateModuleStatus= String.valueOf(form.obj.get(bfVariableMap.get('TXCOMPL')));        
        
    }
    
    public List<SelectOption> getTreatIems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('1','Trauma-Focused Cognitive Behavioral Therapy (TF-CBT) ')); 
        options.add(new SelectOption('2','Life Skills/Life Stories ')); 
        options.add(new SelectOption('3','Structured Psychotherapy for Adolescents Responding to Chronic Stress (SPARCS)    ')); 
        options.add(new SelectOption('4','Trauma Affect Regulation: Guidelines for Education and Therapy (TARGET)')); 
        options.add(new SelectOption('5','Trauma Systems Therapy (TST) ')); 
        options.add(new SelectOption('6','Child-Parent Psychotherapy (CPP) ')); 
        options.add(new SelectOption('7','Cognitive-Behavioral Intervention for Trauma in Schools (CBITS) ')); 
        options.add(new SelectOption('8','Children with Problematic Sexual Behavior Cognitive-Behavioral Treatment Program: School-age Program (PSB-CBT) ')); 
        options.add(new SelectOption('9','Parent-Child Interaction Therapy (PCIT) ')); 
        options.add(new SelectOption('10','Attachment, Self-Regulation, and Competence (ARC): A Comprehensive Framework for Intervention with Complexly Traumatized Youth '));
        options.add(new SelectOption('11','Alternatives for Families: A Cognitive Behavioral Therapy (AF-CBT) '));
        options.add(new SelectOption('98','Other')); 
        
        return options; 
        
    }
    public List<SelectOption> getYNCompletedIems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No, left this treatment before completing ')); 
        options.add(new SelectOption('1','Yes, completed treatment ')); 
        return options; 
        
    }
    
}