class GithubAdapter
  
  attr_accessor :client, :user, :repo

  def initialize(user, repo)
    @client = Github.new basic_auth: "podiobridge:"+ENV["PB_GITHUB_API"]
    @user = user
    @repo = repo
  end

  def create_issue(item_hash)
    result = client.issues.create user: user, repo: repo, title: item_hash[:title], body: item_hash[:body]
    Log.create(
      sender: "GithubAdapter", 
      message: "Created item: #{result.number}",
      status: "success"
      )
    return result
  end

  def update_issue(issue_id, item_hash)
    client.issues.edit user: user, repo: repo, number: issue_id, title: item_hash[:title], body: item_hash[:body], state: item_hash[:state]
    Log.create(
      sender: "GithubAdapter", 
      message: "Updated item: #{issue_id}",
      status: "success"
      )
  end

  def create_comment(issue_id, comment_body)
    result = client.issues.comments.create user: user, repo: repo, number: issue_id, body: comment_body
    Log.create(
      sender: "GithubAdapter", 
      message: "Created comment: #{result.id} on #{issue_id}",
      status: "success"
      )
  end

end
