module CourseCli
  DEBUG_LEVELS = [ 0, 1, 2, 3 ]

  #
  # I18n configuration
  #
  load_path = File.expand_path(File.join('..', '..', '..', 'locales', '*.yml'),
                               __FILE__)

  I18n.config.load_path += Dir[load_path]
  I18n.config.available_locales << 'pt-BR'
  I18n.config.default_locale = 'pt-BR'

  def self.debug_level
    @@debug_level ||= 1
  end

  def self.debug_level=(val)
    @@debug_level = val
  end

  def self.setup(code: )
    dir = PathHelper.user_folder

    FileUtils.rm_rf(dir)
    FileUtils.mkdir(dir)
    FileUtils.mkdir(File.join(dir, 'gradings'))

    File.open(File.join(dir, 'config'), 'w') do |f|
      f.write({ student_code: code }.to_yaml)
    end

    puts I18n.t('config.files_created', path: dir)
  end

  def self.check_user_folder
    File.directory?(PathHelper.user_folder)
  end

  def self.user_folder_exists?
    check_user_folder
  end
end
