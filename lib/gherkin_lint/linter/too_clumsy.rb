require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for too clumsy scenarios
  class TooClumsy < Linter
    def lint
      filled_scenarios do |file, feature, scenario|
        characters = scenario['steps'].map { |step| step['name'].length }.inject(0, :+)
        next if characters < 400
        references = [reference(file, feature, scenario)]
        add_error(references, "Used #{characters} Characters")
      end
    end
  end
end
