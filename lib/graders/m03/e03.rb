require_relative 'e01'

module Graders
  module M03
    class E03 < Graders::M03::E01
      def tests_count
        12
      end

      def expected_file_path
        File.expand_path('m3-e3.rb', @work_dir)
      end
    end
  end
end
