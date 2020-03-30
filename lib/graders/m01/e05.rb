module Graders
  module M01
    class E05 < Graders::Base

      def run_tests
        @file_name = File.expand_path('m1-e5.txt', @work_dir)
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_solution_file_exists
        if File.exist?(@file_name)
          self.solution_file = @file_name
          mark_pass
        else
          mark_fail i18n_args: { f: @file_name }, abort: true
        end
      end

      def check_correct_answer
        answer = File.open(@file_name, 'r').read.strip.downcase
        if answer[/Jeremy Bowers/i]
          mark_pass
        else
          mark_fail
        end
      end
    end
  end
end
