require 'mechanize'

module Graders
  module M10
    class E01 < Graders::Base
      # O exercício M10-E01 (deploy no Heroku) foi removido do conteúdo do curso
      # após o encerramento do plano gratuito do Heroku (nov/2022). Mantemos o
      # corretor apenas informando que não há mais correção a executar.
      def run_tests
        puts Paint["[!] O exercício M10-E01 foi descontinuado.", :yellow, :bold]
        puts Paint["    Ele dependia de deploy no Heroku (plano gratuito encerrado em nov/2022)", :yellow]
        puts Paint["    e não faz mais parte do conteúdo do curso.", :yellow]
      end

      def tests_count
        0
      end

      def check_solution_file_exists
        f = File.expand_path(@file_name, @work_dir)

        if File.exist?(f)
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
