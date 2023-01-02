require 'stringio'
require_relative '../lib/chat_terminal/message'

RSpec.describe Message do
	before(:each) do
		@output = StringIO.new
		@message = Message.new(text: 'Hello world', stdout: @output)
	end

	describe '#print' do
		it 'contains "Hello world" in output' do
			@message.print
			expect(@output.string).to include('Hello world')
		end
	end

	describe '#text' do
		it 'return "Hello World"' do
			expect(@message.text).to include('Hello world')
		end
	end
end
