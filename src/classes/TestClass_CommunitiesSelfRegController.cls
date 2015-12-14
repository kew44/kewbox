@isTest (SeeAllData=false)
public class TestClass_CommunitiesSelfRegController {
    
    static TestMethod void Test_SelfRegController() {
        
        CommunitiesSelfRegController selfReg = new CommunitiesSelfRegController();
        
        selfReg.registerUser();
        
        CommunitiesSelfRegConfirmController confirm = new CommunitiesSelfRegConfirmController();
        
    }

}