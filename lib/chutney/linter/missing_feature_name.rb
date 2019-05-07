require 'chutney/linter'

module Chutney
  # service class to lint for missing feature names
  class MissingFeatureName < Linter
    MESSAGE = 'All features should have name'
    
    def lint
      features do |file, feature|
        name = feature.key?(:name) ? feature[:name].strip : ''
        next unless name.empty?
        references = [reference(file, feature)]
        add_error(references, MESSAGE)
      end
    end
  end
end
