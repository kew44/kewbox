$j(document).ready(function(){
        
    $j('.ptsd-report .ptsd-angle-icon').click(function(){
        
        var sectionNum = $j(this).attr('data-section-number');
        
        // Add the rotate class to ptsd-angle-icon
        $j(this).toggleClass('fa-rotate-90'); 
        
        $j('.ptsd-detail-'+sectionNum).fadeToggle('slow');
        
    });
    
});