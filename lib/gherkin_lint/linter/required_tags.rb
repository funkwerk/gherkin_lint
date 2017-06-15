require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for tags used multiple times
  class RequiredTags < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless tags(feature).grep(@pattern).empty?
        next unless tags(scenario).grep(@pattern).empty?
        references = [reference(file, feature, scenario)]
        add_error(references, "Required Tag #{@pattern} not found")
      end
    end

    def tags(element)
      return [] unless element.include? :tags
      element[:tags].map { |a| a[:name] }
    end

    def matcher(pattern)
      @pattern = Regexp.new pattern
    end
  end
end
