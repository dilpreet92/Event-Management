$(document).on('ready page:change', function(){

  $('#user_filter_enabled').on('change', function() {
    $('#categorySubmit').click();
  });

  $('#user_filter_disabled').on('change', function() {
    $('#categorySubmit').click();
  });

});