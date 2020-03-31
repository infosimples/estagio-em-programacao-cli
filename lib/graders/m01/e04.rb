module Graders
  module M01
    class E04 < Graders::Base

      def run_tests
        @file_name = File.expand_path('m1-e4.sh', @work_dir)
        @file = File.open(@file_name, 'rb').read if File.exists?(@file_name)
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def mark_cmd_description(cmd)
        answer = `#{@file_name} #{cmd}`
        if answer.empty? || answer.match(/^#{cmd}:/).nil?
          mark_fail i18n_args: { cmd: cmd }
        else
          mark_pass i18n_args: { cmd: cmd }
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

      def check_solution_file_executable
        if File.executable?(@file_name)
          mark_pass
        else
          mark_fail i18n_args: { f: @file_name }, abort: true
        end
      end

      def check_cd_description
        mark_cmd_description('cd')
      end

      def check_ls_description
        mark_cmd_description('ls')
      end

      def check_pwd_description
        mark_cmd_description('pwd')
      end

      def check_cat_description
        mark_cmd_description('cat')
      end

      def check_rm_description
        mark_cmd_description('rm')
      end

      def check_mv_description
        mark_cmd_description('mv')
      end

      def check_chmod_description
        mark_cmd_description('chmod')
      end

      def check_man_description
        mark_cmd_description('man')
      end

      def check_touch_description
        mark_cmd_description('touch')
      end

      def check_grep_description
        mark_cmd_description('grep')
      end
    end
  end
end
