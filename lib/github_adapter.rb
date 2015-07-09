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

end