require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for avoiding outline for single example
  class AvoidOutlineForSingleExample < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.is_a?(CukeModeler::Outline)

        next unless scenario.examples.any?
        next if scenario.examples.length > 1
        next if scenario.examples.first.argument_rows.length > 1

        references = [reference(file, feature, scenario)]
        add_error(references, 'Better write a scenario')
      end
    end
  end
end
