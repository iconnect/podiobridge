class GithubAdapter
  
  USER = "t-c-k"
  REPO = "podiobridge"

  attr_accessor :client

  def initialize
    @client = Github.new basic_auth: "podiobridge:"+ENV["PB_GITHUB_API"]
  end

  def create_issue(title, body)
    client.issues.create user: USER, repo: REPO, title: title, body: body
  end

  def extract_issue(params)
    # binding.pry
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

    # podio related stuff
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
