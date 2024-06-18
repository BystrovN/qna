function handleVoteSuccess(event) {
  var response = event.detail[0];
  if (response.success) {
    var ratingElement = $(this).closest('.votes').find('.rating-count');
    ratingElement.text(response.rating);
  } else {
    console.error('Vote operation failed:', response.errors);
  }
}

function handleVoteError(event) {
  var errors = event.detail[0];
  console.error('Vote operation failed:', errors);
}

$(document).on('turbolinks:load', function () {
  $('.votes').on('ajax:success', handleVoteSuccess).on('ajax:error', handleVoteError);
});
