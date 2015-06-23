class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new    
  end

  def create
    # binding.pry
    session[:admin] = params[:password] == ENV["ADMIN_PASSWORD"]
    redirect_to root_path
  end

end
