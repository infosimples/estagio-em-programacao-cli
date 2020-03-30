i = 10
threads = []
threads << Thread.new do
  while i == 10
    puts "waiting for \"i != 10\"..."
    sleep(1)
  end
  puts 'The thread can finish when "i != 10"'
end
sleep(5)
i = 5
threads.each(&:join)
