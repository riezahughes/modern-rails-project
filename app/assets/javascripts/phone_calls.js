$(document).ready(ready_phone_calls);
$(document).on('page:change', ready_phone_calls);

function add_client_file_select_options(client_id){
  if(client_id){

    var client_file_id = location.search.split('client_file_id=')[1];

    $.ajax({
        url: '/clients/' + client_id + '/client_files.js', success: function (result) {
          var result = JSON.parse(result);
          $('#existing_client_file_id').empty();

          if(result.length === 0){
            var option = $('<option></option>').text('No client files');
            $('#existing_client_file_id').append(option);
          } else {

            $('#existing_client_file_id').prop('disabled', false);
            $.each(result, function(i, client_file){
              var option = $('<option></option>')
              .attr("value", client_file.id)
              .text(client_file.file_number + ' - ' + client_file.subject_matter);

              if(client_file.id == client_file_id){
                option.attr('selected','selected');
              }

              $('#existing_client_file_id').append(option);
            });

          }
        }
    });
  }
};

function ready_phone_calls() {

  $('.existing_client_select').bind('railsAutocomplete.select', function(event, data){
    if(data){
      add_client_file_select_options(data.item.id);
    }
  });

  var client_id = $('.client_file_client_id-autocomplete').val();
  add_client_file_select_options(client_id);
};
