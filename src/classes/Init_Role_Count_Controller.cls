public with sharing class Init_Role_Count_Controller {

   public Boolean empty {get;set;}
   
   //init role id
   public String roleID {get;set;}
   //userrole record
   public List<userrole> role {get;set;}
   
   public List<counter_record> CountRec {get;set;}
   
   public class counter_record {
       public Integer Counter {get; set;}
       public Integer Counter2 {get; set;}
       public Integer Counter3 {get; set;}
       public String ItemId {get; set;}
       public String ItemName {get; set;}
       public String RoleId {get; set;}
       public Integer Type {get; set;}
       
       public counter_record(Integer Counter, Integer Counter2, Integer Counter3, String ItemName, String RoleId, Integer Type){
           this.Counter = Counter;
           this.Counter2 = Counter2;
           this.Counter3 = Counter3;
           this.ItemName = ItemName;
           this.RoleId = RoleId;
           this.Type = Type;
       }
   }
  //  public List<Counter__c> counterObj {get;set;}
    
   //Counter__c object
   //get User.role id 
    
    public Init_Role_Count_Controller() {//(ApexPages.StandardController controller) {
     
    CountRec = new List<counter_record>();
    
    List<Counter__c> counterObj = [SELECT id, name, role_id__c
                                    FROM Counter__c];
        if(counterObj.size() == 0){         
           // insert counter record
           empty = true;
        }
        else{
            empty = false;
        }
    }
       
   public PageReference test(){
       if( empty = true){           
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'The Counter__c object is currently empty, please click the \'Init\' button to proceed with initialization. '));
       }
       else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'The Counter__c object has already been initialized.'));
       }
       return page.Init_Role_Count;
   }
   
   public PageReference init(){
       if( empty = true){        
          // insert
          Integer Counter = 1;
          Integer Counter2 = 1;
          Integer Counter3 = 1;
          String ItemName = 'administrator';
          String RoleId = roleId;
          Integer Type = 0;
           CountRec.add(new counter_record(Counter, Counter2, Counter3, ItemName, RoleId, Type));
           System.debug(CountRec);
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Initialized'));
           }
       else{
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Cannot initialize.'));
       }  
       return page.Init_Role_Count;
   }
}