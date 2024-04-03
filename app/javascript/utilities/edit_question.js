$(document).on('turbolinks:load', function () {
  $(document).on('click', '.edit-question-link', function (e) {
    e.preventDefault();
    const $link = $(this);
    $link.hide();
    const questionId = $link.data('questionId');
    console.log(questionId);
    $(`#edit-question-${questionId}`).removeClass('hidden');
  });
});
