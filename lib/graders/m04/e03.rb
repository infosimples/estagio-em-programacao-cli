module Graders
  module M04
    class E03 < Graders::Base

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
          'barcode'           => '12aa',
          'expiration_date'   => '2020-10-10',
          'url'               => 'http://www.google.com'
        }
      end

      def check_fresh_product_is_discount_eligible
        if defined?(FreshProduct) && FreshProduct.included_modules.include?(DiscountEligible)
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_digital_product_is_discount_eligible
        if defined?(DigitalProduct) && DigitalProduct.included_modules.include?(DiscountEligible)
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_days_to_expire
        date_param = (Date.today + 3).to_s

        p = FreshProduct.new(default_params.merge({
          'expiration_date' => date_param
        }))

        days = p.days_to_expire
        expected = (Date.parse(date_param) - Date.today).to_i

        if days == expected
          mark_pass
        else
          mark_fail abort: true, i18n_args: { more_info: "Data informada: #{date_param}. Esperado: #{expected.inspect}, recebido: #{days.inspect}"}
        end
      end


      def check_discount_amount
        date_param = (Date.today + 3).to_s

        p = FreshProduct.new(default_params.merge({
          'expiration_date' => date_param
        }))

        actual = p.discount_amount
        expected = (p.discount_percentage * p.price).round(2)

        if actual == expected
          mark_pass
        else
          mark_fail abort: true, i18n_args: { more_info: "Esperado: #{expected.inspect}, recebido: #{actual.inspect}"}
        end
      end

      def check_discounted_price
        date_param = (Date.today + 3).to_s

        p = FreshProduct.new(default_params.merge({
          'expiration_date' => date_param
        }))

        actual = p.discounted_price
        expected = (p.price - p.discount_amount).round(2)

        if actual == expected
          mark_pass
        else
          mark_fail abort: true, i18n_args: { more_info: "Esperado: #{expected.inspect}, recebido: #{actual.inspect}"}
        end
      end
    end
  end
end
