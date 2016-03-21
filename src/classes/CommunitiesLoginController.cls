/****
*@description An apex page controller that exposes the site login functionality
*
*@author Kelsey Willett
*@date 11/28/2014
*@modified date
*
*@group User handling
*@group-content /ApexDocContent/User/CommunitiesLoginController.htm
****/
global with sharing class CommunitiesLoginController {
    global String Username{get;set;}
    global String Password{get;set;}
    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
        return new PageReference( '/CommunitiesLogin');
    }
    global PageReference login(){
    return Site.login(Username, Password, null);
    }
}