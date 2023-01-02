require 'socket'
require 'io/console'
require "timeout"

class Client
	def initialize(ip:'localhost', port:'2000', stdout: $stdout, stdin: $stdin)
		@socket = TCPSocket.new ip, port
		@stdout = stdout
		@stdin = stdin
		@messages = []
		@message = ""
		@threads = []

		get_name
	
		@threads << Thread.new { input }
		@threads << Thread.new { handle }

		@threads.each { |t| t.join }
	end

	private

	def get_name
		@stdout << "Seu nome: "
		@name = @stdin.gets
		@socket.puts @name
	end

	def input
		char = ''

		loop do
			write_messages
			char.replace('') unless char.nil?

			begin
			  Timeout::timeout(0.4) { char = @stdin.getch }
			rescue Timeout::Error
			end

			case char
			when "\u0003" # ctrl + c
				@stdout << "\nClosed!\n"
				raise "Exit"
			when "\u007F" # backspace
				@message.chop! if @message.length > 0
			when "\r" # enter
				send @message
				@message.replace("")
			when "\e" # arrow
				@stdin.getch
				@stdin.getch
			else
				@message << char unless char.nil?
			end

			system("clear") if @stdout == STDOUT
		end
	end

	def handle
		loop do
			text = @socket.gets
			message = Message.new(text: text, stdout: @stdout)
			@messages << message
		end
	end

	def send message
		@socket.puts(message)
	end

	def write_messages
		@messages.each { |message| message.print }
		@stdout << "\033[36m" << "_"*get_width << "\033[39m\n"
		@stdout << "> " << @message
	end

	def get_width
		IO.console.winsize[1]
	end
end
