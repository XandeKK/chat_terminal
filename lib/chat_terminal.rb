# frozen_string_literal: true

require_relative "chat_terminal/version"
require_relative 'chat_terminal/message'
require_relative 'chat_terminal/user'
require_relative 'chat_terminal/client'
require_relative 'chat_terminal/server'

module ChatTerminal
  def self.start_server
    puts "Start as server"
    Server.new
  end

  def self.start_client
    puts "Start as client"
    Client.new
  end
end
