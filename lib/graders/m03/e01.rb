module Graders
  module M03
    class E01 < Graders::Base
      def tests_count
        21
      end

      def run_tests
        @test_name = 'check_solution_file_exists'
        send(@test_name)

        @test_name = 'check_assert_equal'
        @passing = true
        eval_context = binding
        lines = File.readlines(expected_file_path)

        code = ''
        lines.each_with_index do |line, index|
          code << line + "\n"

          if line.match(/\Aassert/)
            @line = index + 1
            eval(code, eval_context)
            code = ''
          end
          # break if !@passing
        end
      end

      def expected_file_path
        File.expand_path('m3-e1.rb', @work_dir)
      end

      def check_solution_file_exists
        f = expected_file_path
        if File.exists?(f)
          self.solution_file = f
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def assert_equal(value, expected)
        args = {value: value, expected: expected, line: @line}
        if value == expected
          mark_pass i18n_args: args
        else
          @passing = false
          mark_fail i18n_args: args
        end
      end

      def __
        '__'
      end
    end
  end
end
