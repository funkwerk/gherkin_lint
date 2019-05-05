require 'chutney/linter'

module Chutney
  # service class to lint for too long steps
  class TooLongStep < Linter
    def lint
      steps do |file, feature, scenario, step|
        next if step[:text].length < 80
        references = [reference(file, feature, scenario, step)]
        add_error(references, "Used #{step[:text].length} characters")
      end
    end
  end
end
