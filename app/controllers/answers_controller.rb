class AnswersController < ApplicationController
  include Voted
  include Commented

  skip_before_action :authenticate_user!, only: [:show]

  after_action :publish_answer, only: [:create]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = question
    @answer.save
  end

  def update
    return head :forbidden unless current_user.author_of?(answer)

    answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    return head :forbidden unless current_user.author_of?(answer)

    answer.destroy
  end

  def best
    return head :forbidden unless current_user.author_of?(answer.question)

    answer.set_best!
    @question = @answer.question
  end

  private

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : Question.new
  end

  helper_method :question

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("answers_for_question_#{@question.id}", { answer: @answer, question: @question })
  end
end
