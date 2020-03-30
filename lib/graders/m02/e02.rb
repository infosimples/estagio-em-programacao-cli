module Graders
  module M02
    class E02 < Graders::Base

      GLOBAL_GIT_USER_NAME  = 'Global User Name'
      GLOBAL_GIT_USER_EMAIL = 'global_user@email.com'

      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_global_git_user_name_is_set
        global_git_user_name = %x( git config --global user.name )
        global_git_user_name.strip!

        if global_git_user_name == GLOBAL_GIT_USER_NAME
          mark_pass
        else
          mark_fail i18n_args: { str: global_git_user_name }, abort: true
        end
      end

      def check_global_git_user_email_is_set
        global_git_user_email = %x( git config --global user.email )
        global_git_user_email.strip!

        if global_git_user_email == GLOBAL_GIT_USER_EMAIL
          mark_pass
        else
          mark_fail i18n_args: { str: global_git_user_email }, abort: true
        end
      end

      def check_local_git_user_name_is_set
        dir = File.expand_path('ep-m2-repo', @work_dir)
        git_user_name = %x( cd #{dir}; git config user.name )
        git_user_name.strip!

        if git_user_name != GLOBAL_GIT_USER_NAME &&
           git_user_name.length > 0
          mark_pass
        else
          mark_fail i18n_args: { str: git_user_name }, abort: true
        end
      end

      def check_local_git_email_is_set
        dir = File.expand_path('ep-m2-repo', @work_dir)
        git_user_email = %x( cd #{dir}; git config user.email )
        git_user_email.strip!

        if git_user_email != GLOBAL_GIT_USER_EMAIL &&
           git_user_email.match(/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/)
          mark_pass
        else
          mark_fail i18n_args: { str: git_user_email }, abort: true
        end
      end

    end
  end
end
