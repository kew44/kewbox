function difficultModule(value) {
	
    console.log(value);
	
	var SBvalue = $j('input[name$=\'SDSEBCD__c\']:checked').val();//self baseline
	var SFvalue = $j('input[name$=\'SDSEBDD__c\']:checked').val();//self followup
	var PBvalue = $j('input[name$=\'SDPEBCD__c\']:checked').val();//parent baseline
	var PFvalue = $j('input[name$=\'SDPEBDD__c\']:checked').val();//parent followup
	
	console.log(SBvalue);
	console.log(SFvalue);
	console.log(PBvalue);
	console.log(PFvalue);
	
	if(SBvalue != null){
		value = SBvalue;
	}
	else if(SFvalue != null){
		value = SFvalue;
	}
	else if(PBvalue != null){
		value = PBvalue;
	}
	else if(PFvalue !=null){
		value = PFvalue;
	}
	else{
		value = null;
	}
	
	console.log(value);
	
    if (value == '1' || value == '2') {
        $j('.skip-difficult').show();
    } 
    else if (value == '3') {
        $j('.skip-difficult').show();
    } 
    else { //if it is indicated that there are no difficulties, hide the module
        $j('.skip-difficult').hide();
        
        $j('input[name$=\'SDSTIME__c\']:checked').removeAttr('checked').change();
        $j('input[name$=\'SDSTIME__c\']:radio').attr('title', '');
        $j('input[name$=\'SDPTIME__c\']:checked').removeAttr('checked').change();
        $j('input[name$=\'SDPTIME__c\']:radio').attr('title', '');
        
        $j('input[name$=\'SDSUPSET__c\']:checked').removeAttr('checked').change();
        $j('input[name$=\'SDSUPSET__c\']:radio').attr('title', '');
        $j('input[name$=\'SDPUPSET__c\']:checked').removeAttr('checked').change();
        $j('input[name$=\'SDPUPSET__c\']:radio').attr('title', '');
        
        $j('.SDQI:checked').removeAttr('checked').change();
        $j('.SDQI').attr('title', '');
        
        $j('input[name$=\'SDSFAM__c\']:checked').removeAttr('checked').change();
        $j('input[name$=\'SDSFAM__c\']:radio').attr('title', '');
        $j('input[name$=\'SDPFAM__c\']:checked').removeAttr('checked').change();
        $j('input[name$=\'SDPFAM__c\']:radio').attr('title', '');
        
        $j('input[name$=\'SDSIMPH__c\']:checked').removeAttr('checked').change();
        $j('input[name$=\'SDSIMPH__c\']:radio').attr('title', '');
        $j('input[name$=\'SDPIMPH__c\']:checked').removeAttr('checked').change();
        $j('input[name$=\'SDPIMPH__c\']:radio').attr('title', '');
        
        $j("input[name$='SDSIMPF__c']:checked").removeAttr('checked').change();
        $j("input[name$='SDSIMPF__c']:radio").attr('title', '');
        $j("input[name$='SDPIMPF__c']:checked").removeAttr('checked').change();
        $j("input[name$='SDPIMPF__c']:radio").attr('title', '');
        
        $j("input[name$='SDSIMPC__c']:checked").removeAttr('checked').change();
        $j("input[name$='SDSIMPC__c']:radio").attr('title', '');
        $j("input[name$='SDPIMPC__c']:checked").removeAttr('checked').change();
        $j("input[name$='SDPIMPC__c']:radio").attr('title', '');
        
        $j("input[name$='SDSIMPL__c']:checked").removeAttr('checked').change();
        $j("input[name$='SDSIMPL__c']:radio").attr('title', '');        
        $j("input[name$='SDPIMPL__c']:checked").removeAttr('checked').change();
        $j("input[name$='SDPIMPL__c']:radio").attr('title', '');        
        
	    }
}

//function for main sdq symptoms table
$j(document).ready(function () {
    $j('.SDQ').click(function () {
        var radioValue = '';
        var itemNumber = $j(this).val();
        var attrName = $j(this).attr('name');
        radioValue = ($j('#' + attrName + '-' + itemNumber).is(':checked')) ? itemNumber : '';
        $j('.' + attrName).val(radioValue);
    });
    for (var i = 1; i <= 25; i++) { //'i' variable represents question number
        if ($j('.SDQ-' + i).val() != '')
        $j('#SDQ-' + i + '-' + $j('.SDQ-' + i).val()).prop('checked', true);
    }
});

//function for sdq interference w/daily life table
$j(document).ready(function () {
    $j('.SDQI').change(function () {
        var radioValue = '';
        var itemNumber = $j(this).val();
        var attrName = $j(this).attr('name');
        radioValue = ($j('#' + attrName + '-' + itemNumber).is(':checked')) ? itemNumber : '';
        $j('.' + attrName).val(radioValue);
    });
    for (var i = 1; i <= 4; i++) { //'i' variable represents question number
        if ($j('.SDQI-' + i).val() != '')
        $j('#SDQI-' + i + '-' + $j('.SDQI-' + i).val()).prop('checked', true);
    }
});