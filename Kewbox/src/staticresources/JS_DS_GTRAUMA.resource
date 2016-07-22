function expCheck() {
    $j('.GT-checkbox').each(function(){ $j(this).attr("disabled", true); });
    $j('.GT23Q').append($j('#other-content'));
}

expCheck.prototype.oper = function(resource){
    
    var value = resource.val();
    
    var targetCheck = $j('.'+resource.parent('td').attr('data-type'));
    var targetTD = $j('.'+resource.parent('td').attr('data-type')+'TD');
    
    var num = resource.parent('td').attr('data-num');
    
    if((value==2) || (value== 1)) {
        
        // Only show the age under current age
        targetTD.each(function(){
            
            if(parseInt($j(this).attr('data-age')) <= clientAge || 
               $j(this).attr('data-age') == 'unk') {
                $j(this).children('input').removeAttr("disabled");
                $j(this).addClass('GT-age-pointer');
            }
        });
        
        $j('.GT-primary select option[value="'+ num +'"]').show();
    }
    else {
        targetTD.removeClass('GT-age-pointer');
        targetTD.removeClass('GT-age-sel');
        targetCheck.prop('checked', false);
        targetCheck.attr("disabled", true);
        $j('.GT-primary select option[value="'+ num +'"]').hide();
    }                 
}

$j(document).ready(function() {
    
    var exp = new expCheck();
    
    $j('.GT-exp').each(function(){ exp.oper($j(this)); });
    $j('.GT-exp').change(function(){ exp.oper($j(this)); });
    $j('.GT-td-age').click(function(){
        
        if(parseInt($j(this).attr('data-age')) > clientAge) 
            return 0;
        
        if($j(this).hasClass('GT-age-sel')) {  // If the age is selected 
            
            $j(this).children('input').prop('checked', false);
            $j(this).removeClass('GT-age-sel');
            
            if($j(this).hasClass('GT-td-unk')) {
                // Only show the age under current age
                $j('.GT'+$j(this).attr('data-type')+'ATDNUM').each(function(){ 
                    if(parseInt($j(this).attr('data-age')) <= clientAge)
                        $j(this).addClass('GT-age-pointer');
                });
            }
        }
        else {
            if(!$j(this).children('input').attr("disabled") && 
               !$j('.GT'+$j(this).attr('data-type')+'UNK').hasClass('GT-age-sel')) {
                
                $j(this).children('input').prop('checked', true);
                $j(this).addClass('GT-age-sel');
                
                if($j(this).hasClass('GT-td-unk')) { // Select unknown
                    
                    $j('.GT'+$j(this).attr('data-type')+'ACHK').each(function(){
                        if($j(this).is(':checked'))
                            $j(this).trigger("click");
                    }); 
                    $j('.GT'+$j(this).attr('data-type')+'ATDNUM').removeClass('GT-age-pointer');
                }
            }
        }
    });
    
    $j('.GT-td-age').each(function(){
        
        if($j(this).children('input').is(':checked'))
            $j(this).addClass('GT-age-sel');
        
        if($j(this).hasClass('GT'+$j(this).attr('data-type')+'ATDNUM') && 
           $j('.GT'+$j(this).attr('data-type')+'UNKCHK').is(':checked')) {
            $j(this).removeClass('GT-age-pointer');
        }
    });
    
    $j('.GT-checkbox').change(function(){
        if(!$j(this).is(':checked'))
            $j(this).parent().removeClass('GT-age-sel');
    });
});  