puts "I'm the main thread: #{Thread.current}"

Thread.new do
  puts "I'm a new thread: #{Thread.current}"
end

puts "Main thread here: #{Thread.current}"

sleep(2)
