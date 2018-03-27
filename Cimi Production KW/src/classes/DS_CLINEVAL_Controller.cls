/**
* @author Danny Fu
* @date 05/18/2017
*
* @group Baseline
* @group-content /ApexDocContent/DS_Clineval.htm
*
* @description The controller class for Clinical Evaluation. 
*
* @modified 05/18/2017 DF Remove skiplogic for CEPRIM field
*/
public with sharing class DS_CLINEVAL_Controller extends DS_BasicForm_Controller {
    
    public DS_CLINEVAL_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        skip.skipLibrary('CEOTHY', 'show', '1', new Map<String,String>{'CEOTHER'=>'text'});    
        
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Set the obj name 
        form.setObjName('DS_Functioning_Forms_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(form.skip.skipList); 
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('CLINEVAL');
        
    }
     
    public List<SelectOption> getPrimaryProbIems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('1','Attention-Deficit/Hyperactivity Disorder (ADHD) ')); 
        options.add(new SelectOption('2','Bipolar Disorder ')); 
        options.add(new SelectOption('3','Depressive Symptoms ')); 
        options.add(new SelectOption('4','Depressive Disorder')); 
        options.add(new SelectOption('5','Traumatic/Complicated Grief ')); 
        options.add(new SelectOption('6','Generalized Anxiety Disorder ')); 
        options.add(new SelectOption('7','Separation Anxiety Disorder ')); 
        options.add(new SelectOption('8','Social Anxiety Disorder (Social Phobia) ')); 
        options.add(new SelectOption('9','Panic Disorder')); 
        options.add(new SelectOption('10','Specific Phobia ')); 
        options.add(new SelectOption('11','Obsessive Compulsive and Related Disorders ')); 
        options.add(new SelectOption('12','Acute Stress Disorder ')); 
        options.add(new SelectOption('13','Post-Traumatic Stress Disorder ')); 
        options.add(new SelectOption('14','Adjustment Disorder')); 
        options.add(new SelectOption('15','Attachment Problems/Difficulties')); 
        options.add(new SelectOption('16','Dissociative Symptoms')); 
        options.add(new SelectOption('17','Dissociative Disorder')); 
        options.add(new SelectOption('18','Somatization ')); 
        options.add(new SelectOption('19','Feeding and Eating Disorder ')); 
        options.add(new SelectOption('20','Sleep-Wake Disorder ')); 
        options.add(new SelectOption('21','Sexual Behavioral Problems ')); 
        options.add(new SelectOption('22','Oppositional Defiant Disorder ')); 
        options.add(new SelectOption('23','Conduct Disorder ')); 
        options.add(new SelectOption('24','Intermittent Explosive Disorder ')); 
        options.add(new SelectOption('25','General Behavioral Problems')); 
        options.add(new SelectOption('26','Substance Abuse Problems ')); 
        options.add(new SelectOption('27','Substance-Related and Addictive Disorders ')); 
        options.add(new SelectOption('28','Suicidality')); 
        options.add(new SelectOption('29','Suicidal Behavior Disorder ')); 
        options.add(new SelectOption('30','Psychotic Disorder '));
        options.add(new SelectOption('98','Other')); 
        
        return options; 
        
    }
    
}