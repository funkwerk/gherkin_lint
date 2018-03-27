require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for avoiding periods
  class AvoidPeriod < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.respond_to? :steps

        scenario.steps.each do |step|
          references = [reference(file, feature, scenario, step)]
          add_error(references) if step.text.strip.end_with? '.'
        end
      end
    end
  end
end
