require_relative 'base'
require_relative 'e01'

module Graders
  module M06
    class E02 < Graders::M06::Base

      def check_solution_file_exists
        f = File.expand_path('m06-e02.rb', @work_dir)

        if File.exists?(f)
          self.solution_file = f
          mark_pass
          load f
          @exercises = MySQLExercises2.new
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_queries_e02
        check_queries
      end
    end
  end
end
