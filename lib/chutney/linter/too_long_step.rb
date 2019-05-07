require 'chutney/linter'

module Chutney
  # service class to lint for too long steps
  class TooLongStep < Linter
    MESSAGE = "This step is too long at %d characters"
    
    def lint
      steps do |file, feature, scenario, step|
        next if step[:text].length < 80
        references = [reference(file, feature, scenario, step)]
        add_error(references, MESSAGE % step[:text].length)
      end
    end
  end
end
