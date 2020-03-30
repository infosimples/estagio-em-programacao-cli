module Graders
  module M05
    class E01 < Graders::Base

      EXPECTED_NEWS = "09:55 - [política] Prefeito da Krakosia é eleito o melhor para economia\n" +
                      "10:14 - [cotidiano] Cachorro salva dono de assalto\n" +
                      "11:01 - [esporte] Seleção local de golfe se classifica para mundial\n" +
                      "11:36 - [esporte] João da Silva Sauro é cortado da seleção de golfe\n" +
                      "13:19 - [economia] Desemprego sobe para 12% no último mês\n" +
                      "14:55 - [política] Lei de incentivo ao esporte é aprovada no senado às 10:20\n" +
                      "16:13 - [economia] Cotação do dólar sobe 5% em uma semana\n" +
                      "19:26 - [esporte] Liga nacional de basquete tem recorde de público"

      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_solution_file_exists
        f = File.expand_path('m5-e1.rb', @work_dir)

        if File.exists?(f)
          self.solution_file = f
          mark_pass
          load f
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_exercise_class_is_defined
        if (defined? M5E1)
          mark_pass
        else
          mark_fail i18n_args: { klass: 'M5E1'}
        end
      end

      def check_news_constant_is_correctly_defined
        if (defined? M5E1::NOTICIAS)
          if M5E1::NOTICIAS == EXPECTED_NEWS
            mark_pass i18n_args: { constant: 'NOTICIAS' }
          else
            mark_fail i18n_args: { constant: 'NOTICIAS' }
          end
        else
          mark_fail i18n_args: { constant: 'NOTICIAS' }
        end
      end

      def check_format_news_method
        expected = "política: Prefeito da Krakosia é eleito o melhor para economia (09:55)\n" +
                   "cotidiano: Cachorro salva dono de assalto (10:14)\n" +
                   "esporte: Seleção local de golfe se classifica para mundial (11:01)\n" +
                   "esporte: João da Silva Sauro é cortado da seleção de golfe (11:36)\n" +
                   "economia: Desemprego sobe para 12% no último mês (13:19)\n" +
                   "política: Lei de incentivo ao esporte é aprovada no senado às 10:20 (14:55)\n" +
                   "economia: Cotação do dólar sobe 5% em uma semana (16:13)\n" +
                   "esporte: Liga nacional de basquete tem recorde de público (19:26)"

        is_method_correct?(:format_news, expected)
      end

      def check_find_economy_dollar_news_method
        is_method_correct?(:find_economy_dollar_news, 1)
      end

      def check_find_times_method
        times = [ '09:55', '10:14', '11:01', '11:36', '13:19',
          '14:55', '16:13', '19:26' ]
        is_method_correct?(:find_times, times)
      end

      def is_method_correct?(method, expected_value)
        obj = M5E1.new

        if obj.send(method) == expected_value
          mark_pass i18n_args: { method: method }
        else
          mark_fail i18n_args: { method: method }
        end
      rescue Exception => e
        mark_fail i18n_args: { method: method, more_info: "Erro:\n\t#{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}"}
      end

    end
  end
end
