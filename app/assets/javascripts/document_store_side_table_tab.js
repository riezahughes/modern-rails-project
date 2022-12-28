$(document).ready(function () {

    var document_tree = $('.folder_tree');
    var create_folder_button = $('.create_folder');
    var entity_url = document_tree.attr('data-href');

    create_folder_button.toggle();
    document_tree.jstree({
        'core': {
            'data': {
                'url': entity_url + '/folder_contents'
            },
            'error': function (jqXHR, textStatus, errorThrown) {

                var responseJSON = JSON.parse(jqXHR.data).xhr.responseJSON;
                var responseStatus = JSON.parse(jqXHR.data).xhr.status;
                document_tree.html("<div id='document-tree-error'><h4>Error</h4><p>" + responseJSON.message + "</p></div>");

                if (responseStatus == 404) {
                    create_folder_button.toggle(true);
                }

            }
        }
    });

    $('#create_folder_button').on('click', function () {
        var $this = $(this);
        $this.toggle();
        create_folder_button.append("<button class='btn btn-success btn-sm'>Creating...</button>")
    });

    var folder_link = $('.folder_link');
    if (folder_link.length) {
        $.ajax({
            url: entity_url + '/folder_link',
            success: function (result) {
                folder_link.append(result);
            }
        });
    }

});