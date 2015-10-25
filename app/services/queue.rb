class Queue
	def initialize
		@store = Array.new
	end
	def enqueue
		@store.unshift(element)
        self
	end
	def dequeue
		@store.pop
	end
	def size
		@store.size
	end
end