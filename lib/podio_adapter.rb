require "podio"

class PodioAdapter

  def initialize
    Podio.setup(api_key: ENV["PB_PODIO_CLIENT_ID"], api_secret: ENV["PB_PODIO_CLIENT_SECRET"])
    Podio.client.authenticate_with_credentials(ENV["PB_PODIO_USERNAME"], ENV["PB_PODIO_PASSWORD"])
  end

  def verify_hook(hook_id, code)
    result = Podio::Hook.validate(hook_id, code)
    Log.create(
      sender: "PodioAdapter", 
      message: "Verified hook: #{hook_id}",
      status: "success"
      )
    return result
  end

  def create_item(app_id, item_hash)
    result = Podio::Item.create(app_id, fields: item_hash)
    Log.create(
      sender: "PodioAdapter", 
      message: "Created item",
      status: "success"
      )
    return result
  end

  def update_item(item_id, item_hash)
    result = Podio::Item.update(item_id, fields: item_hash)
    Log.create(
      sender: "PodioAdapter", 
      message: "Created item",
      status: "success"
      )
    return result
  end

  def extract_issue(params)
    params[:issue][:body] = nil if params[:issue][:body].empty?
    params[:issue][:assignee] = { login: nil } unless params[:issue][:assignee]
    item_hash = {
      title: params[:issue][:title],
      body: params[:issue][:body],
      assignee: params[:issue][:assignee][:login],
      "created-by" => params[:issue][:user][:login],
      state: params[:issue][:state],
      "github-id" => params[:issue][:number].to_s
    }
    # return item_hash

    PodioAdapter.new
    action = params[:github][:action]
    if action == "opened"
      Podio::Item.create(12885408, fields: item_hash)
    else
      items = Podio::Item.find_by_filter_values("12885408", "github-id" => params[:issue][:number].to_s).first
      Podio::Item.update(items.first[:item_id], fields: item_hash)
    end
  end

end