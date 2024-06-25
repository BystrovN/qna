class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'QuestionsChannel'
  end
end
