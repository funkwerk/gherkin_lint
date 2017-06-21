require 'gherkin_lint/linter/tag_constraint'
require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for tags used multiple times
  class RequiredTagsStartsWith < Linter
    include TagConstraint

    def match_pattern?(target)
      match = false

      target.each do |t|
        t.delete! '@'
        match = t.start_with?(*@pattern)
        break if match
      end
      match
    end
  end
end
