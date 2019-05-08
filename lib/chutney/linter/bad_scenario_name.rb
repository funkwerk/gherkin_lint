require 'chutney/linter'

module Chutney
  # service class to lint for bad scenario names  
  class BadScenarioName < Linter
    MESSAGE = 'You should avoid using words like \'test\', \'check\' or \'verify\' ' \
      'when naming your scenarios to keep them understandable'.freeze
      
    def lint
      scenarios do |file, feature, scenario|
        next if scenario[:name].empty?
        
        references = [reference(file, feature, scenario)]
        bad_words = %w[test verif check]
        bad_words.each do |bad_word|
          add_error(references, MESSAGE) if scenario[:name].downcase.include? bad_word
        end
      end
    end
  end
end
