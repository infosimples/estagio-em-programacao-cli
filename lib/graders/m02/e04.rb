require 'git'

module Graders
  module M02
    class E04 < Graders::Base

      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_release_branch_exists
        git_repo_path = File.expand_path('ep-m2-repo', @work_dir)
        git = Git.open(git_repo_path)

        if git.branches['release'].nil?
          mark_fail abort: true
        else
          mark_pass
        end
      end

      def check_remote_release_branch_exists
        git_repo_path = File.expand_path('ep-m2-repo', @work_dir)
        git = Git.open(git_repo_path)

        if git.branches['origin/release'].nil?
          mark_fail abort: true
        else
          mark_pass
        end
      end

    end
  end
end
