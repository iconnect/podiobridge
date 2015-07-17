class GithubController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :require_login, only: [:create]

  def create
    Log.create(
      sender: "GithubController", 
      message: params[:github][:action],
      status: "info"
      )

    render nothing: true, status: 200 and return if params[:sender]["login"] == "podiobridge"

    pa = PodioAdapter.new
    item_hash = Issue.new(params).github_to_hash

    action = params[:github][:action]
    
    case action
    when "opened"
      pa.create_item(12885408, item_hash)
    when "created"
      #comment created
    else
      podio_item = pa.find_item(12885408, "github-id", params[:issue][:number].to_s)
      pa.update_item(podio_item.item_id, item_hash)
    end

    render nothing: true, status: 200
  end

end
