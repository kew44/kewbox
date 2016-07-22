$j(document).ready(function(){
        
    $j('.Q1').click(function(){
        
        var radioValue = '';
        var itemNumber = $j(this).val();
        var attrName = $j(this).attr('name');
        
        radioValue = ($j('#'+attrName+'-'+itemNumber).is(':checked')) ? itemNumber : '';
        $j('.' + attrName).val( radioValue );
        
    });
    
    for(var i = 1; i <= 17; i++) {  //'i' variable represents question number
        if($j('.Q1-' + i).val() != '') 
            $j('#Q1-' + i + '-' + $j('.Q1-'+i).val()).prop('checked',true);
    }          
    
});