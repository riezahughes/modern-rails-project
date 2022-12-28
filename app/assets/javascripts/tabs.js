$(document).ready(function () {
    var nav_tabs = $('.nav-tabs a');
    nav_tabs.click(function (e) {
        e.preventDefault();
        localStorage.setItem('lastTab', $(this).attr('href'));
        $(this).tab('show');
    });

    var lastTab = localStorage.getItem('lastTab');
    if (lastTab) {
        $('a[href="' + lastTab + '"]').tab('show');
    }
});