$(document).ready(function() {

  function add_template_options(category, template_type) {
    var template_select = $('#document_template-' + template_type);

    if (category) {
      $.ajax({
        url: '/document_templates/by_category?category=' + encodeURIComponent(category),
        success: function(result) {
          var result = JSON.parse(result);

          template_select.empty();

          if (result.length === 0) {
            var option = $('<option></option>').text('No templates under that category');
            template_select.append(option);
          } else {

            template_select.prop('disabled', false);
            $.each(result, function(i, template) {
              var option = $('<option></option>').attr("value", template.id).text(template.name);
              template_select.append(option);
            });
          }
        }
      });
    } else {
      console.error('Template category is', category);

      template_select.empty();
      var option = $('<option></option>').text('Please select a category').val(undefined);
      template_select.append(option);
      template_select.prop('disabled', true);
    }
  };

  $('.category-select').change(function() {
    var category = this.value;
    var template_type = $(this).data('template-type');

    if (!category) {
      console.error('Category not defined');
      return;
    }

    if (!template_type) {
      console.error('Template Type not defined');
      return;
    }

    add_template_options(category, template_type);
  });

  $('.template-selection').submit(function(event) {
    var template_select = $(this).find('select[name=document_template_id]');
    console.log(template_select.val());
    if (template_select.val() && template_select.val() !== "") {
      return;
    }

    template_select.closest('.form-group').addClass('has-error').find('.help-block').html('Please select a template');

    event.preventDefault();
    $(this).find(':submit').attr("disabled", false);
  });

  $('.category-select').each(function(){
    var category = this.value;
    var template_type = $(this).data('template-type');

    if (!category) {
      console.error('Category not defined');
      return;
    }

    if (!template_type) {
      console.error('Template Type not defined');
      return;
    }

    add_template_options(category, template_type);
  });

});
