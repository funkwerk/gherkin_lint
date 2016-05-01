require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for missing feature names
  class MissingFeatureName < Linter
    def lint
      features do |file, feature|
        name = feature.key?('name') ? feature['name'].strip : ''
        next unless name.empty?
        references = [reference(file, feature)]
        add_error(references, 'No Feature Name')
      end
    end
  end
end
