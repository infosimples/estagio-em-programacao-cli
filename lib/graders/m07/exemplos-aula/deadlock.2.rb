queue = Queue.new # an empty queue with no jobs
Thread.new do
  job = queue.pop # it’ll never pop a job
  puts 'Job is finished'
end.join
