/**
* @author Danny Fu
* @date 09/23/2016
*
* @group Data
* @group-content /ApexDocContent/Data_blocker.htm
*
* @description An apex class, which is used in DS_DATA object trigger, prevents
* unauthorized or unexpected modification. 
*/

public class DS_DATA_Blocker {
    
    private List<DS_DATA__c> newData, oldData;
    private String triggerType = '';
    
    /****
    * @description Constructor, gather old and new data. 
    * @param newData new insert/update records
    * @param oldData existed records
    * @example
    *   DS_DATA_Blocker blocker = new DS_DATA_Blocker(Trigger.new, Trigger.old);
    */
    public DS_DATA_Blocker(List<DS_DATA__c> newData, List<DS_DATA__c> oldData) { 
        this.newData = newData;
        this.oldData = oldData;       
    }
    
    /****
    * @description Set triggerType value. 
    * @param triggerType Trigger type
    * @example
    *   DS_DATA_Blocker blocker = new DS_DATA_Blocker(Trigger.new, Trigger.old);
    *   blocker.setTriggerType('insert');
    */
    public void setTriggerType(String triggerType) { 
        this.triggerType = triggerType;
    }
    
    /****
    * @description Find out whether the process record is blocker record. 
    * @return Boolean
    * @example
    *   Boolean isBlockerRecord = isBlockerRecord();
    */
    public Boolean isBlockerRecord() {
        
        Boolean isBlockerRecord = false;
        
        List<DS_DATA__c> dataSet = (triggerType == 'insert') ? newData : oldData;
        
        // Single data update
        if(dataSet.size() == 1) {
            if(dataSet.get(0).DATA_TYPE__c == 'DS_Blocking') {
                isBlockerRecord = true;
            }
        }
        // Multiple data update (For data import)
        else {
            for(DS_DATA__c d : dataSet) {
                if(d.DATA_TYPE__c == 'DS_Blocking') {
                    d.name.addError('This data set contains blocker record.');
                }
            }
        }
        
        return isBlockerRecord;
        
    }
    
    /****
    * @description Check the modify status in blocker record. 
    * @return List<String> Index 0: Modify field value, Index 1: Error message
    * @example
    *   List<String> modifyStatus = checkModifyStatus();
    */
    public List<String> checkModifyStatus() {
                
        List<String> modifyStatus = new List<String>{'false',''};
        
        List<DS_DATA__c> d = [SELECT Allow_Modify__c FROM DS_DATA__c WHERE DATA_TYPE__c = 'DS_Blocking'];
        
        // Blocker record does not exist
        if(d.size() == 0) {
            modifyStatus.set(1, 'Blocker record does not exist.');
        }
        // There are more than two blocker records
        else if(d.size() > 1) {
            modifyStatus.set(1, 'There are more than two blocker records.');
        }
        // There is only one blocker record
        else if(d.size() == 1) {
            
            String modifyField = String.valueOf(d.get(0).Allow_Modify__c);
            
            modifyStatus.set(0, modifyField);
            
            if(modifyField == 'false') {
                modifyStatus.set(1, 'You do not have the permission to '+this.triggerType+' any record.');
            }
        }
                
        return modifyStatus;
        
    }
    
    /****
    * @description Verify and make sure this modification request is permitted. 
    * @return null
    * @example
    *   DS_DATA_Blocker blocker = new DS_DATA_Blocker(Trigger.new, Trigger.old);
    *   blocker.verifyPermission();
    */
    public void verifyPermission() {
        
        List<DS_DATA__c> data; 
        
        String errorMessage = '';
        
        Boolean isBlockerRecord = isBlockerRecord();
        List<String> modifyStatus = checkModifyStatus();
        
        // Trigger type is undefined
        if(triggerType == '') { 
            errorMessage = 'Trigger type is undefined';
        }
        else {
            data = (triggerType == 'delete') ? oldData : newData;
        }
        
        // Not DS_DATA blocker record
        if(!isBlockerRecord) {
            
            // Allow Modify is OFF
            if(modifyStatus.get(0) == 'false') {
                errorMessage = modifyStatus.get(1);
            }
            
        }
        // Error messages for different trigger type with the blocker record
        else {
                        
            if(this.triggerType == 'delete') {
                errorMessage = 'You are not supposed to delete blocker record.';
            }
            else if(this.triggerType == 'update') {
                
                // If Data_type__c is not equal to 'DS_Blocking'
                if(this.oldData.get(0).DATA_TYPE__c != this.newData.get(0).DATA_TYPE__c) {
                    errorMessage = 'You are not supposed to change Data_Type__c value in blocker record.';
                }
                
                // If Data_type__c is not equal to 'DS_Blocking'
                if(this.newData.get(0).Blocker_ID__c != '20160930') {
                    errorMessage = 'You are not supposed to change Blocker_ID__c value in blocker record.';
                }
                
            }
            else if(this.triggerType == 'insert') {
                
                DS_DATA__c blockerRecord = data.get(0);
                
                // You can only have one blocker record and id has to be '20160903'
                if(blockerRecord.DATA_TYPE__c == 'DS_Blocking' && blockerRecord.Blocker_ID__c != '20160930') {
                    errorMessage = 'You can not create new blocker record.';
                }
            }
            
        }
        
        // Reject the request if there is any error message
        if(errorMessage != '') {
            for(DS_DATA__c d: data) {
                // Reject the request and thrown an exception 
                d.name.addError(errorMessage); 
            }
        }
        
    }

}