require 'terminal-table'
require 'base64'

module Graders
  module M06
    class Base < Graders::Base

      attr_reader :q

      def initialize(*args)
        super(*args)
        @q = YAML.load(Base64.decode64(File.read(File.expand_path('../q', __FILE__))))
      end

      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_queries
        queries = Graders::M06::E01 === self ? q[:queries_e01] : q[:queries_e02]

        queries.each do |ex_name, query|

          unless queries.keys.index(ex_name) == (queries.keys.size - 1)
            self.define_singleton_method("check_#{ex_name}".to_sym) do
            end
          end

          begin
            expected = @exercises.client.query(query)
            actual = @exercises.client.query(@exercises.send(ex_name))
            compare_result_sets(ex_name, expected, actual)
          rescue => ex
            if ex.class == Mysql2::Error && ex.message["You have an error in your SQL syntax"]
              mark_fail error_msg: "Erro ao executar o teste do exercício #{ex_name}.\n", error: ex, backtrace: false
            else
              mark_fail error_msg: "Erro ao executar o teste do exercício #{ex_name}.\n", error: ex
            end
          end
        end
      end

      def build_output_table(result)
        rows = []
        rows << result.fields
        rows << :separator
        rows << result.entries.first.values

        if result.entries.count > 10
          result.entries[2..5].each do |entry|
            rows << entry.values
          end

          rows << result.fields.map { |f| '...' }
          rows << result.fields.map { |f| '...' }

          result.entries[-5..-1].each do |entry|
            rows << entry.values
          end
        elsif result.entries.count > 1
          result.entries[1..-1].each do |entry|
            rows << entry.values
          end
        end

        Terminal::Table.new(rows: rows).to_s
      end

      def indent(text, char: "\t")
        text.split("\n").map { |line| "#{char}#{line}" }.join("\n")
      end

      def compare_result_sets(ex_name, expected, actual)
        if expected.entries == actual.entries
          mark_pass i18n_args: { ex_name: ex_name }
        else
          details = "\n"
          details += "- Colunas esperadas: #{expected.fields.inspect}\n"
          details += "- Colunas recebidas: #{actual.fields.inspect}\n"
          details += "\n"
          details += "- Núm. linhas esperado: #{expected.entries.count}\n"
          details += "- Núm. linhas recebido: #{actual.entries.count}\n"
          details += "\n"

          details += "Recebido:\n"
          details += build_output_table(actual)
          details += "\n"
          details += "\n"

          details += "Esperado:\n"
          details += build_output_table(expected)
          details += "\n"

          details = indent(details)

          mark_fail i18n_args: { ex_name: ex_name, more_info: details }
        end
      end

    end
  end
end
