@isTest
public class TestClassData_DS_SDQ_PSI_CDI_Form_Info{
public TestClassData_DS_SDQ_PSI_CDI_Form_Info(){
    
    List<List<String>> FormInfo = new List<List<String>>();
        
    //FormInfo.add(new List<String> {'Data_Type__c','Content__c','Object__c','Form__c','File_name__c','Age_Range__c','Source_form__c','Category__c','Page__c','Weight__c','Variable__c'});
    FormInfo.add(new List<String> {'DS_Form_Info','Strengths and Difficulties Questionnaire for Parents 4-10','DS_SDQ_PSI_CDI_B','DS_SDQ_P_04_10','BASELINE','4-10','DS_SDQ_P_04_10','Assessment','DS_SDQ_P_04_10','4','DS_SDQ_P_04_10'});
    FormInfo.add(new List<String> {'DS_Form_Info','Strengths and Difficulties Questionnaire for Parents 11-17','DS_SDQ_PSI_CDI_B','DS_SDQ_P_11_17','BASELINE','11-17','DS_SDQ_P_11_17','Assessment','DS_SDQ_P_11_17','5','DS_SDQ_P_11_17'});
    FormInfo.add(new List<String> {'DS_Form_Info','Strengths and Difficulties Questionnaire Self-Assessment 11-17','DS_SDQ_PSI_CDI_B','DS_SDQ_S_11_17','BASELINE','11-17','DS_SDQ_S_11_17','Assessment','DS_SDQ_S_11_17','6','DS_SDQ_S_11_17'});

  List<DS_DATA__c> infoBox = new List<DS_DATA__c>();

    for(List<String> f : FormInfo) {
    
        //FormInfo.add(new List<String> {'Data_Type__c','Content__c','Object__c','Form__c','File_name__c','Age_Range__c','Source_form__c','Category__c','Page__c','Weight__c','Variable__c'});

      DS_DATA__c info = new DS_DATA__c();   
      info.Data_Type__c = f.get(0);
      info.Content__c = f.get(1);
      info.Object__c = f.get(2);
      info.Form__c = f.get(3);
      info.File_name__c = f.get(4);
      info.Age_Range__c = f.get(5);
      info.Source_form__c = f.get(6);
      info.Category__c = f.get(7);
      info.Page__c = f.get(8);
      info.Weight__c = (f.get(9) != '') ? Integer.valueOf(f.get(9)) : null;
      info.Variable__c = f.get(10);


      infoBox.add(info);

    }

   List<DS_DATA__c> checkForm = [SELECT id FROM DS_DATA__c WHERE Data_type__c = 'DS_Form_Info' AND Object__c ='DS_SDQ_PSI_CDI_B'];
  
    if(checkForm.size() == 0) insert infoBox;

    //insert infoBox;

    System.debug(infoBox);

  }
    
}