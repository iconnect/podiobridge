class PodioToGithub
  
  attr_accessor :podio_params

  def initialize(podio_params)
    @podio_params = podio_params
  end

  def send_to_github
    case action
    when "item.create"
      create_issue
    when "item.update"
      update_issue
    when "comment.create"
      create_comment
    when "hook.verify"
      verify_hook
    end
  end

  private

  def action
    podio_params[:type]
  end

  def podio
    @podio ||= PodioAdapter.new
  end

  def github
    @github ||= GithubAdapter.new(ENV["PB_GITHUB_USER"], ENV["PB_GITHUB_REPO"])
  end

  def item_hash
    @item_hash ||= Issue.new(podio_item).podio_to_hash
  end

  def podio_item
    @podio_item ||= podio.get_item(podio_params[:item_id])
  end

  def podio_comment
    @podio_comment ||= podio.get_comment(podio_params[:comment_id])
  end

  def created_by_podiobridge?
    podio_item.revisions.first[:created_by][:name] == "Support Requests"
  end

  def comment_by_podiobridge?
    podio_comment.created_by.name == "Support Requests"
  end

  def create_issue
    return if created_by_podiobridge?
    result = github.create_issue(item_hash)
    podio.update_item(podio_params[:item_id], { "github-id" => result[:number].to_s } )
  end

  def update_issue
    return if created_by_podiobridge?
    github.update_issue(item_hash["github-id"], item_hash)
  end

  def create_comment
    return if comment_by_podiobridge?
    body = "#### #{podio_comment.created_by.name}:\r\n<hr/>\r\n#{podio_comment.value}"
    github.create_comment(item_hash["github-id"], body)
  end

  def verify_hook
    podio.verify_hook(podio_params[:hook_id], podio_params[:code])
  end

end
