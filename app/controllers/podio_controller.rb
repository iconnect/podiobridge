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
    item_hash = Issue.new(pa.get_item(params[:item_id])).podio_to_hash
    ga = GithubAdapter.new("t-c-k", "podiobridge")
    action = params[:type]
    if action == "item.create"
      result = ga.create_issue(item_hash)
      pa.update_item(params[:item_id], { hook: false, "github-id" => result[:number].to_s } )
    elsif action == "item.update"
      ga.update_issue(item_hash["github-id"], item_hash)
    end
    # comment = Podio::Comment.find(params[:comment_id])
    pa.verify_hook(params[:hook_id], params[:code]) if params[:type] == "hook.verify"
    render nothing: true, status: 200
  end

end
