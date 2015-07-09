require 'github_api'

class GithubAdapter
  
  attr_reader :client

  def initialize
    @client = Github.new basic_auth: "podiobridge:"+ENV["PB_GITHUB_API"]
  end

  def create_issue(user, repo, title, body)
    client.issues.create user: user, repo: repo, title: title, body: body
  end

end