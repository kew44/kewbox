$j(document).ready(function(){  
    // Assign the radio button value to associate fields
    $j('.Clineval').click(function(){
                      
        var radioValue = '';
        var itemNumber = $j(this).val();
        var attrName = $j(this).attr('name');
        
        setTimeout(function(){
            radioValue = ($j('#'+attrName+'-'+itemNumber).is(':checked')) ? itemNumber : '';
            $j('.' + attrName).val( radioValue );
        }, 0);
        
    });
    
    for(var i = 1; i <= 32; i++) {  
        if($j('.Clineval-' + i).val() != '') 
            $j('#Clineval-' + i + '-' + $j('.Clineval-'+i).val()).prop('checked',true);
    }  
	
    // smartSelection inherit from SmartSelectionBase class in JS_UTILITY
    smartSelection.extend(SmartSelectionBase);
    
    // Define smartselection function for Q32
    var smartSelectionQ32 = new smartSelection('CEPRIM__c', 'skip-element-CEOTHER');
    
    // Apply the smart selection function on all the inputs which have data-smart-select attribute 
    $j("input[data-smart-select]").each(function(){ smartSelectionQ32.action($j(this)); });
    $j("input[data-smart-select]").change(function(){ smartSelectionQ32.action($j(this)); });
    
    // Update the Q32 other option if CEOTHER is changed
    $j('.skip-element-CEOTHER').change(function(){ smartSelectionQ32.otherSpecifySync($j(this).val(), "98"); });
    
    
});

// Define the structure of smartselection for Q32
var smartSelection = function(targetElement, otherField) {  
    
    if (targetElement) this.targetElement = targetElement;  
    if (otherField) this.otherField = otherField; 
    
    // The way smartselection decide to show or hide element
    this.condition = function() {
        
        var QNumber = this.source.attr('data-smart-select');
        
        // Copy the please specify text to the other option when Q31 is selected
        if(QNumber == "98") { this.otherSpecifySync($j('.'+otherField).val(), "98"); }
        
        var value = $j("input[data-smart-select='"+QNumber+"']:checked").val();
            
        return (value == 1 || value == 2) ? true : false;
        
    }
    
} 




      