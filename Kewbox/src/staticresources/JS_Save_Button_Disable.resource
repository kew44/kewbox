$j(document).ready(function(){   
    $j('input[type=submit].btn-info').click(function(){
        setTimeout(function(){$j('input[type=submit].btn-info').attr("disabled","disabled");}, 5);
    });
});