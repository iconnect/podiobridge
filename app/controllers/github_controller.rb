class GithubController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :require_login, only: [:create]

  def create
    # Log.create(
    #   sender: "GithubController",
    #   message: params[:github][:action],
    #   status: "info"
    #   )
    GithubToPodio.new(params).send_to_podio unless params[:sender]["login"] == "podiobridge"
    render nothing: true, status: 200
  end

end
