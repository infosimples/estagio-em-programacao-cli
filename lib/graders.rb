require_relative 'graders/base'

# Load all graders in the 'graders' directory.

graders_dir = File.expand_path('../graders', __FILE__)

Dir["#{graders_dir}/m*/e*.rb"].sort.each do |grader|
  require grader
end
