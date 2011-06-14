$(document).ready(function(){
    $.fn.geocompleteAutocomplete = function(address_input_class, geocoder)
    {
        // global var
        var geocomplete_results;

        // add behavior
        function geocompleteFetch(address, callback)
        {
            // lookup address : $location_field.val()
            geocoder.geocode(
            {
                address: address
            },
            function(results, status) {
                // clean coordinates field
                // $("#" + coordinates_input_id).val('');

                if (status == google.maps.GeocoderStatus.OK && results.length)
                {
                    if (status != google.maps.GeocoderStatus.ZERO_RESULTS)
                    {
                        // save results globally
                        geocomplete_results = results;

                        // set autocomplete array for display
                        list = [];
                        for (var i = 0; i < results.length; i++)
                        {
                            // update autocomplete array
                            list[i] = {
                                label: results[i].formatted_address,
                                value: results[i].formatted_address,
                                coordinates: results[i].geometry.location
                            }
                        }

                        if(typeof(callback) == 'function')
                        {
                            callback(list);
                        }
                    }
                    else
                    {
                // zero result
                }
                }
                else
                {
            // status not ok or no result
            }
            }
            );
        }

        // add autocomplete to field
        $("." + address_input_class).autocomplete({
            source: function(request, response) {
                // autocomplete with address
                geocompleteFetch(request.term, response);
            },
            select: function(e, ui) {
            // assign coordinates
            //$("#" + coordinates_input_id).val(ui.item.coordinates);
            }
        });
    }

    $.fn.geocompleteInitialize = function (address_input_class) {
        alert(address_input_class);
        geocoder = new google.maps.Geocoder();
        $().geocompleteAutocomplete(address_input_class, geocoder);
    };
});