class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :gon_user

  private

  def gon_user
    gon.current_user = current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization unless: :devise_controller?
end
