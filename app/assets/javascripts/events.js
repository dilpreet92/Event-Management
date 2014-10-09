$(document).on('ready page:load', function(){
  // FIXME_AB: Its better if we can use id selector or any other precise selector.
  $('.category :submit').click();
  $('#results').on('click', '.pagination a', function () {
    $.get(this.href, null, null, 'script');
    return false;
  });
  $('#showEvents').on('click', '#allEvents' , function() {
    $('.category :submit').click();
  });
})

// FIXME_AB: JS could be very unreadable so start adding comments