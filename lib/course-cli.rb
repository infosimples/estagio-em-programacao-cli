require 'byebug'
require 'gli'
require 'i18n'

# External
require 'json'
require 'logging'
require 'openssl'
require 'paint'
require 'pygments'
require 'redcarpet'
require 'rest-client'
require 'time'
require 'yaml'
require 'net/http'
require 'fileutils'
require 'pathname'
require 'open-uri'

# Internal
require 'course-cli/analytics'
require 'course-cli/config'
require 'course-cli/logger'
require 'course-cli/path_helper'
require 'course-cli/question_viewer'
require 'course-cli/renderer'
require 'course-cli/user_config'
require 'course-cli/version'
require 'ep'
require 'encryption'
require 'graders'

#
# GLI monkey-patch to show a colored 'error:' message
#
module GLI
  module AppSupport
    def error_message(ex)
      Paint["#{I18n.t('cli.errors.prefix')}: ", :red, :bold] << ex.message
    end
  end
end
