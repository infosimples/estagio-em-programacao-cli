module Graders
  module M05
    class E03 < Graders::Base

      def run_tests
        @file_name = File.expand_path('m5-e3.txt', @work_dir)
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_solution_file_exists
        if File.exist?(@file_name)
          self.solution_file = @file_name
          mark_pass
          @file_contents = File.readlines(@file_name)
        else
          mark_fail i18n_args: { f: @file_name }, abort: true
        end
      end

      def check_ddos_ip_is_correct
        if !@file_contents[0].nil? && @file_contents[0].strip == '243.171.198.248'
          mark_pass
        else
          mark_fail
        end
      end

      def check_error_or_warning_count_is_correct
        if !@file_contents[1].nil? && @file_contents[1].strip.gsub('.', '') == '66622'
          mark_pass
        else
          mark_fail
        end
      end

      def check_file_at_time
        if !@file_contents[2].nil? && @file_contents[2].strip == 'database.sql'
          mark_pass
        else
          mark_fail
        end
      end

      def check_exception_at_time
        if !@file_contents[3].nil? && @file_contents[3].strip == 'TIMEOUT NA CONEXÃO'
          mark_pass
        else
          mark_fail
        end
      end

    end
  end
end
