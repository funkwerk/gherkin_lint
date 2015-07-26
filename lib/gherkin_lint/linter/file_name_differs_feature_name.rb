require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for file name differs feature name
  class FileNameDiffersFeatureName < Linter
    def lint
      features do |file, feature|
        next unless feature.include? 'name'
        expected_feature_name = title_case file
        next unless feature['name'].downcase != expected_feature_name.downcase
        references = [reference(file, feature)]
        add_issue(references, "Feature name should be '#{expected_feature_name}'")
      end
    end

    def title_case(value)
      value = File.basename(value, '.feature')
      value.split('_').collect(&:capitalize).join(' ')
    end
  end
end
