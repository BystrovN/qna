class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = question
    @answer.save
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
    @question = @answer.question
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to question_path(answer.question.id), notice: 'Answer successfully deleted.'
    else
      redirect_to question_path(answer.question.id), alert: 'You are not allowed to delete this answer.'
    end
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
