require 'chutney/linter'

module Chutney
  # service class to lint for too many steps
  class TooManySteps < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        next if scenario[:steps].length < 10
        references = [reference(file, feature, scenario)]
        add_error(references, "Scenario is too long at #{scenario[:steps].length} steps")
      end
    end
  end
end
