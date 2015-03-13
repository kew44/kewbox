@isTest
public class TestClassData_DS_Codelist {

  public TestClassData_DS_Codelist() {
    
    List<List<String>> codeInfo = new List<List<String>>();

    //codeInfo.add(new List<String> {'Data_type__c', 'CODE', 'Codelist','LONGLABEL'});
    codeInfo.add(new List<String> {'DS_CODELIST','0','CTHTH','No Condition'});
    codeInfo.add(new List<String> {'DS_CODELIST','1','CTHTH','"Child has this condition, and it is a mild impact on daily living"'});
    codeInfo.add(new List<String> {'DS_CODELIST','2','CTHTH','Child has this condition and it is a moderate impact on daily living'});
    codeInfo.add(new List<String> {'DS_CODELIST','3','CTHTH','Child has this condition and it is a severe impact on daily living'});
    codeInfo.add(new List<String> {'DS_CODELIST','0','CTYNUN','No'});
    codeInfo.add(new List<String> {'DS_CODELIST','1','CTYNUN','Yes'});
    codeInfo.add(new List<String> {'DS_CODELIST','99','CTYNUN','Unknown'});
    codeInfo.add(new List<String> {'DS_CODELIST','FALSE','ZYES','NO'});

    codeInfo.add(new List<String> {'DS_CODELIST','0','CTCBCL','Not true'});
    codeInfo.add(new List<String> {'DS_CODELIST','1','CTCBCL','Somewhat'});
    codeInfo.add(new List<String> {'DS_CODELIST','2','CTCBCL','Very True'});
    codeInfo.add(new List<String> {'DS_CODELIST','99','CTCBCL','Unknown'});


    List<DS_DATA__c> infoBox = new List<DS_DATA__c>();

    for(List<String> f : codeInfo) {
    
      DS_DATA__c info = new DS_DATA__c();  

      info.Data_Type__c = f.get(0);
      info.CODE__c = f.get(1);
      info.CODELIST__c = f.get(2);
      info.LONGLABEL__c = f.get(3);

      infoBox.add(info);

    }

    List<DS_DATA__c> checkForm = [SELECT id 
                                    FROM DS_DATA__c 
                                   WHERE Data_type__c = 'DS_CODELIST'];
  
    if(checkForm.size() == 0) insert infoBox;

    //insert infoBox;

    System.debug(infoBox);

  }
    
}