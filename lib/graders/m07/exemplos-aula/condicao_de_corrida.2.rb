i = 0
threads = []
4.times do
  threads << Thread.new do
    1_000.times do
      a = i + 1
      sleep 0.001 if rand(100) < 5
      i = a
    end
  end
end
threads.each(&:join) # wait for threads to finish
puts i
