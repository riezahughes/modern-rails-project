$(document).ready(function() {

  $('.recharge-items-button').attr('disabled', true);

  $('input[type=checkbox].charge_item_select').click(function(event){
    var number_of_selected_items = $('input[type=checkbox].charge_item_select:checked').length;
    if( number_of_selected_items <= 0){
      $('.recharge-items-button').attr('disabled', true);
    } else {
      $('.recharge-items-button').attr('disabled', false);
    }

    $('.selected-recharge-items-label').html('Selected ' + number_of_selected_items + ' items');
  });

  $('.recharge-form').submit(function(event){

    var selected_items = $('input[type=checkbox].charge_item_select:checked');
    var form = $('.recharge-form');

    $.each(selected_items, function(index, selected_item){
      var input = $("<input>")
                 .attr("type", "hidden")
                 .attr("name", selected_item.name)
                 .val(selected_item.value);
      form.append($(input));
    });
  });
});
