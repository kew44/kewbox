 function developmentModule(value, init){//development module criteria
        
    console.log(value);
	
    value = $j('input[name$=\'DEVEL__c\']:checked').val();  
    console.log(value);
	
        if( value == '1' ){// minor development 
		
			$j('.skip-dev').show();//<!--show choices of mild developmental concerns--> 
            			
            $j('.skip-mid').hide();//<!--hide moderate developmental concerns-->
				$j('.skip-element-DMOREC').prop('checked', false);
				$j('.skip-element-DMOEXP').prop('checked', false);
				$j('.skip-element-DMOCOG').prop('checked', false);
				$j('.skip-element-DMOMOT').prop('checked', false);
				$j('.skip-element-DMOSOC').prop('checked', false);	
				
				//$( "input:DMOREC__c:checked" ).val();
			
            $j('.skip-sev').hide();// <!--hide severe developmental problems-->
				$j('.skip-element-DSEREC').prop('checked', false);
				$j('.skip-element-DSEEXP').prop('checked', false);
				$j('.skip-element-DSECOG').prop('checked', false);
				$j('.skip-element-DSEMOT').prop('checked', false);
				$j('.skip-element-DSESOC').prop('checked', false);
        }
        else if (value == '2'){//moderate developmental problem
		
			$j('.skip-mid').show();//<!--show choices of moderate developmental concerns--> 
              
			$j('.skip-dev').hide();//<!--hide  mild developmental concerns-->             
				$j('.skip-element-DMIREC').prop('checked', false);
				$j('.skip-element-DMIEXP').prop('checked', false);
				$j('.skip-element-DMICOG').prop('checked', false);
				$j('.skip-element-DMIMOT').prop('checked', false);
				$j('.skip-element-DMISOC').prop('checked', false);
				
			$j('.skip-sev').hide();//<!--hide severe developmental problems-->
				$j('.skip-element-DSEREC').prop('checked', false);
				$j('.skip-element-DSEEXP').prop('checked', false);
				$j('.skip-element-DSECOG').prop('checked', false);
				$j('.skip-element-DSEMOT').prop('checked', false);
				$j('.skip-element-DSESOC').prop('checked', false);
        }
		else if (value == '3'){//severe developmental problems
			$j('.skip-sev').show();//<!--show choices of severe developmental problems--> 
			
			$j('.skip-dev').hide();//<!--hide  mild developmental concerns--> 
				$j('.skip-element-DMIREC').prop('checked', false);
				$j('.skip-element-DMIEXP').prop('checked', false);
				$j('.skip-element-DMICOG').prop('checked', false);
				$j('.skip-element-DMIMOT').prop('checked', false);
				$j('.skip-element-DMISOC').prop('checked', false);
			
			$j('.skip-mid').hide();//<!--hide moderate developmental concerns-->
				$j('.skip-element-DMOREC').prop('checked', false);
				$j('.skip-element-DMOEXP').prop('checked', false);
				$j('.skip-element-DMOCOG').prop('checked', false);
				$j('.skip-element-DMOMOT').prop('checked', false);
				$j('.skip-element-DMOSOC').prop('checked', false);
		}        
		else{//no concerns or unknown concerns
		
			$j('.skip-dev').hide();//<!--hide  mild developmental concerns--> 
				$j('.skip-element-DMIREC').prop('checked', false);
				$j('.skip-element-DMIEXP').prop('checked', false);
				$j('.skip-element-DMICOG').prop('checked', false);
				$j('.skip-element-DMIMOT').prop('checked', false);
				$j('.skip-element-DMISOC').prop('checked', false);
				
			$j('.skip-mid').hide();//<!--hide moderate developmental concerns-->
				$j('.skip-element-DMOREC').prop('checked', false);
				$j('.skip-element-DMOEXP').prop('checked', false);
				$j('.skip-element-DMOCOG').prop('checked', false);
				$j('.skip-element-DMOMOT').prop('checked', false);
				$j('.skip-element-DMOSOC').prop('checked', false);
				
			$j('.skip-sev').hide();//<!--hide severe developmental problems-->    
				$j('.skip-element-DSEREC').prop('checked', false);
				$j('.skip-element-DSEEXP').prop('checked', false);
				$j('.skip-element-DSECOG').prop('checked', false);
				$j('.skip-element-DSEMOT').prop('checked', false);
				$j('.skip-element-DSESOC').prop('checked', false);
		}
    console.log(value);

    }    