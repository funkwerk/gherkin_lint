require 'chutney/linter'

module Chutney
  # service class to lint for missing scenario names
  class MissingScenarioName < Linter
    MESSAGE = 'All scenarios should have a name'.freeze
  
    def lint
      scenarios do |file, feature, scenario|
        name = scenario.key?(:name) ? scenario[:name].strip : ''
        references = [reference(file, feature, scenario)]
        next unless name.empty?
        
        add_error(references, MESSAGE)
      end
    end
  end
end
