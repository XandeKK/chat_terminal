require 'stringio'
require_relative '../lib/chat_terminal/server'

RSpec.describe Server do
	before(:each) do
		@stdout = StringIO.new
		@port = 2999

		until !@socket.nil?
			begin 
				@port += 1
				@socket = TCPServer.new('localhost', @port)
			rescue
			end
		end

		@socket.close
	end

	describe 'IO' do
		it 'should print Alexandre and a message sended' do
			thread = Thread.new { Server.new(ip: 'localhost', port: @port, stdout: @stdout) }
			sleep 1
			client = TCPSocket.new('localhost', @port)
			client.puts 'Alexandre'

			sleep 0.5
			expect(@stdout.string).to include('Alexandre')

			client.puts 'Hello everyone!'

			sleep 0.5
			expect(@stdout.string).to include('Hello everyone!')
			thread.kill
		end

		it 'should print Connection closed' do
			thread = Thread.new { Server.new(ip: 'localhost', port: @port, stdout: @stdout) }
			sleep 1
			client = TCPSocket.new('localhost', @port)
			client.close

			sleep 0.5

			expect(@stdout.string).to include('Connection closed')
			thread.kill
		end
	end

	context 'Get message of server' do
		it 'should print a message received' do
			thread = Thread.new { Server.new(ip: 'localhost', port: @port, stdout: @stdout) }
			sleep 1
			client = TCPSocket.new('localhost', @port)
			client.puts 'Alexandre'

			expect(client.gets).to include('Alexandre')

			client.puts 'Opa'

			expect(client.gets).to include('Opa')

			client.close
			thread.kill
		end
	end
end
