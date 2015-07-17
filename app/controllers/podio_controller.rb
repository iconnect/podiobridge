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
    podio_item = pa.get_item(params[:item_id])
    render nothing: true, status: 200 and return if podio_item[:revisions].first["created_by"]["name"] == "Support Requests"

    item_hash = Issue.new(podio_item).podio_to_hash if params[:item_id]
    ga = GithubAdapter.new("t-c-k", "podiobridge")
    action = params[:type]

    case action
    when "item.create"
      result = ga.create_issue(item_hash)
      pa.update_item(params[:item_id], { "github-id" => result[:number].to_s } )
    when "item.update"
      ga.update_issue(item_hash["github-id"], item_hash)
    when "comment.create"
      # comment = Podio::Comment.find(params[:comment_id])
    when "hook.verify"
      pa.verify_hook(params[:hook_id], params[:code])
    end

    render nothing: true, status: 200
  end

end
