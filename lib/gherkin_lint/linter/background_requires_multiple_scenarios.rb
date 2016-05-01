require 'gherkin_lint/linter'

module GherkinLint
  # service class for check that there are multiple scenarios once a background is used
  class BackgroundRequiresMultipleScenarios < Linter
    def lint
      backgrounds do |file, feature, background|
        scenarios = feature['elements'].select { |element| element['keyword'] != 'Background' }
        next if scenarios.length >= 2

        references = [reference(file, feature, background)]
        add_error(references, "There are just #{scenarios.length} scenarios")
      end
    end
  end
end
