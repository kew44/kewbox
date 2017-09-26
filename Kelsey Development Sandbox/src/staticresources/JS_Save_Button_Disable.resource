$j(document).ready(function(){   
    $j('input[type=submit].btn-info').click(function(){
        setTimeout(function(){$j('input[type=submit].btn-info').attr("disabled","disabled");}, 5);
    });
});

function SmartSelection(target, condition) {
    
    var obj = {};
        
    obj.action = function(resource) {
        
        // Get the option value
        var optionNumber = resource.attr('data-smart-select');
        // Find the target select option        
        var targetSelect = $j('select.'+target+' option[value="'+ optionNumber +'"]');
        
        if(condition(resource)) { targetSelect.show(); }
        else {
            // If the selected option has been hidden, the dropdown value would be blank. 
            if($j('select.'+target).val() == optionNumber) {
                $j('select.'+target).val("");
            }
            targetSelect.hide();
        }
        
    };
    
    return obj;    
    
}
