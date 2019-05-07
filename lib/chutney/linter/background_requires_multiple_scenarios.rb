require 'chutney/linter'

module Chutney
  # service class for check that there are multiple scenarios once a background is used
  class BackgroundRequiresMultipleScenarios < Linter
    MESSAGE = "Avoid using Background steps for just one scenario"
  
    def lint
      backgrounds do |file, feature, background|
        scenarios = feature[:children].reject { |element| element[:type] == :Background }
        next if scenarios.length >= 2

        references = [reference(file, feature, background)]
        add_error(references, MESSAGE)
      end
    end
  end
end
