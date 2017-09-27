/*$j(document).ready(function(){        
	$j('input[type="radio"]').click(function(){            
		var previousValue = $j(this).attr('title');
		var val = $j(this).val();
		var name = $j(this).attr('name');      
		
		if (previousValue == val) {  // uncheck radio button
			$j(this).removeAttr('checked').change();
			$j("input[name='"+name+"']:radio").attr('title', '');
		}
		else {
			$j("input[name='"+name+"']:radio").attr('title', val);
		}            
	});        
}); */   

//Q1 table
$j(document).ready(function () {
	$j('.Q1').click(function(){		
		var radioValue = '';
		var itemNumber = $j(this).val();
		var attrName = $j(this).attr('name');
			radioValue = ($j('#'+attrName+'-'+itemNumber).is(':checked')) ? itemNumber : '';
			$j('.' + attrName).val( radioValue );
	});
	for(var i = 1; i <= 6; i++) {  
		if($j('.Q1-' + i).val() != '') 
		$j('#Q1-' + i + '-' + $j('.Q1-'+i).val()).prop('checked',true);
	}  
});

//Q2 table
$j(document).ready(function () {             
	$j('.Q2').click(function(){	
		var radioValue = '';
		var itemNumber = $j(this).val();
		var attrName = $j(this).attr('name');	
		radioValue = ($j('#'+attrName+'-'+itemNumber).is(':checked')) ? itemNumber : '';
		$j('.' + attrName).val( radioValue );	
	});
	for(var i = 1; i <= 6; i++) {  
		if($j('.Q2-' + i).val() != '') 
		$j('#Q2-' + i + '-' + $j('.Q2-'+i).val()).prop('checked',true);
	} 
});	

//Q3 table
$j(document).ready(function () {
	$j('.Q3').click(function(){	
		var radioValue = '';
		var itemNumber = $j(this).val();
		var attrName = $j(this).attr('name');	
		radioValue = ($j('#'+attrName+'-'+itemNumber).is(':checked')) ? itemNumber : '';
		$j('.' + attrName).val( radioValue );	
	});
	for(var i = 1; i <= 12; i++) {  
		if($j('.Q3-' + i).val() != '') 
		$j('#Q3-' + i + '-' + $j('.Q3-'+i).val()).prop('checked',true);
	}   
});

//Q4 table
$j(document).ready(function () {
	$j('.SC_Q1').click(function(){	
		var radioValue = '';
		var itemNumber = $j(this).val();
		var attrName = $j(this).attr('name');	
		radioValue = ($j('#'+attrName+'-'+itemNumber).is(':checked')) ? itemNumber : '';
		$j('.' + attrName).val( radioValue );	
	});
	for(var i = 1; i <= 4; i++) {  
		if($j('.SC_Q1-' + i).val() != '') 
		$j('#SC_Q1-' + i + '-' + $j('.SC_Q1-'+i).val()).prop('checked',true);
	}   
});	

	/*	setTimeout(function(){
			radioValue = ($j('#'+attrName+'-'+itemNumber).is(':checked')) ? itemNumber : '';
			$j('.' + attrName).val( radioValue );
		}, 0);*/


 