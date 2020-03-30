module CourseCli

  #
  # Helper functions for getting the full path of files and folders.
  #
  class PathHelper
    def self.user_folder
      File.join(ENV['HOME'], '.ep', 'user-files')
    end

    def self.root
      File.expand_path(File.join('..', '..', '..'), __FILE__)
    end

    def self.install_dir
      File.expand_path('..', root)
    end

    def self.log_dir
      File.expand_path('log', install_dir)
    end

    def self.gradings_file(m, e)
      m, e = normalize_me(m, e)
      File.join(user_folder, 'gradings', "m#{m}-e#{e}.yml")
    end

    def self.questions_dir
       File.join(root, 'questions')
    end

    def self.question_file(m, e)
      m, e = normalize_me(m, e)
      File.join(questions_dir, "m#{m}-e#{e}.md")
    end

    def self.public_dir
      File.join(root, 'public')
    end

    def self.public_question_file(m, e)
      m, e = normalize_me(m, e)
      File.join(public_dir, "m#{m}-e#{e}.html")
    end

    def self.layout_file
      File.join(public_dir, 'layout.html.erb')
    end

    def self.normalize_me(m, e)
      [ m.to_i.to_s.rjust(2, '0'), e.to_i.to_s.rjust(2, '0') ]
    end
  end

end
