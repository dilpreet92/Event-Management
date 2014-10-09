$(document).ready(function(){
  $('.category :submit').click();
  $('#results').on('click', '.pagination a', function () {
    $.get(this.href, null, null, 'script');
    return false;
  });
  $('#allEvents').on('click', function() {
    location.reload(true);
  });
})
