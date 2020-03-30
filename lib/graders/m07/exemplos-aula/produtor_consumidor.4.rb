class Producer
  def initialize(queue)
    @queue = queue
  end

  def run
    integers = [131, 271, 991, 3102, 8172, 9102]
    integers.each { |i| @queue.push(i) }
    @queue.push('end')
  end
end

class Consumer
  def initialize(queue)
    @queue = queue
  end

  def run
    while (job = @queue.pop)
      if job == 'end'
        @queue.push('end')
        break
      end
      consume(job)
    end
  end

  def consume(job)
    puts job*10
  end
end

queue = Queue.new
Producer.new(queue).run()
Consumer.new(queue).run()
