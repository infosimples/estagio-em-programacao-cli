puts "Hi, I'm the parent. Process ID: #{Process.pid}"

fork do
  puts "I'm the child. Process ID: #{Process.pid}"
end

puts "Parent here! I've skipped fork (#{Process.pid})"
