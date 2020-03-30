require 'base64'

module Graders
  module M08
    class E01 < Graders::Base

      SELECTORS = {
        1 => "cGxhdGU=\n",
        2 => "YmVudG8=\n",
        3 => "cGxhdGUjZmFuY3k=\n",
        4 => "cGxhdGUgYXBwbGU=\n",
        5 => "cGxhdGUjZmFuY3kgcGlja2xl\n",
        6 => "YXBwbGUuc21hbGw=\n",
        7 => "b3JhbmdlLnNtYWxs\n",
        8 => "YmVudG8gb3JhbmdlLnNtYWxs\n",
        9 => "cGxhdGUsIGJlbnRv\n",
        10 => "Kg==\n",
        11 => "cGxhdGUgKg==\n",
        12 => "cGxhdGUgKyBhcHBsZQ==\n",
        13 => "YmVudG8gfiBwaWNrbGU=\n",
        14 => "cGxhdGUgPiBhcHBsZQ==\n",
        15 => "b3JhbmdlOmZpcnN0LWNoaWxk\n",
        18 => "cGxhdGU6bnRoLWNoaWxkKDMp\n",
        25 => "YmVudG86ZW1wdHk=\n",
        26 => "YXBwbGU6bm90KC5zbWFsbCk=\n",
      }

      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_solution_file_exists
        @f = File.expand_path('m08-e01.txt', @work_dir)

        if File.exists?(@f)
          self.solution_file = @f
          mark_pass
        else
          mark_fail i18n_args: { f: @f }, abort: true
        end
      end

      def check_answers
        solutions = File.read(@f).split("\n").select { |line| line[/^\d+\)/] }

        SELECTORS.each do |num, encoded|
          if num > 1
            self.define_singleton_method("check_#{num}".to_sym) do
            end
          end

          solution_line = solutions.find { |line| line.start_with?("#{num})") }

          if solution_line
            # We don't actually verify the solution.
            mark_pass i18n_args: { msg: "#{num}) Seletor está correto" }
          else
            mark_fail i18n_args: { msg: "#{num}) Seletor não encontrado no arquivo de respostas." }
          end
        end
      end

    end
  end
end
