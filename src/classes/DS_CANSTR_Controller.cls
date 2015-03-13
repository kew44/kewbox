/*Page Description: 
 *  Controller for VisualForce page DS_CANSTR
 * Last Updated on:
 *  7/24/2014
 * Update Purpose:
 *         fix redirect
 7/31/14-Link to DS_Functioning_Forms__c
 * Programmer:
 *  Kelsey
 */
public with sharing class DS_CANSTR_Controller {

        Utility ut = new Utility();
Map<String, String> parameter = ut.urlDecode(Apexpages.currentPage().getParameters().get('cimi'));
        
         public DS_Functioning_Forms_B__c obj { get; set; }//CANSTR
         //public DS_CANSTR__c obj { get; set; }

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
     
    public DS_CANSTR_Controller(ApexPages.StandardController controller) {
    
        cID = parameter.get('c');

    summaryID = parameter.get('summary');
          
        forceRedirect = (parameter.containsKey('f')) ? parameter.get('f') : '';

        skip = new SkipLogic();       
       
        client = [SELECT Name, INIT__c FROM Client__c WHERE id =: cID];  
 //   Client_Summary__c summary = [SELECT SECTION__c FROM Client_Summary__c WHERE ID =:summaryID];
    
    subtitle = '(' + client.Name + ') ' + client.INIT__c;
    
 //   String getDEMOFields = ut.getFields('DS_CANSTR__c');
    String getDEMOFields = ut.getFields('DS_Functioning_Forms_B__c');
    

//    List<DS_CANSTR__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //CANSTR
    List<DS_Functioning_Forms_B__c> record = Database.query('SELECT ' + getDEMOFields + ', Client__r.Name, Client__r.INIT__c' +  //CANSTR
            //                                   '  FROM DS_CANSTR__c' +                                                //CANSTR
                                               '  FROM DS_Functioning_Forms_B__c' +                                           
                                                 ' WHERE Client__c = \''+ cID + '\'');
                                                
    

    if(record.size() == 0) { // New record
      
      obj = new DS_Functioning_Forms_B__c(CLIENT__c = cID, FORM__c = 'DS_CANSTR');                    //
   //   obj = new DS_CANSTR__c(CLIENT__c = cID);                    //CANSTR
 //     summary = new Client_Summary__c(FORM_ID__c=summaryID);//
      
    }
    else {   // Update record
      
      obj = record.get(0);
      edit = TRUE;
      obj.FORM__c = 'DS_CANSTR';  
    } 
   
   }


  public String getClientInfo() { return ut.clientSection(cID,SummaryID);}  


  /* public List<SelectOption> getStrongItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'Well developed or centerpiece strength'));
            options.add(new SelectOption('1', 'Useful strength is evident'));
            options.add(new SelectOption('2', 'Strength identified but requires significant strength-building efforts'));
            options.add(new SelectOption('3', 'No current strength is identified'));
            options.add(new SelectOption('97', 'Not applicable'));
            
            return options;
            }*/
            
    public List<SelectOption> getStrongFamItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'Significant family strengths. There is at least one family member who has a strong loving relationship with the child and is able to provide significant emotional or concrete support'));
            options.add(new SelectOption('1', 'Moderate level of family strengths. There is at least one family member who has a strong loving relationship with the child and is able to provide limited emotional or concrete support'));
            options.add(new SelectOption('2', 'Mild level of family strengths. Family members are known, but currently none are able to provide emotional or concrete support'));
            options.add(new SelectOption('3', 'This level indicates a child with no known family strengths. There are no known family members'));
            
            return options;
            }    
            
    public List<SelectOption> getStrongIntItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'Significant interpersonal strengths. Child has close friends and is friendly with others'));
            options.add(new SelectOption('1', 'Moderate level of interpersonal strengths. Child may have a history of forming positive relationships with peers and/or non-caregivers. Child may have at least one healthy relationship, and is friendly with others'));
            options.add(new SelectOption('2', 'Mild level of interpersonal strengths. Child has some social skills that facilitate positive relationships with peers and adults but may not have any current healthy friendships'));
            options.add(new SelectOption('3', 'Very limited ability to make and maintain positive relationships. Child lacks social skills and has no history of positive relationships with peers and adults'));
            
            return options;
            }  
            
    public List<SelectOption> getStrongEduItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'This level indicates a child who is in school and is involved with an educational plan (or IEP) that appears to exceed expectations.  School works exceptionally well with family and caregivers to create a special learning environment that meets the child’s needs.  Someone at the school goes above and beyond to take a healthy interest in the educational success of the child '));
            options.add(new SelectOption('1', 'This level indicates a child who is in school and has a plan that appears to be effective. School works fairly well with family and caregivers to ensure appropriate educational development'));
            options.add(new SelectOption('2', 'This level indicates a child who is in school but has a plan that does not appear to be effective'));
            options.add(new SelectOption('3', 'This level indicates a child who is either not in school or is in a school setting that does not further his/her education'));
            options.add(new SelectOption('97', 'This item is only rated not applicable when a child is not in a school or preschool setting'));
            
            return options;
            }    
            
    public List<SelectOption> getStrongVocItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'This level indicates an adolescent with vocational skills who is currently working in a natural environment '));
            options.add(new SelectOption('1', 'This level indicates an adolescent with pre-vocational and some vocational skills but limited work experience '));
            options.add(new SelectOption('2', 'This level indicates an adolescent with some pre-vocational skills but who is not presently working in any area related to those skills.  This also may indicate a child or youth with a clear vocational preference '));
            options.add(new SelectOption('3', 'This level indicates an adolescent with no known or identifiable vocational or pre-vocational skills and no expression of any future vocational preferences '));
            options.add(new SelectOption('97', 'This item can be rated not applicable when a child is under 14 years old '));
            
            return options;
            }  
             
    public List<SelectOption> getStrongCopeItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'This level indicates a child with exceptional psychological strengths.  Both coping and savoring skills are well-developed '));
            options.add(new SelectOption('1', 'This level indicates a child with good psychological strengths.  The person has solid coping skills for managing negative life experiences or solid savoring skills that include the ability to enjoy positive life experiences/pleasurable events '));
            options.add(new SelectOption('2', 'This level indicates a child with limited psychological strengths.  For example, a person with very low self-esteem or someone who has difficulty managing negative life events would be rated here'));
            options.add(new SelectOption('3', 'This level indicates a child with no known or identifiable psychological strengths.  This child is not able to enjoy positive experiences and has significant difficulties coping with negative life events. This may be due to intellectual impairment or serious psychiatric disorders '));
            
            return options;
            }         
             
    public List<SelectOption> getStrongOptItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'Child has a strong and stable optimistic outlook on his/her life.  Child is future oriented '));
            options.add(new SelectOption('1', 'Child is generally optimistic.   Child is likely able to articulate some positive future vision '));
            options.add(new SelectOption('2', 'Child has difficulties maintaining a positive view of him/herself and his/her life.  Child may be overly pessimistic '));
            options.add(new SelectOption('3', 'Child has difficulties seeing any positives about him/herself or his/her life '));
            
            return options;
            }   
             
    public List<SelectOption> getStrongTalentItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'This level indicates a child with significant creative/artistic strengths.  A child/youth who receives a significant amount of personal benefit from activities surrounding a talent would be rated here '));
            options.add(new SelectOption('1', 'This level indicates a child with a notable talent.  For example, a youth who is involved in athletics or plays a musical instrument but without gaining significant personal benefit would be rated here '));
            options.add(new SelectOption('2', 'This level indicates a child who has expressed interest in developing a specific talent or talents even if they have not developed that talent to date '));
            options.add(new SelectOption('3', 'This level indicates a child with no known talents, interests, or hobbies '));
            
            return options;
            }      
             
    public List<SelectOption> getStrongSpiritItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'This level indicates a child with strong moral and spiritual strengths.  Child may be very involved in a religious community or may have strongly held spiritual or religious beliefs that can sustain or comfort him/her in difficult times'));
            options.add(new SelectOption('1', 'This level indicates a child with some moral and spiritual strengths.  Child may be involved in a religious community '));
            options.add(new SelectOption('2', 'This level indicates a child with few spiritual or religious strengths.  Child may have little contact with religious institutions'));
            options.add(new SelectOption('3', 'This level indicates a child with no known spiritual or religious involvement '));
            
            return options;
            }     
             
    public List<SelectOption> getStrongComItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'This level indicates a child with extensive and substantial long-term ties with the community.  For example, individual may be a member of a community group (e.g., Girl or Boy Scout, etc.) for more than one year, may be widely accepted by neighbors, or involved in other community activities, informal networks, etc.'));
            options.add(new SelectOption('1', 'This level indicates a child with significant community ties although they may be relatively short term (e.g., past year) '));
            options.add(new SelectOption('2', 'This level indicates a child with limited ties and/or supports from the community '));
            options.add(new SelectOption('3', 'This level indicates a child with no known ties or supports from the community '));
            
            return options;
            }     
             
    public List<SelectOption> getStrongRelateItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'This level indicates a child who has very stable relationships.  Family members, friends, and community have been stable for most of his/her life and are likely to remain so in the foreseeable future.  Child is involved with both parents'));
            options.add(new SelectOption('1', 'This level indicates a child who has had one or more stable relationships but there is some concern about instability in the near future (one year) due to transitions, divorce, or illness, etc.  A child who has a stable relationship with only one parent may be rated here '));
            options.add(new SelectOption('2', 'This level indicates a child who has had only one stable relationship over his/her lifetime and is at more immediate risk of instability due to life transitions, relocation, etc. which has the potential to disrupt this relationship '));
            options.add(new SelectOption('3', 'This level indicates a child who does not have any stability in relationships '));
            
            return options;
            } 
             
    public List<SelectOption> getStrongResItems(){
        List<SelectOption> options=new List<SelectOption>();
        
            options.add(new SelectOption('0', 'Child is able to recognize and use his/her strengths for healthy development and problem solving '));
            options.add(new SelectOption('1', 'Child recognizes his/her strengths, but is not yet able to use them in support of his/her healthy development or problem solving '));
            options.add(new SelectOption('2', 'Child has limited ability to recognize and use his/her strengths to support healthy development and/or problem solving '));
            options.add(new SelectOption('3', 'Child fails to recognize his/her strengths and is therefore unable to utilize them '));
            
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