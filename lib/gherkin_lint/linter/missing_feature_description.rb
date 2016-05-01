require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for missing feature descriptions
  class MissingFeatureDescription < Linter
    def lint
      features do |file, feature|
        name = feature.key?('description') ? feature['description'].strip : ''
        next unless name.empty?
        references = [reference(file, feature)]
        add_error(references, 'Favor a user story as description')
      end
    end
  end
end
