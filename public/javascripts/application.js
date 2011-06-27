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

