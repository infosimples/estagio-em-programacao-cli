require 'erb'

module CourseCli
  module Renderer

    #
    # Custom class to render HTML from Markdown files using the Pygments gem.
    #
    class HTMLwithPygments < Redcarpet::Render::HTML
      def block_code(code, language)
        Pygments.highlight(code, lexer: language)
      end

      def link(link, title, content)
        %Q{<a href="#{link}" target="_blank">#{content}</a>}
      end
    end

    #
    # Used to render HTML from a template file.
    #
    class ERB < ::ERB
      def initialize(hsh)
        hsh.each do |key, val|
          instance_variable_set("@#{key}", val)
        end
        super(File.read(CourseCli::PathHelper.layout_file))
      end

      def result
        super(binding)
      end
    end

  end
end
