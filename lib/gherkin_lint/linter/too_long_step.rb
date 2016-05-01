require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for too long steps
  class TooLongStep < Linter
    def lint
      steps do |file, feature, scenario, step|
        next if step['name'].length < 80
        references = [reference(file, feature, scenario, step)]
        add_error(references, "Used #{step['name'].length} characters")
      end
    end
  end
end
