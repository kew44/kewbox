/**
* @author Danny Fu
* @date 06/29/2016
*
* @group Trauma
* @group-content /ApexDocContent/Trauma/Trauma_detail_element_base.htm
*
* @description An apex base class for trauma detail element.
* 
* @modified DF 03/30/2017 Update the other textfield.
*
*/

public with sharing virtual class DS_TDETAIL_Element_Base implements DS_TDETAIL_Interface.Element {
        
    public ApexPages.Component block;
    
    public String num, question, skip, TDForm, Qtype;
    public Integer version;
    
    public Form form;
    
    public enum ENUMSKIP { NOLOGIC, HASLOGIC, ISELEMENT, NOTELEMENT, PULLLEFT, NOPULLLEFT }
    
    public List<Option> BasicOptions;
    
    public class Option {
        
        public String index { get; set; }
        public String value { get; set; }
        
        public Option (String index, String value) {
            this.index = index;
            this.value = value;
        }
        
    }
    
    public virtual void init(ApexPages.Component component, String num, String question, 
                             String skip, String TDForm, String Qtype, Integer version, Form form) {
                                 
        this.block = component;
        this.num = num;
        this.question = question;
        this.skip = skip;
        this.TDForm = TDForm;   
        this.version = version;
        this.Qtype = Qtype;
        this.form = form;
        
        this.BasicOptions = new List<Option>{
            new Option('',''),
            new Option('0','No'),
            new Option('1','Yes'),
            new Option('99','Unknown')}; 
    }
    
    public virtual void header() {
        defaultHeader(block, Num, question, skip);
    }
    
    public virtual void footer() {
        defaultFooter(block);
    }
    
    public virtual void body() {
        comSelectList(block, Qtype, BasicOptions, ENUMSKIP.NOLOGIC);
    }
    
    public virtual void build() {
        header();
        body();
        footer();
    }
    
    public void contentGenerator(ApexPages.Component component, String text) {
        
        Component.Apex.OutputText outputText = new Component.Apex.OutputText();
        
        outputText.escape = false;
        outputText.value = text;
        
        component.childComponents.add(outputText);
        
    }
    
    public void contentGenerator(ApexPages.Component parent, ApexPages.Component child) {
        parent.childComponents.add(child);
    }
    
    public void defaultHeader(ApexPages.Component component, String Num, String question, String skip) {
        
        String content = '';
        
        skip = (skip != '') ? 'skip-' + skip : null;
        
        Num = (Num != '') ? Num + '.' : '';
        
        content += '<div class="form-group '+skip+'">'; 
        content += '    <label class="control-label col-md-6 col-lg-6">';
        content += '        <span class="nmbr">'+Num+'</span>'+question;
        content += '    </label>';
        content += '    <div class="col-md-4 col-lg-4">';
        
        contentGenerator(component, content);
    }
    
    public void defaultFooter(ApexPages.Component component) {
        contentGenerator(component, '</div></div>');
    }    
    
    public void comSelectList(ApexPages.Component block, String Field, List<Option> options, ENUMSKIP skip) {
        
        Component.Apex.selectList selectGroup = new Component.Apex.selectList();
        
        String fieldName = (Field == 'STATUS') ? Field : TDForm+Field;
        
        selectGroup.id = fieldName+'__c';
        selectGroup.size = 1;
        selectGroup.styleClass = 'form-control input-sm';
        selectGroup.expressions.value = '{!form.obj[bfVariableMap[\''+fieldName+'\']]}';
        
        if(skip == ENUMSKIP.HASLOGIC)
            selectGroup.onChange = 'skipLogic(\''+fieldName+'\',this.value)';
        
        for(Option op : options) {
            Component.Apex.selectOption so = new Component.Apex.selectOption();
            so.itemValue = op.index;
            so.itemLabel = op.value;
            
            selectGroup.childComponents.add(so); 
        }
        
        contentGenerator(block, selectGroup);
                
    }
    
    public void comCheckBox(ApexPages.Component component, List<Option> options, String skipField, ENUMSKIP skipElement, ENUMSKIP pullLeft){
        
        for(Option op : options) {
            
            String labelPullLeft = (pullLeft == ENUMSKIP.PULLLEFT && op.Value == skipField) ? 
                                   ' class="pull-left"' : null;
                        
            contentGenerator(component, '<div class="checkbox"><label '+labelPullLeft+'>');
            
            Component.Apex.InputField input = new Component.Apex.InputField();
            input.expressions.value = '{!form.obj[bfVariableMap[\''+TDForm+op.Value+'\']]}';
            input.id = TDForm+op.Value+'__c';
            
            // Add skip-element class if the option is a skiplogic element. 
            if(skipElement == ENUMSKIP.ISELEMENT)
                input.styleClass = 'skip-element-'+TDForm+op.Value;
            
            if(op.Value == skipField)
                input.onChange = 'skipLogic(\''+TDForm+op.Value+'\',this.checked)';
            
            contentGenerator(component, input);
            
            contentGenerator(component, op.index);
                        
            // If the checkbox has skiplogic element, don't add close div.            
            contentGenerator(component, (op.Value == skipField) ? '</label>' : '</label></div>');
                        
        }
        
    }
    
    public void comAssociateInputField (ApexPages.Component block, String Field, String Content) {
                
        contentGenerator(block, '<div class="skip-'+TDForm+Field+'">');
        
        Component.Apex.outputLabel label = new Component.Apex.outputLabel();
        
        label.value = Content;
        label.for = TDForm+Field+'__c';
        label.escape = false;
        label.styleClass = 'pull-left no-padding-left';
        
        contentGenerator(block, label);
        
        contentGenerator(block,'<div style="display: inline-block;">');
        
        Component.Apex.InputField RODT = new Component.Apex.InputField();
        RODT.expressions.value = '{!form.obj[bfVariableMap[\''+TDForm+Field+'\']]}';
        RODT.id = TDForm+Field+'__c';
        RODT.styleClass = 'form-control auto-width input-sm skip-element-'+TDForm+Field;
        RODT.style = 'height: 20px;';
                
        contentGenerator(block, RODT);
                
        contentGenerator(block,'</div></div></div>');
                
    }
    
    public void comMatrixCheckbox(ApexPages.Component block, String Content, String Num, List<List<Option>> matrix) {
        
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
                        '<td style="vertical-align:middle" class="td-'+fieldName+'"><label class="pull-left">'+fieldTitle+'</label>' :
                    '<td class="text-center td-option" data-row="'+matrix.get(i).get(0).value+'" style="vertical-align:middle">'+fieldTitle;
                    
                    block.childcomponents.add(contentTDHead);
                    
                    Component.Apex.inputCheckbox  input = new Component.Apex.inputCheckbox();
                    input.expressions.value = '{!form.obj[bfVariableMap[\''+TDForm+fieldName+'\']]}';
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
        
        contentGenerator(block, '</table>');
                
        Component.Apex.InputField otherField = new Component.Apex.InputField();
        otherField.expressions.value = '{!form.obj[bfVariableMap[\''+TDForm+'RDOSP\']]}';
        otherField.id = 'matrix_other';
        otherField.styleClass = 'form-control auto-width input-sm matrix-other';
                
        contentGenerator(block, otherField);
        
        String script = '';
        
        script += '<script>';
        script += '    $j(document).ready(function(){';
        script += '        $j(".matrix-option").change(function(){';
        script += '            var isChecked = false;'; 
        script += '            var rowName = $j(this).parent("td").attr("data-row");';
        script += '            $j(".option-"+rowName).each(function() { ';
        script += '                if($j(this).is(":checked")) isChecked = true; });';
        script += '            $j("."+rowName).prop("checked", isChecked);';
        script += '         });';
        script += '         $j(".td-RDO").append($j(".matrix-other"));';
        script += '     });';
        script += '</script>';
        
        contentGenerator(block, script);
        
    }
    
}