require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for missing test actions
  class MissingTestAction < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        when_steps = scenario['steps'].select { |step| step['keyword'] == 'When ' }
        next unless when_steps.empty?
        references = [reference(file, feature, scenario)]
        add_error(references, 'No \'When\'-Step')
      end
    end
  end
end
