$(document).on('ready page:load', function(){
  $('.category :submit').click();
  $('#results').on('click', '.pagination a', function () {
    $.get(this.href, null, null, 'script');
    return false;
  });
  $('#showEvents').on('click', '#allEvents' , function() {
    $('.category :submit').click();
  });
})
