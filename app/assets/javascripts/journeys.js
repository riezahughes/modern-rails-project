$(document).ready(function () {

  $("#journey_user_id").change(set_journey_user_on_travels);
  set_journey_user_on_travels();

  var submit_button = $(".journey-submit");
  submit_button.toggle(false);

  $('.meeting_client_file_select').bind('railsAutocomplete.select', function(event, data){
    if(data){
      var options_list = $('#meeting_for_client_file');
      var resource_name = 'meetings';

      add_select_options(data.item.value, options_list, resource_name, meeting_text);
    }
  });

  $('.court_date_client_file_select').bind('railsAutocomplete.select', function(event, data){
    if(data){
      var options_list = $('#court_date_for_client_file');
      var resource_name = 'court_dates';

      add_select_options(data.item.value, options_list, resource_name, court_date_text);
    }
  });

  function set_journey_user_on_travels(event){
    var user_select;
    if(!event){
      user_select = $("#journey_user_id");
    } else {
      user_select = $(event.delegateTarget);
    }

    var selected_user_id = user_select.find(":selected").val();
    $('form.add_travel_to_form #travel_user_id').val(selected_user_id);
  }

  function meeting_text(meeting) {
    return meeting.date + ' ' + meeting.type + ' ' + meeting.attendance_with + ': ' + meeting.description;
  }

  function court_date_text(court_date) {
    return court_date.date + ' ' + court_date.court + ' ' + court_date.type;
  }

  function add_select_options(client_file_id, options_list, resource_name, record_text){

    if(client_file_id){
      var list_url = '/client_files/' + client_file_id + '/' + resource_name;

      $.ajax({
          url: list_url, success: function (result) {
            var result = JSON.parse(result);
            options_list.empty();

            if(result.length === 0){
              var option = $('<option></option>').text('No ' + resource_name);
              options_list.append(option);
            } else {

              options_list.prop('disabled', false);
              $.each(result, function(i, record){
                var option = $('<option></option>')
                .attr("value", record.id)
                .text(record_text(record));

                if(record.id === client_file_id){
                  option.attr('selected','selected');
                }

                options_list.append(option);
              });

            }
          }
      });
    }
  };
});
