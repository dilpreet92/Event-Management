$(document).on('ready page:load', function(){
  //Submitting the form on page load for upcoming radio button
  $('form.category :submit').click();
  //Making pagination links work as a ajax request
  $('#results').on('click', '.pagination a', function () {
    $.get(this.href, null, null, 'script');
    return false;
  });
  //Clicking on all events will submit the form with radio button upcoming clicked
  $('#showEvents').on('click', '#allEvents #attendingEvents' , function() {
    $('.category :submit').click();
  });

  // $('#myEvents').on('click', function() {
  //   $('#mineCategorySubmit').click();
  // });
  // Clicking on upcoming tab will submit the form with value upcoming
  $('#events_filter_upcoming').on('change', function() {
    $(this).parent('form').trigger('submit');
  });
  
  //Clicking on past tab will submit the form with value past
  $('#events_filter_past').on('change', function() {
    $(this).parent('form').trigger('submit');
  });

  $('#clearText').on('click', function() {
    $('#search').val('');
  });
})

