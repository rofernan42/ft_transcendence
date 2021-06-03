# frozen_string_literal: true

class Registrations::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :configure_permitted_parameters, if: :devise_controller?

  def marvin
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "42") if is_navigational_format?
    else
      session["devise.marvin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
    ActionCable.server.broadcast "users_channel", content: "profile"
  end

  def after_omniauth_failure_path_for scope
    # instead of root_path you can add sign_in_path if you end up to have your own sign_in page.
    root_path
  end
end
