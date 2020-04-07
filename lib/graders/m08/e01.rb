require 'base64'

module Graders
  module M08
    class E01 < Graders::Base

      def run_tests
        print_result [:pass, 'Você deve concluir o jogo em http://flukeout.github.io/']
      end

    end
  end
end
