require 'date'

module Graders
  module M04
    class E02 < Graders::Base

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
          'title' => 'Test product',
          'price' => 9.99,
          'manufacturer_code' => 2,
          'barcode' => '12aa'
        }
      end

      def fresh_params
        default_params.merge({
          'expiration_date' => Date.today.next_day.iso8601,
          'manufacturer_code' => 5
        })
      end

      def digital_params
        default_params.merge({
          'expiration_date' => Date.today.next_day.iso8601,
          'url' => 'http://www.oreilly.com/',
          'manufacturer_code' => 0
        })
      end

      def mark_file_exists(f)
        if File.exists?(f)
          mark_pass
          load f
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      # File exists and declarations

      def check_physical_product_file_exists
        f = File.expand_path('simple_store/lib/products/physical_product.rb', @work_dir)
        mark_file_exists(f)
      end

      def check_physical_product_klass_declaration
        if defined?(PhysicalProduct) == 'constant'
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_physical_product_inherits_product
        if PhysicalProduct.ancestors.include?(Product)
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_fresh_product_file_exists
        f = File.expand_path('simple_store/lib/products/fresh_product.rb', @work_dir)
        mark_file_exists(f)
      end

      def check_fresh_product_klass_declaration
        if defined?(FreshProduct) == 'constant'
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_fresh_product_inherits_product
        if FreshProduct.ancestors.include?(Product)
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_digital_product_file_exists
        f = File.expand_path('simple_store/lib/products/digital_product.rb', @work_dir)
        mark_file_exists(f)
      end

      def check_digital_product_klass_declaration
        if defined?(DigitalProduct) == 'constant'
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_digital_product_inherits_product
        if DigitalProduct.ancestors.include?(Product)
          mark_pass
        else
          mark_fail abort: true
        end
      end

      ########################################################################
      # Check create physical products and errors
      #######################################################################

      def check_valid_physical_params
        params = default_params
        begin
          @physical = PhysicalProduct.new(params)
          mark_pass
        rescue => e
          mark_fail i18n_args: { msg: e.message }, abort: true
        end
      end

      def check_physical_product_title_assignment
        if @physical.send('title') == default_params['title']
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_physical_product_price_assignment
        if @physical.send('price') == default_params['price']
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_physical_product_barcode_assignment
        if @physical.send('barcode') == default_params['barcode']
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_physical_product_manufacturer_assignment
        manufacturer = SimpleStore::AUTHORIZED_MANUFACTURERS.key(default_params['manufacturer_code']).to_s
        if @physical.manufacturer.to_s == manufacturer
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_correct_physical_product_code
        param = default_params
        expected = "#{SimpleStore::PRODUCT_TYPES[:PhysicalProduct]}--#{param['manufacturer_code']}--#{param['barcode']}"
        if @physical.code == expected
          mark_pass
        else
          mark_fail i18n_args: { expected: expected.inspect, actual: @physical.code.inspect }
        end
      end

      def check_invalid_physical_title
        params = default_params.merge('title' => nil)
        e=nil
        begin
          PhysicalProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/O t.+tulo do produto n.+o pode ser vazio/)
            mark_pass
          else
            mark_fail abort: true
          end
        end

        if e.nil?
          mark_fail abort: true
        end
      end

      def check_physical_price_nil
        params = default_params.merge('price' => nil)
        e=nil

        expected = "O preço do produto deve ser >= 0.0"

        begin
          PhysicalProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message == expected
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error foi lançada com a mensagem incorreta.\nEsperado: #{expected.inspect}. Recebido: #{e.message.inspect}" }, abort: true
          end
        end

        if e.nil?
          mark_fail abort: true
        end
      end

      def check_physical_price_negative
        params = default_params.merge('price' => -10)
        e=nil

        expected = "O preço do produto deve ser >= 0.0"

        begin
          PhysicalProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message == expected
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error foi lançada com a mensagem incorreta.\nEsperado: #{expected.inspect}. Recebido: #{e.message.inspect}" }, abort: true
          end
        end

        if e.nil?
          mark_fail abort: true
        end
      end

      def check_invalid_physical_manufacturer
        params = default_params.merge('manufacturer_code' => 'x')
        begin
          PhysicalProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/O fabricante n.+o est.+ autorizado/)
            mark_pass
          else
            mark_fail abort: true
          end
        end
      end

      ########################################################################
      # Check create Fresh products and errors
      # #####################################################################

      def check_valid_fresh_params
        params = fresh_params
        begin
          @fresh = FreshProduct.new(params)
          mark_pass
        rescue => e
          mark_fail i18n_args: { msg: e.message }, abort: true
        end
      end

      def check_fresh_product_title_assignment
        expected = fresh_params['title']
        actual   = @fresh.send('title')
        if actual == expected
          mark_pass
        else
          mark_fail abort: true, i18n_args: { expected: expected.inspect, actual: actual.inspect }
        end
      end

      def check_fresh_product_price_assignment
        if @fresh.send('price') == fresh_params['price']
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_fresh_product_barcode_assignment
        if @fresh.send('barcode') == fresh_params['barcode']
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_fresh_product_expiration_date_setter
        if @fresh.respond_to?(:expiration_date)
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_fresh_product_expiration_date_assignment
        if @fresh.send('expiration_date') == fresh_params['expiration_date']
          mark_pass
        else
          mark_fail abort: true, i18n_args: { more_info: "Esperado: #{fresh_params['expiration_date'].inspect}; Recebido: #{@fresh.expiration_date.inspect}"}
        end
      end

      def check_fresh_product_manufacturer_assignment
        manufacturer = SimpleStore::AUTHORIZED_MANUFACTURERS.key(fresh_params['manufacturer_code']).to_s
        if @fresh.manufacturer.to_s == manufacturer
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_correct_fresh_product_code
        param = fresh_params
        expected = "#{SimpleStore::PRODUCT_TYPES[:FreshProduct]}--#{param['manufacturer_code']}--#{param['barcode']}"
        if @fresh.code == expected
          mark_pass
        else
          mark_fail abort: true, i18n_args: { expected: expected.inspect, actual: @fresh.code.inspect }
        end
      end

      def check_invalid_fresh_title
        params = fresh_params.merge('title' => nil)
        begin
          FreshProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/O t.+tulo do produto n.+o pode ser vazio/)
            mark_pass
          else
            mark_fail abort: true
          end
        end
      end

      def check_fresh_price_nil
        params = fresh_params.merge('price' => nil)
        expected = "O preço do produto deve ser >= 0.0"
        begin
          FreshProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message == expected
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error foi lançada com a mensagem incorreta.\nEsperado: #{expected.inspect}. Recebido: #{e.message.inspect}" }, abort: true
          end
        end
      end

      def check_fresh_price_negative
        params = fresh_params.merge('price' => -10)
        expected = "O preço do produto deve ser >= 0.0"
        begin
          FreshProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message == expected
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error foi lançada com a mensagem incorreta.\nEsperado: #{expected.inspect}. Recebido: #{e.message.inspect}" }, abort: true
          end
        end
      end

      def check_invalid_fresh_manufacturer
        params = fresh_params.merge('manufacturer_code' => 'x')
        begin
          FreshProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/O fabricante n.+o est.+ autorizado/)
            mark_pass
          else
            mark_fail abort: true
          end
        end
      end

      def check_nil_fresh_expiration_date
        params = fresh_params.merge('expiration_date' => nil)
        e=nil

        begin
          FreshProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/O produto n.+o pode estar vencido/)
            mark_pass
          else
            mark_fail abort: true
          end
        end

        if e.nil?
          mark_fail abort: true
        end
      end

      def check_fresh_expirated
        params = fresh_params.merge('expiration_date' => '2015-01-01')
        e=nil

        begin
          FreshProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/O produto n.+o pode estar vencido/)
            mark_pass
          else
            mark_fail abort: true
          end
        end

        if e.nil?
          mark_fail abort: true
        end
      end

      ###########################################
      # Check create Digital products and errors
      ###########################################

      def check_valid_digital_params
        params = digital_params
        begin
          @digital = DigitalProduct.new(params)
          mark_pass
        rescue => e
          mark_fail i18n_args: { msg: e.message }, abort: true
        end
      end

      def check_digital_product_title_assignment
        if @digital.send('title') == digital_params['title']
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_digital_product_price_assignment
        if @digital.send('price') == digital_params['price']
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_digital_product_barcode_assignment
        if @digital.send('barcode') == digital_params['barcode']
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_digital_product_expiration_date_setter
        if @digital.respond_to?(:expiration_date)
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_digital_product_expiration_date_assignment
        if @digital.send('expiration_date') == digital_params['expiration_date']
          mark_pass
        else
          mark_fail abort:true, i18n_args: { more_info: "Esperado: #{fresh_params['expiration_date'].inspect}; Recebido: #{@digital.expiration_date.inspect}"}
        end
      end

      def check_digital_product_url_getter
        if @digital.respond_to?(:url)
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_digital_product_url_assignment
        if @digital.send('url') == digital_params['url']
          mark_pass
        else
          mark_fail abort: true, i18n_args: { more_info: "Esperado: #{digital_params['url'].inspect}; Recebido: #{@digital.url.inspect}"}
        end
      end

      def check_digital_product_manufacturer_assignment
        manufacturer = SimpleStore::AUTHORIZED_MANUFACTURERS.key(digital_params['manufacturer_code']).to_s
        if @digital.manufacturer.to_s == manufacturer
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_correct_digital_product_code
        param = digital_params
        expected = "#{SimpleStore::PRODUCT_TYPES[:DigitalProduct]}--#{param['manufacturer_code']}--#{param['barcode']}"
        if @digital.code == expected
          mark_pass
        else
          mark_fail abort: true, i18n_args: { expected: expected.inspect, actual: @digital.code.inspect }
        end
      end

      def check_invalid_digital_title
        params = digital_params.merge('title' => nil)
        e = nil

        begin
          DigitalProduct.new(params)
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

      def check_digital_price_nil
        params = digital_params.merge('price' => nil)
        e=nil

        expected = "O preço do produto deve ser >= 0.0"

        begin
          DigitalProduct.new(params)
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

      def check_digital_price_negative
        params = digital_params.merge('price' => -10)
        e=nil

        expected = "O preço do produto deve ser >= 0.0"

        begin
          DigitalProduct.new(params)
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

      def check_invalid_digital_manufacturer
        params = digital_params.merge('manufacturer_code' => 'x')
        e=nil

        begin
          DigitalProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/O fabricante n.+o est.+ autorizado/)
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error foi lançada com a mensagem incorreta ('#{e.message}')" }, abort: true
          end
        end

        if e.nil?
          mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error não foi lançada" }, abort: true
        end
      end

      def check_nil_digital_expiration_date
        params = digital_params.merge('expiration_date' => nil)
        e=nil

        begin
          DigitalProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/O produto n.+o pode estar vencido/)
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error foi lançada com a mensagem incorreta ('#{e.message}')" }, abort: true
          end
        end

        if e.nil?
          mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error não foi lançada" }, abort: true
        end
      end

      def check_digital_expirated
        params = digital_params.merge('expiration_date' => '2015-01-01')
        e=nil

        begin
          DigitalProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/O produto n.+o pode estar vencido/)
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error foi lançada com a mensagem incorreta ('#{e.message}')" }, abort: true
          end
        end

        if e.nil?
          mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error não foi lançada" }, abort: true
        end
      end

      def check_invalid_digital_url
        params = digital_params.merge('url' => 'infosimples.com.br')
        e=nil

        begin
          DigitalProduct.new(params)
        rescue SimpleStore::Error => e
          if e.message.match(/A URL do produto deve ser v.+lida/i)
            mark_pass
          else
            mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error foi lançada com a mensagem incorreta ('#{e.message}')" }, abort: true
          end
        end

        if e.nil?
          mark_fail i18n_args: { more_info: "Motivo: a exceção SimpleStore::Error não foi lançada" }, abort: true
        end
      end
    end
  end
end
