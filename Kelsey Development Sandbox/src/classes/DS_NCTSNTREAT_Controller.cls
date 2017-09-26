/**
* @author Danny Fu
* @date 05/18/2017
*
* @group Baseline
* @group-content /ApexDocContent/DS_Nctsntreat.htm
*
* @description The controller class for Treatment by NCTSN Center. 
*
* @modified 05/18/2017 DF Remove skiplogic for TXMODPRI(Q5, other), TXPRISIP(Q7, other) and TXLEADCL(Q10, other)
*/
public class DS_NCTSNTREAT_Controller extends DS_BasicForm_Controller {
    
    public DS_NCTSNTREAT_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        //#1
        skip.skipLibrary('TXRES','show','1', new Map<String, String>{'TXHOS'=>'checkbox', //#1a, Hospital
                                                                     'TXRTC'=>'checkbox', //#1a, Residential treatment center
                                                                     'TXGH'=>'checkbox',  //#1a, Group home
                                                                     'TXOI'=>'checkbox',  'TXOITYP'=>'text'}); //#1a, Other
                                                                     
        
        skip.skipLibrary('TXHOS','show','true', new Map<String, String>{'TXHOSDAY'=>'text'});   //#1a - Hospital  
        skip.skipLibrary('TXRTC','show','true', new Map<String, String>{'TXRTCDAY'=>'text'});   //#1a - Residential treatment center
        skip.skipLibrary('TXGH', 'show','true', new Map<String, String>{'TXGHDAY'=>'text'});    //#1a - Group home
        skip.skipLibrary('TXOI', 'show','true', new Map<String, String>{'TXOIDAY'=>'text'});    //#1a - Other                                                  
        
        //#2
        skip.skipLibrary('TXOP','show','1', new Map<String, String>{'TXITC'=>'checkbox',  //#2a, Individual therapy for child
                                                                    'TXITP'=>'checkbox',  //#2a, Individual therapy for parent
                                                                    'TXFDT'=>'checkbox',  //#2a, Family or Dyadic  
                                                                    'TXGT'=>'checkbox',   //#2a, Group therapy
                                                                    'TXMFG'=>'checkbox',  //#2a, Multi-family
                                                                    'TXOT'=>'checkbox',  'TXOTTYP'=>'text'}); //#2a, Other
        
        skip.skipLibrary('TXITC','show','true', new Map<String, String>{'TXITCVIS'=>'text'});  //#2a - Individual therapy for child  
        skip.skipLibrary('TXITP','show','true', new Map<String, String>{'TXITPVIS'=>'text'});  //#2a - Individual therapy for parent
        skip.skipLibrary('TXFDT','show','true', new Map<String, String>{'TXFDTVIS'=>'text'});  //#2a - Family or Dyadic
        skip.skipLibrary('TXGT', 'show','true', new Map<String, String>{'TXGTVIS'=>'text'});   //#2a - Group therapy
        skip.skipLibrary('TXMFG','show','true', new Map<String, String>{'TXMFGVIS'=>'text'});  //#2a - Multi-family
        skip.skipLibrary('TXOT', 'show','true', new Map<String, String>{'TXOTVIS'=>'text'});   //#2a - Other
        
        skip.skipLibrary('TXSOTH','show','true', new Map<String, String>{'TXSOTHSP'=>'text'});  //#3, other
        skip.skipLibrary('TXOTHMOD','show','true', new Map<String, String>{'TXOTMOSP'=>'text'});//#4, other
        skip.skipLibrary('TXSIPOTH','show','true', new Map<String, String>{'TXSIOTSP'=>'text'});//#6, other
        skip.skipLibrary('TXPSIOTH','show','true', new Map<String, String>{'TXPSOTSP'=>'text'});//#8, other
        skip.skipLibrary('TXOCLIN','show','true', new Map<String, String>{'TXOCLISP'=>'text'}); //#9, other
        
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Set the obj name 
        form.setObjName('DS_Background_Family_Info_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(form.skip.skipList); 
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('NCTSNTREAT');
        
    }
    
    // Q5
    public List<SelectOption> getTXMODPRIOption() {
    
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('1', 'Attachment-based therapy'));
        options.add(new SelectOption('2', 'Behavioral therapy'));
        options.add(new SelectOption('3', 'Cognitive therapy'));
        options.add(new SelectOption('4', 'Cognitive behavioral therapy'));
        options.add(new SelectOption('5', 'Day treatment or partial hospitalization'));
        options.add(new SelectOption('6', 'Expressive therapies (Drawing, movement, theater)'));
        options.add(new SelectOption('7', 'Family therapy'));
        options.add(new SelectOption('8', 'Intensive in-home services'));
        options.add(new SelectOption('9', 'Narrative therapy'));
        options.add(new SelectOption('10', 'Parent training'));
        options.add(new SelectOption('11', 'Peer therapy'));
        options.add(new SelectOption('12', 'Pharmacotherapy/medication'));
        options.add(new SelectOption('13', 'Phase-oriented trauma treatment'));
        options.add(new SelectOption('14', 'Play therapy'));
        options.add(new SelectOption('15', 'Psychoanalysis'));
        options.add(new SelectOption('16', 'Psychodynamic psychotherapy'));
        options.add(new SelectOption('17', 'School-based treatment'));
        options.add(new SelectOption('18', 'Social skills training'));
        options.add(new SelectOption('19', 'Solution-focused therapy'));
        options.add(new SelectOption('20', 'Stress management/relaxation training'));
        options.add(new SelectOption('21', 'Supportive therapy'));
        options.add(new SelectOption('22', '\'Wrap around\' services'));
        options.add(new SelectOption('98', 'Other'));
        options.add(new SelectOption('0', 'None/Not Applicable'));

