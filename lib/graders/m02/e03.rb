require 'git'

module Graders
  module M02
    class E03 < Graders::Base

      def run_tests
        test_methods.each do |tm|
          @test_name = tm
          self.send(tm)
        end
      end

      def check_repo_is_not_empty
        git_repo_path = File.expand_path('ep-m2-repo', @work_dir)
        git = Git.open(git_repo_path)

        begin
          if git.revparse('HEAD').length > 0
            mark_pass
          else
            mark_fail abort: true
          end
        rescue Git::GitExecuteError
          mark_fail abort: true
        end
      end

      def check_first_commit_adds_a_txt
        git_repo_path = File.expand_path('ep-m2-repo', @work_dir)
        git = Git.open(git_repo_path)

        log   = git.log
        count = log.size

        commit = git.log[count - 1]

        if commit.nil?
          mark_fail abort: true
          return
        end

        delta = commit_delta(git, commit.sha)

        if delta.keys.size == 1 && delta['a.txt'] == 'A'
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_first_commit_has_correct_message
        git_repo_path = File.expand_path('ep-m2-repo', @work_dir)
        git = Git.open(git_repo_path)

        log   = git.log
        count = log.size

        commit = git.log[count - 1]

        if commit.nil?
          mark_fail abort: true
          return
        end

        if commit.message.strip == 'Adicionado o arquivo a.txt'
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_second_commit_adds_b_txt
        git_repo_path = File.expand_path('ep-m2-repo', @work_dir)
        git = Git.open(git_repo_path)

        log   = git.log
        count = log.size

        commit = git.log[count - 2]

        if commit.nil?
          mark_fail abort: true
          return
        end

        delta = commit_delta(git, commit.sha)

        if delta.keys.size == 1 && delta['b.txt'] == 'A'
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_second_commit_has_correct_message
        git_repo_path = File.expand_path('ep-m2-repo', @work_dir)
        git = Git.open(git_repo_path)

        log   = git.log
        count = log.size

        commit = git.log[count - 2]

        if commit.nil?
          mark_fail abort: true
          return
        end

        if commit.message.strip == 'Segundo commit - adicionado o arquivo b.txt'
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_third_commit_removes_b_txt
        git_repo_path = File.expand_path('ep-m2-repo', @work_dir)
        git = Git.open(git_repo_path)

        log   = git.log
        count = log.size

        commit = git.log[count - 3]

        if commit.nil?
          mark_fail abort: true
          return
        end

        delta = commit_delta(git, commit.sha)

        if delta.keys.size == 1 && delta['b.txt'] == 'D'
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_third_commit_has_correct_message
        git_repo_path = File.expand_path('ep-m2-repo', @work_dir)
        git = Git.open(git_repo_path)

        log   = git.log
        count = log.size

        commit = git.log[count - 3]

        if commit.nil?
          mark_fail abort: true
          return
        end

        if commit.message.strip == 'Arquivo b.txt removido'
          mark_pass
        else
          mark_fail abort: true
        end
      end

      def check_remote_master_exists
        git_repo_path = File.expand_path('ep-m2-repo', @work_dir)
        git = Git.open(git_repo_path)

        if git.branches['origin/master'].nil?
          mark_fail abort: true
        else
          mark_pass
        end
      end

      def check_push_to_remote_master
        git_repo_path = File.expand_path('ep-m2-repo', @work_dir)
        git = Git.open(git_repo_path)

        master        = git.branches['master']
        remote_master = git.branches['origin/master']

        if master.gcommit.sha == remote_master.gcommit.sha
          mark_pass
        else
          mark_fail abort: true
        end
      end

      #
      # Private methods.
      #
      private

      def commit_delta(git, commit_id)
        str = git.lib.send(:command, "show --name-status --oneline #{commit_id}")
        arr = str.scan(/([ACDMRTUXB])\t(.*)/)

        delta = {}
        arr.map { |d| delta[d[1]] = d[0] }
        delta
      end

    end
  end
end
