$(document).on('ready page:load', function(){
  //Submitting the form on page load for upcoming radio button
  $('#categorySubmit').click();
  //Making pagination links work as a ajax request
  $('#results').on('click', '.pagination a', function () {
    $.get(this.href, null, null, 'script');
    return false;
  });
  //Clicking on all events will submit the form with radio button upcoming clicked
  $('#allEvents').on('click', function() {
    $('#showEvents').find('.active').removeClass('active');
    $(this).parent('div').addClass('active');
    $('#categorySubmit').click();
  });

  $('#mineEvents').on('click', function() {
    $('#showEvents').find('.active').removeClass('active');
    $(this).parent('div').addClass('active');
    $('#categorySubmit').click();
  });

  $('#attendingEvents').on('click',function() {
    $('#showEvents').find('.active').removeClass('active');
    $(this).parent('div').addClass('active');
    $('#categorySubmit').click();
  });

  // Clicking on upcoming tab will submit the form with value upcoming
  $('#events_filter_upcoming').on('change', function() {
    //$(this).parent('form').trigger('submit');
    $('#categorySubmit').click();
  });

  //Clicking on past tab will submit the form with value past
  $('#events_filter_past').on('change', function() {
    //$(this).parent('form').trigger('submit');
    $('#categorySubmit').click();
  });

});

