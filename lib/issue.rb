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
    title = field("title").value
    body = field("body").value
    assignee = field("assignee").value
    created_by = field("created-by").value
    state = field("state").value["text"]
    github_id = field("github-id").value
    body += "\r\n<hr/>\r\nCreated by: #{item.created_by.name}\r\n#{item.link}"
    body.gsub! "@", "@ "
    item_hash = {
      title: title,
      body: body,
      assignee: assignee,
      "created-by" => created_by,
      state: state,
      "github-id" => github_id
    }
    return item_hash
  end

  def field(name)
    Field.new item[:fields].select { |x| x["external_id"] == name }.first
  end  

  class Field < OpenStruct
    def value
      return nil if values.blank?
      values.map { |x| x["value"] }.first
    end
  end

end
