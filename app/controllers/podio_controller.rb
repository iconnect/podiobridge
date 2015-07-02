class PodioController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :require_login, only: [:create]

  def create
    comment = Podio::Comment.find(params[:comment_id])
    Log.create(
      sender: "PodioController", 
      message: comment.value,
      status: "success"
      )
    render nothing: true, status: 200
  end

end
