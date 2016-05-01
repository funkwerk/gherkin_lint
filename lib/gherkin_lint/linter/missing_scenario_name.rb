require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for missing scenario names
  class MissingScenarioName < Linter
    def lint
      scenarios do |file, feature, scenario|
        name = scenario.key?('name') ? scenario['name'].strip : ''
        references = [reference(file, feature, scenario)]
        next unless name.empty?
        add_error(references, 'No Scenario Name')
      end
    end
  end
end
