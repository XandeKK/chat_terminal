class User
	attr_reader :name, :socket, :thread

	def initialize(name, socket)
		@name = name
		@socket = socket
		colors = (1..8).map { |n| "\033[3#{n}m" }
		@color = colors.sample

		color_name
	end

	def thread= thread
		raise "Expected Thread but got class #{thread.class}" if thread.class != Thread
		@thread = thread
	end

	private

	def color_name
		@name = @color + @name + "\033[39m"
	end
end