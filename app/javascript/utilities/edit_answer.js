$(document).on('turbolinks:load', function () {
  $(document).on('click', '.edit-answer-link', function (e) {
    e.preventDefault();
    const $link = $(this);
    $link.hide();
    const answerId = $link.data('answerId');
    console.log(answerId);
    $(`#edit-answer-${answerId}`).removeClass('hidden');
  });
});
