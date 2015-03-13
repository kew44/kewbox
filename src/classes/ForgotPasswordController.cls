/*Page Description:
 * An apex page controller that exposes the site forgot password functionality
 * Last Updated on:
 *  7/17/2014
 * Update Purpose:
 *      
 * Programmer:
 *  
 */

public with sharing class ForgotPasswordController {
    public String username {get; set;}   
       
    public ForgotPasswordController() {}
    
    public PageReference forgotPassword() {
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.ForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if (success) {              
            return pr;
        }
        return null;
    }
}