require 'yaml'
module Chutney
  # gherkin_lint configuration object
  class Configuration
    attr_reader :config

    def initialize(path)
      @path = path
      @config = load_configuration || ''
      load_user_configuration
    end

    def configuration_path
      @path
    end

    def load_configuration
      YAML.load_file configuration_path || '' if File.exist? configuration_path
    end

    def load_user_configuration
      config_file = Dir.glob(File.join(Dir.pwd, '**', '.chutney.yml')).first
      merge_config(config_file) if !config_file.nil? && File.exist?(config_file)
    end

    private

    def merge_config(config_file)
      @config.merge!(YAML.load_file(config_file)) { |_k, old, new| old.merge!(new) } unless @config.empty?
    end
  end
end
