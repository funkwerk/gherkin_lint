require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for unused variables
  class UnusedVariable < Linter
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? 'examples'
        scenario['examples'].each do |example|
          next unless example.key? 'rows'
          example['rows'].first['cells'].each do |variable|
            references = [reference(file, feature, scenario)]
            add_error(references, "'<#{variable}>' is unused") unless used?(variable, scenario)
          end
        end
      end
    end

    def used?(variable, scenario)
      variable = "<#{variable}>"
      return false unless scenario.key? 'steps'
      scenario['steps'].each do |step|
        return true if step['name'].include? variable
        return true if used_in_docstring?(variable, step)
        return true if used_in_table?(variable, step)
      end
      false
    end

    def used_in_docstring?(variable, step)
      step.key?('doc_string') && step['doc_string']['value'].include?(variable)
    end

    def used_in_table?(variable, step)
      return false unless step.key? 'rows'
      step['rows'].each do |row|
        row['cells'].each { |value| return true if value.include?(variable) }
      end
      false
    end
  end
end
