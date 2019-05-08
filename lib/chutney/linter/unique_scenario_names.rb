require 'chutney/linter'

module Chutney
  # service class to lint for unique scenario names
  class UniqueScenarioNames < Linter
    def lint
      references_by_name = Hash.new []
      scenarios do |file, feature, scenario|
        next unless scenario.key? :name
        
        scenario_name = "#{feature[:name]}.#{scenario[:name]}"
        references_by_name[scenario_name] = references_by_name[scenario_name] + [reference(file, feature, scenario)]
      end
      
      references_by_name.each do |name, references|
        next if references.length <= 1
        
        add_error(references, "Scenario name should be unique, '#{name}' used #{references.length} times")
      end
    end
  end
end
