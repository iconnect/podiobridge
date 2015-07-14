class GithubController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :require_login, only: [:create]

  def create
    render nothing: true, status: 200
  end

end
