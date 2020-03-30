# Add lib path so the project's files can be required.
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

# Load application.
require 'course-cli'

# Directory where Markdown files are located
questions_dir = CourseCli::PathHelper.questions_dir

# Pattern to list all the Markdown files
md_pattern = File.join(questions_dir, '**', '*.md')

inputs  = Dir[md_pattern]
outputs = inputs.map do |input|
  # Generate corresponding output path for each input file
  CourseCli::PathHelper.public_dir + input[questions_dir.length..-3] + "html"
end

mapping = Hash[outputs.zip(inputs)]

task :default => :html

desc 'Generate all .html files from corresponding .md files'
task :html    => outputs

desc 'Remove all output files from the public directory'
task :clean do
  FileUtils.rm(outputs)
end

#
# Rule to build an .html file from its corresponding .md file.
#
rule ".html" => [ CourseCli::PathHelper.layout_file,
                  proc { |input| mapping[input] } ] do |task|

  md_renderer = Redcarpet::Markdown.new(
    CourseCli::Renderer::HTMLwithPygments, fenced_code_blocks: true)

  md = md_renderer.render(File.read(task.sources.last))

  title = File.basename(task.name, '.html').upcase
  html = CourseCli::Renderer::ERB.new(title: title, markdown: md).result

  File.open(task.name, 'w') do |f|
    f.write(html)
  end
end
