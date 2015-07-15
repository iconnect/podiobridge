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
      message: "Created item: #{result.item_id}",
      status: "success"
      )
    return result
  end

  def update_item(item_id, item_hash)
    result = Podio::Item.update(item_id, fields: item_hash)
    Log.create(
      sender: "PodioAdapter", 
      message: "Updated item: #{item_id}",
      status: "success"
      )
    return result
  end

end