class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    redirect_to root_path if is_admin?
  end

  def create
    session[:admin] = params[:password] == ENV["ADMIN_PASSWORD"]
    redirect_to root_path
  end

  def delete
    session[:admin] = false
    redirect_to login_path
  end

end
