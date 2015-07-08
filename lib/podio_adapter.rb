require "podio"

class PodioAdapter

  def initialize
    Podio.setup(api_key: ENV["PB_PODIO_CLIENT_ID"], api_secret: ENV["PB_PODIO_CLIENT_SECRET"])
    Podio.client.authenticate_with_credentials(ENV["PB_PODIO_USERNAME"], ENV["PB_PODIO_PASSWORD"])
  end

end