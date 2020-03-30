module CourseCli
  class UserConfig

    ##
    # @return[Hash] The user configuration.
    #
    def self.config
      return @config if @config

      config_path = File.join(CourseCli::PathHelper.user_folder, 'config')
      if File.exist?(config_path)
        @config = YAML.load_file(config_path)
        return @config
      else
        {}
      end
    end

    ##
    # @return[String] The student code.
    #
    def self.student_code
      config[:student_code]
    end

    ##
    #
    def self.last_sha
      config[:last_sha].to_s
    end

    ##
    #
    def self.last_cli_update
      Time.parse(config[:last_cli_update]) rescue nil
    end

    def self.update_config(new_config = {})
      return if self.config.empty?

      config_path = File.join(CourseCli::PathHelper.user_folder, 'config')
      updated = self.config.merge(new_config)

      File.open(config_path, 'w') do |f|
        f.write(updated.to_yaml)
      end
    end
  end
end
