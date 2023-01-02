require 'socket'
require 'stringio'
require_relative '../lib/chat_terminal/user'

RSpec.describe User do
	before(:all) do
		@server = nil
		port = 2999

		until !@server.nil?
			begin 
				port += 1
				@server = TCPServer.new('localhost', port)
			rescue Errno::EACCES
			rescue Errno::EADDRINUSE
			end
		end

		sleep 1
		@socket = TCPSocket.new 'localhost', port
		@user = User.new('Alexandre', @socket)
	end

	describe '#name' do
		it 'return "Alexandre"' do
			expect(@user.name).to include('Alexandre')
		end
	end

	describe '#socket' do
		it 'return object TCPSocket' do
			expect(@socket).to eql(@socket)
		end
	end

	describe '#thread' do
		before(:each) do
			@thread = Thread.new {}
			@user.thread = @thread
		end

		it 'return object Thread' do
			expect(@user.thread).to eql(@thread)
		end

		after(:each) do
			@thread.kill
		end
	end

	describe '#thread=' do
		it 'raises expection invalid class' do
			thread = String.new("foda-se")
			expect { @user.thread = thread }.to raise_error(RuntimeError, "Expected Thread but got class #{thread.class}")
		end

		it 'not raises expection invalid class' do
			thread = Thread.new {}
			@user.thread = thread
			thread.kill
		end
	end

	after(:all) do
		@server.close
		@socket.close
	end
end
