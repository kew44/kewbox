/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
11/28/14 KW
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        if(UserInfo.getUserType() == 'Guest'){
            return new PageReference('/CommunitiesLogin');
        
       // return Network.communitiesLanding();
    }
        else{
            return null;
        }
    }

    
    public CommunitiesLandingController() {}
}