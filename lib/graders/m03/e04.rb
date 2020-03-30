module Graders
  module M03
    class E04 < Graders::Base
      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_solution_file_exists
        f = File.expand_path('m3-e4.rb', @work_dir)

        if File.exists?(f)
          mark_pass
          load f
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end


      # Check function definitions
      #

      def check_function_definition_factorial
        if (defined? factorial) == 'method'
          mark_pass i18n_args: { method: 'factorial' }
        else
          mark_fail i18n_args: { method: 'factorial' }, abort: true
        end
      end

      def check_function_definition_reverse
        if (defined? reverse) == 'method'
          mark_pass i18n_args: { method: 'reverse' }
        else
          mark_fail i18n_args: { method: 'reverse' }, abort: true
        end
      end

      def check_function_definition_sort
        if (defined? sort) == 'method'
          mark_pass i18n_args: { method: 'sort' }
        else
          mark_fail i18n_args: { method: 'sort' }, abort: true
        end
      end

      def check_function_definition_upcase
        if (defined? upcase) == 'method'
          mark_pass i18n_args: { method: 'upcase' }
        else
          mark_fail i18n_args: { method: 'upcase' }, abort: true
        end
      end


      # Factorial
      #

      def mark_factorial(n, correct)
        args = {n: n}

        if factorial(n) == correct
          mark_pass i18n_args: args
        else
          mark_fail i18n_args: args
        end
      end

      def check_factorial_0
        mark_factorial 0, 1
      end

      def check_factorial_1
        mark_factorial 1, 1
      end

      def check_factorial_2
        mark_factorial 2, 2
      end

      def check_factorial_5
        mark_factorial 5, 120
      end

      def check_factorial_10
        mark_factorial 10, 3628800
      end


      # Reverse
      #

      def mark_reverse(str)
        args = {str: str}

        if reverse(str.clone) == str.reverse
          mark_pass i18n_args: args
        else
          mark_fail i18n_args: args
        end
      end

      def check_reverse_a
        mark_reverse 'a'
      end

      def check_reverse_ab
        mark_reverse 'ab'
      end

      def check_reverse_abcdefghijklmnopqrstuvwxyz
        mark_reverse 'abcdefghijklmnopqrstuvwxyz'
      end


      # Sort
      #

      def mark_sort(arr)
        args = { arr: arr.to_s }

        if sort(arr.clone) == arr.sort
          mark_pass i18n_args: args
        else
          mark_fail i18n_args: args
        end
      end

      def check_sort_empty
        mark_sort []
      end

      def check_sort_1
        mark_sort [1]
      end

      def check_sort_1_2
        mark_sort [1, 2]
      end

      def check_sort_2_1
        mark_sort [2, 1]
      end

      def check_sort_big_array
        mark_sort [20, 1, 50, 3, 10, 1, 22, 23, 32, 2]
      end


      # Upcase
      #

      def mark_upcase(str)
        args = { str: str }

        if upcase(str.clone) == str.upcase
          mark_pass i18n_args: args
        else
          mark_fail i18n_args: args
        end
      end

      def check_upcase_empty
        mark_upcase('')
      end

      def check_upcase_a
        mark_upcase('a')
      end

      def check_upcase_ab
        mark_upcase('ab')
      end

      def check_upcase_ab_cd
        mark_upcase('ab cd')
      end

      def check_upcase_abc_def
        mark_upcase('Abc Def')
      end

      def check_upcase_abcdefghijklmnopqrstuvwxyz
        mark_upcase('abcdefghijklmnopqrstuvwxyz')
      end
    end
  end
end
