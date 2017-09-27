/**
 * An apex page controller that exposes the site login functionality
 11/28/14 KW
 */
global with sharing class CommunitiesLoginController {
    global String Username{get;set;}
    global String Password{get;set;}
    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
      /*  String startUrl = System.currentPageReference().getParameters().get('startURL');
        String displayType = System.currentPageReference().getParameters().get('display');
        return Network.forwardToAuthPage(startUrl, displayType);*/
        return new PageReference( '/CommunitiesLogin');
    }
    global PageReference login(){
    return Site.login(Username, Password, null);
    }
}