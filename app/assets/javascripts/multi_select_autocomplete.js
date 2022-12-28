$(document).ready(function () {

    $('.multi-select-autocomplete').on('railsAutocomplete.select', function (e, data) {
        var data_id = data.item.id;
        var data_value = data.item.value;
        var item_row_url = $(this).data('item_row_url');

        $.get(
            ROOT_PATH + item_row_url + '.js',
            {'client_file_id': data_id, 'label': data_value},
            function (data, textStatus) {
                $('.witness-multi-select').append(data);
                apply_multi_select_remove();
            },
            'html'
        );
    });

    apply_multi_select_remove();
});

function apply_multi_select_remove() {
  $('.multi-select-item-remove').on('click', function (e, data) {
      $(this).closest('.multi-select-item').remove();
  });
}
