$j(document).ready(function(){ 
	
	//Family Member Table Initialization
	Q4_member_table();
	
	$j('input[name$="MILSERV"]').change(function(){ Q4_member_table(); });        
});

function Q4_member_table() {//family member table
	
	var MILSERV_value = $j('input[name$="MILSERV"]:checked').val();
	var MILSERV_Trigger = ['1', '2', '3', '4'];//number of family members
	
	MILSERV_value = (MILSERV_value == '5') ? '4' : MILSERV_value;
	
	// Show table
	if(jQuery.inArray(MILSERV_value, MILSERV_Trigger) != -1) {
		
		$j('.family-none-div').hide();//do not show table if 0 members indicated
		
		for(var i = 1; i <= 4; i++) {
			if (i <= MILSERV_value) { // show row
				$j('.family-row-'+i.toString()).show();
			}
			else {                     // hide row and uncheck radio buttons                    
				$j('.family-row-'+i.toString()+' input').each(function(){
					$j(this).removeAttr('checked').change();
				});                    
				$j('.family-row-'+i).hide();                     
			}
		}            
		$j('.family-table-div').show();            
	}
	else {            
		$j('.family-none-div').show();
		$j('.family-table-div').hide();             
		$j('.family-table-div input').each(function(){
			$j(this).removeAttr('checked').change();
		});            
	}        
}          