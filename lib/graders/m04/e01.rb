module Graders
  module M04
    class E01 < Graders::Base

      def run_tests
        f = File.expand_path('simple_store/irb_helper.rb', @work_dir)
        load f

        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def default_params
        {
          'title'             => 'Test product',
          'price'             => 9.99,
          'manufacturer_code' => 0,
          'barcode'           => '12aa'
        }
      end

      def verify_assignment(key)
        begin
          if @product.send(key) == default_params[key]
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Esperado: #{default_params[key]}; Recebido: #{@product.send(key).inspect}"}, abort: true
          end
        rescue Exception => e
          mark_fail i18n_args: { more_info: "Erro:\n\t#{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}"}, abort: true
        end
      end

      def check_product_file_exists
        f = File.expand_path('simple_store/lib/product.rb', @work_dir)
        if File.exists?(f)
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_product_klass_declaration
        if defined?(Product) == 'constant'
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_valid_params
        params = default_params
        begin
          @product = Product.new(params)
          mark_pass
        rescue => e
          backtrace_lines = e.backtrace.select { |line| line !~ /rvm/ }
          mark_fail i18n_args: { msg: "#{e.class}: #{e.message}\n\t#{backtrace_lines.join("\n\t")}", params: params }, abort: true
        end
      end

      def check_instance_variables
        [
          :@title,
          :@price,
          :@manufacturer,
          :@barcode,
          :@code
        ].each do |var|

          product = Product.new(default_params)
          if product.instance_variables.include?(var)
            mark_pass i18n_args: { var: var }
          else
            mark_fail i18n_args: { var: var }, abort: true
          end
        end
      end

      # FIXME: This is a big ugly code so that the summary will be printed
      # correctly.
      def check_price_instance_var; end
      def check_manufacturer_instance_var; end
      def check_barcode_instance_var; end
      def check_code_instance_var; end

      def check_instance_variables_values
        product = Product.new(default_params)

        [
          'title',
          'price',
          'barcode',
        ].each do |var|
          value = product.instance_variable_get("@#{var}")
          if value == default_params[var]
            mark_pass i18n_args: { var: var }
          else
            mark_fail i18n_args: { var: var, expected: default_params[var].inspect, actual:  value.inspect }, abort: true
          end
        end
      end

      def check_price_instance_var_value; end
      def check_barcode_instance_var_value; end

      def check_manufacturer_instance_var_value
        product = Product.new(default_params.merge('manufacturer_code' => 6))

        expected = :PlanetaOrganico
        value = product.instance_variable_get("@manufacturer")

        if value == expected
          mark_pass
        else
          mark_fail i18n_args: { expected: expected.inspect, actual:  value.inspect }, abort: true
        end
      end

      def check_code_instance_var_value
        product = Product.new(default_params.merge('manufacturer_code' => 6, 'barcode' => 'aabbcc'))

        expected = '0--6--aabbcc'
        value = product.instance_variable_get("@code")

        if value == expected
          mark_pass
        else
          mark_fail i18n_args: { expected: expected.inspect, actual:  value.inspect }, abort: true
        end
      end

      def check_readers
        [
          :title,
          :price,
          :manufacturer,
          :barcode,
          :code
        ].each do |var|

          product = Product.new(default_params)
          if product.methods.include?(var)
            mark_pass i18n_args: { var: var }
          else
            mark_fail i18n_args: { var: var }, abort: true
          end
        end
      end

      def check_x_reader; end
      def check_y_reader; end
      def check_z_reader; end
      def check_w_reader; end

      def check_writers
        [
          :title,
          :price,
          :manufacturer,
          :barcode,
          :code
        ].each do |var|

          product = Product.new(default_params)
          if product.methods.include?("#{var}=".to_sym)
            mark_pass i18n_args: { var: var }
          else
            mark_fail i18n_args: { var: var }, abort: true
          end
        end
      end

      def check_x_writer; end
      def check_y_writer; end
      def check_z_writer; end
      def check_w_writer; end

      def check_product_title_assignment
        verify_assignment('title')
      end

      def check_product_price_assignment
        verify_assignment('price')
      end

      def check_product_barcode_assignment
        verify_assignment('barcode')
      end

      def check_product_manufacturer_assignment
        manufacturer = SimpleStore::AUTHORIZED_MANUFACTURERS.find { |k, v| v == default_params['manufacturer_code'] }.first
        begin
          if @product.manufacturer.to_s == manufacturer.to_s
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Esperado: #{manufacturer}; Recebido: #{@product.manufacturer.inspect}"}, abort: true
          end
        rescue Exception => e
          mark_fail i18n_args: { more_info: "Erro:\n\t#{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}"}, abort: true
        end
      end

      def check_generate_control_code_exists
        if Product.new(default_params).private_methods.include?(:generate_control_code)
          mark_pass
        else
          mark_fail
        end
      end

      def check_correct_product_code
        param = default_params
        expected_code = "#{SimpleStore::PRODUCT_TYPES[:Product]}--#{param['manufacturer_code']}--#{param['barcode']}"
        begin
          if @product.code ==expected_code
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Esperado: #{expected_code}; Recebido: #{@product.code.inspect}"}, abort: true
          end
        rescue Exception => e
          mark_fail i18n_args: { more_info: "Erro:\n\t#{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}"}, abort: true
        end
      end

      def check_invalid_title
        params = default_params.merge('title' => nil)
        e = nil

        begin
          Product.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/O t.+tulo do produto n.+o pode ser vazio/)
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error foi lançada com a mensagem incorreta ('#{e.message}')" }, abort: true
          end
        end

        if e.nil?
          mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error não foi lançada" }, abort: true
        end
      end

      def check_price_nil
        params = default_params.merge('price' => nil)
        e=nil

        expected = "O preço do produto deve ser >= 0.0"

        begin
          Product.new(params)
        rescue SimpleStore::Error => e
          if e.message == expected
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error foi lançada com a mensagem incorreta.\nEsperado: #{expected.inspect}. Recebido: #{e.message.inspect}" }, abort: true
          end
        end

        if e.nil?
          mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error não foi lançada" }, abort: true
        end
      end

      def check_price_negative
        params = default_params.merge('price' => -10)
        e=nil

        expected = "O preço do produto deve ser >= 0.0"

        begin
          Product.new(params)
        rescue SimpleStore::Error => e
          if e.message == expected
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error foi lançada com a mensagem incorreta.\nEsperado: #{expected.inspect}. Recebido: #{e.message.inspect}" }, abort: true
          end
        end

        if e.nil?
          mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error não foi lançada" }, abort: true
        end
      end

      def check_invalid_manufacturer
        params = default_params.merge('manufacturer_code' => 'x')
        begin
          Product.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/O fabricante n.o est. autorizado/)
            mark_pass
          else
            mark_fail abort: true
          end
        rescue Exception => e
          mark_fail i18n_args: { more_info: "Erro:\n\t#{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}" }, abort: true
        end
      end
    end
  end
end
