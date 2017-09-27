/**
* @author Danny Fu
* @date 06/17/2016
* @modified date
*
* @group Trauma
* @group-content /ApexDocContent/Trauma/General_Trauma.htm
*
* @description An apex controller class for General Trauma Information Form.
* 
*/
public with sharing class DS_GTRAUMA_Controller extends DS_BasicForm_Controller {
        
    public List<Item> rows { get; set; }
    public List<String> ageTitle {  get; set; }
    public List<String> ageNum { get; set; } 
    
    public class Item {
        
        public String num { get; set; }
        public String trauma { get; set; }
        public String subtitle { get; set; }
        public String exp { get; set; }
        public List<String> ages { get; set; }
        
        public Item(String num, String trauma, String exp, List<String> ages, String subtitle) {
            this.num = num;
            this.trauma = trauma;
            this.exp = exp;
            this.ages = ages;
            this.subtitle = subtitle;
        }
        
    }
    
    public DS_GTRAUMA_Controller(ApexPages.StandardController controller) {
        
        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));
        
        ageNum = new List<String>{'0','1','2','3','4','5','6','7','8','9','10',
                                  '11','12','13','14','15','16','17','18'};
              
        rows = new List<Item>();
        
        ageTitle = new List<String>();
        
        for(Integer i = 0; i<19; i++)
            ageTitle.add(String.valueof(i));
        
        agetitle.add('Unknown'); 
        
        this.rowList();
        
        // Set the obj name 
        form.setObjName('DS_GTRAUMA__c');
        
        // Get the object record into form.obj
        form.getObjRecord();
        
        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('GTRAUMA');
        
    }
        
    public List<SelectOption> getTraumaType() {
        List<SelectOption> options = new List<SelectOption>();
        
       // options.add(new SelectOption('',''));
        options.add(new SelectOption('0','No'));
        options.add(new SelectOption('1','Yes'));
        options.add(new SelectOption('2','Suspected'));
        options.add(new SelectOption('99','Unknown'));
        return options;
    }
    
    public List<SelectOption> getPrimaryType() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--None--'));
        
        for(Item i : rows)
            options.add(new SelectOption(i.num,i.trauma));
        
        return options;
        
    }
    
    public void rowList() {
        
        List<DS_DATA__c> info = [SELECT Content__c, Note__c, Weight__c 
                                 FROM DS_DATA__c 
                                 WHERE Category__c = 'TD'
                                 AND Data_Type__c = 'DS_Form_Info' 
                                 ORDER BY weight__c];
        
        for(DS_DATA__c i : info) {
            
            String count = string.valueof(i.Weight__c);
            
            String subtitle = (i.Note__c == null) ? '' : '<small>' + i.Note__c + '</small>'; 
            
            String trauma = i.Content__c;
            
            List<String> ages = new List<String>();
            
            for(Integer j = 0; j<19; j++) 
                ages.add('GT'+count+'RA'+j+'__c');
            
            ages.add('GT'+count+'RAU__c');
            
            rows.add(new Item(count, trauma, 'GT'+count+'R', ages, subtitle));
            
        }
        
    }    
    
    public override PageReference save() {
        
        PageReference nextPage;
        
        if(form.saveObjRecord()) {
            nextPage = new PageReference(skip.formRedirct(form.cID, form.summary.SECTION__c, '1'));
            nextPage.setRedirect(true);
        }
        else { nextPage = null; }
        
        return nextPage;
        
    }
    
}