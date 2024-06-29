module Commented
  extend ActiveSupport::Concern

  included do
    before_action :find_commentable, only: :add_comment

    after_action :publish_comment, only: :add_comment
  end

  def add_comment
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
    render 'comments/add_comment'
  end

  private

  def find_commentable
    @commentable = controller_name.classify.constantize.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      'CommentsChannel',
      { comment: @comment, commentable_type: @commentable.class.to_s, commentable_id: @commentable.id }
    )
  end
end
