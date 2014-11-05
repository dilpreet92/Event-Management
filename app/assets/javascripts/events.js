$(document).on('ready page:load', function(){
  //Making pagination links work as a ajax request
  $('#results').on('click', '.pagination a', function () {
    $.get(this.href, null, null, 'script');
    return false;
  });
  // Clicking on upcoming tab will submit the form with value upcoming
  $('#event_filter_upcoming').on('change', function() {
    $('#categorySubmit').click();
  });

  //Clicking on past tab will submit the form with value past
  $('#event_filter_past').on('change', function() {
    $('#categorySubmit').click();
  });

  $('.datetimepicker').datetimepicker();

});

