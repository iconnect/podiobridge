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
    PodioAdapter.new
    Podio::Item.create(12885408, fields: {
      title: params[:issue][:title],
      body: params[:issue][:body],
      assignee: params[:issue][:assignee],
      "created-by" => params[:issue][:user][:login],
      state: params[:issue][:state],
      "github-id" => params[:issue][:number].to_s
    })
  end

end
