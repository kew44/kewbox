function dateModule(){
		
    var value = $j('input[name$=\'CBISCOMP__c\']:checked').val();  
	
	if( value == '0'){//client did not complete treatment, display date abandoned
		$j('.skip-No').show();
		$j('.skip-Yes').hide();
		$j('.skip-element-CBISCODT').val('');
	}
	else if( value == '1' ){//client completed treatment, display completion date
		$j('.skip-Yes').show();
		$j('.skip-No').hide();
		$j('.skip-element-CBISLFDT').val('');
	}
	else{//client completion of treatment not specified, do not display any date
		$j('.skip-No').hide();
		$j('.skip-element-CBISLFDT').val('');
		$j('.skip-Yes').hide();
		$j('.skip-element-CBISCODT').val('');
	}
}