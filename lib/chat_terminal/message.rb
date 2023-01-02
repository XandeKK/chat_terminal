class Message
	def initialize(text: '', stdout: $stdout)
		@message = text.chomp
		@stdout = stdout
	end

	def print
		@stdout.puts @message
	end

	def text
		@message
	end
end