class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }
  before_filter -> { flash.now[:alert] = flash[:alert].html_safe if flash[:html_safe] && flash[:alert] }

    protected

  def configure_permitted_parameters
    # TODO: setup with proper user params
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :id_number, :access_code, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    # TODO: setup with proper user params
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :first_name, :last_name, :email, :password, :password_confirmation, :current_password) }
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def append_info_to_payload(payload)
    super
    payload[:remote_ip] = request.remote_ip
  end
end
