$(document).ready(function() {

  $('.witness-cited-change').bind("ajax:success", function() {
    var client_file_file_number = $(this).data('file-number');
    var cited_witnesses_list = $('#cited-witnesses-list');
    cited_witnesses_list.empty();

    $.ajax({
      url: '/client_files/' + client_file_file_number + '/witnesses.json',
      success: function(result) {
        $.each(result, function(index, witness) {
          if (witness.cited === true) {
            cited_witnesses_list.append('<li>' + witness.witnessable.name + '</li>');
          }
        });
      }
    });
  });

});
