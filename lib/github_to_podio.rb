class GithubToPodio
  
  attr_accessor :github_params

  def initialize(github_params)
    @github_params = github_params
  end

  def send_to_podio
    case action
    when "opened"
      create_issue
    when "created"
      create_comment
    else
      update_issue
    end
  end

  private

  def action
    github_params[:github][:action]
  end

  def podio
    @podio ||= PodioAdapter.new
  end

  def podio_item
    @podio_item ||= podio_item = podio.find_item(podio_app_id, "github-id", github_params[:issue][:number].to_s)
  end

  def item_hash
    @item_hash ||= Issue.new(github_params).github_to_hash
  end

  def comment_by_podiobridge?
    github_params["comment"]["user"]["login"] == "podiobridge"
  end

  def create_issue
    podio.create_item(podio_app_id, item_hash)
  end

  def create_comment
    return if comment_by_podiobridge?
    body = "#{github_params["comment"]["user"]["login"]}:\n---\n#{github_params["comment"]["body"]}"
    podio.create_comment(podio_item.id, body)
  end

  def update_issue
    podio.update_item(podio_item.item_id, item_hash)
  end

  def podio_app_id
    ENV["PB_PODIO_APP_ID"]
  end

end
