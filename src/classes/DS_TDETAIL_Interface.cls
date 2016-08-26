/**
* @author Danny Fu
* @date 06/29/2016
*
* @group Trauma
* @group-content /ApexDocContent/Trauma/Trauma_detail_interface.htm
*
* @description An apex interface class for trauma detail element.
* 
*/

public class DS_TDETAIL_Interface {

    public interface Element {
        
        void init(ApexPages.Component component, String num, String question, 
                  String skip, String TDForm, String Qtype, Integer version, Form form);
        void body();
        void build();
        
    }
    
    public class RBASE extends DS_TDETAIL_Element_Base implements Element {
    
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Baseline','RRB'),
                                     new Option('Other','RRO')};
              
            comCheckBox(this.block, options, 'RRO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
              
            comAssociateInputField(this.block, 'RRODT', ', please provide date &nbsp;');
            
        }
        
    }
    
    public class RBEN extends DS_TDETAIL_Element_Base implements Element  {
    
        public override void body() {
            
            List<Option> options = new List<Option>{
                    new Option('Child is acting on their own (sole practitioner)','RBENC'), 
                    new Option('Parent','RBENP'),
                    new Option('Other adult relative','RBENAR'),
                    new Option('Unrelated (but identifiable) adult','RBENUA'),
                    new Option('Sibling','RBENSB'),
                    new Option('Other youth','RBENOY'),
                    new Option('Stranger','RBENST'),
                    new Option('Unknown','RBENU')};
                            
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
    
    }
    
    public class RCG extends DS_TDETAIL_Element_Base implements Element  {
    
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Parent','RCGP'),
                                     new Option('Other adult relative','RCGAR'),
                                     new Option('Unrelated (but identifiable) adult','RCGUA'),
                                     new Option('Sibling','RCGSB'),
                                     new Option('Other youth','RCGOY'),
                                     new Option('Stranger (to the child)', 'RCGST'),
                                     new Option('Other','RCGO')};
                            
            comCheckBox(block, options, 'RCGO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
            comAssociateInputField(block, 'RCGOSP', ', please specify: &nbsp;');
                
            options = new List<option>{new Option('Unknown', 'RCGUK')};
                        
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }
    
    public class RCMP extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            comSelectList(block, 'RCMP', BasicOptions, ENUMSKIP.HASLOGIC);
                
            defaultFooter(block);
            
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
                        
            defaultHeader(block, '', 'Please indicate type of compensation. <strong>(Select all that apply.)</strong>', TDForm+'RCMPM');
            
            comCheckBox(block, options, 'RCMPO', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);            
            
            comAssociateInputField(block, 'RCMPOS', ', please specify: &nbsp;');
            
        }
        
    }

    public class RCP extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            //Checkbox 'Parent/Caregiver was removed from the home'
            List<Option> options = 
                new List<Option>{new Option('Parent/Caregiver was removed from the home','RCP')};
                    
                    comCheckBox(block, options, 'RCP', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
            String header = '';
            
            header += '<div class="form-group skip-'+TDForm+'RCPD no-border-bottom no-space-bottom">'; 
            header += '    <label class="control-label col-md-12 col-lg-12">';
            header += '        <strong>Please describe the reason:</strong>';
            header += '    </label>';
            header += '    <div class="col-md-12 col-lg-12" style="margin-left: 10px;">';
            
            contentGenerator(block, header);
            
            options = 
                new List<Option>{
                    new Option('Divorce', 'RCPD'),
                        new Option('Court mandated separation', 'RCPCM'),
                        new Option('Incarceration', 'RCPIN'),
                        new Option('Hospitalization (medical or psychiatric) ', 'RCPHP'),
                        new Option('Work','RCPW'),
                        new Option('Military assignment/deployment','RCPM'),
                        new Option('Training/education','RCPT'),
                        new Option('Other','RCPO')};
                            
            comCheckBox(block, options, 'RCPO', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);
            
            comAssociateInputField(block, 'RCPOS', ', please specify: &nbsp;'); 
            
            options = new List<Option>{new Option('Unknown','RCPUK')};
                
                comCheckBox(block, options, '', ENUMSKIP.ISELEMENT, ENUMSKIP.NOPULLLEFT);
            
            defaultFooter(block);
            
            contentGenerator(block, '</div>');
            
            //Checkbox 'Child was removed from the home'
            options = 
                new List<Option>{new Option('Child was removed from the home','RCC')};
                    
                    comCheckBox(block, options, 'RCC', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);   
            
            header =  '<div class="form-group skip-'+TDForm+'RCCFC no-border-bottom no-space-bottom">';  
            header += '    <label class="control-label col-md-12 col-lg-12">';
            header += '        <strong>Please describe the reason:</strong>';
            header += '    </label>';
            header += '    <div class="col-md-12 col-lg-12" style="margin-left: 10px;">';
            
            contentGenerator(block, header);
            
            options = 
                new List<Option>{
                    new Option('Placement in foster care (i.e., child protection services involvement)', 'RCCFC'),
                        new Option('Placement in residential setting/group home', 'RCCRS'),
                        new Option('Court mandated separation/changes in custody (not including divorce)', 'RCCCM'),
                        new Option('Incarceration', 'RCCIN'),
                        new Option('Hospitalization (medical or psychiatric)', 'RCCHP'),
                        new Option('Other', 'RCCO')};
                            
                            comCheckBox(block, options, 'RCCO', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);
            
            comAssociateInputField(block, 'RCCOS', ', please specify: &nbsp;');
            
            options = new List<Option>{new Option('Unknown','RCCUK')};
                
                comCheckBox(block, options, '', ENUMSKIP.ISELEMENT, ENUMSKIP.NOPULLLEFT);
            defaultFooter(block);
            
            // Checkbox 'Other'
            options = new List<Option>{new Option('Other','RCO')};
                
                comCheckBox(block, options, 'RCO', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);
            
            comAssociateInputField(block, 'RCOS', ', please specify: &nbsp;');
            
            // Checkbox 'Unknown'
            options = new List<Option>{new Option('Unknown','RCUK')};
                
                comCheckBox(block, options, '', ENUMSKIP.ISELEMENT, ENUMSKIP.NOPULLLEFT);
            
            contentGenerator(block, '</div>');
            
        }
        
    }

    public class RD extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void header() {
            
            String header = '';
            
            header += '<div class="form-group">'; 
            header += '    <label class="control-label col-md-12 col-lg-12">';
            header += '        <span class="nmbr">'+Num+'.</span>'+question;
            header += '    </label>';
            header += '    <div class="col-md-12 col-lg-12">';
            header += '        <table class="table table-bordered table-hover table-condensed">';
            
            contentGenerator(block, header);
          
        }
        
        public override void body() {
            
            List<List<Option>> matrix = new List<List<Option>> { 
                
                // Row 0 - Title
                new List<Option> { 
                    new Option('Cause of Death', null),       new Option('Parent', null),
                    new Option('Grandparent', null),          new Option('Sibling', null),
                    new Option('Other Relative', null), new Option('Unrelated Adult', null),
                    new Option('Unrelated Youth', null)}, 
                        
                // Row 1 - Natural Death
                new List<Option> { 
                    new Option('Natural Death due to a chronic condition/prolonged illness (e.g., cancer)', 'RDN'), 
                    new Option('', 'RDNP'),  new Option('', 'RDNG'),
                    new Option('', 'RDNSB'), new Option('', 'RDNOA'), 
                    new Option('', 'RDNUA'), new Option('', 'RDNOY')}, 
                        
                // Row 2 - Sudden Natural Death        
                new List<Option> { 
                    new Option('Sudden Natural Death due to illness (e.g., heart attack, stroke, organ failure)', 'RDI'), 
                    new Option('', 'RDIP'),  new Option('', 'RDIG'),
                    new Option('', 'RDISB'), new Option('', 'RDIOA'), 
                    new Option('', 'RDIUA'), new Option('', 'RDIOY')}, 
                        
                // Row 3 - Murder/ Homicide         
                new List<Option> { 
                    new Option('Murder/Homicide', 'RDM'), 
                    new Option('', 'RDMP'),  new Option('', 'RDMG'),
                    new Option('', 'RDMSB'), new Option('', 'RDMOA'), 
                    new Option('', 'RDMUA'), new Option('', 'RDMOY')}, 
                        
                // Row 4 - Murder/Homicide        
                new List<Option> {  
                    new Option('Violence (e.g., gang violence, school shooting)', 'RDV'), 
                    new Option('', 'RDVP'),  new Option('', 'RDVG'),
                    new Option('', 'RDVSB'), new Option('', 'RDVOA'), 
                    new Option('', 'RDVUA'), new Option('', 'RDVOY')}, 
                        
                // Row 5 - Accident        
                new List<Option> {  
                    new Option('Accident (e.g., motor vehicle accident)', 'RDA'), 
                    new Option('', 'RDAP'),  new Option('', 'RDAG'),
                    new Option('', 'RDASB'), new Option('', 'RDAOA'), 
                    new Option('', 'RDAUA'), new Option('', 'RDAOY')}, 
                     
                // Row 6 - Suicide        
                new List<Option> {  
                    new Option('Suicide', 'RDS'), 
                    new Option('', 'RDSP'),  new Option('', 'RDSG'),
                    new Option('', 'RDSSB'), new Option('', 'RDSOA'), 
                    new Option('', 'RDSUA'), new Option('', 'RDSOY')}, 
                        
                // Row 7 - Natural Disaster        
                new List<Option> { 
                    new Option('Natural Disaster (e.g., tornado)', 'RDD'), 
                    new Option('', 'RDDP'),  new Option('', 'RDDG'),
                    new Option('', 'RDDSB'), new Option('', 'RDDOA'), 
                    new Option('', 'RDDUA'), new Option('', 'RDDOY')}, 
                        
                // Row 8 - Terrorism/Political Violence/Civilian Casualty of War        
                new List<Option> { 
                    new Option('Terrorism/Political Violence/Civilian Casualty of War', 'RDT'), 
                    new Option('', 'RDTP'),  new Option('', 'RDTG'),
                    new Option('', 'RDTSB'), new Option('', 'RDTOA'), 
                    new Option('', 'RDTUA'), new Option('', 'RDTOY')}, 
                        
                // Row 9 - War        
                new List<Option> {  
                    new Option('War', 'RDW'), 
                    new Option('', 'RDWP'),  new Option('', 'RDWG'),
                    new Option('', 'RDWSB'), new Option('', 'RDWOA'), 
                    new Option('', 'RDWUA'), new Option('', 'RDWOY')}, 
                        
                // Row 10 - Other        
                new List<Option> {  
                    new Option('Other, please specify: ', 'RDO'), 
                    new Option('', 'RDOP'),  new Option('', 'RDOG'),
                    new Option('', 'RDOSB'), new Option('', 'RDOOA'), 
                    new Option('', 'RDOUA'), new Option('', 'RDOOY')}, 
                        
                // Row 11 - Unknown        
                new List<Option> { 
                    new Option('Unknown', 'RDU'), 
                    new Option('', 'RDUP'),  new Option('', 'RDUG'),
                    new Option('', 'RDUSB'), new Option('', 'RDUOA'), 
                    new Option('', 'RDUUA'), new Option('', 'RDUOY')} 
                
              };
        
              comMatrixCheckbox(block, question, Num, matrix);
            
        }
        
    }

    public class RDIS extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            comSelectList(block, 'RDIS', BasicOptions, ENUMSKIP.HASLOGIC);
                
            defaultFooter(block);
                
            defaultHeader(block, '', 'On whom? <b>(Select all that apply.)</b>', TDForm+'RDISC');
            
            List<Option> options = 
                new List<Option>{new Option('Child','RDISC'), 
                    new Option('Parent','RDISP'),
                    new Option('Other adult relative','RDISOR'),
                    new Option('Unrelated (but identifiable) adult','RDISUA'),
                    new Option('Sibling','RDISSB'),
                    new Option('Other youth','RDISOY'),
                    new Option('Other','RDISO')};
                        
            comCheckBox(block, options, 'RDISO', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);
            
            comAssociateInputField(block, 'RDISOS', ', please specify: &nbsp;');   
            
        }
        
    }

    public class RDU extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('0-3 months','RDU3'),
                                     new Option('3-6 months','RDU6'),
                                     new Option('6-9 months','RDU9'),
                                     new Option('9-12 months','RDU12'),
                                     new Option('1-2 years','RDU24'),
                                     new Option('Greater than 2 years','RDU2Y'),
                                     new Option('Unknown','RDUUK')};
                            
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RDV extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Physical violence','RDVPV'),
                                     new Option('Sexual violence','RDVSV'),
                                     new Option('Threats of physical or sexual violence','RDVTFS'),
                                     new Option('Psychological or emotional violence ','RDVPEV'),
                                     new Option('Unknown','RDVUK')};
                            
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RFREQ extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{ new Option('',''),
                                      new Option('1','One-time event'),
                                      new Option('2','Repeated exposure'),
                                      new Option('99','Unknown') };
                          
            comSelectList(block, 'RFREQ', options, ENUMSKIP.NOLOGIC);
            
        }
        
    }

    public class RFTB extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Physical bullying (e.g., hitting, spitting, tripping)','RFPHSB'),
                                     new Option('Sexual bullying (e.g., comments or gestures focusing on a person’s body parts or sexual orientation)', 'RFSEXB'),
                                     new Option('Verbal bullying (e.g., name calling, insults, teasing)','RFVERB'),
                                     new Option('Social bullying (e.g., rumors, mimicking, damaging social reputation, isolation/exclusion)','RFSOCB'),
                                     new Option('Other','RFOTR')};
                            
            comCheckBox(block, options, 'RFOTR', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
            comAssociateInputField(block, 'RFOSP', ', please specify: &nbsp;');
            
        }
        
    }

    public class RILL extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Child','RILLC'),
                                     new Option('Parent','RILLP'),
                                     new Option('Other adult relative','RILLAR'),
                                     new Option('Unrelated (but identifiable) adult','RILLUA'),
                                     new Option('Sibling','RILLSB'),
                                     new Option('Other youth','RILLOY'),
                                     new Option('Other','RILLO')};
                            
            comCheckBox(block, options, 'RILLO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
            comAssociateInputField(block, 'RILLOSP', ', please specify: &nbsp;');
            
        }
        
    }

    public class RIMP extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Drug use/abuse/addiction','RIMPDG'),
                                     new Option('Caregiver mental health impairment/disorder','RIMPDP'),
                                     new Option('Caregiver medical illness','RIMPIL'),
                                     new Option('Other','RIMPO')};
                            
            comCheckBox(block, options, 'RIMPO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                
            comAssociateInputField(block, 'RIMPOSP', ', please specify: &nbsp;');
                
            options = new List<option>{new Option('Unknown', 'RIMPUK')};
                        
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RIN extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{ new Option('Pornography (print, Internet, television, etc.)','RINPRN'),
                                      new Option('Forced witnessing of adult sexual activity','RINFWIT'),
                                      new Option('Orchestration of sexual contact with one or more minor children','RINMINR'),
                                      new Option('Other','RINO') };
                            
            comCheckBox(block, options, 'RINO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                
            comAssociateInputField(block, 'RINOSP', ', please specify: &nbsp;');
            
        }
        
    }

    public class RINC extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('A request for ransom','RINCR'),
                                     new Option('A child custody dispute','RINCC'),
                                     new Option('Arrest/imprisonment of the perpetrator','RINCA'),
                                     new Option('Captor-child bonding (Stockholm Syndrome)','RINCB'),
                                     new Option('Rape/sexual assaults/trafficking','RINCS'),
                                     new Option('Other','RINCO')};
                            
            comCheckBox(block, options, 'RINCO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
            comAssociateInputField(block, 'RINCOS', ', please specify: &nbsp;');
            
        }
        
    }

    public class RINJ extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            if(version == 1) {
            
                comSelectList(block, 'RINJ', this.BasicOptions, ENUMSKIP.HASLOGIC);
                    
                defaultFooter(block);
                
                defaultHeader(block, '', 'On whom? <strong>(Select all that apply.)</strong>', TDForm+'RINJC');
                
                List<Option> options = 
                    new List<Option>{new Option('Child','RINJC'), 
                        new Option('Parent','RINJP'),
                        new Option('Other adult relative','RINJAR'),
                        new Option('Unrelated (but identifiable adult)','RINJUA'),
                        new Option('Sibling','RINJSB'),
                        new Option('Other youth','RINJOY'),
                        new Option('Other','RINJO')};
                            
                            
                comCheckBox(block, options, 'RINJO', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);
                
                comAssociateInputField(block, 'RINJOS', ', please specify: &nbsp;');
                
            }
            else if(version == 2) {
                                
                comSelectList(block, 'RINJ', BasicOptions, ENUMSKIP.HASLOGIC);
                
                defaultFooter(block);
                
                List<Option> options = 
                    new List<Option>{new Option('Child','RINJC'), 
                                     new Option('Teacher/Staff','RINJT'),
                                     new Option('Sibling','RINJSB'),
                                     new Option('Other youth','RINJOY'),
                                     new Option('Other','RINJO')};
                                        
                defaultHeader(block, '', 'On whom? <b>(Select all that apply.)</b>', TDForm+'RINJC');
                
                comCheckBox(block, options, 'RINJO', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);
                
                comAssociateInputField(block, 'RINJOS', ', please specify: &nbsp;');
                
            }
            
            else if(version == 3) {
                                
                List<Option> options = 
                    new List<Option>{new Option('Concussion','RINJCC'),
                                     new Option('Animal bite','RINJAB'),
                                     new Option('Broken bone(s)','RINJBB'),
                                     new Option('Burn','RINJBN'),
                                     new Option('Other','RINJO')};
                            
                comCheckBox(block, options, 'RINJO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
                comAssociateInputField(block, 'RINJOS', ', please specify: &nbsp;');
                
                options = new List<option>{new Option('Unknown', 'RINJUK')};
                    
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
                
            }
            
            else if(version == 4) {
                                    
                comSelectList(block, 'RINJ', BasicOptions, ENUMSKIP.HASLOGIC);
                
                defaultFooter(block);
                
                List<Option> options = 
                    new List<Option>{new Option('Child','RINJC'), 
                                     new Option('Parent','RINJP'),
                                     new Option('Other adult relative','RINJAR'),
                                     new Option('Unrelated (but identifiable) adult','RINJUA'),
                                     new Option('Sibling','RINJSB'),
                                     new Option('Other youth','RINJOY'),
                                     new Option('Other','RINJO')};
                                        
                defaultHeader(block, '', 'On whom? <b>(Select all that apply.)</b>', TDForm+'RINJC');
                
                comCheckBox(block, options, 'RINJO', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);
                
                comAssociateInputField(block, 'RINJOS', ', please specify: &nbsp;');
            
            }
            
        }
        
    }

    public class RMED extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            //Checkbox 'Face-to-face'
            List<Option> options = 
                new List<Option>{new Option('Face-to-face','RMFCE')};
                    
                    comCheckBox(block, options, 'RMFCE', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
            String header = '';
            
            header += '<div class="form-group skip-'+TDForm+'RMFHO no-border-bottom no-space-bottom">'; 
            header += '    <label class="control-label col-md-12 col-lg-12">';
            header += '        <strong>Where did the bullying take place? (Select all that apply.)</strong>';
            header += '    </label>';
            header += '    <div class="col-md-12 col-lg-12" style="margin-left: 10px;">';
            
            contentGenerator(block, header);
            
            options = 
                new List<Option>{
                    new Option('Home', 'RMFHO'),
                        new Option('School', 'RMFSC'),
                        new Option('Community', 'RMFCO'), 
                        new Option('Other', 'RMFOT')};
                            
            comCheckBox(block, options, 'RMFOT', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);
            
            comAssociateInputField(block, 'RMFOSP', ', please specify: &nbsp;'); 
            
            defaultFooter(block);
            
            contentGenerator(block, '</div>');
            
            //Checkbox 'Cyberbullying'
            options = 
                new List<Option>{new Option('Cyberbullying','RMCYB')};
                    
                    comCheckBox(block, options, 'RMCYB', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);   
            
            header =  '<div class="form-group skip-'+TDForm+'RMCSO no-border-bottom no-space-bottom">';  
            header += '    <label class="control-label col-md-12 col-lg-12">';
            header += '        <strong>How did the bullying take place? (Select all that apply.)</strong>';
            header += '    </label>';
            header += '    <div class="col-md-12 col-lg-12" style="margin-left: 10px;">';
            
            contentGenerator(block, header);
            
            options = 
                new List<Option>{
                    new Option('Social networking sites', 'RMCSO'),
                        new Option('Text messages', 'RMCTX'),
                        new Option('Instant messages', 'RMCIM'),
                        new Option('Email', 'RMCEM'),
                        new Option('Website/blog postings', 'RMCWB'),
                        new Option('Other', 'RMCOT')};
                            
                            comCheckBox(block, options, 'RMCOT', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);
            
            comAssociateInputField(block, 'RMCOSP', ', please specify: &nbsp;');
            
            defaultFooter(block);
            
            // Checkbox 'Other'
            options = new List<Option>{new Option('Other','RMOTR')};
                
            comCheckBox(block, options, 'RMOTR', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
            
            comAssociateInputField(block, 'RMOSP', ', please specify: &nbsp;');
            
            // Checkbox 'Unknown'
            options = new List<Option>{new Option('Unknown','RMUK')};
                
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
            contentGenerator(block, '</div>'); 
            
        }
        
    }

    public class RMEN extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = new List<Option>{
                    new Option('Online/pornographic websites (sharing or posting of images, engaging in sex acts, forums)','RMENOL'),
                    new Option('Escort services','RMENE'),
                    new Option('Street prostitution','RMENS'),
                    new Option('Brothels/massage parlors/ strip clubs/ truck stops','RMENB'),
                    new Option('Forced labor/domestic servitude','RMENF'),    
                    new Option('Other', 'RMENO')};
                            
            comCheckBox(block, options, 'RMENO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
            
            comAssociateInputField(block, 'RMENOS', ', please specify: &nbsp;');
            
            options = new List<Option>{new Option('Unknown','RMENU')}; 
                
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RMTYP extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                      new List<Option>{new Option('Emotional neglect (denial of proper care and attention, failure to respond)','RMTYPEN'),
                                       new Option('Verbal abuse (e.g., belittling, rejecting, cruel teasing)','RMTYPVA'),
                                       new Option('Excessive demands (unreasonable or impossible demands)','RMTYPED'),
                                       new Option('Other','RMTYPOTH')};
        
            comCheckBox(block, options, 'RMTYPOTH', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
            
            comAssociateInputField(block, 'RMTYPOS', ', please specify: &nbsp;');
            
            options = new List<Option>{new Option('Unknown','RMTYPU')}; 
                
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RNTYPES extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Physical (inadequate nutrition, hygiene, shelter, clothing)','RTYPPH'),
                                     new Option('Medical/dental','RTYPMD'),
                                     new Option('Educational','RTYPED'),
                                     new Option('Inadequate supervision','RTYPIS'),
                                     new Option('Exposure to violent environments (caregiver intentionally fails to protect child)','RTYPVE'),
                                     new Option('Other','RTYPOTH')};
                            
            comCheckBox(block, options, 'RTYPOTH', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                
            comAssociateInputField(block, 'RTYPOS', ', please specify: &nbsp;');
            
            options = new List<Option>{new Option('Unknown','RTYPUK')};
                
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RPER extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            if(version == 1) {
                List<Option> options = 
                        new List<Option>{new Option('Parent','RPERP'), 
                                         new Option('Other adult relative','RPERAR'),
                                         new Option('Unrelated (but identifiable) adult','RPERUA'),
                                         new Option('Sibling','RPERSB'),
                                         new Option('Other youth','RPEROY'),
                                         new Option('Stranger','RPERST'),
                                         new Option('Unknown','RPERU')};
                                
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            }
            else if(version == 2) {
                                
                List<Option> options = new List<Option>{
                    new Option('Other adult relative','RPERAR'),
                    new Option('Unrelated (but identifiable) adult','RPERUA'),
                    new Option('Other youth','RPEROY'),
                    new Option('Stranger','RPERST'),
                    new Option('Other','RPERO')};
                            
                comCheckBox(block, options, 'RPERO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
                comAssociateInputField(block, 'RPEROS', ', please specify: &nbsp;');
                
                options = new List<Option>{new Option('Unknown','RPERU')}; 
                  
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
                
            }
            
            else if(version == 3) {
                                
                List<Option> options = 
                    new List<Option>{new Option('Classmate','RPERCM'),
                                     new Option('Other youth','RPEROY'),
                                     new Option('Teacher','RPERTH'),
                                     new Option('Other school staff','RPEROS'),
                                     new Option('Other adult outside of school','RPEROA'),
                                     new Option('Other','RPEROT')};
                            
                comCheckBox(block, options, 'RPEROT', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
                comAssociateInputField(block, 'RPEROSP', ', please specify: &nbsp;');
                
            }
            
            else if(version == 4) {
                                    
                List<Option> options = 
                    new List<Option>{new Option('Parent (non-caregiver)','RPERP'), 
                                     new Option('Other adult relative','RPERAR'),
                                     new Option('Unrelated (but identifiable) adult','RPERUA'),
                                     new Option('Sibling','RPERSB'),
                                     new Option('Other youth','RPEROY'),
                                     new Option('Stranger','RPERST'),
                                     new Option('Unknown','RPERU')};
                            
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
                            
            
            }
        }
        
    }

    public class RPR extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            if(version == 1) {
                List<Option> options = 
                        new List<Option>{new Option('Parent','RPRP'),
                                         new Option('Grandparent','RPRGR'),
                                         new Option('Other relative','RPRAR'),
                                         new Option('Sibling','RPRSB'),
                                         new Option('Unrelated adult (known to the child) ','RPRUA'),
                                         new Option('Unrelated youth','RPROY')};
                                             
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            }
            else if(version == 2) {
                                            
                List<Option> options = 
                    new List<Option>{new Option('Parent','RPRP'),
                                     new Option('Other adult relative','RPRAR'),
                                     new Option('Unrelated adult (known to the child) ','RPRUA'),
                                     new Option('Sibling','RPRSB'),
                                     new Option('Other youth (known to the child)','RPROY'),
                                     new Option('Unknown','RPRUK')};
                                         
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
                
            }
            
        }
        
    }

    public class RRE extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Violence, conflict, war','RREVI'),
                                     new Option('Natural or manmade disasters','RREND'),
                                     new Option('Ethnic cleansing','RREEC'),
                                     new Option('Fleeing persecution (for political, social, ethnic, or religious reasons)','RREFP'),
                                     new Option('Other','RREO')};
                            
            comCheckBox(block, options, 'RREO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
            comAssociateInputField(block, 'RREOS', ', please specify: &nbsp;');
            
        }
        
    }

    public class RRES extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            comSelectList(block, 'RRES', BasicOptions, ENUMSKIP.HASLOGIC);
                
            defaultFooter(block);
                
            List<Option> options = 
                new List<Option>{new Option('Race/Ethnicity','RRESRC'), 
                    new Option('Religion','RRESRE'),
                    new Option('Sexual Orientation','RRESSO'),
                    new Option('Disability','RRESDB'),
                    new Option('Weight','RRESWT'),
                    new Option('Socio-economic status','RRESEC'),
                    new Option('Other','RRESO')};
                        
            defaultHeader(block, '', 'What was the reason for targeting? <b>(Select all that apply.)</b>', TDForm+'RRESRC');
            
            comCheckBox(block, options, 'RRESO', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);
            
            comAssociateInputField(block, 'RRESOS', ', please specify: &nbsp;');
            
        }
        
    }

    public class RRESIB extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('',''),
                                     new Option('0','No'),
                                     new Option('1','Yes, for some of the separations'),
                                     new Option('2','Yes, for all of the separations'),
                                     new Option('99','Unknown')};
                            
            comSelectList(block, Qtype, options, ENUMSKIP.NOLOGIC);
            
        }
        
    }

    public class RREUN extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('',''),
                                     new Option('0','0-7 Days'),
                                     new Option('1','1-4 Weeks'),
                                     new Option('2','1-12 Months'),
                                     new Option('3','>12 Months'),
                                     new Option('99','Unknown')};
                            
            comSelectList(block, Qtype, options, ENUMSKIP.NOLOGIC);
            
        }
        
    }

    public class RSE extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('On school property','RSESP'),
                                     new Option('On the way to/from school','RSEWS'),
                                     new Option('During a school-sponsored event','RSESE'),
                                     new Option('On the way to/from a school-sponsored event','RSEWE')};
                            
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RSET extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            if(version == 1) {
                                
                List<Option> options = 
                    new List<Option>{new Option('Extended Home Care','RSETH'),
                                     new Option('Hospital Admission','RSETHS'),
                                     new Option('Extended care facility','RSETEX'),
                                     new Option('Pediatric Intensive Care Unit (PICU) Admission','RSETICU'),
                                     new Option('Other','RSETO')};
                            
                comCheckBox(block, options, 'RSETO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
                comAssociateInputField(block, 'RSETOS', ', please specify: &nbsp;');
                
                options = new List<option>{new Option('Unknown', 'RSETU')};
                        
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
                
            }
            
            else if(version == 2) {
                                
                List<Option> options = 
                    new List<Option>{new Option('School','RSETS'),
                                     new Option('Community','RSETC'),
                                     new Option('Other','RSETO')};
                            
                comCheckBox(block, options, 'RSETO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
                comAssociateInputField(block, 'RSETOS', ', please specify: &nbsp;');
                
                options = new List<option>{new Option('Unknown', 'RSETU')};
                        
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
                
            }
            
            else if(version == 3) {
                                
                List<Option> options = 
                    new List<Option>{new Option('Home','RSETH'),
                                     new Option('School','RSETS'),
                                     new Option('Community','RSETC'),
                                     new Option('Other','RSETO')};
                  
                comCheckBox(block, options, 'RSETO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                 
                comAssociateInputField(block, 'RSETOS', ', please specify: &nbsp;');
                
                options = new List<option>{new Option('Unknown', 'RSETU')};
                        
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
                                    
            }
            
            else if(version == 4) {
                                
                List<Option> options = 
                    new List<Option>{new Option('Home','RSETH'),
                                     new Option('Community','RSETC'),
                                     new Option('Other','RSETO')};
                        
                comCheckBox(block, options, 'RSETO', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
                comAssociateInputField(block, 'RSETOS', ', please specify: &nbsp;');
                
                options = new List<option>{new Option('Unknown', 'RSETU')};
                        
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
                
            }
            
        }
        
    }

    public class RST extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Permanent','RSTP'),
                                     new Option('Temporary','RSTT'),
                                     new Option('Unknown','RSTU')};
                            
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RTHI extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            comSelectList(block, 'RTHI', BasicOptions, ENUMSKIP.HASLOGIC);
                
            defaultFooter(block);
            
            List<Option> options = new List<Option>{
                new Option('Physically hit or slapped','RTHIP'), 
                    new Option('Tattooed or branded','RTHIT'),
                    new Option('Pregnancy/ miscarriage/ forced abortion','RTHIFA'),
                    new Option('Forced drug use','RTHIDU'),
                    new Option('Resources withheld (e.g., food, medical attention, shelter)','RTHIR'),
                    new Option('Contracted an STD','RTHICS'),
                    new Option('Harm (or threatened harm) to family members or friends','RTHIHF'),
                    new Option('Other','RTHIO')};
                        
            defaultHeader(block, '', 'Please indicate the way in which injury was inflicted. <strong>(Select all that apply.)</strong>', TDForm+'RTHIP');
            
            comCheckBox(block, options, 'RTHIO', ENUMSKIP.ISELEMENT, ENUMSKIP.PULLLEFT);
            
            comAssociateInputField(block, 'RTHIOS', ', please specify: &nbsp;');
            
        }
        
    }

    public class RTR extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            comSelectList(block, 'RTRNSP', BasicOptions, ENUMSKIP.HASLOGIC);
                
            defaultFooter(block);
            
            defaultHeader(block, '', 'Was the child transported across state lines to engage in services? ', TDForm+'RTRSTL');
            
            comSelectList(block, 'RTRSTL', BasicOptions, ENUMSKIP.NOLOGIC);
            
        }
        
    }

    public class RTT12C extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Motor vehicle','RMV'),
                                     new Option('Animal attack','RDOGBT'),
                                     new Option('Fall','RFALL'),
                                     new Option('Small house fire','RHSFRE'),
                                     new Option('Near drowning','RDRWN'),
                                     new Option('Accidental shooting','RSHOOT'),
                                     new Option('Other','ROTHR')};
                            
            comCheckBox(block, options, 'ROTHR', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
            comAssociateInputField(block, 'ROTHSP', ', please specify: &nbsp;');
                
            options = new List<option>{new Option('Unknown', 'RACUK')};
                        
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RTVIO extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('School shooting','RSHOOT'),
                                     new Option('Classmate suicide','RCSUIC'),
                                     new Option('Vandalism','RCVAN'),
                                     new Option('Sexual harassment','RCSEX'),
                                     new Option('Fighting','RCFGT'),
                                     new Option('Stealing', 'RCSTL'),
                                     new Option('Weapon possession', 'RCWEAP'),
                                     new Option('Other','RCOTH')};
                            
            comCheckBox(block, options, 'RCOTH', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
            comAssociateInputField(block, 'RCOSP', ', please specify: &nbsp;');
                
            options = new List<option>{new Option('Unknown', 'RCUK')};
                        
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RTYP extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{ new Option('Directly experienced','RTYPE'),
                                     new Option('Witnessed in person','RTYPW'),
                                    new Option('Learned that traumatic experience happened to a close family member or close friend','RTYPV'),
                                    new Option('Unknown','RTYPU') };
        
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RTYPDS extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Earthquake','REQ'),
                                     new Option('Hurricane','RHURR'),
                                     new Option('Flood','RFLOD'),
                                     new Option('Tornado','RTORN'),
                                     new Option('Fire/wildfires','RFIRE'),
                                     new Option('Landslides','RLAND'),
                                     new Option('Drought','RDRGT'),
                                     new Option('Industrial/technological','RINDS'),
                                     new Option('Public health emergency','RPHE'),
                                     new Option('Other', 'ROTH')};
                            
            comCheckBox(block, options, 'ROTH', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
            comAssociateInputField(block, 'ROTHS', ', please specify: &nbsp;');
                
            options = new List<option>{new Option('Unknown', 'RDSUK')};
                        
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RVTYP extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            List<Option> options = 
                    new List<Option>{new Option('Robbery','RROB'),
                                     new Option('Assault','RASSLT'),
                                     new Option('Homicide','RHOM'),
                                     new Option('Suicide','RSUIC'),
                                     new Option('Other', 'ROTH')};
                            
            comCheckBox(block, options, 'ROTH', ENUMSKIP.NOTELEMENT, ENUMSKIP.PULLLEFT);
                            
            comAssociateInputField(block, 'ROTHS', ', please specify: &nbsp;');
                
            options = new List<option>{new Option('Unknown', 'RVPUK')};
                        
            comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
            
        }
        
    }

    public class RWPN extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void body() {
            
            if(version == 1) {
                
                List<Option> options = 
                    new List<Option>{new Option('Conventional (e.g., firearms (shootings), bombs (9/11, Boston Marathon), etc.)','RCONV'),
                                     new Option('Chemical','RCHEM'),
                                     new Option('Radiological/Nuclear','RRAD'),
                                     new Option('Rocket and mortar attacks','RRMA'),
                                     new Option('Biological','RBIO'),
                                     new Option('Unknown','RWPNU')};
                            
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
                
            }
            else if(version == 2) {
                                
                List<Option> options = 
                    new List<Option>{new Option('Conventional (e.g., firearms (shootings), bombings, etc.)','RCONV'),
                                     new Option('Chemical','RCHEM'),
                                     new Option('Radiological/Nuclear','RRAD'),
                                     new Option('Rocket and mortar attacks','RRMA'),
                                     new Option('Biological','RBIO'),
                                     new Option('Unknown','RWPNU')};
                            
                comCheckBox(block, options, '', ENUMSKIP.NOTELEMENT, ENUMSKIP.NOPULLLEFT);
                
            }
            
        }
        
    }

    public class SECTION extends DS_TDETAIL_Element_Base implements Element  {
        
        public override void header() {
            
            String content = '';
            
            content += '<div class="form-group">'; 
            content += '    <label class="control-label col-md-12 col-lg-12">'+question+'</label>';
            content += '    <div>';
            
            contentGenerator(block, content);
          
        }
        
        public override void body() {}
        
    }
    
    public class STATUS extends DS_TDETAIL_Element_Base implements Element  {
    
        public override void header() {
           contentGenerator(block, '<div class="form-group no-border-bottom no-space-bottom"><label class="control-label col-md-2 col-md-offset-8 text-right">Complete?</label><div class="col-md-2">');
        }
        
        public override void body() {
            
            List<Option> options = new List<Option>{new Option('Incomplete','Incomplete'),
                new Option('Complete','Complete')};
                    
            comSelectList(block, 'STATUS', options, ENUMSKIP.NOLOGIC);
            
        }
        
    }
    
    public class SUBMITBTN extends DS_TDETAIL_Element_Base implements Element  {
    
        public override void build() {
            
            Component.Apex.pageBlockButtons blockButtons = new Component.Apex.pageBlockButtons();
            
            Component.Apex.commandButton saveButton = new Component.Apex.commandButton();
            saveButton.expressions.action = '{!save}';
            saveButton.value = 'Save';
            saveButton.styleClass = 'btn-info';
            
            blockButtons.childComponents.add(saveButton);
            
            if(form.forceRedirect != '1') {
                
                Component.Apex.commandButton cancelButton = new Component.Apex.commandButton();
                cancelButton.expressions.action = '{!cancel}';
                cancelButton.value = 'Cancel';
                cancelButton.styleClass = 'btn-info';
                
                blockButtons.childComponents.add(cancelButton);
                
            }
            
            contentGenerator(block, blockButtons);
            
        }
        
    }
    
}