require 'chutney/linter'

module Chutney
  # service class to lint for missing feature descriptions
  class MissingFeatureDescription < Linter
    MESSAGE = 'Features should have a description so that its purpose is clear'.freeze
    def lint
      features do |file, feature|
        name = feature.key?(:description) ? feature[:description].strip : ''
        next unless name.empty?
        
        references = [reference(file, feature)]
        add_error(references, MESSAGE)
      end
    end
  end
end
