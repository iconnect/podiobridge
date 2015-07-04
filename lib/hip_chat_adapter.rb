require "hipchat"

class HipChatAdapter

	attr_reader :client

	def initialize
		@client = HipChat::Client.new(ENV["PB_HIPCHAT_API"])
	end

	def send_message_to_podio_management(message)
		client["Podio Management"].send("PodioBridge", message)
	end

end