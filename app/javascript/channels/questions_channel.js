import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  const questionList = document.querySelector('.question-list');

  if (questionList) {
    consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
      received(data) {
        let result = this.showQuestion(data.question);
        $(questionList).append(result);
      },

      showQuestion(question) {
        return `
          <div class="col-sm-4">
            <div class="card mb-3">
              <div class="card-body">
                <h5 class="card-title">
                  <a href="/questions/${question.id}" class="card-link">${question.title}</a>
                </h5>
                <p class="card-text">${this.truncate(question.body, 30)}</p>
              </div>
            </div>
          </div>
        `;
      },

      truncate(text, length) {
        if (text.length <= length) return text;
        return text.substring(0, length) + '...';
      }
    });
  }
});
