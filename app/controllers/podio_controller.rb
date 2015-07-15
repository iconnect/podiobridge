class PodioController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :require_login, only: [:create]

  def create
    Log.create(
      sender: "PodioController", 
      message: params[:type],
      status: "info"
      )
    pa = PodioAdapter.new
    pa.verify_hook(params[:hook_id], params[:code]) if params[:type] == "hook.verify"
    
    # comment = Podio::Comment.find(params[:comment_id])

    render nothing: true, status: 200
  end

end
