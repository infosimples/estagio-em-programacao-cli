module Graders

  # Base class for all graders.
  class Base
    attr_accessor :solution_file

    #
    # Constructor.
    # @param [String] work_dir Working directory (where to find solution files).
    # @param [Bool] show_hints Whether to print hint messages.
    #
    def initialize(work_dir:, show_hints: false)
      @checks     = []
      @show_hints = show_hints
      @work_dir   = work_dir
    end

    #
    # Ask the grader to perform its tests, save and print results.
    #
    def run
      catch(:abort) do
        run_tests
      end

      # save_results
      wrap_up
    end

    #
    # @return [Array<Symbol>] An array of test methods names.
    #
    def test_methods
      _, m, e = self.class.to_s.split('::').map(&:to_sym)
      expected = I18n.backend.translations['pt-BR'.to_sym][:graders][m][e].keys
      implemented = self.public_methods(false).select { |m| m.to_s.start_with?('check_') }
      expected.find_all { |m| implemented.include?(m) }
    end

    #
    # @return [Fixnum] The number of tests performed by the grader.
    #
    def tests_count
      test_methods.count
    end

    #
    # Record a failed test in the correction.
    # @param [String] msg The error message.
    # @param [String] hint_msg The hint message to display as help.
    # @param [Bool] abort If true, correction will not proceed.
    #
    def mark_fail(i18n_args: {}, abort: false, error_msg: nil, error: nil, backtrace: true, i18n_forced_scope: nil)
      if error
        error_msg ||= "Erro ao executar o teste."
        msg  = "#{error_msg} Mensagem: #{error.message}\n"

        if backtrace
          msg += "\t#{error.backtrace.join("\n\t")}"
        end
      else
        msg  = I18n.t("#{i18n_forced_scope || i18n_scope}.fail", **i18n_args)
      end

      hint = I18n.t("#{i18n_forced_scope || i18n_scope}.hint", **i18n_args)
      @checks << [:fail, msg, hint]
      print_result(@checks.last)

      throw :abort if abort
    end

    #
    # Record a successful test in the correction.
    # @param [String] msg The success message.
    #
    def mark_pass(i18n_args: {}, i18n_forced_scope: nil)
      msg = I18n.t("#{i18n_forced_scope || i18n_scope}.pass", **i18n_args)
      @checks << [:pass, msg]
      print_result(@checks.last)
    end

    #
    # Record a notice in tests to help the user to know what is been tested.
    # @param [String] msg The notice message.
    #
    def notice(i18n_args: {})
      msg = I18n.t("#{i18n_scope}.notice", **i18n_args)
      @checks << [:notice, msg]
      print_result(@checks.last)
    end

    def i18n_scope
      m, e = self.class.name.split('::')[1..-1]
      "graders.#{m}.#{e}.#{@test_name}"
    end

    def print_result(result)
      case result.first
      when :pass
        puts Paint["[v] #{result[1]}", :green]
      when :notice
        puts Paint[result[1], :blue]
      when :fail
        puts Paint["[x] #{result[1]}", :red]

        if @show_hints && (hint = result[2])
          puts "    #{hint}"
        end
      end
    end

    #
    # Print grading summary.
    #
    def wrap_up
      puts
      puts I18n.t('graders.base.summary.footer', p: summary[:pass_count],
                  f: summary[:fail_count], s: summary[:skip_count])
    end

    #
    # Compute the grading summary.
    # @return [Hash] The summary
    #
    def summary
      return @summary if @summary

      name_tokens = self.class.name.split('::')
      pass_count  = 0
      fail_count  = 0

      @checks.each do |check|
        case check.first
        when :pass
          pass_count += 1
        when :fail
          fail_count += 1
        end
      end

      skip_count  = tests_count - pass_count - fail_count

      @summary = {
        module: name_tokens[1][1..-1].to_i,
        exercise: name_tokens[2][1..-1].to_i,
        pass_count: pass_count,
        fail_count: fail_count,
        skip_count: skip_count,
        graded_at: Time.now.iso8601
      }
    end
  end
end
