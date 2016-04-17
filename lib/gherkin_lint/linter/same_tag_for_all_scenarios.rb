require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for using same tag on all scenarios
  class SameTagForAllScenarios < Linter
    def lint
      features do |file, feature|
        tags = gather_same_tags feature
        next if tags.nil?
        next if tags.empty?
        next unless feature['elements'].length > 1
        references = [reference(file, feature)]
        tags.each do |tag|
          add_issue(references, "Tag '#{tag}' should be used at Feature level")
        end
      end
    end

    def gather_same_tags(feature)
      result = nil
      return result unless feature.include? 'elements'
      feature['elements'].each do |scenario|
        next if scenario['keyword'] == 'Background'
        return nil unless scenario.include? 'tags'
        tags = scenario['tags'].map { |tag| tag['name'] }
        result = tags if result.nil?
        result &= tags
      end
      result
    end
  end
end
