$(document).ready(function () {

    //TODO: fix id selector
    $(document).bind('ajaxError', 'div.modal-body > form', function (event, jqxhr, settings, exception) {

        // note: jqxhr.responseJSON undefined, parsing responseText instead
        if (jqxhr.responseText) {
            $(event.data).render_form_errors($.parseJSON(jqxhr.responseText));
        }

    });

    $(".modal-dialog form").submit(function (e) {
      var submit_button = $(this).closest('form').find(':submit');
      submit_button.attr("disabled", true);
      return true;
    });

});

(function ($) {

    $.fn.modal_success = function () {
        // close modal
        this.modal('hide');

        // clear form input elements
        // todo/note: handle textarea, select, etc
        //this.find('form input[type="text"]').val('');

        // clear error state
        this.clear_previous_errors();

        var submit_button = $(".modal-dialog form").closest('form').find(':submit');
        submit_button.attr("disabled", false);
    };

    $.fn.render_form_errors = function (errors) {

        $form = this;
        this.clear_previous_errors();
        model = this.data('model');

        if (model) {
            // show error messages in input form-group help-block
            $.each(errors, function (field, messages) {
                if ($.isArray(messages) && messages.length > 0) {
                    $input = $('[name="' + model + '[' + field + ']"], label:contains("' + field.charAt(0).toUpperCase() + field.substring(1) + '")');
                    $input.closest('.form-group').addClass('has-error').find('.help-block').html(messages.join(' & '));
                }
            });
        }

        var submit_button = $(".modal-dialog form").closest('form').find(':submit');
        submit_button.attr("disabled", false);
    };

    $.fn.clear_previous_errors = function () {
        $('.form-group.has-error', this).each(function () {
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });
    }

}(jQuery));
