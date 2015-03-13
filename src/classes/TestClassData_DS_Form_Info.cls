@isTest
public class TestClassData_DS_Form_Info{

  public TestClassData_DS_Form_Info() {
    
    List<List<String>> FormInfo = new List<List<String>>();
        
     //FormInfo.add(new List<String>{'Data_Type__c', 'Object__c',                   'Page__c',  'Weight__c','Variable__c','Content__c',         'Category__c',  'Form__c', Source_form__c', 'Age_Range','File_name','Note__c'});
//Baseline forms
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Functioning_Forms_B','DS_CLINEVAL',   '15',           'DS_CLINEVAL','Clinical Evaluation','Baseline','DS_CLINEVAL',   'CLINEVAL',     '',     'BASELINE',     ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Functioning_Forms_B','DS_BSLC',       '17',           'DS_BSLC',  'Learning Collaborative','Baseline','DS_BSLC',          'BSLC',     '',     'BASELINE',     ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Functioning_Forms_B', 'DS_BIS',       '16',           'DS_BIS',       'Brief Intervention','Baseline','DS_BIS',           'BIS',      '',     'BASELINE',     ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Background_Family_Info_B','DS_MILITARY','11',     'DS_MILITARY',      'Military',         'Baseline','DS_MILITARY',       'MILITARY',     '',     'BASELINE',     ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Functioning_Forms_B',     'DS_NOMS'   ,'6',           'DS_NOMS',      'NOMS',             'Baseline','DS_NOMS',               'NOMS',     '',     'BASELINE',     ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Background_Family_Info_B','DS_HEALTH','12',        'DS_HEALTH',    'Health Module',        'Baseline','DS_HEALTH',        'HEALTH',        '',    'BASELINE',    ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Background_Family_Info_B','DS_DOMENV','5',        'DS_DOMENV',    'Domestic Environment',    'Baseline','DS_DOMENV',    'DOMENV',        '',    'BASELINE',    ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Background_Family_Info_B','DS_INSDOMENV','4',    'DS_INSDOMENV',    'Insurance Info',        'Baseline','DS_INSDOMENV',    'INSDOMENV', '',    'BASELINE',    ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Background_Family_Info_B','DS_REFIMM','10',    'DS_REFIMM',        'Refugee and Immigrant Families Form','Baseline','DS_REFIMM','REFIMM','',    'BASELINE',    ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Functioning_Forms_B','DS_CANSTR','14',        'DS_CANSTR',        'CANS Strengths',            'Baseline','DS_CANSTR',        'CANSTR',    '',    'BASELINE',    ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Functioning_Forms_B','DS_YCINDSEV','8',        'DS_YCINDSEV', 'Indicators of Severity of Problems 6 YC','Baseline','DS_YCINDSEV','YCINDSEV','',    'BASELINE',    ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Functioning_Forms_B','DS_SERVREC','9',        'DS_SERVREC',      'Service Use  30 Days, Year, Trauma','Baseline','DS_SERVREC','SERVREC',    '',    'BASELINE',    ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Functioning_Forms_B','DS_FAPGAR','13',        'DS_FAPGAR',        'Family Assesment Module',    'Baseline','DS_FAPGAR',        'FAPGAR',    '',    'BASELINE',    ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Functioning_Forms_B','DS_INDSEV','3',        'DS_INDSEV',        'Indicators of Severity of Problems','Baseline','DS_INDSEV','INDSEV',    '7-18',    'BASELINE',    ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_Background_Family_Info_B','DS_DEMO','2',    'DS_DEMO',       'Baseline Visit and Demographic Information','Baseline','DS_DEMO','DEMO',    '',        'BASELINE',        ''});
//CBCL   
    FormInfo.add(new List<String> {'DS_Form_Info','DS_CBCL_B',            'DS_CBCL_0_5','2',    'DS_CBCL_0_5',    'Child Behavior Checklist for Ages 1.5-5','Assessment','DS_CBCL_0_5','DS_CBCL_0_5','1.5-5','BASELINE',    ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_CBCL_B',        'DS_CBCL_6_18','3',        'DS_CBCL_6_18',    'Child Behavior Checklist for Ages 6-18','Assessment','DS_CBCL_6_18','DS_CBCL_6_18','6-18','BASELINE',    ''});
//PTSD    
    FormInfo.add(new List<String> {'DS_Form_Info','DS_PTSD_CA_B',    'DS_PTSD_CA',    '1',        'DS_PTSD_CA',    'PTSD Reaction Index for Children/Adolescents','Assessment','DS_PTSD_CA',    '',         '','BASELINE',    ''});
     
//FormInfo.add(new List<String>{'Data_Type__c', 'Object__c',          'Page__c',  'Weight__c','Variable__c','Content__c',         'Category__c',  'Form__c', Source_form__c', 'Age_Range','File_name','Note__c'});
//SDQ   
    FormInfo.add(new List<String> {'DS_Form_Info','DS_SDQ_PSI_CDI_B','DS_SDQ_P_04_10','6','DS_SDQ_P_04_10','Strengths and Difficulties Questionnaire for Parents 4-10','Assessment','DS_SDQ_P_04_10','DS_SDQ_P_04_10','4-10','BASELINE',''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_SDQ_PSI_CDI_B','DS_SDQ_P_11_17','7','DS_SDQ_P_11_17','Strengths and Difficulties Questionnaire for Parents 11-17','Assessment','DS_SDQ_P_11_17','DS_SDQ_P_11_17','11-17','BASELINE',''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_SDQ_PSI_CDI_B','DS_SDQ_S_11_17','8','DS_SDQ_S_11_17','Strengths and Difficulties Questionnaire Self-Assessment 11-17','Assessment','DS_SDQ_S_11_17','DS_SDQ_S_11_17','11-17','BASELINE',''});
/*//TSCC/TSCYC  
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TSCC_TSCYC_B','DS_TSCC_B','9','DS_TSCC_B','TSCC','Assessment','DS_TSCC_B','DS_TSCC_B','7-11','BASELINE',''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TSCC_TSCYC_B','DS_TSCYC_B','10','DS_TSCYC_B','TRAUMA SYMPTOM CHECKLIST FOR YOUNG CHILDREN','Assessment','DS_TSCYC_B','DS_TSCYC_B','3-12','BASELINE',''});*/
//TRAUMA  
//FormInfo.add(new List<String>{'Data_Type__c', 'Object__c',   'Page__c',  'Weight__c','Variable__c','Content__c'    'Category__c',  'Form__c', Source_form__c', 'Age_Range','File_name','Note__c'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_GTRAUMA','DS_GTRAUMA','',        'GT','General Trauma Information Form','GT',    '',        '',            '',        'BASELINE',    ''});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRSEX','1','GT1R','Sexual Maltreatment/Abuse',            'TD',    '',        '',            '',        '',            'Actual or attempted sexual molestation, exploitation, or coercion by a caregiver'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRSEXASSAULT','2','GT2R','Sexual Assault/Rape',            'TD',    '',        '',            '',        '',        'Actual or attempted sexual molestation, exploitation, or coercion not by a caregiver and not recorded as sexual abuse)'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRCOMMEXP','3','GT3R','Commercial Sexual Exploitation',    'TD',    '',        '',            '',        '',        'Child has been offered, obtained, or engaged in any kind of sexual activity in exchange for anything of value, money, goods, personal benefit, in-kind favors, or some other kind of benefit)'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRABUSE','4','GT4R','Physical Maltreatment/Abuse',            'TD',    '',        '',        '',        '',        'Actual or attempted infliction of physical pain or bodily injury by a caregiver)'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRPHYSASSAULT','5','GT5R','Physical assault',                    'TD',    '',        '',        '',        '',    'Actual or attempted infliction of physical pain or bodily injury not by a caregiver and not recorded as physical abuse )'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRPSYCHABUSE','6','GT6R','Emotional Abuse/Psychological Maltreatment','TD','',        '',        '',        '','Emotional abuse, verbal abuse, excessive demands, emotional neglect)'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRNEGLECT','7','GT7R','Neglect',                                        'TD','',        '',        '',        '','Physical, medical, or educational neglect'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRDOMVIO','8','GT8R','Domestic Violence',                                'TD','',        '',        '',    '',    'Exposure to physical, sexual, and/or emotional abuse directed at adult caregivers in the home'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRWAR','9','GT9R','War/Terrorism/Political violence inside the U.S.',    'TD','',        '',        '',    '',    'Exposure to any of these events inside the U.S.'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRWAROUTSIDEUS','10','GT10R','War/Terrorism/Political violence outside the U.S.','TD','',   '',        '',    '','Exposure to any of these events outside of the U.S.'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRMEDICAL','11','GT11R','Illness/Medical Trauma',                                'TD','',    '',        '',    '','Life threatening or extremely painful illness or medical procedure'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRACCIDENT','12','GT12R','Serious injury/Accident',                                'TD','',    '',    '',    '','Unintentional accident or injury)'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL1','DS_TRNATURALDIS','13','GT13R','Natural disaster',                                     'TD','',    '',    '',    '','Major accident or disaster that is the result of a natural event'});
    
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL2','DS_TRKIDNAP','14','GT14R','Kidnapping','TD','','','','','Unlawful seizure or detention against the child?s will'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL2','DS_TRBEREAVE','15','GT15R','Loss or bereavement','TD','','','','','Death or separation of a primary caregiver or sibling; the unexpected, or premature death of a close relative or close friend'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL2','DS_TRSEPARATION','16','GT16R','Separation','TD','','','','','Separation of a primary caregiver or sibling'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL2','DS_TRDISPLACE','17','GT17R','Forced displacement','TD','','','','','Forced relocation due to political reasons'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL2','DS_TRIMPCARE','18','GT18R','Impaired Caregiver','TD','','','','','History of exposure to caretaker depression, other medical illness, or alcohol/drug abuse'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL2','DS_TRVIOLENCE','19','GT19R','Extreme interpersonal violence','TD','','','','','e.g., Homicide/suicide'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL2','DS_TRCOMMVIO','20','GT20R','Community violence','TD','','','','','e.g., Gang-related violence, neighborhood violence'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL2','DS_TRSCHOOLVIO','21','GT21R','School violence','TD','','','','','e.g., School shooting, bullying, classmate suicide'});
    FormInfo.add(new List<String> {'DS_Form_Info','DS_TRDETAIL2','DS_TRBULLYING','22','GT22R','Bullying','TD','','','','','Unwanted aggressive behavior among school aged children that involves a real or perceived power imbalance'});
  //  FormInfo.add(new List<String> {'DS_Form_Info','','DS_TROTHER','23','GT23R','Other Trauma','TD','','','','',''});

    List<DS_DATA__c> infoBox = new List<DS_DATA__c>();

    for(List<String> f : FormInfo) {
        
     //FormInfo.add(new List<String>{'Data_Type__c', 'Object__c','Page__c',  'Weight__c','Variable__c','Content__c','Category__c',  'Form__c', Source_form__c', 'Age_Range','File_name','Note__c'});

      DS_DATA__c info = new DS_DATA__c();
      info.Data_type__c = f.get(0);
      info.Object__c = f.get(1);
      info.Page__c = f.get(2);
      info.Weight__c = (f.get(3) != '') ? Integer.valueOf(f.get(3)) : null;
      info.Variable__c = f.get(4);
      info.Content__c = f.get(5);
      info.Category__c = f.get(6);
      info.Form__c = f.get(7);
      info.Source_form__c = f.get(8);
      info.Age_Range__c = f.get(9);
      info.File_name__c = f.get(10);
      info.Note__c = f.get(11);

      infoBox.add(info);

    }

   List<DS_DATA__c> checkForm = [SELECT id FROM DS_DATA__c WHERE Data_type__c = 'DS_Form_Info'];

    if(checkForm.size() == 0) insert infoBox;

    //insert infoBox;

    System.debug(infoBox);

  }
    
}