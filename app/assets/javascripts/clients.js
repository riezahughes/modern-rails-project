$(document).ready(ready_clients);
$(document).on('page:change', ready_clients);

function ready_clients() {

  var client_type_select = $('#client_type');
  client_type_select.on("change", function () {
      var selected_value = $(this).val();
      if (selected_value) {
          $('#no_type_selected').toggle(false);

          $("div[class$='fields']").toggle(false);
          $("div[class^='" + selected_value + "']").toggle(true);
          $(".shared_fields").toggle(true);

      } else {
          $('#no_type_selected').toggle(true);
          $("div[class$='fields']").toggle(false);
      }
  });
  client_type_select.change();

  var new_or_exisitng_client_select = $('#new_or_exisitng_client');
  new_or_exisitng_client_select.on("change", function () {
      var selected_value = $(this).val();
      if (selected_value === 'existing_client') {
        $('.new_client').toggle(false);
        $('.existing_client').toggle(true);
      } else {
        $('.new_client').toggle(true);
        $('.existing_client').toggle(false);
      }
  });
  new_or_exisitng_client_select.change();
};
