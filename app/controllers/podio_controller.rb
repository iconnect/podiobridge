class PodioController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :require_login, only: [:create]

  def create
    # Log.create(
    #   sender: "PodioController",
    #   message: params[:type],
    #   status: "info"
    #   )
    PodioToGithub.new(params).send_to_github
    render nothing: true, status: 200
  end

end
