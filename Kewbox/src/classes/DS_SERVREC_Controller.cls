/**
 * The controller class for Services Received.  
 * 
 **/

public with sharing class DS_SERVREC_Controller extends DS_BasicForm_Controller {

    public String tableHeaderTitle { get; set; }
  
    public DS_SERVREC_Controller(ApexPages.StandardController controller) {

        // Initilize the DS_BasicForm_Controller
        super(Apexpages.currentPage().getParameters().get('cimi'));

        // Set the skip object to form object
        form.setSkipLogic(skip);

        // Set the obj name 
        form.setObjName('DS_Functioning_Forms_'+form.BorF+'__c');

        // Get the object record into form.obj
        form.getObjRecord();

        // Get field name from DS_DATA (variable)
        bfVariableMap = form.getVariable('SERVREC');

        // table header title is different in baseline and follow-up
        tableHeaderTitle = (form.isBaseline) ? 'Past 30 Days' : 'Since Last CIMI Assessment';

    }
     
}