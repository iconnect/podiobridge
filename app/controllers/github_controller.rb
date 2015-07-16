class GithubController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :require_login, only: [:create]

  def create
    Log.create(
      sender: "GithubController", 
      message: params[:github][:action],
      status: "info"
      )
    pa = PodioAdapter.new
    item_hash = Issue.new(params).github_to_hash

    action = params[:github][:action]
    podio_item = pa.find_item(12885408, "github-id", params[:issue][:number].to_s)

    case action
    when "opened"
      pa.create_item(12885408, item_hash) unless podio_item
    when "created"
      #comment created
    else
      pa.update_item(podio_item.item_id, item_hash)
    end

    render nothing: true, status: 200
  end

end
