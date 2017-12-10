require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for using same tag on all scenarios
  class SameTagForAllScenarios < Linter
    def lint
      features do |file, feature|
        next unless feature.tests.any?

        lint_scenarios file, feature
        lint_examples file, feature
      end
    end

    def lint_scenarios(file, feature)
      tags = gather_same_tags feature
      return if tags.nil?
      return if tags.empty?
      return unless feature.tests.length > 1
      references = [reference(file, feature)]
      tags.each do |tag|
        next if tag == '@skip'

        add_error(references, "Tag '#{tag}' should be used at Feature level")
      end
    end

    def lint_examples(file, feature)
      feature.tests.each do |scenario|
        tags = gather_same_tags_for_outline scenario
        next if tags.nil? || tags.empty?
        next unless scenario.is_a?(CukeModeler::Outline) && (scenario.examples.length > 1)
        references = [reference(file, feature, scenario)]
        tags.each do |tag|
          next if tag == '@skip'

          add_error(references, "Tag '#{tag}' should be used at Scenario Outline level")
        end
      end
    end

    def gather_same_tags(feature)
      result = nil
      feature.children.each do |scenario|
        next if scenario.is_a? CukeModeler::Background
        return nil unless scenario.tags.any?
        tags = scenario.tags.map(&:name)
        result = tags if result.nil?
        result &= tags
      end
      result
    end

    def gather_same_tags_for_outline(scenario)
      result = nil
      return result unless scenario.is_a?(CukeModeler::Outline)
      scenario.examples.each do |example|
        return nil unless example.tags.any?
        tags = example.tags.map(&:name)
        result = tags if result.nil?
        result &= tags
      end
      result
    end
  end
end
