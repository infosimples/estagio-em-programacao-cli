module CourseCli
  ##
  # Shortcut to the logger object.
  #
  def self.logger
    Logger.logger
  end

  class Logger

    ##
    # Return the application's logger object.
    # If it doesn't exist yet, create a new one and return it.
    #
    def self.logger
      return @logger if @logger

      log_file = 'cli.log'
      log_file = File.join(PathHelper.log_dir, log_file)

      @logger = Logging.logger[:cli]
      @logger.add_appenders(
        Logging.appenders.file(log_file, layout: Logging.layouts.json)
      )
      @logger.level = :debug

      @logger
    end
  end
end