        return options; 
            
    }
    
    //Q7
    public List<SelectOption> getTXPRISIPOption() {

        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('1','None'));
        options.add(new SelectOption('2','Alternatives for Families: A Cognitive Behavioral Therapy (AF-CBT)'));
        options.add(new SelectOption('3','Adapted Dialectical Behavior Therapy for Special Populations (DBT-SP)'));
        options.add(new SelectOption('4','Attachment, Self-Regulation, and Competence (ARC): A Comprehensive Framework for Intervention with Complexly Traumatized Youth'));
        options.add(new SelectOption('5','Child-Parent Psychotherapy (CPP)'));
        options.add(new SelectOption('6','Children with Problematic Sexual Behavior Cognitive-Behavioral Treatment Program: School-age Program (PSB-CBT)'));
        options.add(new SelectOption('7','Cognitive-Behavioral Intervention for Trauma in Schools (CBITS)'));
        options.add(new SelectOption('8','Combined Parent Child Cognitive-Behavioral Therapy: Empowering Families Who Are at Risk for Physical Abuse (CPC-CBT)'));
        options.add(new SelectOption('9','Combined Trauma-Focused Cognitive Behavioral Therapy (TF-CBT) and Selective Serotonin Reuptake Inhibitors (SSRI) Treatment'));
        options.add(new SelectOption('10','Culturally Modified Trauma-Focused Treatment (CM-TFT)'));
        options.add(new SelectOption('11','Eye Movement Desensitization and Reprocessing (EMDR)'));
        options.add(new SelectOption('12','Group Treatment for Children Affected by Domestic Violence'));
        options.add(new SelectOption('13','Integrative Treatment of Complex Trauma (ITCT)'));
        options.add(new SelectOption('14','Life Skills/Life Stories'));
        options.add(new SelectOption('15','Multi-systemic Treatment (MST)'));
        options.add(new SelectOption('16','Parent-Child Interaction Therapy (PCIT)'));
        options.add(new SelectOption('17','Real Life Heroes (RLH)'));
        options.add(new SelectOption('18','Safety, Mentoring, Advocacy, Recovery, and Treatment (SMART)'));
        options.add(new SelectOption('19','Sanctuary Model'));
        options.add(new SelectOption('20','Structured Psychotherapy for Adolescents Responding to Chronic Stress (SPARCS)'));
        options.add(new SelectOption('21','Trauma Affect Regulation: Guidelines for Education and Therapy (TARGET)'));
        options.add(new SelectOption('22','Trauma-Focused Cognitive Behavioral Therapy (TF-CBT)'));
        options.add(new SelectOption('23','Trauma-Focused Cognitive Behavioral Therapy for Childhood Traumatic Grief (TG-CBT)'));
        options.add(new SelectOption('24','Trauma-Focused Coping (TFC)/ Multimodality Trauma Treatment (MMTT)'));
        options.add(new SelectOption('25','Trauma-Informed Brief Intervention Services (TIBIS)'));
        options.add(new SelectOption('26','Trauma Systems Therapy (TST)'));
        options.add(new SelectOption('27','Trauma and Grief Component Therapy for Adolescents (TGCT-A)'));
        options.add(new SelectOption('28','Youth Dialectical Behavioral Therapy/ Dialectical Behavior Therapy for Adolescents (DBTA)'));
        options.add(new SelectOption('98','Other'));

        return options; 

    }
    
    // Q10
    public List<SelectOption> getTXLEADCLOption() {

        List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('1','Psychologist (Master’s or PhD)'));
        options.add(new SelectOption('2','School psychologist (Not recorded above)'));
        options.add(new SelectOption('3','Psychology trainee/intern'));
        options.add(new SelectOption('4','Social worker (MSW, LCSW)'));
        options.add(new SelectOption('5','School social worker'));
        options.add(new SelectOption('6','Social worker trainee/intern'));
        options.add(new SelectOption('7','Psychiatrist'));
        options.add(new SelectOption('8','Other physician not psychiatrist'));
        options.add(new SelectOption('9','Physician extender: (NP, PA), advanced practice nurse (MSN, CNS)'));
        options.add(new SelectOption('10','Nurse (RN, LPN)'));
        options.add(new SelectOption('11','Therapist/counselor (Not recorded above)'));
        options.add(new SelectOption('12','Occupational therapist/physical therapist'));
        options.add(new SelectOption('13','Paraprofessional'));
        options.add(new SelectOption('14','Translator/interpreter'));
        options.add(new SelectOption('98','Other')); 

        return options;

    }
    
}