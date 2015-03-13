@isTest
public class TestClassData_DS_CBCL_Scale{

  public TestClassData_DS_CBCL_Scale() {
        
    List<List<String>> scales = new List<List<String>>();

    // Data_type__c, Gender__c, Age_range__c, scale__c, Sig_Range__c, Raw_score__c, T_Score__c, Percentile__c 

    // Girl 1.5_5
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '1.5_5', 'I',   'Normal',  '5', '62', '88'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '1.5_5', 'II',  'Clinical','10','74', '98+'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '1.5_5', 'III', 'Normal',  '4', '62', '88'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '1.5_5', 'IV',  'Normal',  '4', '63', '90'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '1.5_5', 'V',   'Clinical','10','76', '98+'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '1.5_5', 'VI',  'Normal',  '0', '50', '50'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '1.5_5', 'VII', 'Normal',  '4', '50', '50'});

    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '1.5_5', 'Internalizing', 'Clinical',  '23', '68', '96'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '1.5_5', 'Externalizing', 'Normal',    '4', '39', '<50'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '1.5_5', 'Total',         'Normal','49', '59', '81'});

    // Girl 6_11
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '6_11', 'I',   'Normal',  '2', '51', '54'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '6_11', 'II',  'Clinical',  '10', '80', '98+'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '6_11', 'III', 'Normal',  '1', '51', '54'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '6_11', 'IV',  'Normal',  '5', '59', '81'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '6_11', 'V',   'Borderline',  '5', '66', '94'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '6_11', 'VI',  'Normal',  '7', '62', '88'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '6_11', 'VII', 'Normal',  '1', '52', '58'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '6_11', 'VIII','Normal',  '11', '63', '90'});

    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '6_11', 'Internalizing', 'Borderline', '13', '63', '90'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '6_11', 'Externalizing', 'Borderline', '12', '60', '84'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Girl', '6_11', 'Total',         'Borderline', '46', '63', '90'});

    // Boy 12_18
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Boy', '12_18', 'I',   'Normal',    '11', '72', '98+'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Boy', '12_18', 'II',  'Clinical',  '8',  '70', '98+'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Boy', '12_18', 'III', 'Normal',    '3',  '61', '86'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Boy', '12_18', 'IV',  'Borderline','8',  '69', '97'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Boy', '12_18', 'V',   'Borderline','5',  '66', '94'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Boy', '12_18', 'VI',  'Clinical',  '15', '76', '98+'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Boy', '12_18', 'VII', 'Normal',    '6',  '62', '88'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Boy', '12_18', 'VIII','Clinical',  '19', '73', '98+'});

    scales.add(new List<String> {'DS_CBCL_SCALES', 'Boy', '12_18', 'Internalizing',  'Clinical',  '22', '70', '98'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Boy', '12_18', 'Externalizing',  'Clinical',  '25', '69', '97'});
    scales.add(new List<String> {'DS_CBCL_SCALES', 'Boy', '12_18', 'Total',          'Clinical',  '81', '71', '98+'});


    List<DS_DATA__c> infoBox = new List<DS_DATA__c>();

    for(List<String> f : scales) {

      DS_DATA__c info = new DS_DATA__c();

      info.Data_Type__c = f.get(0);
      info.Gender__c = f.get(1);
      info.Age_Range__c = f.get(2);
      info.Scale__c = f.get(3);
      info.Sig_Range__c = f.get(4);
      info.Raw_Score__c = Decimal.valueOf(f.get(5));
      info.T_Score__c = Decimal.valueOf(f.get(6));
      info.Percentile__c = f.get(7);

      infoBox.add(info);

    }

    List<DS_DATA__c> checkForm = [SELECT id FROM DS_DATA__c WHERE Data_Type__c = 'DS_CBCL_SCALES'];

    if(checkForm.size() == 0) insert infoBox;

  }
    
}