class GithubController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :require_login, only: [:create]

  def create
    # binding.pry
    Log.create(
      sender: "GithubController", 
      message: params[:github][:action],
      status: "success"
      )
    GithubAdapter.new.extract_issue(params)
    render nothing: true, status: 200
  end

end
