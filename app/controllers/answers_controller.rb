class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]

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

  private

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : Question.new
  end

  helper_method :question

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
