require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for tags used multiple times
  class RequiredTags < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless tags(feature).grep(matcher).empty?
        next unless tags(scenario).grep(matcher).empty?
        references = [reference(file, feature, scenario)]
        add_error(references, "Required Tag #{matcher} not found")
      end
    end

    def tags(element)
      return [] unless element.include? :tags
      element[:tags].map { |a| a[:name] }
    end

    def matcher
      /PB|MCC/
    end
  end
end
