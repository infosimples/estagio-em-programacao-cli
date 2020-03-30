module Graders
  module M05
    class E02 < Graders::Base

      def define_test_method(name, &block)
        self.class.send(:define_method, name, &block)
      end

      def setup
        valid_cpfs = ['883.880.580-61', '638.415.69200', '044.237271-02', '085432.784-42',
          '581394921-67', '763530.83351', '581.39492167', '85512141449']
        invalid_cpfs = ['883.880.580-6', '638.0415.69200', '044.2372.71-02', '085432.784.42',
          '58139.4921-67', '581.39492-167', '2S2.382.028-99', '821.937.902-R4']

        define_test_set(:check_valid_cpfs, :cpf_validation, valid_cpfs, true)
        define_test_set(:check_invalid_cpfs, :cpf_validation, invalid_cpfs, false)


        valid_emails = ['joao43@email.com', 'joao.silva.sauro@email.com.br', 'joao_sauro@email.org',
          'joao.silva_sauro@email2.edu.br']
        invalid_emails = ['joao$sauro@email.com', 'joao#email.com',
          'joao_sauro@@email.com', 'joao43@email_2.com']

        define_test_set(:check_valid_emails, :email_validation, valid_emails, true)
        define_test_set(:check_invalid_emails, :email_validation, invalid_emails, false)


        valid_prices = ['R$ 123,78', 'R$1.982,03', 'U$ 1,864,999.90', 'R$ 1.938.093,33',
          'U$ 3.09', 'U$ 298,927,831,092.93']
        invalid_prices = ['R$ 1232,78', 'R$ 1982,03', 'U$ 1.864.999,90', 'R$ 1,938.093,33',
          'U$ 3.039', 'R$ 432,493.99', 'R$   1,22']

        define_test_set(:check_valid_prices, :price_validation, valid_prices, true)
        define_test_set(:check_invalid_prices, :price_validation, invalid_prices, false)
      end

      def define_test_set(m1, m2, entries, expected_value)
        count = 0
        entries.each do |entry|
          define_test_method("#{m1}_#{count}") { is_method_correct?(m2, entry, expected_value) }
          count += 1
        end
      end

      def run_tests
        setup

        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_solution_file_exists
        f = File.expand_path('m5-e2.rb', @work_dir)

        if File.exists?(f)
          self.solution_file = f
          mark_pass
          load f
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_exercise_class_is_defined
        if (defined? M5E2)
          mark_pass
        else
          mark_fail i18n_args: { klass: 'M5E2'}
        end
      end

      def is_method_correct?(method, args, expected_value)
        obj = M5E2.new

        if obj.send(method, args) == expected_value
          mark_pass i18n_args: { method: method, args: args }, i18n_forced_scope: "graders.M05.default_m5_methods_with_args"
        else
          mark_fail i18n_args: { method: method, args: args }, i18n_forced_scope: "graders.M05.default_m5_methods_with_args"
        end
      rescue Exception => e
        mark_fail i18n_args: { method: method, args: args, more_info: "Erro:\n\t#{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}"}
      end

    end
  end
end
