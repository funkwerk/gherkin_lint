require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for unused variables
  class UnusedVariable < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless (scenario.is_a?(CukeModeler::Outline) && scenario.examples.any?)
        scenario.examples.each do |example|
          next unless example.parameter_row
          example.parameter_row.cells.map { |cell| cell.value }.each do |variable|
            references = [reference(file, feature, scenario)]
            add_error(references, "'<#{variable}>' is unused") unless used?(variable, scenario)
          end
        end
      end
    end

    def used?(variable, scenario)
      variable = "<#{variable}>"
      return false unless scenario.steps.any?
      scenario.steps.each do |step|
        return true if step.text.include? variable
        next unless step.block
        return true if used_in_docstring?(variable, step)
        return true if used_in_table?(variable, step)
      end
      false
    end

    def used_in_docstring?(variable, step)
      step.block.is_a?(CukeModeler::DocString) && step.block.content.include?(variable)
    end

    def used_in_table?(variable, step)
      return false unless step.block.is_a?(CukeModeler::Table)
      step.block.rows.each do |row|
        row.cells.each { |value| return true if value.value.include?(variable) }
      end
      false
    end
  end
end
