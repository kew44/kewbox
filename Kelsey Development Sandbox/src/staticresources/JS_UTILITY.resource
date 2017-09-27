/**
* @author Danny Fu
* @date 05/12/2017
*
* @description Script to disable the submit button with class name btn-info. Prventing from the double submission
* @example
*   <input type="submit" value="Save" class="btn btn btn-info btn-sm">   // Save button
*   <input type="submit" value="Cancel" class="btn btn btn-info btn-sm"> // Cancel button
*/
$j(document).ready(function(){   
    $j('input[type=submit].btn-info').click(function(){
        setTimeout(function(){$j('input[type=submit].btn-info').attr("disabled","disabled");}, 5);
    });
});

/**
* @author Danny Fu
* @date 05/12/2017
*
* @description A javascript class for Smart Selection 
* @example
*   // Define the structure of smart selection
*	var SmartSelection = function(targetElement, otherField) {  
*    	if (targetElement) this.targetElement = targetElement; 
*		if (otherField) this.otherField = otherField; 
*    	// Define the condition function
*    	this.condition = function() { return this.source.prop('checked'); }
*	}; 
*    
*   // Inherit from SmartSelectionBase class
*   smartSelection.extend(SmartSelectionBase); 
*    
*   // Define the smartselection object
*   var smartSelection = new SmartSelection('TXPRISIP__c', 'skip-element-TXSIOTSP');
*    
*   // Run the smartselection with a specific source ($j(selector))
*   smartSelection.action(source);
*    
*   // Update the other option text when please specify textfield gets changed
*   smartSelection.otherSpecifySync('Other field text', 'Other option value');
*/
var SmartSelectionBase = {
    targetElement: '',
    source: '',
    condition: function() {},
    action: function(source) {
        
        this.source = source;
        
        // Get the option value
        var optionNumber = source.attr('data-smart-select');
        // Find the target select option        
        var targetSelectOption = $j('select.'+this.targetElement+' option[value="'+ optionNumber +'"]');
        
        if(this.condition()) { 
            targetSelectOption.show(); 
            targetSelectOption.removeAttr('disabled'); 
        }
        else {
            // If the selected option has been hidden, the dropdown value would be blank. 
            if($j('select.'+this.targetElement).val() == optionNumber) {
                $j('select.'+this.targetElement).val("");
            }
            targetSelectOption.hide();
            targetSelectOption.attr('disabled','disabled');
        }
        
    },
    otherSpecifySync: function(otherText, otherOptionValue) {
        var optionText = (otherText == "") ? "" : " - " + otherText;
        $j('select.'+this.targetElement+' option[value="'+otherOptionValue+'"]').text('Other'+optionText);
    }
};

/**
* @author Danny Fu
* @date 05/12/2017
*
* @description A generic funciton to implement the inherit feature
* e.g. :
*	var Animal = {
*       name: '',
*       speak: function(food) {
*           return 'I would like to eat '+food+'!';
*       }
*	}; 
*   var Rabbit = function() {   
*       this.name = 'Rabbit';  
*       this.speak = function() {
*           return 'Rabbits don\'t speak!';
*       };
*   }
*   Rabbit.extend(Animal); 
*   var rabbit1 = new Rabbit();
*   rabbit1.speak(); // displays "Rabbits don't speak!"
*/
Function.prototype.extend = function(parent) {
  var child = this;
  child.prototype = parent;
  child.prototype = new child(Array.prototype.slice.call(1,arguments));
  child.prototype.constructor = child;
}  