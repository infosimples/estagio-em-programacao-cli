module Graders
  module M01
    class E02 < Graders::Base

      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def execute_m1_e2_script(file)
        @data = {}
        # remove all .html files in the work_dir
        FileUtils.rm Dir.glob(File.expand_path('*.html', @work_dir))

        # Execute the script
        @data[:contents] = URI.open('http://www.tldp.org/LDP/intro-linux/html/intro-linux.html').read.encode('utf-8', invalid: :replace, replace: '?')
        @data[:output] = %x[cd #{File.dirname(file)} && ./#{File.basename(file)}]
      end

      def mark_case_count(linux_case, rb_count)
        if rb_count == @answer[linux_case].to_i
          mark_pass
        else
          mark_fail i18n_args: { expected: rb_count, actual: @answer[linux_case].to_i }, abort: true
        end
      end

      def check_solution_file_exists
        f = File.expand_path('m1-e2.sh', @work_dir)

        if File.exist?(f)
          self.solution_file = f
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_solution_file_executable
        f = File.expand_path('m1-e2.sh', @work_dir)

        if File.executable?(f)
          mark_pass
          execute_m1_e2_script(f)
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_answer_format
        @answer = {}
        capital = @data[:output].match(/Linux:\s+(\d+)/)
        lower = @data[:output].match(/linux:\s+(\d+)/)
        insensitive = @data[:output].match(/linux [^\d]+(\d+)/)

        if capital.nil? || lower.nil? || insensitive.nil?
          mark_fail i18n_args: { out: @data[:output] }, abort: true
        else
          @answer[:capital] = capital[1]
          @answer[:lower] = lower[1]
          @answer[:insensitive] = insensitive[1]
          mark_pass
        end
      end

      def check_capitalcase_occurrencies_count
        rb_count = @data[:contents].scan(/Linux/).size
        mark_case_count(:capital, rb_count)
      end

      def check_lowercase_occurrencies_count
        rb_count = @data[:contents].scan(/linux/).size
        mark_case_count(:lower, rb_count)
      end

      def check_insensitive_occurrencies_count
        rb_count = @data[:contents].scan(/linux/i).size
        mark_case_count(:insensitive, rb_count)
      end
    end
  end
end
