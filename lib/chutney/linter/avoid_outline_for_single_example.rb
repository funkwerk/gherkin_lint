require 'chutney/linter'

module Chutney
  # service class to lint for avoiding outline for single example
  class AvoidOutlineForSingleExample < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario[:type] == :ScenarioOutline

        next unless scenario.key? :examples
        next if scenario[:examples].length > 1
        next if scenario[:examples].first[:tableBody].length > 1

        references = [reference(file, feature, scenario)]
        add_error(references, 'Better write a scenario')
      end
    end
  end
end
