$(document).ready(function () {
  open_webdav_link();
});

function open_webdav_link(){
  var webdav_div = $('#open-webdav-url');
  if(webdav_div.length){
    open_webdav_url(webdav_div.data('url'));
  }
}

function open_webdav_url(url){
  window.open(url, "_parent");
}
