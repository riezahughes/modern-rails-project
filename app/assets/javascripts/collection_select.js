$(document).ready(function() {

  $('input[list]').change(function(e) {
    update_list_value($(e.target));
  });

  $('input[list]').keyup(function(e) {
    if (!e.keyCode) {
      update_list_value($(e.target));
    }
  });

  $('input[list]').each(function(i, e) {
    update_list_value($(e));
  })

  function update_list_value(target) {
    var input = target;
    if(!input.attr('id')){
      return;
    }

    var list = input.attr('list'),
      options = $('#' + list + ' option'),
      hiddenInput = $('#' + input.attr('id').replace('-input', '')),
      inputValue = input.val();

    hiddenInput.val(inputValue);

    for (var i = 0; i < options.length; i++) {
      var option = options[i];

      if (option.innerText === inputValue) {
        hiddenInput.val($(option).attr('data-value'));
        break;
      }
    }
  }

});
