require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for avoid scripting
  class AvoidScripting < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        steps = filter_when_steps scenario['steps']

        next if steps.length <= 1
        references = [reference(file, feature, scenario)]
        add_error(references, 'Multiple Actions')
      end
    end

    def filter_when_steps(steps)
      steps = steps.drop_while { |step| step['keyword'] != 'When ' }
      steps = steps.reverse.drop_while { |step| step['keyword'] != 'Then ' }.reverse
      steps.select { |step| step['keyword'] != 'Then ' }
    end
  end
end
