class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    redirect_to root_path if is_admin?
  end

  def create
    session[:admin] = params[:password] == ENV["ADMIN_PASSWORD"]
    # log("Admin has logged in", "info") if is_admin?
    redirect_to root_path
  end

  def delete
    session[:admin] = false
    # log("Admin has logged out", "info")
    redirect_to login_path
  end

  private

  def log(message, status)
    # Log.create(sender: "SessionsController", message: message, status: status)
    HipChatAdapter.new.send_message_to_podio_management(message)
  end

end
