/**
* The controller class for Young Child Indicators of Severity of Problems  - Children Under 6  
* 
**/

public with sharing class DS_YCINDSEV_Controller extends DS_BasicForm_Controller {
        
    public String developmentModuleStatus { get; set; }  
    
    public DS_YCINDSEV_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        // Set the skip object to form object
        form.setSkipLogic(skip);
        
        // Set the obj name 
        form.setObjName('DS_Functioning_Forms_'+form.BorF+'__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Serialize the skip library to JSON format
        skipElementToJson = JSON.serialize(form.skip.skipList); 
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('YCINDSEV');
        
        developmentModuleStatus = String.valueOf(form.obj.get(bfVariableMap.get('DEVEL')));
        
    }
    
    // Q1 Options
    public List<SelectOption> getNSVUItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No current self-injurious behaviors')); 
        options.add(new SelectOption('1','Mild risk of self-injury due to dysregulated behaviors (e.g., climbing high furniture, etc.) ')); 
        options.add(new SelectOption('2','Moderate problems with dangerous or self-injurious behaviors (e.g., running from caregivers, pulls own hair, head banging) ')); 
        options.add(new SelectOption('3','Severe problems with dangerous or self-injurious behaviors (e.g., child runs into street, tries to hang or injure self or talks about wanting to kill themselves even though their understanding of death is not complete) '));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    }
    
    // Q2 options
    public List<SelectOption> getNYUItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No evidence of regulatory problems ')); 
        options.add(new SelectOption('1','Mild problems with emotional regulation. Child may have difficulty in choosing or may require more structure and support than other children in coping with frustration and difficult emotions ')); 
        options.add(new SelectOption('2','Moderate problems with emotion regulation that may include: 1) difficulties with transitions; 2) severe irritability including extreme or prolonged tantrums; 3) low frustration tolerance; 4) age-inappropriate ability to delay gratification.  Problems interfere with child’s developmental functioning and may require consistent adult intervention ')); 
        options.add(new SelectOption('3','Profound problems with emotional regulation that place the child’s safety, well-being, and/or development at risk  '));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    }  
    
    // Q3 options
    public List<SelectOption> getFeedItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No evidence of any feeding problems ')); 
        options.add(new SelectOption('1','Child has minor feeding problems; however, problems have not interfered with the child’s functioning or the parent-child relationship ')); 
        options.add(new SelectOption('2','Child has moderate symptoms of feeding problems ')); 
        options.add(new SelectOption('3','Child’s feeding problems have become so significant that the child has had medical problems, or there is concern for future serious health problems associated with feeding issues'));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    }  
    
    // Q4 options
    public List<SelectOption> getSleepItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No evidence of sleep disturbance  ')); 
        options.add(new SelectOption('1','Mild sleep disruption, including occasional nightmares, or difficulty falling asleep (i.e.,  mild insomnia of up to 1 hour)')); 
        options.add(new SelectOption('2','Moderate sleep disturbance including frequent (i.e.,  at least once per week to nearly daily) resistance to going to bed, difficulty falling asleep, or nightmares. May include insomnia for up to 2 hours each night or frequent waking with difficulty falling back asleep.')); 
        options.add(new SelectOption('3','Severe sleep disturbance that could include daily sleep problems, difficulty falling asleep, or waking in the night. The child has less than 4 hours of sleep per night or has day/night reversal'));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    }    
    
    // Q5 options
    public List<SelectOption> getPlayItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','Child demonstrates age-appropriate play ')); 
        options.add(new SelectOption('1','Child demonstrates age-appropriate play most of the time or is responsive to adult prompts to play ')); 
        options.add(new SelectOption('2','Child demonstrates moderate problems with age-appropriate play (e.g., child shows little interest or enjoyment in playing with peers or adults, child does not explore toys for significant length of time)')); 
        options.add(new SelectOption('3','Child does not demonstrate age-appropriate play skills. Child does not often respond to or engage in play activities with adults or peers, s/he does not explore or use toys in a way that is appropriate for their age '));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    }  
    
    // Q6 options
    public List<SelectOption> getPreCareItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('97','Not applicable, child not in preschool or daycare')); 
        options.add(new SelectOption('0','No evidence of problems with functioning in current preschool or childcare environment')); 
        options.add(new SelectOption('1','Mild problems with functioning in current preschool or daycare environment ')); 
        options.add(new SelectOption('2','Moderate problems with functioning in current preschool or daycare environment. Child has difficulties with behavior in this setting, creating significant concerns or problems for others')); 
        options.add(new SelectOption('3','Profound problems with functioning in current preschool or daycare environment. Child has been removed or is at immediate risk of being removed from program due to behaviors or unmet needs  '));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    } 
    
    // Q7 options
    public List<SelectOption> getSocialItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No evidence of problems and/or child exhibits developmentally appropriate social functioning ')); 
        options.add(new SelectOption('1','Minor problems in social relationships. (i.e., infants may be slow to respond to or engage adults, toddlers may need support to interact positively with peers and toddlers, and preschoolers may be withdrawn or aggressive) ')); 
        options.add(new SelectOption('2','Moderate problems with social relationships. (i.e., infants and toddlers may be disengaged from adults or peers, hard to soothe, and/or show difficulty in focusing on toys in social situations.  Preschoolers may hit, bite, or have difficulty sharing and taking turns even when adults offer support)')); 
        options.add(new SelectOption('3','Severe disruptions in social relationships. (i.e., infants and toddlers show limited ability to signal needs or express pleasure.  Infants, toddlers, or preschoolers are consistently withdrawn and unresponsive to familiar adults.  Preschoolers show no joy or sustained interaction with peers or adults, and/or aggression, and/or may place themselves or others at risk) '));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    } 
    
    // Q8 options
    public List<SelectOption> getAggressiveItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No evidence of aggressive behaviors ')); 
        options.add(new SelectOption('1','Mild concerns but does not interfere with functioning; adults are able to manage challenging behaviors')); 
        options.add(new SelectOption('2','Clear evidence of aggressive behavior. Behavior is persistent, and caregiver’s attempts to change behavior have not been successful ')); 
        options.add(new SelectOption('3','Significant challenges with aggressive behaviors, characterized as dangerous and involves threat of harm to others or problems in more than one life domain that significantly threatens child’s growth and development  '));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    } 
    
    // Q9 options
    public List<SelectOption> getSexualizedItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No evidence of problems with sexualized talk or behavior ')); 
        options.add(new SelectOption('1','Some evidence of sexualized talk or behavior. Child may exhibit occasional inappropriate sexual language or behavior or engages in behaviors that mimic sexualized behaviors ')); 
        options.add(new SelectOption('2','Moderate problems with sexualized behavior. Child may exhibit more frequent masturbation than is age-appropriate, may frequently use sexualized language or say or do things related to sex that children his/her age do not usually know ')); 
        options.add(new SelectOption('3','Significant problems with sexualized behaviors. Child exhibits sexualized behaviors that indicates exposure to sexual activity or possible victimization and may try to touch other children'));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    } 
    
    // Q10 options
    public List<SelectOption> getAttachmentItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No evidence of attachment problems. Child appears able to respond to caregiver cues in a consistent, appropriate manner, and child seeks age-appropriate contact with caregiver for both nurturing and safety needs. Child experiences a sense of security and trust within his/her attachment relationships ')); 
        options.add(new SelectOption('1','Mild problems with attachment. Child may have difficulty accurately reading caregiver efforts to provide attention and nurturance; may be inconsistent in response; or may be occasionally needy. Child may have mild problems with separation (e.g., anxious/clingy behaviors in the absence of obvious cues of danger) or may avoid contact with caregiver in age-inappropriate way')); 
        options.add(new SelectOption('2','Moderate problems with attachment. Child may consistently misinterpret cues, act in an overly needy way, or ignore/avoid contact even when distressed. Child may have ongoing difficulties with separation or may consistently avoid contact with caregivers ')); 
        options.add(new SelectOption('3','Severe problems with attachment. Child is unable to form attachment relationships with others (e.g., chronic dismissive/avoidant/detached behavior in care-giving relationships) OR child presents with diffuse emotional/physical boundaries leading to indiscriminate friendliness with others. Child is considered at ongoing risk due to the nature of his/her attachment behaviors. A child who meets the criteria for an Attachment Disorder in DSM-5 would be rated here '));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    }
    
    // Q11 options
    public List<SelectOption> getDevItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','Child meets or exceeds all developmental milestones')); 
        options.add(new SelectOption('1','Child is close to meeting all developmental milestones'));    
        options.add(new SelectOption('2','Child has some problems with immaturity or delay in meeting developmental milestones. Problems occasionally interfere with child’s ability to function')); 
        options.add(new SelectOption('3','Significant difficulties or unevenness with development. Developmental delays significantly impair child’s functioning '));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    }
    
    // Q12 options
    public List<SelectOption> getAtypicalItems() {
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        options.add(new SelectOption('0','No evidence of atypical behaviors in the infant/child ')); 
        options.add(new SelectOption('1','Child engages in atypical behaviors at times ')); 
        options.add(new SelectOption('2','Clear evidence of atypical behaviors reported by caregivers that are observed on an ongoing basis ')); 
        options.add(new SelectOption('3','Clear evidence of atypical behaviors that are consistently present and interfere with the infant’s/child’s functioning on a regular basis '));    
        options.add(new SelectOption('99','Unknown/unable to rate '));
        
        return options; 
        
    }
            
}