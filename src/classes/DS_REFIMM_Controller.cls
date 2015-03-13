/*Page Description:
 *  Controller for VisualForce page DS_REFIMM
 * Last Updated on:
 *  7/24/2014
 * Update Purpose:
 *      fix redirect
 7/31/14 Link to DS_Background_Family_Info__c
 8/13/14 Link to DS_Background_Family_Info_B__c
 * Programmer:
 *  Kelsey
 */
public with sharing class DS_REFIMM_Controller {

        Utility ut = new Utility();
        
Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));

public DS_Background_Family_Info_B__c obj{get; set; }                                                            //
//public DS_REFIMM__c obj{get; set; }                                                            //REFIMM

   String cID;
  
  String summaryID;
   
  public String forceRedirect { get; set; } 

  Boolean edit = FALSE;

  public String subtitle {get; set;} 
    
  public Client__c client { get; set; }

  public Client_Summary__c summaryInfo { get; set; }
  
  public String triggerValue {get; set;}
  public String skipTrigger {get; set;}
  
  public SkipLogic skip {get;set;}
  
  public String skipElementToJson { get; set; }
   
      public DS_REFIMM_Controller(ApexPages.StandardController controller) {
    
        cID = parameter.get('c');

    summaryID = parameter.get('summary');
          
        forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

        skip = new SkipLogic(); 

    skip.skipLibrary('BMOMUS', 'show', '0', new Map<String,String>{'BMOMCTY'=>'text'});  
    skip.skipLibrary('BDADUS', 'show', '0', new Map<String,String>{'BDADCTY'=>'text'});  
    skip.skipLibrary('BREFCAMP', 'show', '1', new Map<String,String>{'BCAMPMO'=>'text'});  
 
    client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID]; 
   // Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
     
    subtitle = '(' + client.Name + ') ' + client.INIT__c;
    
 //   String getDEMOFields = ut.getFields('DS_REFIMM__c');
    String getDEMOFields = ut.getFields('DS_Background_Family_Info_B__c');
 
