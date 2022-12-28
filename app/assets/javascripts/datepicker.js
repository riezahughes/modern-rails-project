$(document).ready(function () {
  $('.date-select').datepicker({
      format: 'dd/mm/yyyy',
      assumeNearbyYear: true,
      clearBtn: true,
      keyboardNavigation: false
  });
});
