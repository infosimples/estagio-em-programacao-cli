require 'git'

module Graders
  module M02
    class E01 < Graders::Base

      GITHUB_REMOTE_URL_REGEX = /github\.com\/[^\/]*\/ep-m2-repo/

      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_repo_directory_exists
        dir = File.expand_path('ep-m2-repo', @work_dir)

        if File.directory?(dir)
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_dir_is_a_git_repo
        dir = File.expand_path('ep-m2-repo/.git', @work_dir)

        if File.directory?(dir)
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_repo_has_github_remote
        dir = File.expand_path('ep-m2-repo', @work_dir)

        git = ::Git.open(dir)

        match = nil
        git.remotes.each do |remote|
          break if (match = remote.url.match(GITHUB_REMOTE_URL_REGEX))
        end

        if match
          mark_pass
        else
          mark_fail abort: true
        end
      end

    end
  end
end
