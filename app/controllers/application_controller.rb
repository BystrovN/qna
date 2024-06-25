class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :gon_user

  private

  def gon_user
    gon.current_user = current_user
  end
end
