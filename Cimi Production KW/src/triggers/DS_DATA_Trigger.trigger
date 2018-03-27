/****
* @author Danny Fu
* @date 10/13/2016
*
* @group Test Script 
* @group-content /ApexDocContent/Trigger/DS_DATA_Trigger.htm
*
* @description The class provides the trigger for DS_DATA object.
*
*/
trigger DS_DATA_Trigger on DS_DATA__c (before insert, before update, before delete) {
    
    // Define DS_DATA Blocker 
    DS_DATA_Blocker blocker = new DS_DATA_Blocker(Trigger.new, Trigger.old);
    
    if(Trigger.isInsert) { blocker.setTriggerType('insert'); }
    
    if(Trigger.isUpdate) { blocker.setTriggerType('update'); }
    
    if(Trigger.isDelete) { blocker.setTriggerType('delete'); }
    
    blocker.verifyPermission();

}