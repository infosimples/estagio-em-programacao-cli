module Graders
  module M07
    class E02 < Graders::Base
      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_solution_file_exists
        f = File.expand_path('m7-e2.rb', @work_dir)

        if File.exists?(f)
          self.solution_file = f
          mark_pass
          load f
        else
          mark_fail i18n_args: { f: f }
        end
      end

      def check_producer_class_is_defined
        if (defined? Producer)
          mark_pass
        else
          mark_fail i18n_args: { klass: 'Producer'}
        end
      end

      def check_consumer_class_is_defined
        if (defined? Consumer)
          mark_pass
        else
          mark_fail i18n_args: { klass: 'Consumer'}
        end
      end

      def check_producer_is_producing_expected_integers
        return unless (defined? Producer)
        queue = Queue.new
        Producer.new(queue).run()
        values = queue.size.times.map { queue.pop }
        values.delete_if { |v| !v.is_a?(Fixnum) }
        if values.sort == [131, 271, 991, 3102, 8172, 9102]
          mark_pass i18n_args: { values: values }
        else
          mark_fail i18n_args: { values: values }
        end
      end

      def check_consumer_is_consuming_integers_as_expected
        return unless (defined? Producer)
        return unless (defined? Consumer)
        queue = Queue.new
        Producer.new(queue).run()
        Consumer.new(queue).run()
        if OUTPUT.sort == [1310, 2710, 9910, 31020, 81720, 91020]
          mark_pass i18n_args: { values: OUTPUT }
        else
          mark_fail i18n_args: { values: OUTPUT }
        end
      end
    end
  end
end
