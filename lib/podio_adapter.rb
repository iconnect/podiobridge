require "podio"

class PodioAdapter

  def initialize
    Podio.setup(api_key: ENV["PB_PODIO_CLIENT_ID"], api_secret: ENV["PB_PODIO_CLIENT_SECRET"])
    # Podio.client.authenticate_with_credentials(ENV["PB_PODIO_USERNAME"], ENV["PB_PODIO_PASSWORD"])
    Podio.client.authenticate_with_app(ENV["PB_PODIO_APP_ID"], ENV["PB_PODIO_APP_TOKEN"])
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

  def create_item(app_id, item_hash, hook = false)
    result = Podio::Item.create( app_id, fields: item_hash, hook: hook )
    Log.create(
      sender: "PodioAdapter", 
      message: "Created item: #{result.item_id}",
      status: "success"
      )
    return result
  end

  def update_item(item_id, item_hash, hook = false)
    Podio::Item.update( item_id, fields: item_hash, hook: hook )
    Log.create(
      sender: "PodioAdapter", 
      message: "Updated item: #{item_id}",
      status: "success"
      )
  end

  def get_item(item_id)
    Podio::Item.find(item_id)
  end

  def find_item(app_id, field_id, value)
    Podio::Item.find_by_filter_values(app_id, field_id => value).first.first
  end

end
