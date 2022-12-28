$(document).ready(ready_client_files);
$(document).on('page:change', ready_client_files);

function ready_client_files() {

    $('#next_file_number_link').on('click', function (event) {
        var url = $(this).attr('data-href');
        var type_id = $('.client_file_type_select').val();

        $.ajax({
            url: url + '?client_file_type_id=' + type_id, success: function (result) {
                $(".client_file_file_number").val(result);
            }
        });
    });

    var new_or_exisitng_client_file_select = $('#new_or_exisitng_client_file');
    new_or_exisitng_client_file_select.on("change", function () {
        var selected_value = $(this).val();
        if (selected_value === 'existing_client_file') {
          $('.new_client_file').toggle(false);
          $('.existing_client_file').toggle(true);
        } else {
          $('.new_client_file').toggle(true);
          $('.existing_client_file').toggle(false);
        }
    });
    new_or_exisitng_client_file_select.change();
};
