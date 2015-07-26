require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for missing verifications
  class MissingVerification < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        then_steps = scenario['steps'].select { |step| step['keyword'] == 'Then ' }
        next if then_steps.length > 0
        references = [reference(file, feature, scenario)]
        add_issue(references, 'No verification step')
      end
    end
  end
end
