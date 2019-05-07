require 'chutney/linter'

module Chutney
  # service class to lint for avoiding periods
  class AvoidPeriod < Linter
    MESSAGE = 'Avoid using a period (full-stop) in steps so that it is easier to re-use them'
    
    def lint
      scenarios do |file, feature, scenario|
        next unless scenario.key? :steps

        scenario[:steps].each do |step|
          references = [reference(file, feature, scenario, step)]
          add_error(references, MESSAGE) if step[:text].strip.end_with? '.'
        end
      end
    end
  end
end
