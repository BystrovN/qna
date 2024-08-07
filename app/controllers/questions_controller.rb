class QuestionsController < ApplicationController
  include Voted
  include Commented

  skip_before_action :authenticate_user!, only: %i[index show]

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    question
    @answer = Answer.new(question: @question)
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def edit
    question
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    if can? :destroy, question
      question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted.'
    else
      redirect_to question, alert: 'You are not allowed to delete this question.'
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(
      :title, :body, files: [], links_attributes: %i[name url _destroy], reward_attributes: %i[title image]
    )
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('QuestionsChannel', { question: @question })
  end
end
