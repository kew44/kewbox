/*Page Description:
 *  Global Class for Role Scheduling
 * Last Updated on:
 *  7/17/2014
 * Update Purpose:
 *      
 * Programmer:
 *  
 */
global class scheduledRole implements Schedulable {

    public String roleName;
    public String centerID;
    public Integer type;

    public void sentParameter(String roleName2, String centerID2, Integer type2) {
        roleName = roleName2;
        centerID = centerID2;
        type = type2;
    }

  global void execute(SchedulableContext SC) {
    if(!Test.isRunningTest()) RoleControllerStatic.insertRoleList(roleName, centerID, type);
    System.abortJob(SC.getTriggerId());
  }

  /*global void finish(Database.BatchableContext BC){
    system.debug(BC);
    CronTrigger cron = [SELECT id FROM CronTrigger WHERE CronExpression =: cronExpression];
        System.abortJob(cron.id);
    }*/
}