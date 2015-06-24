class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    redirect_to root_path if session[:admin]
  end

  def create
    # binding.pry
    session[:admin] = params[:password] == ENV["ADMIN_PASSWORD"]
    redirect_to root_path
  end

  def logout
    session[:admin] = false
    redirect_to login_path
  end

end
