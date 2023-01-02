require_relative '../lib/chat_terminal/client'
require_relative '../lib/chat_terminal/server'

RSpec.describe Client do
	before(:all) do
		stdout = StringIO.new
		@port = 2999

		until !@socket.nil?
			begin 
				@port += 1
				@socket = TCPServer.new('localhost', @port)
			rescue
			end
		end

		@socket.close

		@thread_server = Thread.new { Server.new(ip: 'localhost', port: @port, stdout: stdout) }
		sleep 1
	end

	after(:all) do
		@thread_server.kill
	end

	it 'write name and a message and close chat' do
		stdout = StringIO.new
		stdin = StringIO.new("Alexandre\neai, como vai?\r\n\u0003")

		expect { Client.new(ip: 'localhost', port: @port, stdout: stdout, stdin: stdin) }.to raise_error(RuntimeError, "Exit")

		expect(stdout.string).to include('eai, como vai?')
		expect(stdout.string).to include('Closed')
	end

	it 'should chop string' do
		text = "eai,#{"\u007F"*4} como vai?" # chop a word 'eai,'
		stdout = StringIO.new
		stdin = StringIO.new("Alexandre\n#{text}\r\n\u0003")

		expect { Client.new(ip: 'localhost', port: @port, stdout: stdout, stdin: stdin) }.to raise_error(RuntimeError, "Exit")

		expect(stdout.string).to_not include("eai, como vai?")
		expect(stdout.string).to include("como vai?")
		expect(stdout.string).to include('Closed')
	end
end