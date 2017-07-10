require 'gherkin_lint/linter/tag_constraint'
require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for tags used multiple times
  class RequiredTagsStartsWith < Linter
    include TagConstraint

    def match_pattern?(target)
      target.each do  |t|
        return true if t.delete!('@').start_with?(*@pattern)
      end
      false
    end
  end
end
