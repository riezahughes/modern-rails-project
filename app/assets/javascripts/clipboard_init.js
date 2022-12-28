$(document).ready(function(){
  var clipboard = new Clipboard('.clipboard-btn',
    {
      text: function (trigger) {
        var target = $($(trigger).attr('data-clipboard-target'))
        return target.text();
      }
    });
});
