/* Page Description:
 *  Controller for VisualForce page DS_TDETAIL
 *
 * Updated history:
 *
 *   Date: 7/21/2014       
 *   Programmer: Danny  
 *   Description: Change for the new trauma detail object. 
 * 
 * 
 *  
 */
public with sharing class DS_TDETAIL_Controller {

  Utility ut = new Utility();
  
  public SObject TDObject {get; set;}

  Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));
  
  public String cID { get; set; }

  public String summaryID{ get; set; }
  
  String TDForm;
  
  String formType = parameter.get('TDF');

  public String forceRedirect {get; set;} 
  
  Boolean edit = FALSE;
  
  List<Option> BasicOptions;
      
  public String subtitle {get;set;}

  public String triggerValue {get; set;}
  public String skipTrigger {get; set;}
  //public Map<String, SkipElement> skipAction {get; set;}
  
  object emptyText = null;
  Object emptyCheck = FALSE;
  
  Map<String, String> DefaultQuestion = new Map<String, String>();
  
  Map<String, String> formNum = new Map<String, String>();
  
  public SkipLogic skip { get; set; }

  public String skipElementToJson { get; set; }
    
    
  public DS_TDETAIL_Controller() {

    cID = parameter.get('c');

    summaryID = parameter.get('summary');

    forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';
      
    String pageName = 'DS_'+formType;

    //System.debug(pageName);
    
    DS_DATA__c forminfo = [SELECT Content__c, Object__c, Variable__c
                             FROM DS_DATA__c 
                            WHERE Page__c = :pageName 
                              AND Data_Type__c = 'DS_Form_Info'];
    
    subtitle = forminfo.Content__c;
    
    List<DS_DATA__c> formNums = [SELECT Page__c, Variable__c 
                                   FROM DS_DATA__c 
                                  WHERE Data_Type__c = 'DS_Form_Info' 
                                    AND Category__c = 'TD'];
    
    for(DS_DATA__c num : formNums) 
      formNum.put(num.Page__c.substringAfter('DS_'), num.Variable__c.substringAfter('G').substringBefore('R'));
    
    DefaultQuestion.put('RBASE',  'When was this trauma revealed/known (to the clinician)?');
    DefaultQuestion.put('RDV',    'Please identify the type of domestic violence. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RFREQ',  'Please describe the frequency of the experience. <b>(Select only one.)</b>');
    DefaultQuestion.put('RTYP',   'Please describe the type(s) of experience. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RILL',   'Who had the illness/medical trauma? <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RIN',    'Did this maltreatment/abuse involve any of the following? <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RSET1',  'Please indicate the setting(s) of the experience. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RSET2',  'Please indicate the setting(s) of the experience. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RSET3',  'Please indicate the setting(s) of the experience. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RSET4',  'Please indicate the setting(s) of the experience. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RPER',   'Please identify the perpetrator(s). <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RPER2',  'Please identify the purchaser(s)/perpetrator(s) of the exploitation or service. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RPER3',  'Please identify the perpetrator(s). <b>(Select all that apply.)</b>');   
    DefaultQuestion.put('RPER4',  'Please identify the perpetrator(s). <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RINJ',   'Was serious injury inflicted?');
    DefaultQuestion.put('RINJ2',  'Was serious injury inflicted?');
    DefaultQuestion.put('RINJ3',  'Please specify the type of injury(ies) that occurred.');
    DefaultQuestion.put('RINJ4',  'Was anyone seriously injured or killed?');
    DefaultQuestion.put('RREPORT','Was a report filed? (e.g., Police, Child Protective Services)');
    DefaultQuestion.put('RPENET', 'Did this trauma ever involve oral, vaginal, or anal penetration?');//<!--on TD1 maltreatment/abuse, TD2 assault/rape, not assault/abuse. Trauma is temporary generic-->
    DefaultQuestion.put('RWEAPON','Was a weapon used?');
    DefaultQuestion.put('RTYPES', 'Please identify the type of maltreatment involved. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RNTYPES','Please identify the type of neglect involved. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RWPN',   'Please indicate the type of weapons used. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RLIFE',  'Was the child\'s condition life threatening? <b>(Select only one.)</b>');
    DefaultQuestion.put('RTT12C', 'Please specify type of accident(s). <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RGANG',  'Was the violence gang-related?');
    DefaultQuestion.put('RPORNOG','Did this assault/abuse involve any of the following? <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RPAIN',  'Did the child experience painful medical procedures? <b>(Select only one.)</b>');  
    DefaultQuestion.put('RFRGT',  'Did the child have invasive or frightening treatment experiences? <b>(Select only one.)</b>');  
    DefaultQuestion.put('RPICU',  'Was the child admitted to the Pediatric Intensive Care Unit (PICU)? <b>(Select only one.)</b>');  
    DefaultQuestion.put('REVAC',  'Did the child/family evacuate their home?');
    DefaultQuestion.put('RHDAM',  'Was the child’s home severely damaged or destroyed?');
    DefaultQuestion.put('RTYPDS', 'Please specify type of disaster(s) involved. <b>(Select all that apply.) </b>');
    DefaultQuestion.put('RREUN',  'How long was it before reunification?');
    DefaultQuestion.put('RINC',   'Did the kidnapping/abduction include: <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RRE',    'What was the reason for the forced displacement? <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RCG',    'Please identify the impaired caregiver(s). <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RIMP',   'What was the impairment due to? <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RTVIO',  'Please identify the type(s) of violence. <b>(Select all that apply.)     <p>For Bullying, please see new trauma category. </b></p>');
    DefaultQuestion.put('RSE',    'Please identify where the violence occurred. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RVTYP',  'Please indicate the type(s) of violence. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RMEN',   'Please indicate the means by/through which the child was exploited/trafficked. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RBEN',   'Please identify the person (or trafficker) who brokered or received the benefit from the perpetration of the exploitation (i.e., boyfriend, pimp, controller).  <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RTHI',   'Was the child ever threatened or injured?');
    DefaultQuestion.put('RCMP',   'Did the child receive any compensation for his/her services?');
    DefaultQuestion.put('RTR',    'Was the child ever transported to other cities or towns to engage in services?');
    DefaultQuestion.put('RMTYP',  'Please identify the type of maltreatment involved. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RDIS',   'Was permanent disability/death inflicted?');
    DefaultQuestion.put('RPR',    'Please identify the people who died. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RPR2',   'Please identify the person(s) from whom the child was separated. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RSRV',   'In the case of an immediate family member or caregiver, did the child attend any rituals or customs associated with the death (e.g., visitation, wake, funeral, burial, memorial)?');
    DefaultQuestion.put('RFTB',   'Please identify the type(s) of bullying. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RRES',   'Was the victim targeted by the bully for a specific reason?');
    DefaultQuestion.put('RMED',   'Please describe the medium through which bullying occurred. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RCP',    'Please describe the circumstances of the separation. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RDU',    'What was the duration of the separation? <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RST',    'Please describe the permanency status of the separation. <b>(Select all that apply.)</b>');
    DefaultQuestion.put('RRESIB', 'Did the child remain with siblings during the separation? <b>(Select only one.)</b>');
    DefaultQuestion.put('RD',     'Please specify cause of death experienced by someone close to  the client and the relationship of each person who died to the client.');

    //Schema.SObjectType TDObjectType = Schema.getGlobalDescribe().get('DS_'+formType+'__c');

    //System.debug(forminfo.Object__c);

    Schema.SObjectType TDObjectType = Schema.getGlobalDescribe().get(forminfo.Object__c+'__c');

    TDObject = TDObjectType.newSObject();
   
    TDForm = formNum.get(formType);
    
    skip = new SkipLogic();

    //RBASE
    skip.skipLibrary(TDForm+'RRO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RRODT'=>'text'});  
    //RIN
    skip.skipLibrary(TDForm+'RINO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RINOSP'=>'text'}); 
    //RSET1
    skip.skipLibrary(TDForm+'RSETO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RSETOS'=>'text'}); 
    //RINJ 1
    skip.skipLibrary(TDForm+'RINJ', 'show', '1', 
                     new Map<String, String>{
                      TDForm+'RINJC'  => 'checkbox', TDForm+'RINJP'  => 'checkbox',
                      TDForm+'RINJAR' => 'checkbox', TDForm+'RINJUA' => 'checkbox',
                      TDForm+'RINJSB' => 'checkbox', TDForm+'RINJOY' => 'checkbox',
                      TDForm+'RINJO'  => 'checkbox'});  
    //RINJ 2 / 3 / 4
    skip.skipLibrary(TDForm+'RINJO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RINJOS'=>'text'}); 

    
    //RNTYPE
    skip.skipLibrary(TDForm+'RTYPOTH', 'show', 'true', 
                     new Map<String, String>{TDForm+'RTYPOS'=>'text'}); 

    //RTYPDS & RVTYP
    skip.skipLibrary(TDForm+'ROTH', 'show', 'true', 
                     new Map<String, String>{TDForm+'ROTHS'=>'text'}); 

    //RTT12C
    skip.skipLibrary(TDForm+'ROTHR', 'show', 'true', 
                     new Map<String, String>{TDForm+'ROTHSP'=>'text'}); 

    //RINC
    skip.skipLibrary(TDForm+'RINCO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RINCOS'=>'text'});

    //RRE
    skip.skipLibrary(TDForm+'RREO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RREOS'=>'text'}); 

    //RILL
    skip.skipLibrary(TDForm+'RILLO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RILLOSP'=>'text'});

    //RCG
    skip.skipLibrary(TDForm+'RCGO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RCGOSP'=>'text'});

    //RIMP
    skip.skipLibrary(TDForm+'RIMPO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RIMPOSP'=>'text'});
     
    //RTVIO
    skip.skipLibrary(TDForm+'RCOTH', 'show', 'true', 
                     new Map<String, String>{TDForm+'RCOSP'=>'text'});
     
    //RMEN
    skip.skipLibrary(TDForm+'RMENO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RMENOS'=>'text'});
    
    //RPER2
    skip.skipLibrary(TDForm+'RPERO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RPEROS'=>'text'});

    //RTHI1
    skip.skipLibrary(TDForm+'RTHI', 'show', '1', 
                     new Map<String, String>{
                      TDForm+'RTHIP'  => 'checkbox', TDForm+'RTHIT'  => 'checkbox',
                      TDForm+'RTHIR'  => 'checkbox', TDForm+'RTHICS' => 'checkbox',
                      TDForm+'RTHIHF' => 'checkbox', TDForm+'RTHIO'  => 'checkbox'});  
    //RTHI2
    skip.skipLibrary(TDForm+'RTHIO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RTHIOS'=>'text'});
    
    //RCMP1
    skip.skipLibrary(TDForm+'RCMP', 'show', '1', 
                     new Map<String, String>{
                      TDForm+'RCMPM'  => 'checkbox', TDForm+'RCMPF'  => 'checkbox',
                      TDForm+'RCMPMP' => 'checkbox', TDForm+'RCMPS'  => 'checkbox',
                      TDForm+'RCMPFD' => 'checkbox', TDForm+'CMPD'   => 'checkbox',
                      TDForm+'RCMPPS' => 'checkbox', TDForm+'RCMPSA' => 'checkbox',
                      TDForm+'RCMPO'  => 'checkbox'});  
    //RCMP2
    skip.skipLibrary(TDForm+'RCMPO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RCMPOS'=>'text'});
     
    //RMTYP
    skip.skipLibrary(TDForm+'RMTYPOTH', 'show', 'true', 
                     new Map<String, String>{TDForm+'RMTYPOS'=>'text'});
    
    //RRDIS 1
    skip.skipLibrary(TDForm+'RDIS', 'show', '1', 
                     new Map<String, String>{
                      TDForm+'RDISC'  => 'checkbox', TDForm+'RDISP'  => 'checkbox',
                      TDForm+'RDISOR' => 'checkbox', TDForm+'RDISUA' => 'checkbox',
                      TDForm+'RDISSB' => 'checkbox', TDForm+'RDISOY' => 'checkbox',
                      TDForm+'RDISO'  => 'checkbox'});
    
    //RRDIS 2
    skip.skipLibrary(TDForm+'RDISO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RDISOS'=>'text'});

    //RFTB
    skip.skipLibrary(TDForm+'RFOTR', 'show', 'true', 
                     new Map<String, String>{TDForm+'RFOSP'=>'text'});

    //RPER3
    skip.skipLibrary(TDForm+'RPEROT', 'show', 'true', 
                     new Map<String, String>{TDForm+'RPEROSP'=>'text'});

    //RRES 1
    skip.skipLibrary(TDForm+'RRES', 'show', '1', 
                     new Map<String, String>{
                      TDForm+'RRESRC' => 'checkbox', TDForm+'RRESRE' => 'checkbox',
                      TDForm+'RRESSO' => 'checkbox', TDForm+'RRESDB' => 'checkbox',
                      TDForm+'RRESWT' => 'checkbox', TDForm+'RRESEC' => 'checkbox',
                      TDForm+'RRESO'  => 'checkbox'});

    //RRES 2
    skip.skipLibrary(TDForm+'RRESO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RRESOS'=>'text'});

    //RMED 1.1  Face-to-face checkbox
    skip.skipLibrary(TDForm+'RMFCE', 'show', 'true', 
                     new Map<String, String>{
                      TDForm+'RMFHO' => 'checkbox', TDForm+'RMFSC' => 'checkbox',
                      TDForm+'RMFCO' => 'checkbox', TDForm+'RMFOT' => 'checkbox'});

    //RMED 1.2  Other
    skip.skipLibrary(TDForm+'RMFOT', 'show', 'true', 
                     new Map<String, String>{TDForm+'RMFOSP'=>'text'});

    //RMED 2.1  Cyberbullying checkbox
    skip.skipLibrary(TDForm+'RMCYB', 'show', 'true', 
                     new Map<String, String>{
                      TDForm+'RMCSO' => 'checkbox', TDForm+'RMCTX' => 'checkbox',
                      TDForm+'RMCIM' => 'checkbox', TDForm+'RMCEM' => 'checkbox',
                      TDForm+'RMCWB' => 'checkbox', TDForm+'RMCOT' => 'checkbox'});

    //RMED 2.2  Other
    skip.skipLibrary(TDForm+'RMCOT', 'show', 'true', 
                     new Map<String, String>{TDForm+'RMCOSP'=>'text'});

    //RMED 3 Other
    skip.skipLibrary(TDForm+'RMOTR', 'show', 'true', 
                     new Map<String, String>{TDForm+'RMOSP'=>'text'});
    

    //RCP 1.1  Parent.Caregiver was removed from the home
    skip.skipLibrary(TDForm+'RCP', 'show', 'true', 
                     new Map<String, String>{
                      TDForm+'RCPD'  => 'checkbox', TDForm+'RCPCM' => 'checkbox',
                      TDForm+'RCPIN' => 'checkbox', TDForm+'RCPHP' => 'checkbox',
                      TDForm+'RCPW'  => 'checkbox', TDForm+'RCPM'  => 'checkbox',
                      TDForm+'RCPT'  => 'checkbox', TDForm+'RCPO'  => 'checkbox',
                      TDForm+'RCPUK' => 'checkbox'});

    //RMED 1.2  Other
    skip.skipLibrary(TDForm+'RCPO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RCPOS'=>'text'});

    //RMED 2.1  Cyberbullying checkbox
    skip.skipLibrary(TDForm+'RCC', 'show', 'true', 
                     new Map<String, String>{
                      TDForm+'RCCFC' => 'checkbox', TDForm+'RCCRS' => 'checkbox',
                      TDForm+'RCCCM' => 'checkbox', TDForm+'RCCIN' => 'checkbox',
                      TDForm+'RCCHP' => 'checkbox', TDForm+'RCCO'  => 'checkbox',
                      TDForm+'RCCUK' => 'checkbox'});

    //RMED 2.2  Other
    skip.skipLibrary(TDForm+'RCCO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RCCOS'=>'text'});

    //RMED 3 Other
    skip.skipLibrary(TDForm+'RCO', 'show', 'true', 
                     new Map<String, String>{TDForm+'RCOS'=>'text'});

    //RTR
    skip.skipLibrary(TDForm+'RTRNSP', 'show', '1', 
                     new Map<String, String>{TDForm+'RTRSTL'=>'picklist'});
    

    String gtFields = ut.getFields(forminfo.Object__c+'__c');
    
    List<Sobject> TD = Database.query('SELECT ' + gtFields + ', Client__r.Name, Client__r.INIT__c' +  
                                      '  FROM '+forminfo.Object__c+'__c ' +
                                      ' WHERE Client__c = \''+ cID + '\'');

    Set<string> fields = new Set<string>(gtFields.split(','));
   
    if(TD.size() == 0) {
      TDObject.put('Client__c', cID);
      ///TDObject.put('FORM__c', 'DS_'+formType);
    }
    else { 
      TDObject = TD.get(0);
      //TDObject.put('FORM__c', 'DS_'+formType);
      edit = TRUE;
      
      for(String lKey : skip.skipList.keySet()) 
        for(String sKey : skip.skipList.get(lKey).keySet()) {
          if(fields.contains(lKey+'__c'))
            skip.skipList.get(lKey).get(sKey).addTargetValue(String.valueOf(TDObject.get(lKey+'__c')));
        }
    }
    
    BasicOptions = new List<Option>{new Option('',''),
                                    new Option('0','No'),
                                    new Option('1','Yes'),
                                    new Option('99','Unknown')};  

    skipElementToJson = JSON.serialize(skip.skipList);   
     
  }
  
  public class Option {
  
    public String index { get; set; }
    public String value { get; set; }
    
    public Option (String index, String value) {
      this.index = index;
      this.value = value;
    }
      
  }

  public String getClientInfo() { return ut.clientSection(cID,SummaryID); } 
    
  public Component.Apex.pageBlock getContent() {
          
    Component.Apex.pageBlock block = new Component.Apex.pageBlock();
    block.title = 'Trauma Detail Information';
    
    Component.Apex.pageMessages message = new Component.Apex.pageMessages();
    
    block.childComponents.add(message);

    List<DS_DATA__c> instruction = [SELECT Category__c, Note__c, weight__c 
                                      FROM DS_DATA__c 
                                     WHERE Form__c = :formType 
                                       AND Data_Type__c = 'DS_TD_Form_Info'
                                       AND Category__c = 'INSTRUCTION'];

    String instructionContent = (instruction.size() > 0) ? 
                                '<blockquote><p style="font-size:16px;">'+instruction.get(0).Note__c+'</p></blockquote>' :
                                '';

    //System.debug(formType);
    //System.debug(instruction);

    Component.Apex.OutputText tHead = new Component.Apex.OutputText();
    tHead.value = '<div id="force">'+instructionContent+'<table class="table table-hover table-responsive">';
    thead.escape = false;
    
    block.childComponents.add(thead);
    
    /*List<DS_TD_Form_Info__c> Qinfo = [SELECT Category__c, Content__c, weight__c 
                                        FROM DS_TD_Form_Info__c 
                                       WHERE Form__c = :formType 
                                    ORDER BY weight__c];*/

    List<DS_DATA__c> Qinfo = [SELECT Category__c, Content__c, weight__c 
                                        FROM DS_DATA__c 
                                       WHERE Form__c = :formType 
                                         AND Data_Type__c = 'DS_TD_Form_Info'
                                         AND Category__c != 'INSTRUCTION'
                                    ORDER BY weight__c];
        
    if(Qinfo.size() != 0)
      for(DS_DATA__c info : Qinfo)
        QuesGenerator(block, info.Category__c, String.valueof(info.weight__c), info.Content__c);

    completeStatus(block);
            
    Component.Apex.OutputText tFooter = new Component.Apex.OutputText(value = '</table>', escape = false);
    block.childComponents.add(tFooter);
    
    //comStatus(block);
    
    Component.Apex.OutputText endDiv = new Component.Apex.OutputText(value = '</div>', escape = false);
    block.childComponents.add(endDiv);
    
    block.childComponents.add(CommandButton());
            
    return block;
      
  }
    
    
    
  public void QuesGenerator(Component.Apex.pageBlock block, String Qtype, String Num, String Content) {
      
    Content = (Content != null) ? Content : DefaultQuestion.get(Qtype);

    if(Qtype != 'RD') {
      if(Qtype == 'SECTION') 
        block.childComponents.add(rowHeadFoot('section', Num, Content, null));
      else 
        block.childComponents.add(rowHeadFoot('head', Num, Content, null));
    }
    

    if(Qtype == 'RBASE') {
                    
      /*List<Option> options = new List<Option>{new Option('',''),
                                              new Option('RB','Baseline'),
                                              new Option('RO','Other')};
      
      block.childComponents.add(comSelectList(Qtype, options, 'skip'));
      
      block.childComponents.add(rowHeadFoot('foot', null, null));*/
      

      List<Option> options = new List<Option>{new Option('Baseline','RRB'),
                                              new Option('Other','RRO')};
      
      comCheckBox(block, options, 'RRO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RRODT', '<span style="padding-left:15px;">Please provide date</span>');
            
    }

    else if(Qtype == 'RDV') {
                                        
      List<Option> options = new List<Option>{
        new Option('Physical violence','RDVPV'),
        new Option('Sexual violence','RDVSV'),
        new Option('Threats of physical or sexual violence','RDVTFS'),
        new Option('Psychological or emotional violence ','RDVPEV'),
        new Option('Unknown','RDVUK')};

      comCheckBox(block, options, '');
                    
    }

    else if(Qtype == 'RFREQ') {
                        
      List<Option> options = 
        new List<Option>{ new Option('',''),
                          new Option('1','One-time event'),
                          new Option('2','Repeated exposure'),
                          new Option('99','Unknown') };
      
      block.childComponents.add(comSelectList(Qtype, options, null));
                       
    }
    else if(Qtype == 'RTYP') {
                                        
      List<Option> options = 
        new List<Option>{ new Option('Directly experienced','RTYPE'),
                          new Option('Witnessed in person','RTYPW'),
                          new Option('Learned that traumatic experience happened to a close family member or close friend','RTYPV'),
                          new Option('Unknown','RTYPU') };

      comCheckBox(block, options, '');
                    
    }
    else if(Qtype == 'RIN') {
                            
      List<Option> options = 
        new List<Option>{ new Option('Pornography (print, Internet, television, etc.)','RINPRN'),
                          new Option('Forced witnessing of adult sexual activity','RINFWIT'),
                          new Option('Orchestration of sexual contact with one or more minor children','RINMINR'),
                          new Option('Other','RINO') };
      
      comCheckBox(block, options, 'RINO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RINOSP', '<span style="padding-left:15px;">Please specify: </span>');
      
    }
    else if(Qtype == 'RSET1') {
                            
      List<Option> options = 
        new List<Option>{ new Option('Extended Home Care','RSETH'),
                          new Option('Hospital Admission','RSETHS'),
                          new Option('Extended care facility','RSETEX'),
                          new Option('Pediatric Intensive Care Unit (PICU) Admission','RSETICU'),
                          new Option('Other','RSETO'),
                          new Option('Unknown','RSETU') };
      
      comCheckBox(block, options, 'RSETO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RSETOS', '<span style="padding-left:15px;">Please specify: </span>');
      
    }
    else if(Qtype == 'RSET2') {
                            
      List<Option> options = new List<Option>{new Option('School','RSETS'),
                                              new Option('Community','RSETC'),
                                              new Option('Other','RSETO'),
                                              new Option('Unknown','RSETU')};
      
      comCheckBox(block, options, 'RSETO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RSETOS', '<span style="padding-left:15px;">Please specify the setting of the experience: </span>');
        
    }

    else if(Qtype == 'RSET3') {
                            
      List<Option> options = new List<Option>{new Option('Home','RSETH'),
                                              new Option('School','RSETS'),
                                              new Option('Community','RSETC'),
                                              new Option('Other','RSETO'),
                                              new Option('Unknown','RSETU')};
      
      comCheckBox(block, options, 'RSETO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RSETOS', '<span style="padding-left:15px;">Please specify the setting of the experience: </span>');
        
    }

    else if(Qtype == 'RSET4') {
                            
      List<Option> options = new List<Option>{new Option('Home','RSETH'),
                                              new Option('Community','RSETC'),
                                              new Option('Other','RSETO'),
                                              new Option('Unknown','RSETU')};
      
      comCheckBox(block, options, 'RSETO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RSETOS', '<span style="padding-left:15px;">Please specify the setting of the experience: </span>');
        
    }

    else if(Qtype == 'RRESIB') {
                        
      List<Option> options = new List<Option>{
        new Option('',''),
        new Option('0','No'),
        new Option('1','Yes, for some of the separations'),
        new Option('2','Yes, for all of the separations'),
        new Option('99','Unknown')};
      
      block.childComponents.add(comSelectList(Qtype, options, null));
                       
    }

    else if(Qtype == 'RPR') {
                                        
      List<Option> options = new List<Option>{
        new Option('Parent','RPRP'),
        new Option('Grandparent','RPRGR'),
        new Option('Other relative','RPRAR'),
        new Option('Sibling','RPRSB'),
        new Option('Unrelated adult (known to the child) ','RPRUA'),
        new Option('Unrelated youth','RPROY')};
      comCheckBox(block, options, '');
                    
    }

    else if(Qtype == 'RPR2') {
                                        
      List<Option> options = new List<Option>{
        new Option('Parent','RPRP'),
        new Option('Other adult relative','RPRAR'),
        new Option('Unrelated adult (known to the child) ','RPRUA'),
        new Option('Sibling','RPRSB'),
        new Option('Other youth (known to the child)','RPROY'),
        new Option('Unknown','RPRUK')};
      comCheckBox(block, options, '');
                    
    }

    else if(Qtype == 'RST') {
                                        
      List<Option> options = new List<Option>{
        new Option('Permanent','RSTP'),
        new Option('Temporary','RSTT'),
        new Option('Unknown','RSTU')};

      comCheckBox(block, options, '');
                    
    }

    else if(Qtype == 'RDU') {
                                        
      List<Option> options = new List<Option>{
        new Option('0-3 months','RDU3'),
        new Option('3-6 months','RDU6'),
        new Option('6-9 months','RDU9'),
        new Option('9-12 months','RDU12'),
        new Option('1-2 years','RDU24'),
        new Option('Greater than 2 years','RDU2Y'),
        new Option('Unknown','RDUUK')};

      comCheckBox(block, options, '');
                    
    }

    else if(Qtype == 'RINC') {
                            
      List<Option> options = new List<Option>{
        new Option('A request for ransom','RINCR'),
        new Option('A child custody dispute','RINCC'),
        new Option('Arrest/imprisonment of the perpetrator','RINCA'),
        new Option('Captor-child bonding (Stockholm Syndrome)','RINCB'),
        new Option('Rape/sexual assaults/trafficking','RINCS'),
        new Option('Other','RINCO')};

      comCheckBox(block, options, 'RINCO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RINCOS', '<span style="padding-left:15px;">Please specify what the kidnapping/abduction included: </span>');
        
    }

    else if(Qtype == 'RMTYP') {
                            
      List<Option> options = new List<Option>{
        new Option('Emotional neglect (denial of proper care and attention, failure to respond)','RMTYPEN'),
        new Option('Verbal abuse (e.g., belittling, rejecting, cruel teasing)','RMTYPVA'),
        new Option('Excessive demands (unreasonable or impossible demands)','RMTYPED'),
        new Option('Other','RMTYPOTH'),
        new Option('Unknown','RMTYPU')};

      comCheckBox(block, options, 'RMTYPOTH');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RMTYPOS', '<span style="padding-left:15px;">Please specify the type of maltreatment involved: </span>');
        
    }

    else if(Qtype == 'RRE') {
                            
      List<Option> options = new List<Option>{
        new Option('Violence, conflict, war','RREVI'),
        new Option('Natural or manmade disasters','RREND'),
        new Option('Ethnic cleansing','RREEC'),
        new Option('Fleeing persecution (for political, social, ethnic, or religious reasons)','RREFP'),
        new Option('Other','RREO')};

      comCheckBox(block, options, 'RREO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RREOS', '<span style="padding-left:15px;">Please specify the reason for the forced displacement: </span>');
        
    }

    else if(Qtype == 'RSE') {
                                        
      List<Option> options = new List<Option>{
        new Option('On school property','RSESP'),
        new Option('On the way to/from school','RSEWS'),
        new Option('During a school-sponsored event','RSESE'),
        new Option('On the way to/from a school-sponsored event','RSEWE')};

      comCheckBox(block, options, '');
                    
    }

    else if(Qtype == 'RCG') {
                            
      List<Option> options = new List<Option>{
        new Option('Parent','RCGP'),
        new Option('Other adult relative','RCGAR'),
        new Option('Unrelated (but identifiable) adult','RCGUA'),
        new Option('Sibling','RCGSB'),
        new Option('Other youth','RCGOY'),
        new Option('Stranger (to the child)', 'RCGST'),
        new Option('Other','RCGO'),
        new Option('Unknown', 'RCGUK')};

      comCheckBox(block, options, 'RCGO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RCGOSP', '<span style="padding-left:15px;">Please specify the impaired caregiver(s): </span>');
        
    }

    else if(Qtype == 'RILL') {
                            
      List<Option> options = new List<Option>{
        new Option('Child','RILLC'),
        new Option('Parent','RILLP'),
        new Option('Other adult relative','RILLAR'),
        new Option('Unrelated (but identifiable) adult','RILLUA'),
        new Option('Sibling','RILLSB'),
        new Option('Other youth','RILLOY'),
        new Option('Other','RILLO')};

      comCheckBox(block, options, 'RILLO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RILLOSP', '<span style="padding-left:15px;">Please specify the person who had the illness/medical trauma: </span>');
        
    }

    else if(Qtype == 'RIMP') {
                            
      List<Option> options = new List<Option>{
        new Option('Drug use/abuse/addiction','RIMPDG'),
        new Option('Caregiver mental health impairment/disorder','RIMPDP'),
        new Option('Caregiver medical illness','RIMPIL'),
        new Option('Other','RIMPO'),
        new Option('Unknown', 'RIMPUK')};

      comCheckBox(block, options, 'RIMPO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RIMPOSP', '<span style="padding-left:15px;">Please specify what the impairment was due to: </span>');
        
    }

    else if(Qtype == 'RTVIO') {
                            
      List<Option> options = new List<Option>{
        new Option('School shooting','RSHOOT'),
        new Option('Classmate suicide','RCSUIC'),
        new Option('Vandalism','RCVAN'),
        new Option('Sexual harassment','RCSEX'),
        new Option('Fighting','RCFGT'),
        new Option('Stealing', 'RCSTL'),
        new Option('Weapon possession', 'RCWEAP'),
        new Option('Other','RCOTH'),
        new Option('Unknown', 'RCUK')};

      comCheckBox(block, options, 'RCOTH');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RCOSP', '<span style="padding-left:15px;">Please specify the type(s) of violence: </span>');
        
    }
    
    else if(Qtype == 'RPER') {
                            
      List<Option> options = new List<Option>{
        new Option('Parent','RPERP'), 
        new Option('Other adult relative','RPERAR'),
        new Option('Unrelated (but identifiable) adult','RPERUA'),
        new Option('Sibling','RPERSB'),
        new Option('Other youth','RPEROY'),
        new Option('Stranger','RPERST'),
        new Option('Unknown','RPERU')};

      comCheckBox(block, options, '');
                    
    }

    else if(Qtype == 'RPER2') {
                            
      List<Option> options = new List<Option>{
        new Option('Other adult relative','RPERAR'),
        new Option('Unrelated (but identifiable) adult','RPERUA'),
        new Option('Other youth','RPEROY'),
        new Option('Stranger','RPERST'),
        new Option('Other','RPERO'),
        new Option('Unknown','RPERU')};

      comCheckBox(block, options, 'RPERO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RPEROS', '<span style="padding-left:15px;">Please specify the purchaser(s)/perpetrator(s): </span>');
                    
    }

    else if(Qtype == 'RPER3') {
                            
      List<Option> options = new List<Option>{
        new Option('Classmate','RPERCM'),
        new Option('Other youth','RPEROY'),
        new Option('Teacher','RPERTH'),
        new Option('Other school staff','RPEROS'),
        new Option('Other adult outside of school','RPEROA'),
        new Option('Other','RPEROT')};

      comCheckBox(block, options, 'RPEROT');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RPEROSP', '<span style="padding-left:15px;">Please specify the perpetrator(s): </span>');
                    
    }

    // This is used in T5
    else if(Qtype == 'RPER4') {
                            
      List<Option> options = new List<Option>{
        new Option('Parent (non-caregiver)','RPERP'), 
        new Option('Other adult relative','RPERAR'),
        new Option('Unrelated (but identifiable) adult','RPERUA'),
        new Option('Sibling','RPERSB'),
        new Option('Other youth','RPEROY'),
        new Option('Stranger','RPERST'),
        new Option('Unknown','RPERU')};

      comCheckBox(block, options, '');
                    
    }

    else if(Qtype == 'RRES') {
                            
      block.childComponents.add(comSelectList('RRES', BasicOptions, 'skip'));
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      
      List<Option> options = new List<Option>{
        new Option('Race/Ethnicity','RRESRC'), 
        new Option('Religion','RRESRE'),
        new Option('Sexual Orientation','RRESSO'),
        new Option('Disability','RRESDB'),
        new Option('Weight','RRESWT'),
        new Option('Socio-economic status','RRESEC'),
        new Option('Other','RRESO')};
      
      comAssociateCheckBox (block, 'What was the reason for targeting? <b>(Select all that apply.)</b>', options, 'RRESRC', 'RRESO');
      
      comAssociateInputField(block, 'RRESOS', '<span style="padding-left:15px;">What was the reason for targeting? Please specify: </span>');
        
        
    }

    else if(Qtype == 'RBEN') {
                            
      List<Option> options = new List<Option>{
        new Option('Child is acting on their own (sole practitioner)','RBENC'), 
        new Option('Parent','RBENP'),
        new Option('Other adult relative','RBENAR'),
        new Option('Unrelated (but identifiable) adult','RBENUA'),
        new Option('Sibling','RBENSB'),
        new Option('Other youth','RBENOY'),
        new Option('Stranger','RBENST'),
        new Option('Unknown','RBENU')};

      comCheckBox(block, options, '');
                    
    }

    else if(Qtype == 'RREUN') {
                            
      List<Option> options = new List<Option>{
        new Option('',''),
        new Option('0','0-7 Days'),
        new Option('1','1-4 Weeks'),
        new Option('2','1-12 Months'),
        new Option('3','>12 Months'),
        new Option('99','Unknown')};
      
      block.childComponents.add(comSelectList(Qtype, options, null));
                    
    }
    
    else if(Qtype == 'RINJ') {
                            
      block.childComponents.add(comSelectList('RINJ', BasicOptions, 'skip'));
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      
      List<Option> options = new List<Option>{
        new Option('Child','RINJC'), 
        new Option('Parent','RINJP'),
        new Option('Other adult relative','RINJAR'),
        new Option('Unrelated (but identifiable) adult','RINJUA'),
        new Option('Sibling','RINJSB'),
        new Option('Other youth','RINJOY'),
        new Option('Other','RINJO')};

      comAssociateCheckBox (block, 'On whom was serious injury inflicted? <b>(Select all that apply.)</b>', options, 'RINJC', 'RINJO');
      
      comAssociateInputField(block, 'RINJOS', '<span style="padding-left:2px;">On whom was serious injury inflicted? Please specify: </span>');
        
        
    }

    else if(Qtype == 'RINJ2') {
                            
      block.childComponents.add(comSelectList('RINJ', BasicOptions, 'skip'));
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      
      List<Option> options = new List<Option>{
        new Option('Child','RINJC'), 
        new Option('Teacher/Staff','RINJT'),
        new Option('Sibling','RINJSB'),
        new Option('Other youth','RINJOY'),
        new Option('Other','RINJO')};
      
      comAssociateCheckBox (block, 'On whom was serious injury inflicted? <b>(Select all that apply.)</b>', options, 'RINJC', 'RINJO');
      
      comAssociateInputField(block, 'RINJOS', '<span style="padding-left:15px;">On whom was serious injury inflicted? Please specify: </span>');
        
        
    }

    else if(Qtype == 'RINJ3') {
                            
      List<Option> options = new List<Option>{
        new Option('Concussion','RINJCC'),
        new Option('Animal bite','RINJAB'),
        new Option('Broken bone(s)','RINJBB'),
        new Option('Burn','RINJBN'),
        new Option('Other','RINJO'),
        new Option('Unknown','RINJUK')};

      comCheckBox(block, options, 'RINJO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RINJOS', '<span style="padding-left:15px;">Please specify the type of injury: </span>');
        
    }

    else if(Qtype == 'RINJ4') {
                            
      block.childComponents.add(comSelectList('RINJ', BasicOptions, 'skip'));
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      
      List<Option> options = new List<Option>{
        new Option('Child','RINJC'), 
        new Option('Parent','RINJP'),
        new Option('Other adult relative','RINJAR'),
        new Option('Unrelated (but identifiable) adult','RINJUA'),
        new Option('Sibling','RINJSB'),
        new Option('Other youth','RINJOY'),
        new Option('Other','RINJO')};

      comAssociateCheckBox (block, 'Who was seriously injured or killed? <b>(Select all that apply.)</b>', options, 'RINJC', 'RINJO');
      
      comAssociateInputField(block, 'RINJOS', '<span style="padding-left:2px;">Who was seriously injured or killed? Please specify: </span>');
        
        
    }

    else if(Qtype == 'RNTYPES') {
                            
      List<Option> options = new List<Option>{
        new Option('Physical (inadequate nutrition, hygiene, shelter, clothing)','RTYPPH'),
        new Option('Medical/dental','RTYPMD'),
        new Option('Educational','RTYPED'),
        new Option('Inadequate supervision','RTYPIS'),
        new Option('Exposure to violent environments (caregiver intentionally fails to protect child)','RTYPVE'),
        new Option('Other','RTYPOTH'),
        new Option('Unknown','RTYPUK')};
      
      comCheckBox(block, options, 'RTYPOTH');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RTYPOS', '<span style="padding-left:15px;">Please specify the type of neglect involved: </span>');
          
    }

    else if(Qtype == 'RTR') {
                            
      block.childComponents.add(comSelectList('RTRNSP', BasicOptions, 'skip'));
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));

      comAssociatePicklist(block, 'RTRSTL', 'Was the child transported across state lines to engage in services?', BasicOptions);
        
    }

    else if(Qtype == 'RTYPES') {
                            
      List<Option> options = new List<Option>{
        new Option('Emotional abuse','RTYPT5'),
        new Option('Emotional neglect','RTYPEN'),
        new Option('Verbal abuse','RTYPVA'),
        new Option('Excessive demands','RTYPED'),
        new Option('Other', 'RTYPOTH'),
        new Option('Unknown','RTYPEU')};
      
      comCheckBox(block, options, 'RTYPOTH');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RTYPOS', '<span style="padding-left:15px;">Please specify the type of maltreatment involved: </span>');
        
    }
    else if(Qtype == 'RTYPDS') {
                            
      List<Option> options = new List<Option>{
        new Option('Earthquake','REQ'),
        new Option('Hurricane','RHURR'),
        new Option('Flood','RFLOD'),
        new Option('Tornado','RTORN'),
        new Option('Fire/wildfires','RFIRE'),
        new Option('Landslides','RLAND'),
        new Option('Drought','RDRGT'),
        new Option('Industrial/technological','RINDS'),
        new Option('Public health emergency','RPHE'),
        new Option('Other', 'ROTH'),
        new Option('Unknown','RDSUK')};
      
      comCheckBox(block, options, 'ROTH');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'ROTHS', '<span style="padding-left:15px;">Please specify the type of disaster(s) involved: </span>');
        
    }

    else if(Qtype == 'RTHI') {
                            
      block.childComponents.add(comSelectList('RTHI', BasicOptions, 'skip'));
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      
      List<Option> options = new List<Option>{
        new Option('Physically hit or slapped','RTHIP'), 
        new Option('Tattooed or branded','RTHIT'),
        new Option('Pregnancy/ miscarriage/ forced abortion','RTHIFA'),
        new Option('Forced drug use','RTHIDU'),
        new Option('Resources withheld (e.g., food, medical attention, shelter)','RTHIR'),
        new Option('Contracted an STD','RTHICS'),
        new Option('Harm (or threatened harm) to family members or friends','RTHIHF'),
        new Option('Other','RTHIO')};
      
      comAssociateCheckBox (block, 'Please indicate the way in which injury was inflicted. <b>(Select all that apply.)</b>', options, 'RTHIP', 'RTHIO');
      
      comAssociateInputField(block, 'RTHIOS', '<span style="padding-left:15px;">Please specify the threat or injury: </span>');
        
        
    }

    else if(Qtype == 'RCMP') {
                            
      block.childComponents.add(comSelectList('RCMP', BasicOptions, 'skip'));
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      
      List<Option> options = new List<Option>{
        new Option('Money','RCMPM'), 
        new Option('Favors','RCMPF'),
        new Option('Material possessions (electronic devices, clothing)','RCMPMP'),
        new Option('Shelter','RCMPS'),
        new Option('Food','RCMPFD'),
        new Option('Drugs','RCMPD'),
        new Option('Personal safety','RCMPPS'),
        new Option('Safety of another (family member or friend)','RCMPSA'),
        new Option('Other','RCMPO')};
      
      comAssociateCheckBox (block, 'Please indicate the type of compensation. <b>(Select all that apply.)</b>', options, 'RCMPM', 'RCMPO');
      
      comAssociateInputField(block, 'RCMPOS', '<span style="padding-left:15px;">Please specify the compensation for his/her services: </span>');       
        
    }

    else if(Qtype == 'RDIS') {
                            
      block.childComponents.add(comSelectList('RDIS', BasicOptions, 'skip'));
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      
      List<Option> options = new List<Option>{
        new Option('Child','RDISC'), 
        new Option('Parent','RDISP'),
        new Option('Other adult relative','RDISOR'),
        new Option('Unrelated (but identifiable) adult','RDISUA'),
        new Option('Sibling','RDISSB'),
        new Option('Other youth','RDISOY'),
        new Option('Other','RDISO')};
      
      comAssociateCheckBox (block, 'On whom? <b>(Select all that apply.)</b>', options, 'RDISC', 'RDISO');
      
      comAssociateInputField(block, 'RDISOS', '<span style="padding-left:15px;">Please specify the person who was permanently disabled/killed: </span>');       
        
    }

    else if(Qtype == 'RMEN') {
                            
      List<Option> options = new List<Option>{
        new Option('Online/pornographic websites (sharing or posting of images, engaging in sex acts, forums)','RMENOL'),
        new Option('Escort services','RMENE'),
        new Option('Street prostitution','RMENS'),
        new Option('Brothels/massage parlors/ strip clubs/ truck stops','RMENB'),
        new Option('Forced labor/domestic servitude','RMENF'),
       
        new Option('Other', 'RMENO'),
        new Option('Unknown','RMENU')};
      
      comCheckBox(block, options, 'RMENO');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RMENOS', '<span style="padding-left:15px;">Please specify the means by/through which the child was exploited/trafficked: </span>');
        
    }

    else if(Qtype == 'RVTYP') {
                            
      List<Option> options = new List<Option>{
        new Option('Robbery','RROB'),
        new Option('Assault','RASSLT'),
        new Option('Homicide','RHOM'),
        new Option('Suicide','RSUIC'),
        new Option('Other', 'ROTH'),
        new Option('Unknown','RVPUK')};
      
      comCheckBox(block, options, 'ROTH');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'ROTHS', '<span style="padding-left:15px;">Please specify the type of violence: </span>');
        
    }
    else if(Qtype == 'RWPN') {
                            
      List<Option> options = new List<Option>{
        new Option('Conventional (e.g., firearms (shootings), bombs (9/11, Boston Marathon), etc.)','RCONV'),
        new Option('Chemical','RCHEM'),
        new Option('Radiological/Nuclear','RRAD'),
        new Option('Rocket and mortar attacks','RRMA'),
        new Option('Biological','RBIO'),
        new Option('Unknown','RWPNU')};
      
      comCheckBox(block, options, '');
        
    }
    else if(Qtype == 'RTT12C') {
                            
      List<Option> options = new List<Option>{
        new Option('Motor vehicle','RMV'),
        new Option('Animal attack','RDOGBT'),
        new Option('Fall','RFALL'),
        new Option('Small house fire','RHSFRE'),
        new Option('Near drowning','RDRWN'),
        new Option('Accidental shooting','RSHOOT'),
        new Option('Other','ROTHR'),
        new Option('Unknown','RACUK')};
      
      comCheckBox(block, options, 'ROTHR');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'ROTHSP', '<span style="padding-left:15px;">Please specify the type of accident(s): </span>');
        
    }

    else if(Qtype == 'RFTB') {
                            
      List<Option> options = new List<Option>{
        new Option('Physical bullying (e.g., hitting, spitting, tripping)','RFPHSB'),
        new Option('Sexual bullying (e.g., comments or gestures focusing on a person’s body parts or sexual orientation)', 'RFSEXB'),
        new Option('Verbal bullying (e.g., name calling, insults, teasing)','RFVERB'),
        new Option('Social bullying (e.g., rumors, mimicking, damaging social reputation, isolation/exclusion)','RFSOCB'),
        new Option('Other','RFOTR')};
      
      comCheckBox(block, options, 'RFOTR');
      
      block.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      comAssociateInputField(block, 'RFOSP', '<span style="padding-left:15px;">Please specify the type(s) of bullying: </span>');
        
    }

    else if(Qtype == 'RMED') {

      //Option fieldLevel_1 = new Option('Face-to-face','RMFCE');

      List<Option> fieldLevel_1 = new List<Option>{
        new Option('Face-to-face','RMFCE'),
        new Option('Cyberbullying','RMCYB'),
        new Option('Other','RMOTR'),
        new Option('Unknown','RMUK')};
        
      List<List<Option>> fieldLevel_2 = new List<List<Option>> { 
        new List<Option>{ new Option('Home', 'RMFHO'),
                          new Option('School', 'RMFSC'),
                          new Option('Community', 'RMFCO'),
                          new Option('Other', 'RMFOT')},
        new List<Option>{ new Option('Social networking sites', 'RMCSO'),
                          new Option('Text messages', 'RMCTX'),
                          new Option('Instant messages', 'RMCIM'),
                          new Option('Email', 'RMCEM'),
                          new Option('Website/blog postings', 'RMCWB'),
                          new Option('Other', 'RMCOT')},
        null,  // Option - Other 
        null}; // Option - Unknown

      Map<String, String> skipElementOther = new Map<String, String>();

      List<String> ContentLevel_2 = new List<String>();

      ContentLevel_2.add('Where did the bullying take place? (Select all that apply.)');
      ContentLevel_2.add('How did the bullying take place? (Select all that apply.)');

      skipElementOther.put('RMFOT', 'RMFOSP');
      skipElementOther.put('RMCOT', 'RMCOSP');
      skipElementOther.put('RMOTR', 'RMOSP');

      comCheckboxInsideCheckbox(block, fieldLevel_1, ContentLevel_2, fieldLevel_2, skipElementOther);

      block.childComponents.add(rowHeadFoot('foot', null, null, null));


    }

    else if(Qtype == 'RCP') {

      List<Option> fieldLevel_1 = new List<Option>{
        new Option('Parent/Caregiver was removed from the home','RCP'),
        new Option('Child was removed from the home','RCC'),
        new Option('Other','RCO'),
        new Option('Unknown', 'RCUK')};

      List<List<Option>> fieldLevel_2 = new List<List<Option>> { 
        new List<Option>{
          new Option('Divorce', 'RCPD'),
          new Option('Court mandated separation', 'RCPCM'),
          new Option('Incarceration', 'RCPIN'),
          new Option('Hospitalization (medical or psychiatric) ', 'RCPHP'),
          new Option('Work','RCPW'),
          new Option('Military assignment/deployment','RCPM'),
          new Option('Training/education','RCPT'),
          new Option('Other','RCPO'),
          new Option('Unknown','RCPUK')
        },
        new List<Option>{
          new Option('Placement in foster care (i.e., child protection services involvement)', 'RCCFC'),
          new Option('Placement in residential setting/group home', 'RCCRS'),
          new Option('Court mandated separation/changes in custody (not including divorce)', 'RCCCM'),
          new Option('Incarceration', 'RCCIN'),
          new Option('Hospitalization (medical or psychiatric)', 'RCCHP'),
          new Option('Other', 'RCCO'),
          new Option('Unknown', 'RCCUK')
        },
        null, 
        null
      }; 

      Map<String, String> skipElementOther = new Map<String, String>();

      List<String> ContentLevel_2 = new List<String>();

      ContentLevel_2.add('Please describe the reason:');
      ContentLevel_2.add('Please describe the reason:');

      skipElementOther.put('RCO', 'RCOS');
      skipElementOther.put('RCPO', 'RCPOS');
      skipElementOther.put('RCCO', 'RCCOS');

      comCheckboxInsideCheckbox(block, fieldLevel_1, ContentLevel_2, fieldLevel_2, skipElementOther);

      block.childComponents.add(rowHeadFoot('foot', null, null, null));


    }

    else if(Qtype == 'RD') {

      List<List<Option>> matrix = new List<List<Option>> { 
        new List<Option> { // Row 0 - Title
            new Option('Cause of Death', null),       new Option('Parent', null),
            new Option('Grandparent', null),          new Option('Sibling', null),
            new Option('Other Relative', null), new Option('Unrelated Adult', null),
            new Option('Unrelated Youth', null)},          
        new List<Option> { // Row 1 - Natural Death
            new Option('Natural Death due to a chronic condition/prolonged illness (e.g., cancer)', 'RDN'), 
            new Option('', 'RDNP'),  new Option('', 'RDNG'),
            new Option('', 'RDNSB'), new Option('', 'RDNOA'), 
            new Option('', 'RDNUA'), new Option('', 'RDNOY')}, 
        new List<Option> { // Row 2 - Sudden Natural Death
            new Option('Sudden Natural Death due to illness (e.g., heart attack, stroke, organ failure)', 'RDI'), 
            new Option('', 'RDIP'),  new Option('', 'RDIG'),
            new Option('', 'RDISB'), new Option('', 'RDIOA'), 
            new Option('', 'RDIUA'), new Option('', 'RDIOY')}, 
        new List<Option> { // Row 3 - Murder/ Homicide 
            new Option('Murder/Homicide', 'RDM'), 
            new Option('', 'RDMP'),  new Option('', 'RDMG'),
            new Option('', 'RDMSB'), new Option('', 'RDMOA'), 
            new Option('', 'RDMUA'), new Option('', 'RDMOY')}, 
        new List<Option> { // Row 4 - Murder/Homicide 
            new Option('Violence (e.g., gang violence, school shooting)', 'RDV'), 
            new Option('', 'RDVP'),  new Option('', 'RDVG'),
            new Option('', 'RDVSB'), new Option('', 'RDVOA'), 
            new Option('', 'RDVUA'), new Option('', 'RDVOY')}, 
        new List<Option> { // Row 5 - Accident 
            new Option('Accident (e.g., motor vehicle accident)', 'RDA'), 
            new Option('', 'RDAP'),  new Option('', 'RDAG'),
            new Option('', 'RDASB'), new Option('', 'RDAOA'), 
            new Option('', 'RDAUA'), new Option('', 'RDAOY')}, 
        new List<Option> { // Row 6 - Suicide 
            new Option('Suicide', 'RDS'), 
            new Option('', 'RDSP'),  new Option('', 'RDSG'),
            new Option('', 'RDSSB'), new Option('', 'RDSOA'), 
            new Option('', 'RDSUA'), new Option('', 'RDSOY')}, 
        new List<Option> { // Row 7 - Natural Disaster
            new Option('Natural Disaster (e.g., tornado)', 'RDD'), 
            new Option('', 'RDDP'),  new Option('', 'RDDG'),
            new Option('', 'RDDSB'), new Option('', 'RDDOA'), 
            new Option('', 'RDDUA'), new Option('', 'RDDOY')}, 
        new List<Option> { // Row 8 - Terrorism/Political Violence/Civilian Casualty of War
            new Option('Terrorism/Political Violence/Civilian Casualty of War', 'RDT'), 
            new Option('', 'RDTP'),  new Option('', 'RDTG'),
            new Option('', 'RDTSB'), new Option('', 'RDTOA'), 
            new Option('', 'RDTUA'), new Option('', 'RDTOY')}, 
        new List<Option> { // Row 9 - War 
            new Option('War', 'RDW'), 
            new Option('', 'RDWP'),  new Option('', 'RDWG'),
            new Option('', 'RDWSB'), new Option('', 'RDWOA'), 
            new Option('', 'RDWUA'), new Option('', 'RDWOY')}, 
        new List<Option> { // Row 10 - Other 
            new Option('Other, please specify: ', 'RDO'), 
            new Option('', 'RDOP'),  new Option('', 'RDOG'),
            new Option('', 'RDOSB'), new Option('', 'RDOOA'), 
            new Option('', 'RDOUA'), new Option('', 'RDOOY')}, 
        new List<Option> { // Row 11 - Unknown
            new Option('Unknown', 'RDU'), 
            new Option('', 'RDUP'),  new Option('', 'RDUG'),
            new Option('', 'RDUSB'), new Option('', 'RDUOA'), 
            new Option('', 'RDUUA'), new Option('', 'RDUOY')} 
        
      };

      comMatrixCheckbox(block, 'Field', Content, Num, matrix);

    }

    else if(Qtype == 'RREPORT' || Qtype == 'RPENET' || Qtype == 'RWEAPON' || 
            Qtype == 'RLIFE'   || Qtype == 'RGANG'  || Qtype == 'RPORNOG' ||
            Qtype == 'RPAIN'   || Qtype == 'RFRGT'  || Qtype == 'RPICU'   ||
            Qtype == 'REVAC'   || Qtype == 'RHDAM'  || Qtype == 'RTRNSP'  ||
            Qtype == 'RSRV') {
      block.childComponents.add(comSelectList(Qtype, BasicOptions, null));
    }
    
    block.childComponents.add(rowHeadFoot('foot', null, null, null));
    
      
  
  }

  public void comMatrixCheckbox(Component.Apex.pageBlock block, String Field, String Content, String Num, List<List<Option>> matrix) {

    Component.Apex.OutputText rowContentHeader = new Component.Apex.OutputText(escape = false);
      
    rowContentHeader.value = '<tr><td class="numTD">'+Num+'. <td colspan="2">'+Content+'<br><br>';

    block.childcomponents.add(rowContentHeader);


    Component.Apex.OutputText matrixHeader = new Component.Apex.OutputText(escape = false);
      
    matrixHeader.value = '<table class="table table-bordered table-hover table-condensed">';

    block.childcomponents.add(matrixHeader);


    for(Integer i = 0; i < matrix.size(); i++) {

      for(Integer j = 0; j < matrix.get(0).size(); j++) {

        String fieldName = matrix.get(i).get(j).value;
        String fieldTitle = (matrix.get(i).get(j).index == null) ? '' : matrix.get(i).get(j).index;

        if(j == 0) {
          
          Component.Apex.OutputText contentTRHead = new Component.Apex.OutputText(escape = false);
          
          contentTRHead.value = '<tr>';
          
          block.childcomponents.add(contentTRHead);

        }

        if(i == 0)  { // title
          
          Component.Apex.OutputText contentTHHead = new Component.Apex.OutputText(escape = false);
          
          contentTHHead.value = '<th class="text-center">'+fieldTitle+'</th>';
          
          block.childcomponents.add(contentTHHead);

        }
        else {       // Content
          
          Component.Apex.OutputText contentTDHead = new Component.Apex.OutputText(escape = false);
          
          contentTDHead.value = (j == 0) ? 
                                '<td style="vertical-align:middle" class="td-'+fieldName+'">'+fieldTitle :
                                '<td class="text-center td-option" data-row="'+matrix.get(i).get(0).value+'" style="vertical-align:middle">'+fieldTitle;

          block.childcomponents.add(contentTDHead);

          Component.Apex.inputCheckbox  input = new Component.Apex.inputCheckbox();
          input.expressions.value = '{!TDObject[\''+TDForm+fieldName+'__c\']}';
          input.id = TDForm+fieldName+'__c';
          input.styleClass = (j != 0) ? 'matrix-option option-' + matrix.get(i).get(0).value : fieldName + ' hidden';
          
          block.childcomponents.add(input);

          Component.Apex.OutputText contentTDFoot = new Component.Apex.OutputText(escape = false);

          contentTDFoot.value = '</td>';

          block.childcomponents.add(contentTDFoot);
        }
        
        if(j == matrix.get(0).size()) {
          Component.Apex.OutputText contentTRFoot = new Component.Apex.OutputText(escape = false);
          contentTRFoot.value += '</tr>';
          block.childcomponents.add(contentTRFoot);
        }

      }
    }

    Component.Apex.OutputText matrixFooter = new Component.Apex.OutputText(escape = false);

    matrixFooter.value = '</table>';
                            
    block.childcomponents.add(matrixFooter);

    Component.Apex.OutputText rowContentFooter = new Component.Apex.OutputText(escape = false);
      
    rowContentFooter.value = '</td></tr>';

    block.childcomponents.add(rowContentFooter);

    Component.Apex.InputField other = new Component.Apex.InputField();
    other.expressions.value = '{!TDObject[\''+TDForm+'RDOSP__c\']}';
    other.id = 'matrix_other';
    other.styleClass = 'form-control auto-width input-sm matrix-other';

    block.childcomponents.add(other);

    Component.Apex.OutputText script = new Component.Apex.OutputText(escape = false);
      
    script.value = '<script> $j(document).ready(function(){$j(".matrix-option").change(function(){ var isChecked = false;var rowName = $j(this).parent("td").attr("data-row");$j(".option-"+rowName).each(function() { if($j(this).is(":checked")) isChecked = true; });$j("."+rowName).prop("checked", isChecked);});  }); $j(".td-RDO").append($j(".matrix-other"));</script>';

    block.childcomponents.add(script);

  }

  public void comAssociatePicklist (Component.Apex.pageBlock block, String Field, String Content, List<Option> options) {
      
      Component.Apex.outputPanel panel = new Component.Apex.outputPanel(layout = 'none');
      //panel.expressions.rendered = '{!skipAction[\''+Field+'\']}';
      //panel.expressions.rendered = '{!skip.skipAction[\''+TDForm+Field+'\']}';
      
      panel.childComponents.add(rowHeadFoot('head', '', Content, TDForm+Field)); 
          
      Component.Apex.selectList selectGroup = new Component.Apex.selectList();

      String fieldName = TDForm+Field;
      
      selectGroup.id = fieldName+'__c';
      selectGroup.size = 1;
      selectGroup.expressions.value = '{!TDObject[\''+fieldName+'__c\']}';
      selectGroup.styleClass = 'form-control skip-element-'+TDForm+Field;
      
      for(Option op : options) {
        Component.Apex.selectOption so = new Component.Apex.selectOption();
          so.itemValue = op.index;
          so.itemLabel = op.value;
        
        selectGroup.childComponents.add(so); 
      }
      
      panel.childComponents.add(selectGroup);
      
      panel.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      block.childComponents.add(panel);
      
  }
    
  public void comAssociateInputField (Component.Apex.pageBlock block, String Field, String Content) {
      
      Component.Apex.outputPanel panel = new Component.Apex.outputPanel(layout = 'none');
      //panel.expressions.rendered = '{!skipAction[\''+Field+'\']}';
      //panel.expressions.rendered = '{!skip.skipAction[\''+TDForm+Field+'\']}';
      
      panel.childComponents.add(rowHeadFoot('head', '', Content, TDForm+Field)); 
          
      Component.Apex.InputField RODT = new Component.Apex.InputField();
      RODT.expressions.value = '{!TDObject[\''+TDForm+Field+'__c\']}';
      RODT.id = TDForm+Field+'__c';
      RODT.styleClass = 'form-control auto-width skip-element-'+TDForm+Field;

      panel.childComponents.add(RODT);
      
      panel.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      block.childComponents.add(panel);
      
  }

  public void comCheckboxInsideCheckbox(Component.Apex.pageBlock block, List<Option> fieldLevel_1, 
                                        List<String> ContentLevel_2, List<List<Option>> fieldLevel_2, 
                                        Map<String, String> skipElementOther) {

    for(Integer i = 0; i < fieldLevel_1.size(); i++) {

      String fieldName = fieldLevel_1.get(i).value;

      Component.Apex.outputPanel panel = new Component.Apex.outputPanel(layout = 'none');

      // Checkbox Level 1
      Component.Apex.panelGrid grid = new Component.Apex.panelGrid(columns = 2);
            
      Component.Apex.inputCheckbox  input = new Component.Apex.inputCheckbox();
      input.expressions.value = '{!TDObject[\''+TDForm+fieldName+'__c\']}';
      input.id = TDForm+fieldName+'__c';
      input.styleClass = 'skip-element-'+TDForm+fieldName;
      input.onChange = 'skipLogic(\''+TDForm+fieldName+'\',this.checked)';
      
      grid.childComponents.add(input);

      Component.Apex.outputPanel otherPanel1 = new Component.Apex.outputPanel(layout = 'none');
          
      Component.Apex.outputLabel label1 = new Component.Apex.outputLabel(value = fieldLevel_1.get(i).index);
      label1.for = TDForm+fieldName+'__c';

      otherPanel1.childcomponents.add(label1);

      if(fieldLevel_2.get(i) == null) {

        if(!skipElementOther.isEmpty()) {

          if(skipElementOther.containsKey(fieldName)) {

            String skipOtherField = skipElementOther.get(fieldName);

            Component.Apex.outputPanel specifyDiv = new Component.Apex.outputPanel(layout = 'block', styleClass = 'skip-'+TDForm+skipOtherField);

            Component.Apex.OutputText specifyText = new Component.Apex.OutputText();
            
            specifyText.value = 'Please specify: ';
            specifyText.escape = false;

            Component.Apex.InputField otherField = new Component.Apex.InputField();
            otherField.expressions.value = '{!TDObject[\''+TDForm+skipOtherField+'__c\']}';
            otherField.id = skipOtherField;
            otherField.styleClass = 'form-control auto-width input-sm skip-element-'+TDForm+skipOtherField;

            specifyDiv.childcomponents.add(specifyText);
            specifyDiv.childcomponents.add(otherField);

            otherPanel1.childcomponents.add(specifyDiv);

          }

        }

      }

      grid.childComponents.add(otherPanel1);
      
      panel.childComponents.add(grid);

      block.childComponents.add(panel);

      if(fieldLevel_2.get(i) != null) {

        //Checkbox Level 2
        Component.Apex.outputPanel panel2 = new Component.Apex.outputPanel();    

        panel2.layout = 'block';
        panel2.styleClass = 'skipContent skip-'+TDForm+fieldLevel_2.get(i).get(0).value;

        Component.Apex.OutputText content2 = new Component.Apex.OutputText();
          
        content2.value = '<p><b>'+ContentLevel_2.get(i)+'</b></p>';
        content2.escape = false;

        panel2.childcomponents.add(content2); 

        for(Option field2 : fieldLevel_2.get(i)) {
                  
          Component.Apex.panelGrid grid2 = new Component.Apex.panelGrid(columns = 2);
          
          Component.Apex.inputCheckbox  input2 = new Component.Apex.inputCheckbox();
          input2.expressions.value = '{!TDObject[\''+TDForm+field2.Value+'__c\']}';
          input2.id = TDForm+field2.Value+'__c';
          input2.styleClass = 'skip-element-'+TDForm+field2.value;
          
          if(skipElementOther.containsKey(field2.Value))
            input2.onChange = 'skipLogic(\''+TDForm+field2.Value+'\',this.checked)';

          grid2.childComponents.add(input2);

          Component.Apex.outputPanel otherPanel = new Component.Apex.outputPanel(layout = 'none');
          
          Component.Apex.outputLabel label2 = new Component.Apex.outputLabel(value = field2.index);
          label2.for = TDForm+field2.Value+'__c';

          otherPanel.childcomponents.add(label2);

          if(!skipElementOther.isEmpty()) {

            //System.debug(field2.value);

            if(skipElementOther.containsKey(field2.Value)) {

              String skipOtherField = skipElementOther.get(field2.Value);

              Component.Apex.outputPanel specifyDiv = new Component.Apex.outputPanel(layout = 'block', styleClass = 'skip-'+TDForm+skipOtherField);

              Component.Apex.OutputText specifyText = new Component.Apex.OutputText();
              
              specifyText.value = 'Please specify: ';
              specifyText.escape = false;

              Component.Apex.InputField otherField = new Component.Apex.InputField();
              otherField.expressions.value = '{!TDObject[\''+TDForm+skipOtherField+'__c\']}';
              otherField.id = TDForm+skipOtherField+'__c';
              otherField.styleClass = 'form-control auto-width input-sm skip-element-'+TDForm+skipOtherField;

              specifyDiv.childcomponents.add(specifyText);
              specifyDiv.childcomponents.add(otherField);

              otherPanel.childcomponents.add(specifyDiv);

            }

          }

          grid2.childComponents.add(otherPanel);
          
          panel2.childComponents.add(grid2);
              
        }   

        block.childComponents.add(panel2);

      }
      
    }

  }
    
  public void comAssociateCheckBox (Component.Apex.pageBlock block, String Content, List<Option> Options, String Field, String action) {
      
      Component.Apex.outputPanel panel = new Component.Apex.outputPanel(layout = 'none');
      //panel.expressions.rendered = '{!skipAction[\''+Field+'\']}';
      //panel.expressions.rendered = '{!skip.skipAction[\''+TDForm+Field+'\']}';
      
      panel.childComponents.add(rowHeadFoot('head', '', Content, TDForm+Field)); 
          
      for(Option op : options) {
              
          Component.Apex.panelGrid grid = new Component.Apex.panelGrid(columns = 2);
          
          Component.Apex.inputCheckbox  input = new Component.Apex.inputCheckbox();
          input.expressions.value = '{!TDObject[\''+TDForm+op.Value+'__c\']}';
          input.id = TDForm+op.Value+'__c';
          input.styleClass = 'skip-element-'+TDForm+Field;
          
          if(op.Value == action)
              input.onChange = 'skipLogic(\''+TDForm+op.Value+'\',this.checked)';
          
          Component.Apex.outputLabel label = new Component.Apex.outputLabel(value = op.index);
          label.for = TDForm+op.Value+'__c';
          
          grid.childComponents.add(input);
          grid.childComponents.add(label);
          
          panel.childComponents.add(grid);
          
      }
      
      panel.childComponents.add(rowHeadFoot('foot', null, null, null));
      
      block.childComponents.add(panel);
      
  }
    
  /*public PageReference skipLogic() {
      
      skip.runSkipLogic(skipTrigger, triggerValue, TDObject);
      
      
      return null;
  }*/
    
    
  public void comCheckBox(Component.Apex.pageBlock block, List<Option> options, String action){
      
    for(Option op : options) {
            
      Component.Apex.panelGrid grid = new Component.Apex.panelGrid(columns = 2);
      
      Component.Apex.inputCheckbox  input = new Component.Apex.inputCheckbox();
      input.expressions.value = '{!TDObject[\''+TDForm+op.Value+'__c\']}';
      input.id = TDForm+op.Value+'__c';
      
      if(op.Value == action)
          input.onChange = 'skipLogic(\''+TDForm+op.Value+'\',this.checked)';
      
      Component.Apex.outputLabel label = new Component.Apex.outputLabel(value = op.index);
      label.for = TDForm+op.Value+'__c';
      
      grid.childComponents.add(input);
      grid.childComponents.add(label);
      
      block.childComponents.add(grid);
        
    }
      
  }
    
  public Component.Apex.selectList comSelectList(String Field, List<Option> options, String action) {
  
    Component.Apex.selectList selectGroup = new Component.Apex.selectList();

    String fieldName = (Field == 'STATUS') ? Field+'_'+formType : TDForm+Field;
    
    selectGroup.id = fieldName+'__c';
    selectGroup.size = 1;
    selectGroup.styleClass = 'form-control';
    selectGroup.expressions.value = '{!TDObject[\''+fieldName+'__c\']}';

    if(action == 'skip')
        selectGroup.onChange = 'skipLogic(\''+fieldName+'\',this.value)';
    
    for(Option op : options) {
      Component.Apex.selectOption so = new Component.Apex.selectOption();
        so.itemValue = op.index;
        so.itemLabel = op.value;
      
      selectGroup.childComponents.add(so); 
    }
    
    return selectGroup;
      
  }
    
  public Component.Apex.pageBlockButtons CommandButton() {
      
    Component.Apex.pageBlockButtons blockButtons = new Component.Apex.pageBlockButtons();
    
    Component.Apex.commandButton saveButton = new Component.Apex.commandButton();
    saveButton.expressions.action = '{!save}';
    saveButton.value = 'Save';
    
    blockButtons.childComponents.add(saveButton);
    
    if(forceRedirect != '1') {

      Component.Apex.commandButton cancelButton = new Component.Apex.commandButton();
      cancelButton.expressions.action = '{!cancel}';
      cancelButton.value = 'Cancel';
      
      blockButtons.childComponents.add(cancelButton);

    }
    
    return blockButtons;
      
  }

  public void completeStatus(Component.Apex.pageBlock block) {

    Component.Apex.OutputText head = new Component.Apex.OutputText();
      
    head.value = '<tr><td colspan="2" class="text-right complete-title"><b>Complete?</b></td><td class="optionTD">';
    head.escape = false;

    block.childComponents.add(head);

    List<Option> options = new List<Option>{new Option('Incomplete','Incomplete'),
                                              new Option('Complete','Complete')};
      
    block.childComponents.add(comSelectList('STATUS', options, null));

    Component.Apex.OutputText foot = new Component.Apex.OutputText();
    foot.value = '</td></tr>';
    foot.escape = false;

    block.childComponents.add(foot);

  }
  
  
  public Component.Apex.OutputText rowHeadFoot(String type, String Num, String Content, String skip) {
      
      Component.Apex.OutputText rowContent = new Component.Apex.OutputText();

      skip = (skip != null) ? 'skip-' + skip : null;

      Num = (Num != '') ? Num + '.' : '';
      
      if(type == 'head') 
        rowContent.value = '<tr class="'+skip+'"><td class="numTD">'+Num+'</td><td class="questionTD">'+Content+'</td><td class="optionTD">';
      else if(type == 'section')
        rowContent.value = '<tr><td class="numTD"></td><td class="questionTD" colspan="2">'+Content;
      else if(type == 'foot') 
        rowContent.value = '</td></tr>';
      
      rowContent.escape = false;
      
      return rowContent;
      
  }
    
  /*public void comStatus(Component.Apex.pageBlock block) {
      
      Component.Apex.OutputText completeStart = new Component.Apex.OutputText(value = '<div style="float:right;">', escape = false);
      
      Component.Apex.OutputText completeEnd = new Component.Apex.OutputText(value = '</div>', escape = false);
      
      Component.Apex.panelGrid grid = new Component.Apex.panelGrid(columns = 2);
      
      Component.Apex.outputLabel label = new Component.Apex.outputLabel(value = 'Complete');
      
      Component.Apex.InputField input = new Component.Apex.InputField();
      input.expressions.value = '{!TDObject[\'Status__c\']}';
      input.id = 'TDStatus';
      input.styleClass = 'form-control input-sm';
      
      grid.childComponents.add(label);
      grid.childComponents.add(input);
      
      block.childComponents.add(completeStart);   
      block.childComponents.add(grid);
      block.childComponents.add(completeEnd); 
      
  }*/

  public PageReference cancel() {

    PageReference summaryPage = new PageReference('/apex/ClientSummary?s=-1&id=' + cID);
    summaryPage.setRedirect(true);
    
    return summaryPage;

  }
  
  public PageReference save() {

    PageReference nextPage;
      
    try {
      if(edit == FALSE)
        insert TDObject;
      else
        update TDObject;

      nextPage = new PageReference(skip.formRedirct(cID, '-1', forceRedirect));
      nextPage.setRedirect(true);
    }
    catch(DMLException e) { nextPage = null; }

    return nextPage;
      
  } 
    
}