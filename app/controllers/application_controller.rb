class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login

  private

  def require_login
    redirect_to login_path unless is_admin?
  end

  helper_method :is_admin?
  def is_admin?
    session[:admin]
  end

end
