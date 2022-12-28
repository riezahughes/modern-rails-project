$(document).ready(function() {
  var submit_button = $('.submit-change-aware');

  $("input, textarea, select")
    .not(".show-all")
    .not(".no-sumbit-check")
    .not("select[name=per_page]")
    .not("[type=search]")
    .on("input change", function() {
    window.onbeforeunload = window.onbeforeunload || function(e) {
      return true;
    };

    submit_button.addClass('btn-danger');
    submit_button.removeClass('btn-default');
    submit_button.attr('data-toggle', 'tooltip');
    submit_button.attr('title', 'You have unsaved changes');
  });

  $('form').submit(function() {
    window.onbeforeunload = null;

    submit_button.addClass('btn-default');
    submit_button.removeClass('btn-danger');
    submit_button.removeAttr('data-toggle');
    submit_button.removeAttr('title');
  });
});
