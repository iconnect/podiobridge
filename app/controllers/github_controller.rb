class GithubController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :require_login, only: [:create]

  def create
    # binding.pry
    GithubAdapter.new.extract_issue(params)
    Log.create(
      sender: "GithubController", 
      message: params[:github][:action],
      status: "success"
      )
    render nothing: true, status: 200
  end

end
