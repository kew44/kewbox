function suicideModule() {   //suicide display criteria 
    
    var value = $j('input[name$=\'ISPSUIC__c\']:checked').val();    
	    
    if(value == '1' || value == '2') { $j('.skip-suicide').show(); }
    else {
        $j('.skip-suicide').hide();
        
        $j('.skip-element-SUITALK').val('');
            $j("input[name$='SUITALK__c']:checked").removeAttr('checked').change();
            $j("input[name$='SUITALK__c']:radio").attr('title', '');
            
        $j('.skip-element-SUIATT').val('');
            $j("input[name$='SUIATT__c']:checked").removeAttr('checked').change();
            $j("input[name$='SUIATT__c']:radio").attr('title', '');
            
        skipLogic('SUITALK', null);
        skipLogic('SUIATT', null); 
    }
}

function criminalModule() { //criminal display criteria       
    
    var value = $j('input[name$=\'ISPCRIM__c\']:checked').val();     
    
    if(value == '1' || value == '2')
        $j('.skip-criminal').show();
    else {
        $j('.skip-criminal').hide();
        $j('.skip-element-ISPCRRU').val('');
            $j("input[name$='ISPCRRU__c']:checked").removeAttr('checked').change();
            $j("input[name$='ISPCRRU__c']:radio").attr('title', '');
			
			$j('.skip-element-ISPCRSP').val('');
			
        skipLogic('ISPCRRU ', null);        
        
    }
    
    if(value == 'undefined') { $j('input[name$=\'ISPCRIM__c\']:radio').attr('title', ''); }
}