$j(document).ready(function(){//for allowing de-selection of radiobuttons
        
    $j('.nights').change(function(){//script that provides real-time calculation and display of total nights not at home
        var sum  = 0;
        
        $j('.nights').each(function(){
            if($j(this).val() != '') 
                sum += parseInt($j(this).val());
        });
        
        $j('.total span').html(sum);
        $j('.NTTOTN2').val(sum);
        
    });             
    
});   

function unexcusedAbsences() {
    
    var value = parseInt($j('input[name$=\'ABSENT__c\']:checked').val());  
        
    // show absences
    if(value <= 5 && value > 0) {
        $j('.skip-absences').fadeIn('slow');
    }
    // hide absences
    else {
        $j('.skip-absences').fadeOut('slow');
        // unselect the radio button
        $j("input[name$='ABSENTUX__c']:checked").removeAttr('checked');
        $j("input[name$='ABSENTUX__c']:radio").attr('title', '');
    }
    
}