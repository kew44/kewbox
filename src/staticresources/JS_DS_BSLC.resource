function dateModule(){	
		
    var value = $j('input[name$=\'TXCOMPL__c\']:checked').val();  
	
		if( value == '0'){
			$j('.skip-No').show();
			$j('.skip-Yes').hide();
			$j('.skip-element-TXCPDT').val('');
		}
		else if( value == '1' ){
			$j('.skip-Yes').show();			
			$j('.skip-No').hide();
			$j('.skip-element-TXLFTDT').val('');
		}
		else{
			$j('.skip-No').hide();
			$j('.skip-element-TXLFTDT').val('');			
			$j('.skip-Yes').hide();
			$j('.skip-element-TXCPDT').val('');
		}
}