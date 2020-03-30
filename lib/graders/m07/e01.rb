module Graders
  module M07
    class E01 < Graders::Base
      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_solution_file_exists
        f = File.expand_path('m7-e1.rb', @work_dir)

        if File.exists?(f)
          self.solution_file = f
          mark_pass
          load f
        else
          mark_fail i18n_args: { f: f }
        end
      end

      def check_job_class_is_defined
        if (defined? Job)
          mark_pass
        else
          mark_fail i18n_args: { klass: 'Job'}
        end
      end

      def check_digits_constant_is_correctly_defined
        if (defined? Job::DIGITS)
          if Job::DIGITS.sort == (0..9).to_a
            mark_pass i18n_args: { constant: 'DIGITS' }
          else
            mark_fail i18n_args: { constant: 'DIGITS' }
          end
        else
          mark_fail i18n_args: { constant: 'DIGITS' }
        end
      end

      def check_execution_time_is_less_than_2_seconds
        if (defined? EXECUTION_TIME)
          if EXECUTION_TIME < 2
            mark_pass i18n_args: { time: EXECUTION_TIME }
          else
            mark_fail i18n_args: { time: EXECUTION_TIME }
          end
        else
          mark_fail
        end
      end
    end
  end
end
