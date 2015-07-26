require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for missing test actions
  class MissingTestAction < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        when_steps = scenario['steps'].select { |step| step['keyword'] == 'When ' }
        next if when_steps.length > 0
        references = [reference(file, feature, scenario)]
        add_issue(references, 'No \'When\'-Step')
      end
    end
  end
end