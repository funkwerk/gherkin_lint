require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for using same tag on all scenarios
  class SameTagForAllScenarios < Linter
    def lint
      features do |file, feature|
        next unless feature.include? 'elements'

        lint_scenarios file, feature
        lint_examples file, feature
      end
    end

    def lint_scenarios(file, feature)
      tags = gather_same_tags feature
      return if tags.nil?
      return if tags.empty?
      return unless feature['elements'].length > 1
      references = [reference(file, feature)]
      tags.each do |tag|
        next if tag == '@skip'

        add_error(references, "Tag '#{tag}' should be used at Feature level")
      end
    end

    def lint_examples(file, feature)
      feature['elements'].each do |scenario|
        tags = gather_same_tags_for_outline scenario
        next if tags.nil? || tags.empty?
        next unless scenario['examples'].length > 1
        references = [reference(file, feature, scenario)]
        tags.each do |tag|
          next if tag == '@skip'

          add_error(references, "Tag '#{tag}' should be used at Scenario Outline level")
        end
      end
    end

    def gather_same_tags(feature)
      result = nil
      feature['elements'].each do |scenario|
        next if scenario['keyword'] == 'Background'
        return nil unless scenario.include? 'tags'
        tags = scenario['tags'].map { |tag| tag['name'] }
        result = tags if result.nil?
        result &= tags
      end
      result
    end

    def gather_same_tags_for_outline(scenario)
      result = nil
      return result unless scenario.include? 'examples'
      scenario['examples'].each do |example|
        return nil unless example.include? 'tags'
        tags = example['tags'].map { |tag| tag['name'] }
        result = tags if result.nil?
        result &= tags
      end
      result
    end
  end
end
