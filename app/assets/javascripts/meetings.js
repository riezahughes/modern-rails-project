$(document).ready(function() {

  const input_selector = "input[name^=meeting], select[name^=meeting]"

  $(input_selector).change(function(){
    var field_id = $(this).attr('id');
    var field_value = $(this).val();

    $('.' + field_id + '-template-display').html(field_value);
    $('.' + field_id + '-template-value').val(field_value);
  });

  $(input_selector).change();

  $("#meeting_witness_id").change(function() {
     var selected_witness = $(this).find(":selected").text();
     $("#meeting_attendance_with").val(selected_witness);
  });

  $("#new_meetings_modal").click(set_template_fields)

  function set_template_fields() {
    $(input_selector).each(function(i, element){
      var field_id = $(element).attr('id');
      var field_value = $(element).val();

      $('.' + field_id + '-template-display').html(field_value);
      $('.' + field_id + '-template-value').val(field_value);
    });
  }
});
