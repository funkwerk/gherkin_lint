require 'chutney/linter/tag_constraint'
require 'chutney/linter'

module Chutney
  # service class to lint for tags used multiple times
  class RequiredTagsStartsWith < Linter
    include TagConstraint

    def match_pattern?(target)
      target.each do |t|
        return true if t.delete!('@').start_with?(*@pattern)
      end
      false
    end
  end
end
