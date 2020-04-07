module Graders
  module M08
    class E02 < Graders::Base

      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_solution_file_exists
        f = File.expand_path('form.html', @work_dir)

        if File.exists?(f)
          self.solution_file = f
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_run_casper
        if File.exists?("/opt/bin/casperjs")
          @casperjs = "/opt/bin/casperjs"
        elsif File.exists?("/usr/bin/casperjs")
          @casperjs = "/usr/bin/casperjs"
        elsif File.exists?("/usr/local/bin/casperjs")
          @casperjs = "/usr/local/bin/casperjs"
        end

        if File.exists?(@casperjs || "blablabla")
          out = %x{#{@casperjs}}

          if out[/CasperJS version [^ ]+ at/]
            mark_pass i18n_args: { msg: "casperjs foi instalado corretamente" }
          else
            mark_fail i18n_args: { msg: "casperjs não foi encontrado no diretório /opt/bin/casperjs" } , abort: true
          end
        else
          mark_fail i18n_args: { msg: "casperjs não foi encontrado no diretório /opt/bin/casperjs" } , abort: true
        end

        test_file  = File.expand_path('form-test.js', @work_dir)
        casper_cmd = "( cd #{@work_dir} && #{@casperjs} test --no-colors form-test.js )"
        casper_out = %x{#{casper_cmd}}

        print_casper_instructions(casper_cmd)

        exercises = casper_out.split(/^# \(/)[1..-1]

        exercises.each do |exercise|
          content = exercise.split("\n").reject { |line| line.match(/tests executed in/) }.join("\n")

          ex_name_readable = content.match(/\(\d+\) (.*) \(\d+ tests\)/)[1]
          ex_name_code     = ex_name_readable.downcase.gsub(' ', '_')

          self.define_singleton_method("check_#{ex_name_code}".to_sym) do
          end

          if content.scan(/^(?:PASS|FAIL)/).uniq == ["PASS"]
            mark_pass i18n_args: { msg: ex_name_readable }
          else
            mark_fail i18n_args: { msg: ex_name_readable }
          end
        end
      end

      def print_casper_instructions(casper_cmd)
        home_dir = %x{(cd ~ && pwd)}.strip
        casper_cmd_user = casper_cmd.gsub(home_dir, "~").gsub("--no-colors ", '')

        puts Paint['**********************************************************************']
        puts Paint['Para ver detalhes sobre a correção de cada exercício, execute o']
        puts Paint['comando abaixo em um terminal (com os parênteses):']
        puts Paint[casper_cmd_user]
        puts Paint['**********************************************************************']
      end
    end
  end
end
