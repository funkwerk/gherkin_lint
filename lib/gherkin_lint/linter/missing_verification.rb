require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for missing verifications
  class MissingVerification < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        then_steps = scenario['steps'].select { |step| step['keyword'] == 'Then ' }
        next unless then_steps.empty?
        references = [reference(file, feature, scenario)]
        add_error(references, 'No verification step')
      end
    end
  end
end
