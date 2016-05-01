require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for too many tags
  class TooManyTags < Linter
    def lint
      scenarios do |file, feature, scenario|
        tags = gather_tags(feature) + gather_tags(scenario)
        next unless tags.length >= 3
        references = [reference(file, feature, scenario)]
        add_error(references, "Used #{tags.length} Tags")
      end
    end
  end
end
