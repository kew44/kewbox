/****
*@description An apex page controller that takes the user to the correct start page based on credentials 
*
*@author Kelsey Willett
*@date 11/28/2014
*@modified date
*
*@group User handling
*@group-content /ApexDocContent/User/CommunitiesLandingController.htm
****/
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        if(UserInfo.getUserType() == 'Guest'){
            return new PageReference('/CommunitiesLogin');
        
    }
        else{
            return null;
        }
    }

    
    public CommunitiesLandingController() {}
}