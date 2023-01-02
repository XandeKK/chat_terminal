require 'socket'
require_relative 'user'
require_relative 'message'

class Server
	def initialize(ip:'localhost', port:'2000', stdout: $stdout)
		@server = TCPServer.new(ip, port)
		@stdout = stdout

		@messages = Queue.new
		@users = []
		@threads = []

		@threads << Thread.new { new_client }
		@threads << Thread.new { send }

		@threads.each { |t| t.join }
	end

	private

	def new_client
		loop do
			socket = @server.accept
			name = socket.recv(1024).chomp

			if name.length <= 0
				@stdout.puts "Connection closed"
				next
			end

			user = User.new(name, socket)
			message = Message.new(text: "#{user.name} joined the chat.", stdout: @stdout)

			push(message)

			thread = Thread.new { handle(user) }
			user.thread = thread

			@users.push(user)
		end
	end

	def handle user
		loop do
			begin
				message = user.socket.recv(1024)
			rescue Errno::ECONNRESET
				message = ''
			end

			if message.length > 0
				message = Message.new(text: "#{user.name}: #{message}", stdout: @stdout)
				push(message)
			else
				message = Message.new(text: "#{user.name} left the chat", stdout: @stdout)
				push(message)

				remove_user user
				user.thread.kill
			end
		end
	end

	def send
		loop do
			begin
				message = @messages.pop(true)
				@users.each do |user|
					user.socket.puts message.text
				end
			rescue ThreadError
				next
			end
		end
	end

	def remove_user user
		@users.reject! { |u| u == user }
	end

	def push message
		@messages << message
		message.print
	end
end
