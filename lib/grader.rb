require 'i18n'
I18n.load_path << Dir[File.expand_path('../locales/*.yml', File.dirname(__FILE__))]
I18n.default_locale = 'pt-BR'

# External
require 'json'
require 'paint'
require 'time'
require 'yaml'
require 'fileutils'
require 'pathname'
require 'open-uri'

# Load Grader
require_relative 'graders/base'
begin
  require_relative "graders/m#{M}/e#{E}.rb"
rescue LoadError
end
