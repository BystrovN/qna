class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    handle_auth 'Github'
  end

  def vkontakte
    handle_auth 'Vkontakte'
  end

  def failure
    redirect_to root_path, alert: 'Something went wrong'
  end

  private

  def handle_auth(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
