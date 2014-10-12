$(document).on('ready page:load', function(){
  // FIXED: Its better if we can use id selector or any other precise selector.
  //Submitting the form on page load for upcoming radio button
  $('form.category :submit').click();
  //Making pagination links work as a ajax request
  $('#results').on('click', '.pagination a', function () {
    $.get(this.href, null, null, 'script');
    return false;
  });
  //Clicking on all events will submit the form with radio button upcoming clicked
  $('#showEvents').on('click', '#allEvents' , function() {
    $('.category :submit').click();
  });

  $('#events_filter_upcoming').on('change', function() {
    $(this).parent('form').trigger('submit');
  });

  $('#events_filter_past').on('change', function() {
    $(this).parent('form').trigger('submit');
  });
})

// FIXME_AB: JS could be very unreadable so start adding comments