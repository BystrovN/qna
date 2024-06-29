import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  consumer.subscriptions.create({ channel: "CommentsChannel" }, {
    received(data) {
      const container = document.querySelector(`.comments[data-commentable-type='${data.commentable_type}'][data-commentable-id='${data.commentable_id}']`);
      if (container) {
        let result = this.showComment(data.comment);
        $(container).append(result);
      }
    },

    showComment(comment) {
      return `
        <div class="card mb-2">
          <div class="card-body">
            <h6 class="card-text">${comment.body}</h6>
          </div>
        </div>
      `;
    },
  });
});
