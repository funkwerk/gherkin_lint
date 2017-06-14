require 'yaml'
module GherkinLint
  class Configuration
    attr_reader :config

    DEFAULT_CONFIG = 'default.yml'.freeze

    def initialize
      @config = load_configuration || ''
    end

    def configuration_path
      DEFAULT_CONFIG
    end

    def load_configuration
      YAML.load_file(configuration_path) || '' if File.exist? configuration_path
    end
  end
end
