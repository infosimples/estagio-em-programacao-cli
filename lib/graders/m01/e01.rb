module Graders
  module M01
    class E01 < Graders::Base

      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def execute_m1_e1_script(file)
        f = File.expand_path('dir_1', @work_dir)

        # Remove existent dir to ensure the creation by the script
        FileUtils.rm_rf(f)

        # Execute the script
        %x[cd #{File.dirname(file)} && ./#{File.basename(file)}]
      end

      def mark_directory(f)
        if File.directory?(f)
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_solution_file_exists
        f = File.expand_path('m1-e1.sh', @work_dir)

        if File.exist?(f)
          self.solution_file = f
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_solution_file_executable
        f = File.expand_path('m1-e1.sh', @work_dir)

        if File.executable?(f)
          mark_pass
          # Clean up and execute the script
          execute_m1_e1_script(f)
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_raiz_directory_exists
        f = File.expand_path('dir_1', @work_dir)
        mark_directory(f)
      end

      def check_treinamento_estagio_programacao_directory_exists
        f = File.expand_path('dir_1/treinamento_estagio_programacao', @work_dir)
        mark_directory(f)
      end

      def check_tep_file_exists
        f = File.expand_path('dir_1/TEP', @work_dir)
        mark_directory(f)
      end

      def check_tep_is_symlink
        f = File.expand_path('dir_1/TEP', @work_dir)

        if File.symlink?(f)
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_tep_points_treinamento_estagio_programacao
        tep = File.expand_path('dir_1/TEP', @work_dir)
        f = File.expand_path('dir_1/treinamento_estagio_programacao', @work_dir)

        if Pathname.new(tep).realpath.to_s == f
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_fernando_directory_exists
        f = File.expand_path('dir_1/treinamento_estagio_programacao/aluno_fernando', @work_dir)
        mark_directory(f)
      end

      def check_fer_file_exists
        f = File.expand_path('dir_1/treinamento_estagio_programacao/fer', @work_dir)
        mark_directory(f)
      end

      def check_fer_is_symlink
        f = File.expand_path('dir_1/treinamento_estagio_programacao/fer', @work_dir)

        if File.symlink?(f)
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_fer_points_fernando
        fer = File.expand_path('dir_1/treinamento_estagio_programacao/fer', @work_dir)
        f = File.expand_path('dir_1/treinamento_estagio_programacao/aluno_fernando', @work_dir)

        if Pathname.new(fer).realpath.to_s == f
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end

      def check_vazio_file_exists
        f = File.expand_path('dir_1/treinamento_estagio_programacao/aluno_fernando/notas.txt', @work_dir)

        if File.file?(f)
          mark_pass
        else
          mark_fail i18n_args: { f: f }, abort: true
        end
      end
    end
  end
end
