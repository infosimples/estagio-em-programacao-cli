require 'mechanize'

module Graders
  module M10
    class E01 < Graders::Base
      def run_tests
        @file_name = File.expand_path('m10-e1.txt', @work_dir)
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_solution_file_exists
        f = File.expand_path(@file_name, @work_dir)

        if File.exists?(f)
          mark_pass
        else
          mark_fail i18n_args: { f: f }
        end
      end

      def check_app_is_running
        url = File.read(@file_name) || ''
        url = url.strip

        agent = Mechanize.new
        agent.get url

        if agent.page.image_with(alt: 'Logo cpe')
          mark_pass
        else
          mark_fail i18n_args: { url: url }
        end
      rescue
        mark_fail i18n_args: { url: url }
      end
    end
  end
end
