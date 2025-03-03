$(document).on('turbolinks:load', function() {
  function checkVoting() {
    $('a.voting').on('ajax:success', function(e) {
      var resource = $(this).data('resource');
      var id = $(this).data('id');
      var response = e.detail[0];

      if (response.error) {
        $('#' + resource + '-error-' + id).text(response.error);
      } else {
        $('#' + resource + '-rating-' + id).text(response.rating);
      }
    });

    $('a.voting').on('ajax:error', function(e) {
      var error = e.detail[0].error;
      $('.question-errors').empty().append('<p>' + error + '</p>');
    });
  }

  window.checkVoting = checkVoting;
  checkVoting();
});