require 'yaml'
module GherkinLint
  class Configuration
    attr_reader :config

    def initialize(path)
      @path = path
      @config = load_configuration || ''
    end

    def configuration_path
      @path
    end

    def load_configuration
      YAML.load_file configuration_path || '' if File.exist? configuration_path
    end
  end
end
