/****
*@description Tests Community Self Register Controller & Community Self Register Confirm Controller
*
*@group Test Script 
*@group-content /ApexDocContent/Test/CommunitiesSelfRegController.htm
****/
@isTest (SeeAllData=false)
public class TestClass_CommunitiesSelfRegController {
    
    static TestMethod void Test_SelfRegController() {
        
        CommunitiesSelfRegController selfReg = new CommunitiesSelfRegController();
        
        selfReg.registerUser();        
        
        CommunitiesSelfRegConfirmController confirm = new CommunitiesSelfRegConfirmController();
        
    }

}