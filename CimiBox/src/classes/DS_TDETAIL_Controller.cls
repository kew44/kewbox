/**
* @author Danny Fu
* @date 07/21/2014
*
* @modified 06/29/2016 DF Modularization and New style.
* @modified 7/21/2016 KW delete extra ENUMSKIP, _1 from RSET
*
* @group Trauma
* @group-content /ApexDocContent/Trauma/Trauma_detail.htm
*
* @description An apex controller class to pupolate Trauma Detail Forms.
* 
*/
public with sharing class DS_TDETAIL_Controller extends DS_BasicForm_Controller {
    
    String TDForm;
        
    Object emptyText = null;
    Object emptyCheck = FALSE;
        
    Map<String, String> DefaultQuestion = new Map<String, String>();
    
    Map<String, String> formNum = new Map<String, String>();
    
    String formType;
    
    public class Option {
        
        public String index { get; set; }
        public String value { get; set; }
        
        public Option (String index, String value) {
            this.index = index;
            this.value = value;
        }
        
    }
    
    public DS_TDETAIL_Controller() {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        formType = form.parameter.get('TDF');
        
        String pageName = 'DS_'+formType;
        
        DS_DATA__c forminfo = [SELECT Content__c, Object__c, Variable__c
                               FROM DS_DATA__c 
                               WHERE Page__c = :pageName 
                               AND Data_Type__c = 'DS_Form_Info'];
        
        // Set the obj name 
        form.setObjName(forminfo.Object__c+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable(formType);
        
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
        DefaultQuestion.put('RSET',  'Please indicate the setting(s) of the experience. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RSET_2',  'Please indicate the setting(s) of the experience. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RSET_3',  'Please indicate the setting(s) of the experience. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RSET_4',  'Please indicate the setting(s) of the experience. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RPER',   'Please identify the perpetrator(s). <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RPER_2',  'Please identify the purchaser(s)/perpetrator(s) of the exploitation or service. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RPER_3',  'Please identify the perpetrator(s). <b>(Select all that apply.)</b>');   
        DefaultQuestion.put('RPER_4',  'Please identify the perpetrator(s). <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RINJ',   'Was serious injury inflicted?');
        DefaultQuestion.put('RINJ_2',  'Was serious injury inflicted?');
        DefaultQuestion.put('RINJ_3',  'Please specify the type of injury(ies) that occurred.');
        DefaultQuestion.put('RINJ_4',  'Was anyone seriously injured or killed?');
        DefaultQuestion.put('RREPORT','Was a report filed? (e.g., Police, Child Protective Services)');
        DefaultQuestion.put('RPENET', 'Did this trauma ever involve oral, vaginal, or anal penetration?');//<!--on TD1 maltreatment/abuse, TD2 assault/rape, not assault/abuse. Trauma is temporary generic-->
        DefaultQuestion.put('RWEAPON','Was a weapon used?');
        DefaultQuestion.put('RTYPES', 'Please identify the type of maltreatment involved. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RNTYPES','Please identify the type of neglect involved. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RWPN',   'Please indicate the type of weapons used. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RWPN_2',  'Please indicate the type of weapons used. <b>(Select all that apply.)</b>');
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
        DefaultQuestion.put('RPR_2',   'Please identify the person(s) from whom the child was separated. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RSRV',   'In the case of an immediate family member or caregiver, did the child attend any rituals or customs associated with the death (e.g., visitation, wake, funeral, burial, memorial)?');
        DefaultQuestion.put('RFTB',   'Please identify the type(s) of bullying. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RRES',   'Was the victim targeted by the bully for a specific reason?');
        DefaultQuestion.put('RMED',   'Please describe the medium through which bullying occurred. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RCP',    'Please describe the circumstances of the separation. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RDU',    'What was the duration of the separation? <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RST',    'Please describe the permanency status of the separation. <b>(Select all that apply.)</b>');
        DefaultQuestion.put('RRESIB', 'Did the child remain with siblings during the separation? <b>(Select only one.)</b>');
        DefaultQuestion.put('RD',     'Please specify cause of death experienced by someone close to  the client and the relationship of each person who died to the client.');
        
        TDForm = formNum.get(formType);
        
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
                                 TDForm+'RINJT' => 'checkbox', TDForm+'RINJO'  => 'checkbox'});  
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
        
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(skip.skipList);
                
    }
    
    public Component.Apex.pageBlock getContent() {
        
        Component.Apex.pageBlock block = new Component.Apex.pageBlock();
        
        block.title = 'Trauma Detail, '+form.title;
        
        Component.Apex.pageMessages message = new Component.Apex.pageMessages();
        
        block.childComponents.add(message);
        
        List<DS_DATA__c> instruction = [SELECT Category__c, Note__c, weight__c 
                                        FROM DS_DATA__c 
                                        WHERE Form__c = :formType 
                                        AND Data_Type__c = 'DS_TD_Form_Info'
                                        AND Category__c = 'INSTRUCTION'];
        
        String instructionContent = (instruction.size() > 0) ? 
            '<div class="alert alert-info"><strong>'+instruction.get(0).Note__c+'</strong></div>' : '';
        
        Component.Apex.OutputText instructionDiv = new Component.Apex.OutputText();
        instructionDiv.value = instructionContent;
        instructionDiv.escape = false;
        
        block.childComponents.add(instructionDiv);
        
        List<DS_DATA__c> Qinfo = [SELECT Category__c, Content__c, weight__c 
                                  FROM DS_DATA__c 
                                  WHERE Form__c = :formType 
                                  AND Data_Type__c = 'DS_TD_Form_Info'
                                  AND Category__c != 'INSTRUCTION'
                                  ORDER BY weight__c];
        
        if(Qinfo.size() != 0) {
            for(DS_DATA__c info : Qinfo) {
                elementGenerator(block, info.Category__c, String.valueof(info.weight__c), info.Content__c);
            }
        }
        
        // Status dropdown menu
        elementGenerator(block, 'STATUS', '', null); 
        
        // Save & Cancel buttons
        elementGenerator(block, 'SUBMITBTN', '', null);
        
        return block;        
    }
    
    public void elementGenerator(ApexPages.Component block, String Qtype, String Num, String Content) {
                
        Content = (Content != null) ? Content : DefaultQuestion.get(Qtype);
                
        String [] splitQtype = Qtype.split('_');
        
        Integer version = (splitQtype.size() > 1) ? Integer.valueOf(splitQtype[1]) : 1;
        
        
        Set<String> baseClass = new Set<String>{'RREPORT','RPENET','RWEAPON','RLIFE','RGANG','RPORNOG',
                                                'RPAIN','RFRGT','RPICU','REVAC','RHDAM','RTRNSP','RSRV'};
                                                    
        String elementClassName = (!baseClass.contains(splitQtype[0])) ? 'DS_TDETAIL_Interface.'+splitQtype[0] : 'DS_TDETAIL_Element_Base';
                        
        DS_TDETAIL_Interface.Element elementInstance = DS_TDETAIL_Factory.getInstance(elementClassName);
        
        if(elementInstance != null) {
            elementInstance.init(block, Num, Content, '', TDForm, splitQtype[0], version, form);
            elementInstance.build();
        }
  
    }
    
}