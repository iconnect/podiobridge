class GithubController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :require_login, only: [:create]

  def create
    ga = GithubAdapter.new
    item_hash = ga.extract_issue(params)

    pa = PodioAdapter.new
 
    action = params[:github][:action]
    if action == "opened"
      pa.create_item(12885408, item_hash)
    elsif action == "created"
        
    else
      item = pa.find_item(12885408, "github-id", params[:issue][:number].to_s)
      pa.update_item(item.item_id, item_hash)
    end


    Log.create(
      sender: "GithubController", 
      message: params[:github][:action],
      status: "success"
      )
    render nothing: true, status: 200
  end

end
