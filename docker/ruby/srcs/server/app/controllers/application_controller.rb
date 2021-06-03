class ApplicationController < ActionController::Base
    before_action :banned?
    before_action :configure_permitted_parameters, if: :devise_controller?
    rescue_from ActionController::UnknownFormat, :with => :template_not_found

    def error_404
        redirect_to "/404"
    end

    def template_not_found
        redirect_to "/404"
    end

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])
        devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
    end

    def is_superuser(user)
        if user.superuser == true
            return true
        end
        return false
    end

    def is_sadmin(user)
        if user.admin == true
            return true
        end
        return false
    end

    def banned?
        if current_user.present? && current_user.banned?
            sign_out current_user
            redirect_to root_path
        end
    end
end
