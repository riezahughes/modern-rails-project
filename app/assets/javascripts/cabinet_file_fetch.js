$(document).ready(function () {

  var fetch_document_element = $('.fetch_document');

  if(fetch_document_element.length > 0){
    $.ajax({
        url: '/legacy_cabinet_file/fetch_file',
        type: 'PUT',
        data: 'documentable_id=' + fetch_document_element.data('id') + '&documentable_type=' + fetch_document_element.data('type'),
        success: function (result) {

        },
        error: function (xhr, text_status, error) {
          if(xhr.responseText && $('.fetch_error').length > 0){
            $('.fetch_error').html(JSON.parse(xhr.responseText));
          }
        }
    });
  }

});
