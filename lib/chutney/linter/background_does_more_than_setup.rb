require 'chutney/linter'

module Chutney
  # service class to lint for background that does more than setup
  class BackgroundDoesMoreThanSetup < Linter
    MESSAGE = 'A Feature\'s Background should just contain \'Given\' steps'.freeze
   
    def lint
      backgrounds do |file, feature, background|
        next unless background.key? :steps
        
        invalid_steps = background[:steps].select { |step| step[:keyword] == 'When ' || step[:keyword] == 'Then ' }
        next if invalid_steps.empty?
        
        references = [reference(file, feature, background, invalid_steps[0])]
        add_error(references, MESSAGE)
      end
    end
  end
end
