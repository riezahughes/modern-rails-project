$(document).ready(function () {

  var documentable_type_select = $('.documentable_type-select');
  documentable_type_select.on("change", function () {
      var selected_value = $(this).val();
      if (selected_value) {
          $("div.documentable_type").toggle(false);
          $("div.documentable_type>input").prop('disabled', true);
          $("div." + selected_value + "-documentable").toggle(true);
          $("div." + selected_value + "-documentable>input").prop('disabled', false);

      } else {
          $("div.documentable_type").toggle(false);
          $("div.documentable_type>input").prop('disabled', true);
          $("div.documentable_type").first().toggle(true);
          $("div.documentable_type>input").first().prop('disabled', false);
      }
  });
  documentable_type_select.change();

});
