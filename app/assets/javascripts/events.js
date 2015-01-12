function CheckEvent() {}

CheckEvent.prototype.bindEvents = function() {

  //Making pagination links work as a ajax request

  $('#modal').hide();

  $('#results').on('click', '.pagination a', function () {
    $.get(this.href, null, null, 'script');
    return false;
  });
  // Clicking on upcoming tab will submit the form with value upcoming
  $('#event_filter_upcoming').on('change', function() {
    $('#categorySubmit').click();
  });

  $('#searchButton').on('click', function() {
    $('#showEvents').hide();
  });

  //Clicking on past tab will submit the form with value past
  $('#event_filter_past').on('change', function() {
    $('#categorySubmit').click();
  });

  $('.datetimepicker').datetimepicker();

  $('FORM').nestedFields();

  $('a[data-popup]').on('click', function() {
    $('#modal').show();
  });

  $('a[data-dismiss]').on('click', function() {
    $('#modal').hide();
  });

};

$(document).on('ready page:change', function(){

  var event = new CheckEvent();
  event.bindEvents();

});

