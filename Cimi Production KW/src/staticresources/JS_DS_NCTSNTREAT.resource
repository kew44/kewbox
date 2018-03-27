$j(document).ready(function(){   
	
    // Inherit from SmartSelectionBase class in JS_UTILITY
    smartSelection.extend(SmartSelectionBase);
    
    // Smart selection Q5
    var smartSelectionQ5 = new smartSelection('TXMODPRI__c', 'skip-element-TXOTMOSP');
    
    $j('.smart-select-source-Q5').each(function(){  smartSelectionQ5.action($j(this)); });
    $j('.smart-select-source-Q5').change(function(){  smartSelectionQ5.action($j(this)); }); 
    
    // Update the Q5 other option if TXOTMOSP is changed
    $j('.skip-element-TXOTMOSP').change(function(){ smartSelectionQ5.otherSpecifySync($j(this).val(), "98"); });
    
    // Smart selection Q7
    var smartSelectionQ7 = new smartSelection('TXPRISIP__c', 'skip-element-TXSIOTSP');
    
    $j('.smart-select-source-Q7').each(function(){  smartSelectionQ7.action($j(this)); });
    $j('.smart-select-source-Q7').change(function(){  smartSelectionQ7.action($j(this)); }); 
    
    // Update the Q8 other option if TXSIOTSP is changed
    $j('.skip-element-TXSIOTSP').change(function(){ smartSelectionQ7.otherSpecifySync($j(this).val(), "98"); });
    
    // Smart selection Q10
    var smartSelectionQ10 = new smartSelection('TXLEADCL__c', 'skip-element-TXOCLISP');
    
    $j('.smart-select-source-Q10').each(function(){  smartSelectionQ10.action($j(this)); });
    $j('.smart-select-source-Q10').change(function(){  smartSelectionQ10.action($j(this)); }); 
    
    // Update the Q10 other option if TXOCLISP is changed
    $j('.skip-element-TXOCLISP').change(function(){ smartSelectionQ10.otherSpecifySync($j(this).val(), "98"); });
    
     
});

// Define the structure of smartselection for Q5, Q7, Q10
var smartSelection = function(targetElement, otherField) {  
    
    if (targetElement) this.targetElement = targetElement;  
    if (otherField) this.otherField = otherField; 
    
    // The way smartselection decide to show or hide element
    this.condition = function() {
        
        var QNumber = this.source.attr('data-smart-select');
        
        // Copy the please specify text to the other option when other checkbox is checked
        if(QNumber == "98") { this.otherSpecifySync($j('.'+this.otherField).val(), "98"); }
            
        return this.source.prop('checked');
        
    }
    
}; 