function noddModule() {
    
    var value = $j('select[name$=\'DEVCON__c\']').val(); 
        
    // Regular skiplogic for Q15
    skipLogic('DEVCON',value);
        
    if(value =='1') {
        // Show Q16 & Q17
        $j('.skip-DVTR').show();
        $j('.skip-DVSR').show();
    }
    else {
        
        // Hide Q16 & Q17
        $j('.skip-DVTR').hide();
        $j('.skip-DVSR').hide();
        
        // Deselect Q16 & trigger the regular skiplogic
        $j("input[name$='DVTR__c']:checked").removeAttr('checked').change();
        $j("input[name$='DVTR__c']:radio").attr('title', '');
        
        // Deselect Q17 & trigger the regular skiplogic
        $j("input[name$='DVSR__c']:checked").removeAttr('checked').change();
        $j("input[name$='DVSR__c']:radio").attr('title', '');
        
        
    }
}
