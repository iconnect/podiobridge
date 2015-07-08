require "podio"

class PodioAdapter
  
  def initialize
    Podio.setup(ENV["PB_PODIO_CLIENT_ID"], ENV["PB_PODIO_CLIENT_SECRET"])
    Podio.client.authenticate_with_credentials(ENV["PB_PODIO_USERNAME"], ENV["PB_PODIO_PASSWORD"])
  end

end