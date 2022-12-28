$(document).ready(function () {

  var show_all_checkbox = $('input[name=show_all]');
  show_all_checkbox.click(function() {
    var current_href = window.location.href;
    var params = $.param({show_all: show_all_checkbox.is(':checked')});

    if(current_href.indexOf('show_all=') !== -1){
      window.location.href = current_href.replace(/show_all=(true|false)/gi, "show_all=" + show_all_checkbox.is(':checked'));
    } else {
      if (location.href.match(/\?/)) {
          location.href += params;
      } else {
          location.href += '?' + params;
      }
    }

  });

});
