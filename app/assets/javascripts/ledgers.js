/**
 * Created by sashman on 25/05/2015.
 */
$(document).ready(function () {

    $('#ledger_amount_in, #ledger_amount_out').on('input propertychange paste', function (event) {
        var url = $(this).attr('data-href');
        var ledgerable_id = $('#ledger_client_id').val();
        var amount_in = $('#ledger_amount_in').val() || 0;
        var amount_out = $('#ledger_amount_out').val() || 0;

        if ($.isNumeric(amount_in) && $.isNumeric(amount_out)) {
            $.ajax({
                url: url + '?client_id=' + ledgerable_id + '&amount_in=' + amount_in + '&amount_out=' + amount_out,
                success: function (result) {
                    if ($.isNumeric(result)) result = result / 100;
                    $("#ledger_balance").val(result);
                }
            });
        }
    });

});