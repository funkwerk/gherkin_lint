require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for too many steps
  class TooManySteps < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        next if scenario['steps'].length < 10
        references = [reference(file, feature, scenario)]
        add_error(references, "Used #{scenario['steps'].length} Steps")
      end
    end
  end
end
