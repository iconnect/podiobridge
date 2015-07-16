class Issue

  attr_accessor :item

  def initialize(item)
    @item = item
  end

  def github_to_hash
    item[:issue][:body] = nil if item[:issue][:body].empty?
    item[:issue][:assignee] = { login: nil } unless item[:issue][:assignee]
    item_hash = {
      title: item[:issue][:title],
      body: item[:issue][:body],
      assignee: item[:issue][:assignee][:login],
      "created-by" => item[:issue][:user][:login],
      state: item[:issue][:state],
      "github-id" => item[:issue][:number].to_s
    }
    return item_hash

  end

  def podio_to_hash
    title = item[:fields].select { |x| x["external_id"] == "title" }.flat_map{ |x| x["values"] }.map { |x| x["value"] }.first
    body = item[:fields].select { |x| x["external_id"] == "body" }.flat_map{ |x| x["values"] }.map { |x| x["value"] }.first
    # assignee = item[:fields].select { |x| x["external_id"] == "assignee" }.flat_map{ |x| x["values"] }.map { |x| x["value"] }.first
    # created_by = item[:fields].select { |x| x["external_id"] == "created-by" }.flat_map{ |x| x["values"] }.map { |x| x["value"] }.first
    state = item[:fields].select { |x| x["external_id"] == "state" }.flat_map{ |x| x["values"] }.map { |x| x["value"]["text"] }.first
    github_id = item[:fields].select { |x| x["external_id"] == "github-id" }.flat_map{ |x| x["values"] }.map { |x| x["value"] }.first
  

    state ||= nil
    github_id ||= nil

    item_hash = {
      title: title,
      body: body,
      # assignee: assignee,
      # "created-by" => created_by,
      state: state,
      "github-id" => github_id
    }
    return item_hash
  end


end
