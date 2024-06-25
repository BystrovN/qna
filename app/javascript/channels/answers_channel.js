import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  const questionElement = document.querySelector('.question');

  if (questionElement) {
    const questionId = questionElement.getAttribute('data-question-id');
    const currentUserId = gon.current_user ? gon.current_user.id : null;

    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: questionId }, {
      received(data) {
        if (data.answer.user_id !== currentUserId) {
          const isQuestionAuthor = data.question.user_id === currentUserId;
          $('.answers').append(this.showAnswer(data.answer, isQuestionAuthor));
        }
      },

      showAnswer(answer, isQuestionAuthor) {
        let setBestLink = '';
        if (isQuestionAuthor && !answer.best) {
          setBestLink = `
              <p>
                <a href="/answers/${answer.id}/set_best" data-remote="true" data-method="patch">
                  Set as best
                </a>
              </p>
            `;
        }

        return `
          <div class="answer-container">
            <div id="answer_${answer.id}" class="card mb-3">
              <h3 class="card-title">${answer.body}</h3>
              ${setBestLink}
              <div class="answer-rating">
                <p>Rating: 0</p>
              </div>
            </div>
          </div>
        `;
      }
    });
  }
});
