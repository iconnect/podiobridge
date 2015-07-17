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

  def podio
    @podio ||= PodioAdapter.new
  end

  def item_hash
    @item_hash ||= Issue.new(github_params).github_to_hash
  end

  private

  def action
    github_params[:github][:action]
  end

  def create_issue
    podio.create_item(12885408, item_hash)
  end

  def create_comment
    #comment created
  end

  def update_issue
    podio_item = podio.find_item(12885408, "github-id", github_params[:issue][:number].to_s)
    podio.update_item(podio_item.item_id, item_hash)
  end




end