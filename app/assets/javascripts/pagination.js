$(document).ready(function () {
    var per_page_select = $('select[name=per_page]');
    per_page_select.change(function() {
      var current_href = window.location.href;
      var value = $(this).find(":selected").val();
      var params = $.param({per_page: value});

      if(current_href.indexOf('per_page=') !== -1){
        window.location.href = current_href.replace(/per_page=(\d+)/gi, "per_page=" + value);
      } else {
        if (location.href.match(/\?/)) {
            location.href += params;
        } else {
            location.href += '?' + params;
        }
      }

    });
});
