require 'gherkin_lint/linter/required_tags'
require 'gherkin_lint/linter'

module GherkinLint
  # service class to lint for tags used multiple times
  class RequiredTagsStartsWith < Linter

    include RequiredTags

    def match_pattern?(target)
      match = false
      target.each do |t|
        match = t.start_with? @pattern
        break if match
      end
      match
    end
  end
end
