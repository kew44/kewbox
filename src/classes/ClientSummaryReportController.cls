public with sharing class ClientSummaryReportController {

  Utility ut = new Utility();
  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

  String cID;

  public Decimal visitAge { get; set; }

  public String cimi { get; set; }
  
  String summaryID;

  public String forceRedirect {get; set;} 

  Boolean edit = FALSE;

  public String subtitle {get; set;}  
    
  public Client__c client { get; set; }

  public String visitType { get; set; }
  public Integer section { get; set; }

  public SObject clientBackgroundInfo {get; set;}
  public SObject clientFunctioningForm {get; set;}
  public SObject clientCBCL{get;set;}
  public SObject clientPTSD{get;set;}
  public SObject clientSDQ{get;set;}
  
  //Cans vars
  public List<String> cansOptions { get; set; }
  public Boolean cansExisted { get; set; }
  public List<Element> cansList { get; set; }
  public AscElementList[] cans { get; set; }

  //Indsev & Ycindsev (ios) vars
  public List<String> iosOptions { get; set; }
  public List<String> YCiosOptions { get; set; }
  public Boolean iosExisted { get; set; }
  public Boolean iosCriticalExisted { get; set; }
  public List<Element> iosList { get; set; }
  public DescElementList[] ios { get; set; }
  public List<String> iosCritical { get; set; }

  //Gen Trauma vars
  public DS_GTRAUMA__c gtObj { get; set; }
  public List<gtItem> rowsGTRAUMA { get; set; }
  public List<String> ageNum { get; set; } 
  public Boolean traumaExisted { get; set; }
  public AscGTItemList[] gTRAUMA { get; set; }

  //Service Rec vars
  public Boolean serviceExisted { get; set; }
  public Boolean service30Existed { get; set; }
  public Boolean serviceLifeExisted { get; set; }
  public Map<Integer, Element> service { get; set; }
  public List<String> service30 { get; set; }
  public List<String> serviceLife { get; set; }
  
  //CBCL vars  
  public List<String>CBCLOptions {get;set;}
  public Boolean CBCLExisted {get;set;}
  public List<CBCLElement> cbclList{get;set;}
  
  //PTSD vars
  public Boolean PTSDExisted{get;set;}
  public List<PTSDElement> ptsdlist{get;set;}
  public Integer IntrusionNum {get;set;}
  public Integer AvoidNum {get;set;}
  public Integer MoodNum {get;set;}
  public Integer ReactNum {get;set;}
  
  //SDQ vars
  public Boolean SDQExisted{get;set;}
  public Boolean SDQParentExisted{get;set;}
  public Boolean SDQSelfExisted{get;set;}
  public List<SDQElement> sdqList {get;set;}

  //Generic Standardized measures (PTSD+CBCL+SDQ) vars
  public Boolean measureExisted { get; set; }
  public Map<Integer, Element> measure { get; set; }

  //Clin Eval vars
  public Boolean evaluationExisted { get; set; }
  public Boolean evaluationPrimaryExisted { get; set; }
  public Boolean evaluationOtherExisted { get; set; }
  public Map<Integer, Element> otherEvaluationList { get; set; }
  public DescElementList[] otherEvaluation { get; set; }
  public String evaluationPrimary { get; set; }

  public String BorF { get; set; }
  
  //print button var and method
  public Boolean printReport { get; set; }  
  public void init() { 
      printReport = (Apexpages.currentPage().getParameters().get('print') == '1') ? true : false;
  }

  //sort ascending method
  public class AscElementList implements Comparable {

    public Element element { get; set; }

    public AscElementList(Element element) {
      this.element = element;
    }

    public Integer compareTo(Object compareTo) {
      // Cast argument to ascElementList
      AscElementList compareToOppy = (AscElementList)compareTo;
      
      // The return value of 0 indicates that both elements are equal.
      Integer returnValue = 0;

      if (element.value > compareToOppy.element.value) {
          // Set return value to a positive value.
          returnValue = 1;
      } else if (element.value < compareToOppy.element.value) {
          // Set return value to a negative value.
          returnValue = -1;
      }
      
      return returnValue;       
    }

  }

  //sort descending method
  public class DescElementList implements Comparable {

    public Element element { get; set; }

    public DescElementList(Element element) {
      this.element = element;
    }

    public Integer compareTo(Object compareTo) {
      // Cast argument to ascElementList
      DescElementList compareToOppy = (DescElementList)compareTo;
      
      // The return value of 0 indicates that both elements are equal.
      Integer returnValue = 0;

      if (element.value < compareToOppy.element.value) {
          // Set return value to a positive value.
          returnValue = 1;
      } else if (element.value > compareToOppy.element.value) {
          // Set return value to a negative value.
          returnValue = -1;
      }
      
      return returnValue;       
    }

  }

  //record
  public class Element {

    public String item { get; set; }
    public String field { get; set; }
    public Integer value { get; set; }

    public element(String item, String field, Integer value) {
      this.item = item; 
      this.field = field; 
      this.value = value;
    }

  }
  
  //CBCL record
  public class CBCLElement{
  
    public String category {get;set;}
    public String tscore {get;set;}
    public String percentile {get;set;}
    public String significance {get;set;}
    
    public cbclelement(String category, String tscore,String percentile, String significance){
        this.category = category;
        this.tscore = tscore;
        this.percentile = percentile;
        this.significance = significance;
    }
}

  //PTSD record
  public class PTSDElement{
    public String clusterName {get;set;}
    public String met{get;set;}
    
    public ptsdelement(String clusterName,String met){
        this.clusterName=clusterName;
        this.met=met;
    }
    }

//SDQ record
    public class SDQElement{
    public String category {get;set;}
    public Integer score {get;set;}
    public String significance {get;set;}
    
    public sdqelement (String category,Integer score,String significance){
        this.category=category;
        this.score=score;
        this.significance=significance;
        }
    }
  //sort ascending GT
  public class AscGTItemList implements Comparable {

    public GTItem element { get; set; }

    public AscGTItemList(GTItem element) {
      this.element = element;
    }

    public Integer compareTo(Object compareTo) {
      // Cast argument to ascElementList
      AscGTItemList compareToOppy = (AscGTItemList)compareTo;
      
      // The return value of 0 indicates that both elements are equal.
      Integer returnValue = 0;

      if (element.exp > compareToOppy.element.exp) {
          // Set return value to a positive value.
          returnValue = 1;
      } else if (element.exp < compareToOppy.element.exp) {
          // Set return value to a negative value.
          returnValue = -1;
      }
      
      return returnValue;       
    }

  }

  //GT record
  public class GTItem {
      
    public String num { get; set; }
    public String trauma { get; set; }
    public String field { get; set; }
    public List<String> ages { get; set; }
    public Integer value { get; set; }
    public String exp { get; set; }
        
    public GTItem(String num, String trauma, String field, 
                  List<String> ages, Integer value, String exp) {
      this.num = num;
      this.trauma = trauma;
      this.field = field;
      this.ages = ages;      
      this.value = value;
      this.exp = exp;
    }
  
  }
  
  

  public ClientSummaryReportController(ApexPages.StandardController controller) {

    cID = parameter.get('c');

    cimi = Apexpages.currentPage().getParameters().get('cimi');

    section = Integer.valueOf(parameter.get('section'));

    BorF = (section > 0) ? 'F' : 'B';
    visitType = (section > 0) ? 'Follow-up' : 'Baseline';
    
    client = Database.query('SELECT ' + ut.getFields('Client__c') +  
                            '  FROM Client__c ' +
                            ' WHERE id = \'' + cID + '\'');


    subtitle = '(' + client.Name + ') ' + client.INIT__c;
//background
    List<SObject> background = 
      Database.query('SELECT '+ut.getFields('DS_Background_Family_Info_'+BorF+'__c')+
                     '  FROM DS_Background_Family_Info_'+BorF+'__c' +
                     ' WHERE client__c = \'' + cID + '\'' +
                     '   AND SECTION__c = \''+ section + '\'');

    if(background.size() > 0) clientBackgroundInfo = background.get(0);

//functioning
    List<SObject> functioning = 
      Database.query('SELECT '+ut.getFields('DS_Functioning_Forms_'+BorF+'__c')+  
                     '  FROM DS_Functioning_Forms_'+BorF+'__c' +
                     ' WHERE client__c = \'' + cID + '\'' +
                     '   AND SECTION__c = \''+ section + '\'');
                     
    if(functioning.size() > 0) clientFunctioningForm = functioning.get(0);
//CBCL
  List<SObject> cbcl = 
        Database.query('SELECT ' + ut.getFields('DS_CBCL_'+BorF+'__c') +  
                       '  FROM DS_CBCL_' + BorF + '__c' +
                       ' WHERE client__c = \'' + cID + '\'');
                       
    if(cbcl.size() > 0) clientCBCL= cbcl.get(0);

//PTSD 
      List<SObject> ptsd = 
        Database.query('SELECT ' + ut.getFields('DS_PTSD_CA_'+BorF+'__c') +  
                     '  FROM DS_PTSD_CA_' + BorF + '__c' +
                     ' WHERE client__c = \'' + cID + '\''); 
                      
    if(ptsd.size() > 0) clientPTSD= ptsd.get(0);
    
//SDQ
    List<Sobject> sdq = 
        Database.query('SELECT ' + ut.getFields('DS_SDQ_PSI_CDI_'+BorF+'__c') +  
                     '  FROM DS_SDQ_PSI_CDI_' + BorF + '__c' +
                     ' WHERE client__c = \'' + cID + '\''); 
                      
    if(sdq.size() > 0) clientSDQ= sdq.get(0);
                       
    Date dob = Date.valueOf(client.DOB1__c);
    Date visitDate = Date.valueOf(clientBackgroundInfo.get('BDOV__c'));
    visitAge = dob.daysBetween(visitDate)/365;

    cansExisted = false;
    iosExisted = false;
    iosCriticalExisted = false;
    traumaExisted = false;
    serviceExisted = false;
    service30Existed = false;
    serviceLifeExisted = false;
    measureExisted = false;
    evaluationExisted = false;
    evaluationPrimaryExisted = false;
    evaluationOtherExisted = false;    
    CBCLExisted = false;
    PTSDExisted = false;
    SDQParentExisted = false;
    SDQSelfExisted = false;
    SDQExisted = false;

    if(clientFunctioningForm != null) { 
      cans(); ios();  service(); measure(); evaluation(); 
    }
    
    trauma();
   if(clientCBCL != null){
    CBCLrec();
    }
   if(clientPTSD != null){
    PTSDrec();
    }
   if(clientSDQ != null){
    SDQrec();
    }
   } 
    
  //CBCL
  public void CBCLrec(){
  cbclList = new List<CBCLElement>();
  
  CBCLOptions  =
      new List<String>{'Borderline','Clinical'};//need normal?
      
     // CBCL 1.5 - 5
     if(visitAge < 6) {
      cbclList.add(new CBCLElement('Overall Score',
      String.valueOf(clientCBCL.get(BorF+'CBTSTY__c')),
      String.valueOf(clientCBCL.get(BorF+'CBTSPY__c')),
      String.valueOf(clientCBCL.get(BorF+'CBTSSY__c'))));      
      
      cbclList.add(new CBCLElement('Internalizing Score',
      String.valueOf(clientCBCL.get(BorF+'CBIBTY__c')),//
      String.valueOf(clientCBCL.get(BorF+'CBIBPY__c')),//
      String.valueOf(clientCBCL.get(BorF+'CBIBSY__c'))));//
      
      cbclList.add(new CBCLElement('Externalizing Score',
      String.valueOf(clientCBCL.get(BorF+'CBEBTY__c')),////,
      String.valueOf(clientCBCL.get(BorF+'CBEBPY__c')),////,
      String.valueOf(clientCBCL.get(BorF+'CBEBSY__c'))));//
        }
     // CBCL 6 - 18
      else {
      cbclList.add(new CBCLElement('Overall Score',
      String.valueOf(clientCBCL.get(BorF+'CBTST__c')),
      String.valueOf(clientCBCL.get(BorF+'CBTSP__c')),
      String.valueOf(clientCBCL.get(BorF+'CBTSS__c'))));      
      
      cbclList.add(new CBCLElement('Internalizing Score',
      String.valueOf(clientCBCL.get(BorF+'CBIBT__c')),//
      String.valueOf(clientCBCL.get(BorF+'CBIBP__c')),//
      String.valueOf(clientCBCL.get(BorF+'CBIBS__c'))));//
      
      cbclList.add(new CBCLElement('Externalizing Score',
      String.valueOf(clientCBCL.get(BorF+'CBEBT__c')),////,
      String.valueOf(clientCBCL.get(BorF+'CBEBP__c')),////,
      String.valueOf(clientCBCL.get(BorF+'CBEBS__c'))));//
        }
      
    for(CBCLElement cbclelement : cbclList) {   
    }
    cbclExisted = true;//(CBCLrec.size() > 0) ? true : false;  
  }
  
  //SDQ
  public void SDQrec(){
  sdqList = new List<SDQElement>();      
    if (visitAge>10){
    //Parent
    sdqList.add(new SDQElement('SDQ Parent Overall Stress Score', Integer.valueOf(clientSDQ.get(BorF+'SDPTOT__c')), String.valueOf(clientSDQ.get(BorF+'SDPTYP__c'))));
    //self
    sdqList.add(new SDQElement('SDQ Self Overall Stress Score', Integer.valueOf(clientSDQ.get(BorF+'SDSTOT__c')), String.valueOf(clientSDQ.get(BorF+'SDSTYP__c'))));
     }
    else
           //Parent
    sdqList.add(new SDQElement('SDQ Parent Overall Stress Score', Integer.valueOf(clientSDQ.get(BorF+'SDPTOT__c')), String.valueOf(clientSDQ.get(BorF+'SDPTYP__c'))));
           
           sdqExisted=  true;
           }
           
    
  //PTSD
  public void PTSDrec(){
  ptsdList = new List<PTSDElement>();
    if(visitAge >= 7) { 
    IntrusionNum = Integer.valueOf(clientPTSD.get(BorF+'PTSBMN__c'));
    AvoidNum = Integer.valueOf(clientPTSD.get(BorF+'PTSCMN__c'));
    MoodNum = Integer.valueOf(clientPTSD.get(BorF+'PTSDMN__c'));
    ReactNum = Integer.valueOf(clientPTSD.get(BorF+'PTSEMN__c'));
        if (IntrusionNum  ==1){
            ptsdList.add(new PTSDElement('Intrusion', String.valueOf(clientPTSD.get(BorF+'PTSBM__c'))));
        }
        if (AvoidNum ==1){
            ptsdList.add(new PTSDElement('Avoidance', String.valueOf(clientPTSD.get(BorF+'PTSCM__c'))));
        }
        if (MoodNum ==1){
            ptsdList.add(new PTSDElement('Negative Alterations in Cognitions/Mood', String.valueOf(clientPTSD.get(BorF+'PTSDM__c'))));
        }
        if (ReactNum ==1){
            ptsdList.add(new PTSDElement('Alterations in Arousal/Reactivity', String.valueOf(clientPTSD.get(BorF+'PTSEM__c'))));
        }  
  ptsdExisted = true;
  }
  }

  //Strengths
  public void cans() {

    cans = new List<AscElementList>();
    
    cansOptions = 
      new List<String>{'A well-developed strength',
                       'A useful strength',
                       'An area where strengths are identified',
                       'An area where no current strength is identified'};

    cansList = new List<Element>();

    cansList.add(new Element('Family', 'STFAM__c', null));
    cansList.add(new Element('Interpersonal', 'STINTP__c', null));
    cansList.add(new Element('Educational Setting', 'STEDU__c', null));
    cansList.add(new Element('Vocational', 'STVOC__c', null));
    cansList.add(new Element('Coping and Savoring Skills', 'STCOPE__c', null));
    cansList.add(new Element('Optimism', 'STOPT__c', null));
    cansList.add(new Element('Talent/Interests', 'STTAL__c', null));
    cansList.add(new Element('Spirtual/Religious', 'STSPIR__c', null));
    cansList.add(new Element('Community Life', 'STCOM__c', null));
    cansList.add(new Element('Relationship Permanence', 'STRELT__c', null));
    cansList.add(new Element('Resilience', 'STRESC__c', null));

    for(Element element : cansList) {

      Integer value = Integer.valueOf(clientFunctioningForm.get(BorF+element.field));

      element.value = value;

      if(value <=2 && value != null) 
        cans.add(new AscElementList(element));
          
    }
    
    cans.sort();
    
    cansExisted = (cans.size() > 0) ? true : false;

  }

  // Indicators of Severity
  public void ios() {

    iosOptions = new List<String>{
                                  'Not a Problem',
                                  'Somewhat/sometimes a problem',
                                  'Very much/often a problem.',
                                  ' '
                                  };
                                  
    YCiosOptions = new List<String>{
                                  '',
                                  'Mild',
                                  'Moderate',
                                  'Severe'
                                  };

    ios = new List<DescElementList>();

    iosList = new List<Element>();

    iosCritical = new List<String>();

    if(visitAge < 6) {

      iosList.add(new Element('Immediate Risk','IMRISK', null)); 
      iosList.add(new Element('Emotional Regulation','EMREG', null));  
      iosList.add(new Element('Feeding','FEEDING', null)); 
      iosList.add(new Element('Child Sleep Problems','SLEEP', null)); 
      iosList.add(new Element('Play','PLAY', null));  
      iosList.add(new Element('Preschool/Childcare','PRESCH', null));  
      iosList.add(new Element('Social functioning','SOCFUNC', null)); 
      iosList.add(new Element('Aggression','AGGRESS', null)); 
      iosList.add(new Element('Sexualized behaviors','SEXBEH', null)); 
      iosList.add(new Element('Child attachment difficulties','ATTACH', null)); 
      iosList.add(new Element('Developmental concerns','DEVEL', null));
      iosList.add(new Element('Atypical behaviors','ATYPBEH', null));
      
    }
    else {

      iosList.add(new Element('Academic Problems','ISPACAD', null)); 
      iosList.add(new Element('Behavior problems in school or daycare','ISPBEHS', null));  
      iosList.add(new Element('Problems with skipping school or daycare','ISPSKPS', null)); 
      iosList.add(new Element('Behavior problems at home or community','ISPBEHH', null)); 
      iosList.add(new Element('Suicidality','ISPSUIC', null));  
      iosList.add(new Element('Other self-injurious behaviors','ISPSINJ', null));  
      iosList.add(new Element('Developmentally inappropriate sexualized behaviors','ISPSXBE', null)); 
      iosList.add(new Element('Alcohol use','ISPALC', null)); 
      iosList.add(new Element('Substance use','ISPSA', null)); 
      iosList.add(new Element('Attachment problems','ISPATT', null)); 
      iosList.add(new Element('Criminal activity','ISPCRIM', null));
      iosList.add(new Element('Running away from home','ISPRUN', null));
      iosList.add(new Element('Commercial Sexual Acts','ISPCSA', null));
      iosList.add(new Element('Child has shown signs of an eating disorder','ISPED', null));
      iosList.add(new Element('Child has other medical problems or disabilities','ISPDISA', null));

    }

    List<Integer> removeElement = new List<Integer>();

    Map<String, String> criticalWords = new Map<String, String>();

    criticalWords.put('ISPSUIC', 'Suicidality');
    criticalWords.put('ISPSINJ', 'Other self-injurious behaviors');
    criticalWords.put('IMRISK',  'Immediate Risk');

    for(Element element : iosList) {

      Integer value = Integer.valueOf(clientFunctioningForm.get(BorF+element.field+'__c'));

      element.value = value;

      if(value == 1 || value == 2 || value == 3) ios.add(new DescElementList(element));

      if(criticalWords.containskey(element.field))
        if(element.field == 'IMRISK' && value == 3) 
          iosCritical.add(criticalWords.get(element.field));
        else if(element.field == 'ISPSUIC' && (value == 2 || value == 3))
          iosCritical.add(criticalWords.get(element.field));
        else if(element.field == 'ISPSINJ' && (value == 2 || value == 3))
          iosCritical.add(criticalWords.get(element.field));

    }

    ios.sort();

    iosExisted = (ios.size() > 0) ? true : false;

    iosCriticalExisted = (iosCritical.size() > 0) ? true : false;

  }

  public void trauma() {

    rowsGTRAUMA = new List<GTItem>();

    gTRAUMA = new List<AscGTItemList>();

    ageNum = new List<String>{'0','1','2','3','4','5','6','7','8','9','10',
                              '11','12','13','14','15','16','17','18'};

    String gtFields = ut.getFields('DS_GTRAUMA__c');
    
    List<DS_GTRAUMA__c> gt = 
      Database.query('SELECT ' + gtFields +   
                     '  FROM DS_GTRAUMA__c ' +
                     ' WHERE Client__c = \''+ cID + '\'');
                     
    if(gt.size() != 0) { 

      traumaExisted = true; 
      gtObj = gt.get(0); 

      List<DS_DATA__c> info = [SELECT Content__c, Weight__c, Page__c, Variable__c
                                 FROM DS_DATA__c 
                                WHERE Category__c = 'TD' 
                                  AND Data_Type__c = 'DS_Form_Info'
                             ORDER BY weight__c];

      Set<String> formId = new Set<String>();

      for(DS_DATA__c i : info) formId.add(i.id);

      Map<String, String> agesVarList = new Map<String, String>();

      for(DS_DATA__c i : info) {

        String exp = 'None';
      
        String count = string.valueof(i.Weight__c);
                          
        String trauma = i.Content__c;
        
        List<String> ages = new List<String>();
        
        for(Integer j = 0; j<19; j++) 
          ages.add('GT'+count+'RA'+j+'__c');
        
        ages.add('GT'+count+'RAU__c');

        String url = '';

        String field = 'GT'+count+'R__c';

        if(gtObj.get(field) == '1' || gtObj.get(field) == '2') {
          exp = (gtObj.get(field) == '1') ? 'Confirmed' : 'Suspected';
          Integer value = Integer.valueOf(gtObj.get(field));
          //rowsGTRAUMA.add(new GTItem(count, trauma, field, ages, value, url));
          gTRAUMA.add(new AscGTItemList(new GTItem(count, trauma, field, ages, value, exp)));
        }
        
      }

      gTRAUMA.sort();

    }

  }

  //Service Use
  public void service() {

    service = new Map<Integer, Element>();
    service30 = new List<String>();
    serviceLife = new List<String>();

    service.put(0, new Element('Inpatient psychiatric unit or a hospital for mental health problems', 'INPSY', null));
    service.put(1, new Element('Residential treatment center', 'RES', null));
    service.put(2, new Element('Detention center, training school, jail, or prison', 'DET', null));
    service.put(3, new Element('Group home', 'GROUP', null));
    service.put(4, new Element('Treatment foster care', 'TXFOS', null));
    service.put(5, new Element('Probation officer or court counselor', 'PROB', null));
    service.put(6, new Element('Day treatment program', 'DAYTR', null));
    service.put(7, new Element('Case management or care coordination', 'CASMG', null));
    service.put(8, new Element('In-home counseling', 'INHME', null));
    service.put(9, new Element('Outpatient therapy', 'OUTTX', null));
    service.put(10, new Element('Outpatient treatment from a psychiatrist', 'OUTPS', null));
    service.put(11, new Element('Primary care physician/pediatrician for symptoms related to trauma or emotional/ behavioral problems.', 'PRIMC', null));
    service.put(12, new Element('School counselor, school psychologist, or school social worker', 'SCHCN', null));
    service.put(13, new Element('Special class, special school, or Early Intervention Services', 'SPCL', null));
    service.put(14, new Element('Child welfare', 'CHWE2', null));
    service.put(15, new Element('Social services other than child welfare', 'SOCSE', null));
    service.put(16, new Element('Foster care', 'FOST', null));
    service.put(17, new Element('Therapeutic recreation services', 'REC', null));
    service.put(18, new Element('Hospital emergency room', 'ER', null));
    service.put(19, new Element('Self-help groups', 'SELFH', null));
    service.put(20, new Element('Medication management', 'MED', null));
    service.put(21, new Element('Home Visiting', 'HOMV', null));
    service.put(22, new Element('Head Start Program or Early Intervention Service Coordination', 'HEADS', null));
    service.put(23, new Element('Parent education and skill-building programs', 'PARED', null));
    service.put(24, new Element('Peer support / therapy', 'PEER', null));
    service.put(25, new Element('\'Wraparound\' services', 'WRAP', null));
    service.put(26, new Element('Mentor', 'MEN', null));
    service.put(27, new Element('Other - ', 'OTH', null));

    for(Integer index : service.keySet()) {

      Element element = service.get(index);

      element.value = 1;

      Integer value30 = Integer.valueOf(clientFunctioningForm.get(BorF+'OS'+element.field+'__c'));
      Integer valueLife = Integer.valueOf(clientFunctioningForm.get(BorF+'LT'+element.field+'__c'));

      if(value30 == 1) service30.add(element.item);
      if(valueLife == 1) serviceLife.add(element.item);

    }

    serviceExisted = (service30.size() > 0 || serviceLife.size() > 0) ? true : false;

    service30Existed = (service30.size() > 0) ? true : false;
    serviceLifeExisted = (serviceLife.size() > 0) ? true : false;


  }


  //Standardized Measures
  
  public void measure() {

    measure = new Map<Integer, Element>();    
    
    // PTSD
    if(visitAge >= 7) {
      List<SObject> ptsd = 
        Database.query('SELECT ' + ut.getFields('DS_PTSD_CA_'+BorF+'__c') +  
                     '  FROM DS_PTSD_CA_' + BorF + '__c' +
                     ' WHERE client__c = \'' + cID + '\''); 

      if(ptsd.size() > 0)
        measure.put(0, new Element('UCLA PTSD-RI Overall Raw Score', null, Integer.valueOf(ptsd.get(0).get(BorF+'PTSORN__c'))));
    }
    
    // CBCL
    if(visitAge >= 1.5 && visitAge < 19) {

      List<SObject> cbcl = 
        Database.query('SELECT ' + ut.getFields('DS_CBCL_'+BorF+'__c') +  
                       '  FROM DS_CBCL_' + BorF + '__c' +
                       ' WHERE client__c = \'' + cID + '\'');

    
      if(cbcl.size() > 0) {
        // CBCL 1.5 - 5
        if(visitAge < 6) {
          measure.put(1, new Element('CBCL Internalizing Behavior Raw Score', null, Integer.valueOf(cbcl.get(0).get(BorF+'CBIBRNY__c'))));
        }
        // CBCL 6 - 18
        else {
          measure.put(1, new Element('CBCL Internalizing Behavior Raw Score', null, Integer.valueOf(cbcl.get(0).get(BorF+'CBIBRN__c'))));
        }
      }
}
    

    //SDQ
    if(visitAge >= 4 && visitAge < 18){
    
    List<SObject> sdq =     
                Database.query('SELECT ' + ut.getFields('DS_SDQ_PSI_CDI_'+BorF+'__c') +   
                               '  FROM DS_SDQ_PSI_CDI_'+BorF+'__c' +                              
                               ' WHERE Client__c = \''+ cID + '\'' );
               
                     
       if (sdq.size() >0){
           if (visitAge>10)
           {
           
           //Self
           measure.put(2, new Element('SDQ Self Overall Stress Score', null, Integer.valueOf(sdq.get(0).get(BorF+'SDSTOT__c'))));
           
           //Parent
           measure.put(3, new Element('SDQ Parent Overall Stress Score', null, Integer.valueOf(sdq.get(0).get(BorF+'SDPTOT__c'))));
           }
           else
           //Parent
           measure.put(3, new Element('SDQ Parent Overall Stress Score', null, Integer.valueOf(sdq.get(0).get(BorF+'SDPTOT__c'))));
       
    }
    }
    

    // TSCC


    if(measure.size() > 0) measureExisted = true;
    
  }

  // Clinical Evaluation
  public void evaluation() {

    otherEvaluation = new List<DescElementList>();

    otherEvaluationList = new Map<Integer, Element>();

    evaluationPrimary = '';

    otherEvaluationList.put(1,  new Element('Attention-Deficit/Hyperactivity Disorder','CEADHD', null)); 
    otherEvaluationList.put(2,  new Element('Bipolar Disorder','CEBIPL', null));    
    otherEvaluationList.put(3,  new Element('Depressive Symptoms','CEDPS', null)); 
    otherEvaluationList.put(4,  new Element('Depressive Disorder','CEDEP', null)); 
    otherEvaluationList.put(5,  new Element('Traumatic/Complicated Grief','CETG', null));  
    otherEvaluationList.put(6,  new Element('Generalized Anxiety Disorder','CEGA', null));  
    otherEvaluationList.put(7,  new Element('Separation Anxiety Disorder','CESEPDS', null)); 
    otherEvaluationList.put(8,  new Element('Social Anxiety Disorder','CESOCAD', null));
    otherEvaluationList.put(9,  new Element('Panic Disorder','CEPANDS', null)); 
    otherEvaluationList.put(10,  new Element('Specific Phobia','CEPHODS', null)); 
    otherEvaluationList.put(11, new Element('Obsessive Compulsive and Related Disorders','CEOCD', null));
    otherEvaluationList.put(12, new Element('Acute Stress Disorder','CEASD', null));
    otherEvaluationList.put(13, new Element('Post-Traumatic Stress Disorder','CEPTSD', null));
    otherEvaluationList.put(14, new Element('Adjustment Disorder','CEADJ', null));
    otherEvaluationList.put(15, new Element('Attachment Problems/ Difficulties','CEATTPR', null));
    otherEvaluationList.put(16, new Element('Dissociative Disorders','CEDISYMP', null));
    otherEvaluationList.put(17, new Element('Dissociative Symptoms','CEDISSO', null));
    otherEvaluationList.put(18, new Element('Somatization','CESOMAT', null));
    otherEvaluationList.put(19, new Element('Feeding and Eating Disorder','CEEAT', null));
    otherEvaluationList.put(20, new Element('Sleep-Wake Disorder','CESLPDS', null));
    otherEvaluationList.put(21, new Element('Sexual Behavioral Problems','CESEXPR', null));
    otherEvaluationList.put(22, new Element('Oppositional Defiant Disorder','CEODD', null));
    otherEvaluationList.put(23, new Element('Conduct Disorder','CECD', null));
    otherEvaluationList.put(24, new Element('Intermittent Explosive Disorder','CEEXPL', null));
    otherEvaluationList.put(25, new Element('General Behavioral Problems','CEGBP', null));
    otherEvaluationList.put(26, new Element('Substance Abuse Problems','CESA', null));
    otherEvaluationList.put(27, new Element('Substance-Related and Addictive Disorders','CESUBST', null));
    otherEvaluationList.put(28, new Element('Suicidality','CESUICD', null));
    otherEvaluationList.put(29, new Element('Suicidal Behavior Disorder','CESBD', null));
    otherEvaluationList.put(98, new Element('Other',null, null));

    List<Integer> removeElement = new List<Integer>{98};

    for(Integer index : otherEvaluationList.keySet()) {

      if(index == 98) continue; 

      Element element = otherEvaluationList.get(index);

      Integer value = Integer.valueOf(clientFunctioningForm.get(BorF+element.field+'__c'));

      element.value = value;

      if(value == 0 || value == null) {}
      else otherEvaluation.add(new DescElementList(element));

    }

    Integer primary = Integer.valueOf(clientFunctioningForm.get(BorF+'CEPRIM__c'));

    if(primary != null) {
      evaluationPrimaryExisted = true;  
      evaluationPrimary = otherEvaluationList.get(primary).item;
    }

    otherEvaluation.sort();

    evaluationOtherExisted = (otherEvaluation.size() > 0) ? true : false;
    
    evaluationExisted = (evaluationOtherExisted == true || evaluationPrimaryExisted == true) ? true : false;


  }

}