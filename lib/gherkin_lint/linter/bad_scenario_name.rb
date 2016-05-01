require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for bad scenario names
  class BadScenarioName < Linter
    def lint
      scenarios do |file, feature, scenario|
        next if scenario['name'].empty?
        references = [reference(file, feature, scenario)]
        description = 'Prefer to rely just on Given and When steps when name your scenario to keep it stable'
        bad_words = %w(test verif check)
        bad_words.each do |bad_word|
          add_error(references, description) if scenario['name'].downcase.include? bad_word
        end
      end
    end
  end
end