//    List<DS_REFIMM__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //REFIMM
    List<DS_Background_Family_Info_B__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //REFIMM    
  //                                             '  FROM DS_REFIMM__c' +                                                 //
                                               '  FROM DS_Background_Family_Info_B__c' +                                               
                                                 ' WHERE Client__c = \''+ cID + '\'');
                                                
    if(record.size() == 0) { // New record
      
    //  obj = new DS_REFIMM__c(CLIENT__c = cID);                                        //
      obj = new DS_Background_Family_Info_B__c(CLIENT__c = cID, FORM__c = 'DS_REFIMM');                                        //REFIMM
    //  summary = new Client_Summary__c(FORM_ID__c=summaryID);//
      
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;

      obj.FORM__c = 'DS_REFIMM';

      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          //skip.runSkipLogic(lKey, String.valueOf(obj.get(lKey+'__c')), obj);
          skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(obj.get(lKey+'__c')));       
    } 
   
   }

    skipElementToJson = JSON.serialize(skip.skipList);

  }
  
  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}  
    
    public List<SelectOption> getCTYNUNItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('99','Unknown'));
    
    return options; 
    }
    
    public List<SelectOption> getEngWellItems() {
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','Speaks little or no English ')); 
    options.add(new SelectOption('1','Speaks some English ')); 
    options.add(new SelectOption('2','Speaks English well ')); 
    options.add(new SelectOption('99','Unknown'));
    
    return options; 
    }
    
         public List<SelectOption> getCTDECT() {
   
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('',''));
    
    options.add(new SelectOption('1','Afghanistan'));
    options.add(new SelectOption('2','Albania'));
    options.add(new SelectOption('3','Algeria'));
    options.add(new SelectOption('4','American Somoa'));
    options.add(new SelectOption('5','Andorra'));
    options.add(new SelectOption('6','Angola'));
    options.add(new SelectOption('7','Anguilla'));
    options.add(new SelectOption('8','Antarctica'));
    options.add(new SelectOption('9','Antigua (including Barbuda)'));
    options.add(new SelectOption('10','Argentina'));
    options.add(new SelectOption('11','Armenia'));
    options.add(new SelectOption('12','Aruba'));
    options.add(new SelectOption('13','Ascension Islands'));
    options.add(new SelectOption('14','Australia'));
    options.add(new SelectOption('15','Austria'));
    options.add(new SelectOption('16','Azerbaijan'));
    
    options.add(new SelectOption('17','Bahamas'));
    options.add(new SelectOption('18','Bahrain'));
    options.add(new SelectOption('19','Bangladesh'));
    options.add(new SelectOption('20','Barbados'));
    options.add(new SelectOption('21','Belarus'));
    options.add(new SelectOption('22','Belgium'));
    options.add(new SelectOption('23','Belize'));
    options.add(new SelectOption('24','Benin, Republic Of'));
    options.add(new SelectOption('25','Bermuda'));
    options.add(new SelectOption('27','Bolivia'));
    options.add(new SelectOption('28','Bosnia-Herzegovina'));
    options.add(new SelectOption('29','Botswana'));
    options.add(new SelectOption('30','Brazil'));
    options.add(new SelectOption('31','British Virgin Islands'));
    options.add(new SelectOption('32','Brunei'));
    options.add(new SelectOption('33','Bulgaria'));
    options.add(new SelectOption('34','Burkina Faso'));
    options.add(new SelectOption('35','Burma (Union Of Myanmar)'));
    options.add(new SelectOption('36','Burundi'));
    
    options.add(new SelectOption('37','Cambodia'));
    options.add(new SelectOption('38','Cameroon United Republic Of'));
    options.add(new SelectOption('39','Canada'));
    options.add(new SelectOption('40','Cape Verde Island'));
    options.add(new SelectOption('41','Cayman Islands'));
    options.add(new SelectOption('42','Central African Republic'));
    options.add(new SelectOption('43','Chad Republic'));
    options.add(new SelectOption('44','Chile'));
    options.add(new SelectOption('45','China'));
    options.add(new SelectOption('46','Christmas And Cocos Islands'));
    options.add(new SelectOption('47','Colombia'));
    options.add(new SelectOption('48','Comoros Federal And Islamic Republic Of'));
    options.add(new SelectOption('49','Congo'));
    options.add(new SelectOption('50','Cook Islands'));
    options.add(new SelectOption('51','Costa Rica'));
    options.add(new SelectOption('52','Croatia'));
    options.add(new SelectOption('53','Cuba'));
    options.add(new SelectOption('54','Curacao'));
    options.add(new SelectOption('55','Cyprus'));
    options.add(new SelectOption('56','Czech Republic'));
    
    options.add(new SelectOption('57','Denmark'));
    options.add(new SelectOption('58','Diego Garcia'));
    options.add(new SelectOption('59','Djibouti'));
    options.add(new SelectOption('60','Dominica'));
    options.add(new SelectOption('61','Dominican Republic'));
    
    options.add(new SelectOption('62','Ecuador'));
    options.add(new SelectOption('63','Egypt'));
    options.add(new SelectOption('64','El Salvador'));
    options.add(new SelectOption('65','Equatorial Guinea'));
    options.add(new SelectOption('66','Estonia'));
    
    options.add(new SelectOption('67','Falkland Islands'));
    options.add(new SelectOption('68','Faroe Islands'));
    options.add(new SelectOption('69','Fiji Islands'));
    options.add(new SelectOption('70','Finland'));
    options.add(new SelectOption('71','France'));
    options.add(new SelectOption('72','French Antilles (Martinique)'));
    options.add(new SelectOption('73','French Guiana'));
    options.add(new SelectOption('74','French Polynesia'));
    
    options.add(new SelectOption('75','Gabon Republic'));
    options.add(new SelectOption('76','Gambia'));
    options.add(new SelectOption('77','Georgia'));
    options.add(new SelectOption('78','Germany'));
    options.add(new SelectOption('79','Ghana'));
    options.add(new SelectOption('80','Gibraltar'));
    options.add(new SelectOption('81','Greece'));
    options.add(new SelectOption('82','Greenland'));
    options.add(new SelectOption('83','Grenada'));
    options.add(new SelectOption('84','Guadeloupe'));
    options.add(new SelectOption('85','Guam'));
    options.add(new SelectOption('86','Guantanamo Bay (US Naval Base) Cuba'));
    options.add(new SelectOption('87','Guatemala'));
    options.add(new SelectOption('88','Guinea People&#39;s Revolutionary Republic'));
    options.add(new SelectOption('89','Guinea-Bissau'));
    options.add(new SelectOption('90','Guyana'));
    
    options.add(new SelectOption('91','Haiti'));
    options.add(new SelectOption('92','Honduras'));
    options.add(new SelectOption('93','Hong Kong'));
    options.add(new SelectOption('94','Hungary'));
    
    options.add(new SelectOption('95','Iceland'));
    options.add(new SelectOption('96','India'));
    options.add(new SelectOption('97','Indonesia'));
    options.add(new SelectOption('98','Iran'));
    options.add(new SelectOption('99','Iraq'));
    options.add(new SelectOption('100','Ireland'));
    options.add(new SelectOption('101','Israel'));
    options.add(new SelectOption('102','Italy'));
    options.add(new SelectOption('103','Ivory Coast, Republic Of'));
    
    options.add(new SelectOption('104','Jamaica'));
    options.add(new SelectOption('105','Japan'));
    options.add(new SelectOption('106','Jordan'));
   
    options.add(new SelectOption('107','Kazakhstan'));
    options.add(new SelectOption('108','Kenya'));
    options.add(new SelectOption('109','Kiribati'));
    options.add(new SelectOption('110','Korea'));
    options.add(new SelectOption('111','Kuwait'));
    
    options.add(new SelectOption('113','Laos'));
    options.add(new SelectOption('114','Latvia'));
    options.add(new SelectOption('115','Lebanon'));
    options.add(new SelectOption('116','Lesotho'));
    options.add(new SelectOption('117','Liberia'));
    options.add(new SelectOption('118','Libya'));
    options.add(new SelectOption('119','Lesotho'));
    options.add(new SelectOption('120','Lithuania'));
    options.add(new SelectOption('121','Luxembourg'));
    
    options.add(new SelectOption('122','Macau'));
    options.add(new SelectOption('123','Macedonia, Republic of'));
    options.add(new SelectOption('124','Madagascar'));
    options.add(new SelectOption('125','Malawi'));
    options.add(new SelectOption('126','Malaysia'));
    options.add(new SelectOption('127','Maldives'));
    options.add(new SelectOption('128','Mali Republic'));
    options.add(new SelectOption('129','Malta'));
    options.add(new SelectOption('130','Marisat'));
    options.add(new SelectOption('131','Marshall Islands'));
    options.add(new SelectOption('132','Mauritania'));
    options.add(new SelectOption('133','Mauritius'));
    options.add(new SelectOption('134','Mayotte Island'));
    options.add(new SelectOption('135','Mexico'));
    options.add(new SelectOption('136','Micronesia'));
    options.add(new SelectOption('137','Moldova'));
    options.add(new SelectOption('138','Monaco'));
    options.add(new SelectOption('139','Montserrat'));
    options.add(new SelectOption('140','Morocco'));
    options.add(new SelectOption('141','Mozambique'));
    options.add(new SelectOption('142','Myanmar'));
    
    options.add(new SelectOption('143','Namibia'));
    options.add(new SelectOption('144','Nauru'));
    options.add(new SelectOption('145','Nepal'));
    options.add(new SelectOption('146','Netherlands'));
    options.add(new SelectOption('147','New Caledonia'));
    options.add(new SelectOption('148','New Zealand'));
    options.add(new SelectOption('149','Nicaragua'));
    options.add(new SelectOption('150','Niger Republic'));
    options.add(new SelectOption('151','Nigeria'));
    options.add(new SelectOption('152','Niue'));
    options.add(new SelectOption('153','Norfolk Island'));
    options.add(new SelectOption('154','Norway'));
    
    options.add(new SelectOption('155','Oman'));
    
    options.add(new SelectOption('156','Pakistan'));
    options.add(new SelectOption('157','Palau'));
    options.add(new SelectOption('158','Panama, Republic Of'));
    options.add(new SelectOption('159','Papua New Guinea'));
    options.add(new SelectOption('160','Paraguay'));
    options.add(new SelectOption('161','Peru'));
    options.add(new SelectOption('162','Philippines'));
    options.add(new SelectOption('163','Poland'));
    options.add(new SelectOption('164','Portugal'));
    options.add(new SelectOption('165','Puerto Rico'));
    
    options.add(new SelectOption('166','Qatar'));
    
    options.add(new SelectOption('167','Reunion Island'));
    options.add(new SelectOption('168','Romania'));
    options.add(new SelectOption('169','Russia'));
    options.add(new SelectOption('170','Rwanda'));
    
    options.add(new SelectOption('171','Saipan, Northern Marianas Islands'));
    options.add(new SelectOption('172','San Marino'));
    options.add(new SelectOption('173','Sao Tome'));
    options.add(new SelectOption('174','Saudi Arabia'));
    options.add(new SelectOption('175','Senegal Republic'));
    options.add(new SelectOption('176','Sierra Leone'));
    options.add(new SelectOption('177','Singapore, Republic Of'));
    options.add(new SelectOption('178','Slovakia'));
    options.add(new SelectOption('180','Solomon Islands'));
    options.add(new SelectOption('181','Somalia Republic'));
    options.add(new SelectOption('182','South Africa'));
    options.add(new SelectOption('183','Spain'));
    options.add(new SelectOption('184','Sri Lanka'));
    options.add(new SelectOption('185','St Eustatius'));
    options.add(new SelectOption('186','St Helena'));
    options.add(new SelectOption('187','St Kitts and Nevis'));
    options.add(new SelectOption('188','St Lucia'));
    options.add(new SelectOption('189','St Maarten'));
    options.add(new SelectOption('190','St Pierre and Miguelon'));
    options.add(new SelectOption('191','St Vincen'));
    options.add(new SelectOption('192','Sudan'));
    options.add(new SelectOption('193','Suriname'));
    options.add(new SelectOption('194','Swaziland, Antigua and Barbuda'));
    options.add(new SelectOption('195','Sweden'));
    options.add(new SelectOption('196','Switzerland'));
    options.add(new SelectOption('197','Syria'));
    
    options.add(new SelectOption('198','Taiwan'));
    options.add(new SelectOption('199','Tajikistan'));
    options.add(new SelectOption('200','Tanzania'));
    options.add(new SelectOption('201','Thailand'));
    options.add(new SelectOption('202','Togo'));
    options.add(new SelectOption('203','Tonga Islands'));
    options.add(new SelectOption('204','Trinidad and Tobago'));
    options.add(new SelectOption('205','Tunisia'));
    options.add(new SelectOption('206','Turkey'));
    options.add(new SelectOption('207','Turkmenistan'));
    options.add(new SelectOption('208','Turks and Caicos'));
    options.add(new SelectOption('209','Tuvalu'));
    
    options.add(new SelectOption('210','U.S. Virgin Islands'));
    options.add(new SelectOption('211','Uganda'));
    options.add(new SelectOption('212','Ukraine'));
    options.add(new SelectOption('213','United Arab Emirates'));
    options.add(new SelectOption('214','United Kingdom'));
    options.add(new SelectOption('215','United States of America'));
    options.add(new SelectOption('216','Uruguay'));
    options.add(new SelectOption('217','Uzbekistan Tashkent'));
    
    options.add(new SelectOption('218','Vanuatu, Republic Of'));
    options.add(new SelectOption('219','Vatican City'));
    options.add(new SelectOption('220','Venezuela'));
    options.add(new SelectOption('221','Vietnam'));
    
    options.add(new SelectOption('222','Wallis And Futuna Islands'));
    options.add(new SelectOption('223','Western Samoa'));
    
    options.add(new SelectOption('224','Yemen'));
    options.add(new SelectOption('225','Yugoslavia--Federated States of, Serbia--Republic of'));
    
    options.add(new SelectOption('226','Zambia'));
    options.add(new SelectOption('227','Zimbabwe'));
    
    options.add(new SelectOption('228','Ethiopia'));
    
    return options; 
    }
    
    public PageReference cancel() {

    PageReference summaryPage = new PageReference('/apex/ClientSummary?s=0&id=' + cID);
    summaryPage.setRedirect(true);
    
    return summaryPage;

  }

  public PageReference save() {

    PageReference nextPage;
        
    try {
      if(edit == FALSE) insert obj;
      else update obj;
      nextPage = new PageReference(skip.formRedirct(cID, '0', forceRedirect));
      nextPage.setRedirect(true);
    }
    catch(DMLException e) { nextPage = null; }
    
    return nextPage;        
    
        }
        }