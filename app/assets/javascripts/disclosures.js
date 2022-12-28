$(document).ready(function () {
    $('.page-numbering-row').toggle(false);
    $('.page-numbering-row').toggle(false);

    $('.page-numbering-row-toggle').on('click', function () {
        $('#' + $(this).data('toggle')).toggle();
    });

    $('#upload-to-document-store-submit').on('click', function () {
        var $this = $(this);
        $this.toggle();
        $('.link-delete').toggle(false);
        $('#upload-to-document-store-placeholder')
            .append('<div id="upload-to-document-store-loading" class="progress" style="width: 15%;">' +
                '<div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="100" style="width: 100%;" >' +
                'Uploading...</div></div>')
    });

    $('.link-delete').on('confirm:complete', function (e, answer) {
        if (answer) {
            $(this).toggle(false);
            $('#link-delete-placeholder' + $(this).data('id'))
                .append('<div id="deleting-loading" class="progress" style="width: 100%;">' +
                    '<div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="100" style="width: 100%;" >' +
                    'Deleting...</div></div>')
        }
    });

    $('.link-delete').bind('ajax:complete', function () {
        var disclosure_id = $(this).data('id');
        $('#disclosure-document-row-' + disclosure_id).remove();
        $('#page-numbering-row-' + disclosure_id).remove();

        if ($('#disclosures_table').children('tbody').children().length === 0) {
            $('#upload-to-document-store-placeholder').toggle(false);
        }

    });

    $('.document_link').each(function () {
        var current_link = $(this);
        $.ajax({
            url: '/' + current_link.data('entity') + '/document_link',
            success: function (result) {
                current_link.empty();
                current_link.append(result);
            }
        });
    });

});