require 'chutney/linter'

module Chutney
  # service class to lint for too clumsy scenarios
  class TooClumsy < Linter
    MESSAGE = "This scenario is too long at %d characters"
    def lint
      filled_scenarios do |file, feature, scenario|
        characters = scenario[:steps].map { |step| step[:text].length }.inject(0, :+)
        next if characters < 400
        references = [reference(file, feature, scenario)]
        add_error(references, MESSAGE % characters)
      end
    end
  end
end
