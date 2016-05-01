require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for missing example names
  class MissingExampleName < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'examples'
        next unless scenario['examples'].length > 1
        scenario['examples'].each do |example|
          name = example.key?('name') ? example['name'].strip : ''
          next unless name.empty?
          references = [reference(file, feature, scenario)]
          add_error(references, 'No Example Name')
        end
      end
    end
  end
end
