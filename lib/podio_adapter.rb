require "podio"

class PodioAdapter
  def initialize(args = {})
    setup_podio!
  end

  private

  attr_reader :organization, :user, :user_input

  def app_id
    ENV["PB_APP_ID"]
  end

  def api_secret
    ENV["PB_API_SECRET"]
  end

  def app_token
    ENV["PB_APP_TOKEN"]
  end

  def app_keys_missing?
    !app_keys_present?
  end

  def app_keys_present?
    app_token.present? && api_secret.present?
  end

  def setup_podio!
    raise "Please provide app tokens" if app_keys_missing?
    Podio.setup(api_key: "podiobridge", api_secret: api_secret).tap do |client|
      client.authenticate_with_app(app_id, app_token)
    end
  end
end