jQuery(window).load(function() {
    setTimeout ( "hideFlash()", 6000);
});



function hideFlash(){
    jQuery('#signup-color').slideUp('slow');
}


function hideShowValue(object, str,to_do){
    if(to_do == 'hide'){
        if($(object).val() == str ){
            $(object).val('');
        }
    }else if(to_do == 'show'){
        if($(object).val() == ''){
            $(object).val(str);
        }
    }    
}

function submitCheck(elem_id){
    var submit_check = "false"+elem_id;

    if($(elem_id).val() != ""){
        submit_check =  "true"+elem_id;
    }
    else{
        submit_check =  "false"+elem_id;
    }

    if(submit_check == "true"+elem_id){

        $('#buttons_div').toggle();
        $('#uploader_div').toggle();
        return true;
    }else{
        alert('Please enter personal message');
        $('#upload_button').attr('disabled', true);
        return false;
    }

}

function personalMessageCheck(elem_id){
    var pm_check = "false"+elem_id;

    if($(elem_id).val() != ""){
        pm_check =  "true"+elem_id;
    }
    else{
        pm_check =  "false"+elem_id;
    }

    if(pm_check == "true"+elem_id){
        $('#upload_button').css('background-image', "url('/images/simple_button.png')");
        $('#upload_button').attr('disabled', false);
        $('#upload_button').removeAttr('disabled');
        return true;
    }else{
        $('#upload_button').css('background-image', "url('')");
        $('#upload_button').attr('disabled', true);
        return false;
    }
}
