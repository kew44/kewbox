/****
*@description A page to develop a style guide template
*
*@date 5/4/16
*@author KW
*
*@modified    5/5/16    KW    map dummy variables
*
*@modified    6/6/16    KW    changed option labels, add skiplogic
*
*@modified    6/9/16    KW    radio1_temp for long options, zip code
*
*@modified    6/9/16    KW    radio2_temp, radio3_temp for grid radio4_temp, radio5_temp, radio6_temp for list
*
*@group Assessment
*@group-content /ApexDocContent/TEMP.htm
****/
public with sharing class DS_TEMP_Controller  extends DS_BasicForm_Controller {

    Final String warningMessageContent = 'Please note that if...';

    public DS_TEMP_Controller(ApexPages.StandardController controller) {
    
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
            
        // Set the obj name 
        form.setObjName('DS_Background_Family_Info_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();     
        
        //variable(s) needed for js would go here
        
        //skipLogic library 
        skip.skipLibrary('RADIO_TEMP', 'show', '98',   new Map<String, String>{'TXTSP_TEMP'    => 'text'}); 
        skip.skipLibrary('CHECK5_TEMP', 'show', 'true', new Map<String, String>{'TXTSP1_TEMP'=>'text'});    
        
        // Set the skip object to form object  
        form.setSkipLogic(skip);
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(skip.skipList);
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('TEMP');                
        
        //add variables to BorF map
        bfVariableMap.put('DOV_TEMP',   form.BorF+'DOV_TEMP__c'); 
        bfVariableMap.put('ZIP_TEMP',   form.BorF+'ZIP_TEMP__c');  
        bfVariableMap.put('TXTSP_TEMP',   form.BorF+'TXTSP_TEMP__c'); 
        bfVariableMap.put('TXTSP1_TEMP',   form.BorF+'TXTSP1_TEMP__c'); 
        bfVariableMap.put('DOV_TEMP1',   form.BorF+'DOV_TEMP1__c');
        bfVariableMap.put('MET_TEMP',   form.BorF+'MET_TEMP__c');
        bfVariableMap.put('RADIO_TEMP',   form.BorF+'RADIO_TEMP__c');
        bfVariableMap.put('RADIO1_TEMP',   form.BorF+'RADIO1_TEMP__c');
        bfVariableMap.put('RADIO2_TEMP',   form.BorF+'RADIO2_TEMP__c');
        bfVariableMap.put('RADIO3_TEMP',   form.BorF+'RADIO3_TEMP__c');
        bfVariableMap.put('RADIO4_TEMP',   form.BorF+'RADIO4_TEMP__c');
        bfVariableMap.put('RADIO5_TEMP',   form.BorF+'RADIO5_TEMP__c');
        bfVariableMap.put('RADIO6_TEMP',   form.BorF+'RADIO6_TEMP__c');
        bfVariableMap.put('NUM1_TEMP',   form.BorF+'NUM1_TEMP__c');
        bfVariableMap.put('NUM2_TEMP',   form.BorF+'NUM2_TEMP__c');
        bfVariableMap.put('NUM3_TEMP',   form.BorF+'NUM3_TEMP__c');
        bfVariableMap.put('NUM3_DBL_TEMP',   form.BorF+'NUM3_DBL_TEMP__c');
        bfVariableMap.put('NUM4_TEMP',   form.BorF+'NUM4_TEMP__c');
        bfVariableMap.put('NUM4_DBL_TEMP',   form.BorF+'NUM4_DBL_TEMP__c');
        bfVariableMap.put('NUM5_TEMP',   form.BorF+'NUM5_TEMP__c');
        bfVariableMap.put('NUM5_DBL_TEMP',   form.BorF+'NUM5_DBL_TEMP__c');
        bfVariableMap.put('NUM6_TEMP',   form.BorF+'NUM6_TEMP__c');
        bfVariableMap.put('NUM6_DBL_TEMP',   form.BorF+'NUM6_DBL_TEMP__c');
        bfVariableMap.put('UNK_CHECK_TEMP',   form.BorF+'UNK_CHECK_TEMP__c');
        bfVariableMap.put('UNK_CHECK2_TEMP',   form.BorF+'UNK_CHECK2_TEMP__c');
        bfVariableMap.put('CHECK1_TEMP',   form.BorF+'CHECK1_TEMP__c');
        bfVariableMap.put('CHECK2_TEMP',   form.BorF+'CHECK2_TEMP__c');
        bfVariableMap.put('CHECK3_TEMP',   form.BorF+'CHECK3_TEMP__c');
        bfVariableMap.put('CHECK4_TEMP',   form.BorF+'CHECK4_TEMP__c');
        bfVariableMap.put('CHECK5_TEMP',   form.BorF+'CHECK5_TEMP__c');
        bfVariableMap.put('CHECK6_TEMP',   form.BorF+'CHECK6_TEMP__c');

    }
    public list<SelectOption> getRadioTempItems() {
    
    
    List<SelectOption> options = new List<SelectOption>(); 
    
    options.add(new SelectOption('0','No')); 
    options.add(new SelectOption('1','Yes')); 
    options.add(new SelectOption('98','Other (this triggers skipLogic)')); 
    
    return options; 
        
    }
    
    //long options
    public List<SelectOption> getLongItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudant'));
        options.add(new SelectOption('1','Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies.'));
        options.add(new SelectOption('2','Li Europan lingues es membres del sam familie. Lor separat existentie es un myth. Por scientie, musica, sport etc, litot Europa usa li sam vocabular. Li lingues differe solmen in li grammatica, li pronunciation e li plu commun vocabules. Omnicos directe al desirabilite de un nov lingua franca: On.'));
        options.add(new SelectOption('3','The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz prog. Junk MTV quiz graced by fox whelps. Bawds jog, flick quartz, vex nymphs. Waltz, bad nymph, for quick jigs vex! Fox nymphs grab quick-jived waltz. Brick quiz whangs jumpy veldt fox. Bright vixens jump; dozy fowl quack. Quick wafting zephyrs vex bold Jim. Quick zephyrs blow, vexing daft Jim'));     
        options.add(new SelectOption('99','BlindTextGenerator.com '));
        
        return options; 
        
    } 

    public Integer countBlankAnswer() {
        
        Integer blankCount = 0; 
                
        return blankCount;
        
    }
    
    public Boolean showWarningMessageForBlank(Integer blankCount, String warningMessageContent) {
        
        if(blankCount >= 1 && displayWarningMessage == false) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, warningMessageContent));
            displayWarningMessage = true;
            return true;
        }
        
        return false;
    }
    
    /****
    * @description Assessment radio button options. 
    * @return List<SelectOption>
    */
    public List<SelectOption> getRadioItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','0 = None')); 
        options.add(new SelectOption('1','1 = Little')); 
        options.add(new SelectOption('2','2 = Some')); 
        options.add(new SelectOption('3','3 = Much')); 
        options.add(new SelectOption('4','4 = Most')); 
        
        return options; 
        
    }
    
    public PageReference saveview() {
        
        return (showWarningMessageForBlank(countBlankAnswer(), warningMessageContent)) ? null : save('/apex/DS_TEMP_Report?cimi=' + Apexpages.currentPage().getParameters().get('cimi'));    
        
    } 
    
    public override PageReference save() {
        
        PageReference nextPage;
        
        // If there is some blank answers and we need to display the warning message
        if(!showWarningMessageForBlank(countBlankAnswer(), warningMessageContent)) {
            
            if(form.saveObjRecord()) {
                nextPage = new PageReference(skip.formRedirct(form.cID, form.summary.SECTION__c, form.forceRedirect));
                nextPage.setRedirect(true);
            }
            else { nextPage = null; }
            
        }
        
        return nextPage;  
        
    }
}