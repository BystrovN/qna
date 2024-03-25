class AnswersController < ApplicationController
  def new; end

  def create
    @answer = question.answers.build(answer_params)

    if @answer.save
      redirect_to question_path(question)
    else
      render :new
    end
  end

  private

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : Question.new
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
