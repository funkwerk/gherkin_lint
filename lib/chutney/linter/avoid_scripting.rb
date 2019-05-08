require 'chutney/linter'

module Chutney
  # service class to lint for avoid scripting
  class AvoidScripting < Linter
    MESSAGE = "You have multiple (%d) 'When' actions in your steps - you should only have one".freeze
  
    def lint
      filled_scenarios do |file, feature, scenario|
        steps = filter_when_steps scenario[:steps]
        next if steps.length <= 1
        
        references = [reference(file, feature, scenario)]
        add_error(references, MESSAGE % steps.length)
      end
    end

    def filter_when_steps(steps)
      steps = steps.drop_while { |step| step[:keyword] != 'When ' }
      steps = steps.reverse.drop_while { |step| step[:keyword] != 'Then ' }.reverse
      steps.reject { |step| step[:keyword] == 'Then ' }
    end
  end
end
