module Graders
  module M01
    class E03 < Graders::Base

      def run_tests
        @answer = {}
        @data = {}
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def execute_m1_e3_script(file, url, term)
        f = File.expand_path(url.split('/').last, @work_dir)
        # Remove file
        FileUtils.rm f if File.exists?(f)

        # Execute the script
        @data[term.to_sym] = open(url).read.encode('utf-8', invalid: :replace, replace: '?')
        @data["output_#{term}".to_sym] = %x[cd #{File.dirname(file)} && ./#{File.basename(file)} #{url} #{term}]
      end

      def mark_count(term, rb_count)
        if rb_count == @answer[term].to_i
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_solution_file_exists
        f = File.expand_path('m1-e3.sh', @work_dir)

        if File.exist?(f)
          self.solution_file = f
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_solution_file_executable
        @solution_file = File.expand_path('m1-e3.sh', @work_dir)

        if File.executable?(@solution_file)
          mark_pass
        else
          mark_fail i18n_args: { f: @solution_file }, abort: true
        end
      end

      def check_answer_ibm_format
        notice
        execute_m1_e3_script(@solution_file, 'https://en.wikipedia.org/wiki/Unix', 'ibm')
        ibm = @data[:output_ibm].match(/ibm:\s+(\d+)/)
        if ibm.nil?
          mark_fail abort: true
        else
          @answer[:ibm] = ibm[1]
          mark_pass
        end
      end

      def check_ibm_occurrencies_count
        rb_count = @data[:ibm].scan(/ibm/i).size
        mark_count(:ibm, rb_count)
      end

      def check_answer_kernel_format
        notice
        execute_m1_e3_script(@solution_file, 'https://en.wikiquote.org/wiki/Linus_Torvalds', 'kernel')
        kernel = @data[:output_kernel].match(/kernel:\s+(\d+)/)

        if kernel.nil?
          mark_fail abort: true
        else
          @answer[:kernel] = kernel[1]
          mark_pass
        end
      end

      def check_kernel_occurrencies_count
        rb_count = @data[:kernel].scan(/kernel/i).size
        mark_count(:kernel, rb_count)
      end
    end
  end
end
