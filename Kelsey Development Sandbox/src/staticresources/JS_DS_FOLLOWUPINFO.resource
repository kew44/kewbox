function TypeModule(value){
    console.log(value);

    value = $j('input[name$=\'UTYPE__c\']:checked').val();  
    console.log(value);
	
	if(value =='1'){//ongoing
		//show
			$j('.skip-UTIME').show();
			$j('.skip-UTXCHNG').show();
		//hide
			$j('.skip-ETSTAT').hide();
			$j('.skip-ETSTATSP').hide();
			$j('.skip-UTYPESP').hide();
		//deselect radio
			$j("input[name$='ETSTAT__c']:checked").removeAttr('checked').change();
			$j("input[name$='ETSTAT__c']:radio").attr('title', '');
		//reset text fields
	//		$j('.skip-ETSTATSP').val('');
		//	$j('.skip-UTYPESP').val('');
				
    //    skipLogic('ETSTAT', null);
	}
	else if(value =='2'){//ending
		//show
			$j('.skip-ETSTAT').show();
		//hide
			$j('.skip-UTIME').hide();
			$j('.skip-UTXCHNG').hide();
			$j('.skip-UTIMESP').hide();
			$j('.skip-UTYPESP').hide();
		//deselect radio
			$j("input[name$='UTIME__c']:checked").removeAttr('checked').change();
			$j("input[name$='UTIME__c']:radio").attr('title', '');
			
			$j("input[name$='UTXCHNG__c']:checked").removeAttr('checked').change();
			$j("input[name$='UTXCHNG__c']:radio").attr('title', '');
		//reset text fields
		//	$j('.skip-UTIMESP').val('');
			//$j('.skip-UTYPESP').val('');
			
        //skipLogic('UTIME', null);
	}
	else if(value =='98'){//other
		//show
			$j('.skip-UTYPESP').show();
		//hide
			$j('.skip-UTIME').hide();
			$j('.skip-UTXCHNG').hide();
			$j('.skip-UTIMESP').hide();
			$j('.skip-ETSTAT').hide();
			$j('.skip-ETSTATSP').hide();
		//deselect radio
			$j("input[name$='UTIME__c']:checked").removeAttr('checked').change();
			$j("input[name$='UTIME__c']:radio").attr('title', '');
			
			$j("input[name$='UTXCHNG__c']:checked").removeAttr('checked').change();
			$j("input[name$='UTXCHNG__c']:radio").attr('title', '');
			
			$j("input[name$='ETSTAT__c']:checked").removeAttr('checked').change();
			$j("input[name$='ETSTAT__c']:radio").attr('title', '');
		//reset text fields
			//$j('.skip-UTIMESP').val('');
			//$j('.skip-ETSTATSP').val('');
			
        //skipLogic('UTIME', null);
        //skipLogic('ETSTAT', null);
	}
	else{
		//hide
			$j('.skip-UTIME').hide();
			$j('.skip-UTXCHNG').hide();
			$j('.skip-UTIMESP').hide();
			$j('.skip-ETSTAT').hide();
			$j('.skip-ETSTATSP').hide();
			$j('.skip-UTYPESP').hide();
		//deselect radio
			$j("input[name$='UTIME__c']:checked").removeAttr('checked').change();
			$j("input[name$='UTIME__c']:radio").attr('title', '');
			
			$j("input[name$='UTXCHNG__c']:checked").removeAttr('checked').change();
			$j("input[name$='UTXCHNG__c']:radio").attr('title', '');
			
			$j("input[name$='ETSTAT__c']:checked").removeAttr('checked').change();
			$j("input[name$='ETSTAT__c']:radio").attr('title', '');
		//reset text fields
			$j('.skip-UTIMESP').val('');
			$j('.skip-ETSTATSP').val('');
			$j('.skip-UTYPESP').val('');
			
        skipLogic('UTIME', null);
        skipLogic('ETSTAT', null);

	}
}

function NewTraumaModule(value){
    
    value = $j('select[name$=\'NEWTR__c\']').val(); 
console.log(value);

	if (value == '1')
		$j('.skip-trauma-new').show(); 
	else{
		$j('.skip-trauma-new').hide();
		}
}

function OldTraumaModule(value){
    
    value = $j('select[name$=\'PRETR__c\']').val(); 
	console.log(value);

	if (value == '1')
		$j('.skip-trauma-old').show(); 
	else{
		$j('.skip-trauma-old').hide();
		}
}

function HealthModule(value){
    
    value = $j('input[name$=\'HOVERALL__c\']:checked').val(); 
console.log(value);

	if (value == '4' || value == '5')
		$j('.skip-health').show();  
	else{
		$j('.skip-health').hide();
		}
}

function MilitaryModule(value){
    
    value = $j('input[name$=\'MSTAT__c\']:checked').val(); 
console.log(value);

	if (value == '1')
		$j('.skip-military').show();  
	else{
		$j('.skip-military').hide();
		}
}